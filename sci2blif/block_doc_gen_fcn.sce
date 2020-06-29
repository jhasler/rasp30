global block_doc_name block_doc_list block_doc_ni block_doc_no block_doc_pl block_doc_bdt block_doc_bdf;

function dir_callback()
    disp("   ");
endfunction

function block_doc_name_callback()
    global block_doc_name block_doc_list; block_name_obj = findobj('tag','block_doc_name'); block_doc_name = block_name_obj.string;
    
    file_list=listfiles("/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/*.tex");
    block_doc_list=[""];
    size_flist=size(file_list,1);
    for ii=1:size_flist
        temp_file_list=strsplit(file_list(ii),["/";"."],100);
        block_doc_list(ii)=temp_file_list(9);
        if block_doc_list(ii) == block_doc_name then messagebox('You already have the block in doc list. This will overwrite it.', "warning", "warning"); end
    end
endfunction

function block_doc_ni_callback()
    global block_doc_ni;
    block_obj = findobj('tag','block_doc_ni');
    block_doc_ni = block_obj.string;
endfunction

function block_doc_no_callback()
    global block_doc_no; block_obj = findobj('tag','block_doc_no'); block_doc_no = block_obj.string;
endfunction

function block_doc_pl_callback()
    global block_doc_pl; block_obj = findobj('tag','block_doc_pl'); block_doc_pl = block_obj.string;
endfunction

function block_doc_bdt_callback()
    global block_doc_bdt; block_obj = findobj('tag','block_doc_bdt'); block_doc_bdt = block_obj.string;
    [a1,b1]=unix_g("ls "+block_doc_bdt); // b1: 0 if no error occurred, 1 if error.
    if (b1~=0) then messagebox('Incorect file path or name. Please check it again.', "Block Description Text error", "error"); abort; end
endfunction

function block_doc_bdf_callback()
    global block_doc_bdf; block_obj = findobj('tag','block_doc_bdf'); block_doc_bdf = block_obj.string;
    [a1,b1]=unix_g("ls "+block_doc_bdf); // b1: 0 if no error occurred, 1 if error.
    if (b1~=0) then messagebox('Incorect file path or name. Please check it again.', "Block Description Text error", "error"); abort; end
endfunction

function Gen_block_doc_callback()
    global block_doc_name block_doc_list block_doc_ni block_doc_no block_doc_pl block_doc_bdt block_doc_bdf;
    
    fd_w= mopen("/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex",'wt');
    mputl("\pagebreak",fd_w);
    mputl("",fd_w);
    temp_bdn=strsplit(block_doc_name,["_";],100); size_temp_bdn=size(temp_bdn); temp_name1=temp_bdn(1);
    for i=2:size_temp_bdn(1)
        temp_name1=temp_name1+"\_"+temp_bdn(i);
    end
    mputl("Block name: "+temp_name1,fd_w);
    mputl("",fd_w);
    mputl("Number of inputs: "+block_doc_ni,fd_w);
    mputl("",fd_w);
    mputl("Number of outputs: "+block_doc_no,fd_w);
    mputl("",fd_w);
    temp_pl=strsplit(block_doc_pl,["_";],100); size_temp_pl=size(temp_pl); temp_name2=temp_pl(1);
    for i=2:size_temp_pl(1)
        temp_name2=temp_name2+"\_"+temp_pl(i);
    end
    mputl("Parameter list: "+temp_name2,fd_w);
    mputl("",fd_w);
    mputl("Block description: ",fd_w);
    mclose(fd_w);
    
    unix_w("cat /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex "+block_doc_bdt+" > /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex1");
    unix_w("mv /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex1 /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex");
    temp_string=strsplit(block_doc_bdf,["/";"."],100);
    size_temp_string=size(temp_string,1);
    unix_w("cp "+block_doc_bdf+" /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/figures/"+block_doc_name+"."+temp_string(size_temp_string));
    
    fd_w= mopen("/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_name+".tex",'a');
    mputl("",fd_w);
    mputl("\begin{figure}[H]  % jpg, png, or pdf",fd_w);
    mputl("\includegraphics[width=300pt]{/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/figures/"+block_doc_name+"."+temp_string(size_temp_string)+"}",fd_w);
    mputl("\end{figure}",fd_w);
    mputl("",fd_w);
    mclose(fd_w);
    
    file_list=listfiles("/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/*.tex");
    block_doc_list=[""];
    size_flist=size(file_list,1);
    for ii=1:size_flist
        temp_file_list=strsplit(file_list(ii),["/";"."],100);
        block_doc_list(ii)=temp_file_list(9);
    end
    block_doc_list=gsort(block_doc_list,"g",'i');
    
    fd_w= mopen("/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/block_list.tex",'wt');
    for ii=1:size_flist
        mputl("\input{/home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/text/"+block_doc_list(ii)+".tex}",fd_w);
    end
    mclose(fd_w);
    
    [a,b]=unix_g("cd /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/ && pdflatex /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/block_doc.tex");
    if b == 1 then
        messagebox("Texlive for latex compilation is not installed. It will install Texlive and take some time. Do not turn off it", "Texlive not installed yet!", "scilab");
        unix_g("sudo apt-get install texlive");
    end
    
    [a,b]=unix_g("acroread /home/ubuntu/rasp30/sci2blif/documentation/blocks_latex/block_doc.pdf &"); 
    if b == 1 then messagebox("Install Adobe Reader via the Documents menu. ", "Adode Reader not installed yet!", "scilab"); end
    
endfunction






