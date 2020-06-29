global para_abs_name;

function dir_callback()
    disp("   ");
endfunction

function BP_block_name_callback()
    global para_abs_name;
    block_name_obj = findobj('tag','BP_block_name');
    para_abs_name = block_name_obj.string;
endfunction

function Generate_MB_callback()
    global para_abs_name;
    para_abs_name="bi_fgota.sci";
    
    file_list=listfiles("/home/ubuntu/rasp30/sci2blif/block_info/*.sci");
    l_file_list=size(file_list,1);
    for ii=1:l_file_list
        if file_list(ii) == "/home/ubuntu/rasp30/sci2blif/block_info/"+para_abs_name+".sci" then messagebox('The block does not exist. Please check the block name.', "an error", "error"); abort; end
    end
    
    //////////////////////////////////
    // Read Block information file 
    //////////////////////////////////
    mblif_xcos_r=[""];
    ele_index_r=[""];
    fd_r = mopen("/home/ubuntu/rasp30/sci2blif/block_info/bi_"+Macroblif_name+".sci",'r');
    for i=1:7
        str_temp=mgetl(fd_r, 1); str_temp=strsplit(str_temp,[","],100);str_size=size(str_temp);
        for j=1:str_size(1)
            mblif_xcos_r(i,j)=str_temp(j)
        end
    end
    for i=1:strtod(mblif_xcos_r(7,1))
        str_temp=mgetl(fd_r, 1); str_temp=strsplit(str_temp,[","],100);str_size=size(str_temp);
        for j=1:str_size(1)
            ele_index_r(i,j)=str_temp(j)
        end
    end
    mclose(fd_r);
    
    //disp(mblif_xcos_r);
    //disp(ele_index_r);
    
    
    
    
    
    
    //////////////////////////////////////////////
    // Read BLIF file and get/modify net names
    //////////////////////////////////////////////
    //Macroblif_name="mblif_test_ex1";
    //Macroblif_name="test";
    
    clear model model_name inputs outputs;
    fd_r = mopen(fname+'.blif','r');
    model=mfscanf(1, fd_r, '%s');
    model_name=mfscanf(1, fd_r, '%s');
    
    clear mblif_xcos inputs outputs match_ele;
    mblif_xcos(1,1)=Macroblif_name;
    
    // Input
    mgetl(fd_r,1); // 1st line
    inputs_temp=mgetl(fd_r, 1); inputs_temp=strsplit(inputs_temp,' ',100); No_inputs_temp=size(inputs_temp); // 2nd line
    vcc_flag=0; gnd_flag=0;
    for i=2:No_inputs_temp(1)  // Check i/o including vcc/gnd
        if inputs_temp(i) == "vcc" then vcc_flag=1; end
        if inputs_temp(i) == "gnd" then gnd_flag=1; end
        if inputs_temp(i) ~= "vcc" & inputs_temp(i) ~= "gnd" then
            inputs(1,i-1)=inputs_temp(i);
            inoutputs(1,i-1)=inputs_temp(i);
        end
    end
    No_inputs=size(inputs);
    mblif_xcos(1,2)=string(No_inputs(2));
    
    // Output
    outputs_temp=mgetl(fd_r,1); outputs_temp=strsplit(outputs_temp,' ',100); No_outputs_temp=size(outputs_temp); // 3rd line
    for i=2:No_outputs_temp(1)
        outputs(1,i-1)=outputs_temp(i);
        inoutputs(1,i+No_inputs(2)-1)=outputs_temp(i); 
    end
    No_outputs=size(outputs);
    mblif_xcos(1,3)=string(No_outputs(2));
    
    No_inoutputs=No_inputs(2)+No_outputs(2);
    
    inputs_temp=mgetl(fd_r, 1); inputs_temp=strsplit(inputs_temp,' ',100); No_inputs_temp=size(inputs_temp); // 4th line
    for i=1:No_inputs(2)
        //inputs(2,i)=inputs_temp(i+1);
        inoutputs(2,i)=inputs_temp(i+1);
    end
    
    outputs_temp=mgetl(fd_r, 1); outputs_temp=strsplit(outputs_temp,' ',100); No_outputs_temp=size(outputs_temp); // 5th line
    for i=1:No_outputs(2)
        //outputs(2,i)=string(strtod(outputs_temp(i+1))-No_inputs(2));
        inoutputs(2,i+No_inputs(2))=outputs_temp(i+1);
    end
    
    mgetl(fd_r, 1); // 6th  line
    
    mblif_xcos(2,1)="2";mblif_xcos(2,2)="1";mblif_xcos(2,3)="2";
    mblif_xcos(4,1)="num_of_blk";mblif_xcos(4,2)="1";mblif_xcos(4,3)="mblif_num";mblif_xcos(4,4)="0";
    mblif_xcos(5,1)="num_of_blk";mblif_xcos(5,2)="mblif_num";
    
    No_ele=0;
    No_rpar=1; // rpar number
    col_mblif_xcos=1; // column in bmlif xcos
    match_ele=[""];
    ele_index=mgetl(fd_r, 1); // 7th line
    ele_index=strsplit(ele_index,' ',100); //2:name 3:bl 4:mblif number 5: vectorized number
    while ele_index(1) ~= ".end",
        No_ele=No_ele+1;
        col_mblif_xcos2=1;
        str_temp=mgetl(fd_r, 1); str_temp=strsplit(str_temp,[" ";"=";"&"],100); // 8th line
        // Read Block information
        fd_r1 = mopen("/home/ubuntu/rasp30/sci2blif/block_info/bi_"+ele_index(2)+'.sci','r');
        mgetl(fd_r1, 1);mgetl(fd_r1, 1);mgetl(fd_r1, 1); // Xcos information is not used here. Block info 1-3 lines
        blif_info_line4=mgetl(fd_r1, 1); blif_info_line4=strsplit(blif_info_line4,',',100);
        blif_info_line5=mgetl(fd_r1, 1); blif_info_line5=strsplit(blif_info_line5,',',100);
        blif_info=mgetl(fd_r1,1); // Block info 6th line (Not used here)
        blif_info=mgetl(fd_r1,1); blif_info=strsplit(blif_info,',',100); // Block info 7th line
        for i=1:strtod(blif_info(1)) // # of BLIF blocks
            col_match=1; // column in match_ele
            col_bi=1; // column in block info
            col_blif=1; // column in blif
            blif_temp1=mgetl(fd_r1,1); blif_temp1=strsplit(blif_temp1,',',100); // Block info 8th line
            match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1; // blif block name
            match_ele(No_ele,col_match)=ele_index(4);col_match=col_match+1; // mblif number
            match_ele(No_ele,col_match)=ele_index(5);col_match=col_match+1; // vectorized number
            col_bi=col_bi+1;col_bi=col_bi+1; // mblif numberm, vectorized number
            match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1; // # of input
            match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1; // # of output
            match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1; // # of blif parameters
            
            for j=1:strtod(blif_temp1(4)) // Inputs
                in_typ_comp=blif_temp1(col_bi);
                if in_typ_comp=="0" then // internal or vcc or gnd
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi)+"_"+Macroblif_name;col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
                if in_typ_comp=="2" | in_typ_comp=="3" then // vcc or gnd
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
                if in_typ_comp=="1" then // external
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=str_temp(col_blif+2);
                    for l=1:No_inoutputs
                        if match_ele(No_ele,col_match) == inoutputs(1,l) then match_ele(No_ele,col_match) = inoutputs(2,l); end
                    end
                    if match_ele(No_ele,col_match)==str_temp(col_blif+2) then 
                        if match_ele(No_ele,col_match) == "vcc" then 
                            match_ele(No_ele,col_match-1)="2";
                        elseif match_ele(No_ele,col_match) == "gnd" then 
                            match_ele(No_ele,col_match-1)="3";
                        else
                            match_ele(No_ele,col_match-1)="0";
                            match_ele(No_ele,col_match)=str_temp(col_blif+2)+"_"+Macroblif_name;
                        end
                    end
                    col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
            end
            for j=1:strtod(blif_temp1(5)) // Outputs
                out_typ_comp=blif_temp1(col_bi);
                if out_typ_comp=="0" then // internal
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi)+"_"+Macroblif_name;col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
                if out_typ_comp=="1" then // external
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=str_temp(col_blif+2);
                    for l=1:No_inoutputs
                        if match_ele(No_ele,col_match) == inoutputs(1,l) then match_ele(No_ele,col_match) = inoutputs(2,l); end
                    end
                    if match_ele(No_ele,col_match)==str_temp(col_blif+2) then 
                        match_ele(No_ele,col_match-1)="0";
                        match_ele(No_ele,col_match)=str_temp(col_blif+2)+"_"+Macroblif_name; 
                    end
                    col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
            end
            
            sum_p=0; // # of rpar parameter in an element
            for j=1:strtod(blif_temp1(6)) // Parameters
                para_typ_comp=blif_temp1(col_bi);
                if para_typ_comp=="0" | para_typ_comp=="2" | para_typ_comp=="4" | para_typ_comp=="6" then // connection or hidden
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
                if para_typ_comp=="1" | para_typ_comp=="5" then // bias, smcap
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;sum_p=sum_p+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=string(No_rpar);
                    mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
                    mblif_xcos(4,2*col_mblif_xcos+3)=blif_info_line4(2*col_mblif_xcos2+3)+"_"+Macroblif_name+"_"+ele_index(4)+"_"+ele_index(5);
                    mblif_xcos(4,2*col_mblif_xcos+4)=str_temp(col_blif+2);
                    mblif_xcos(5,col_mblif_xcos+2)=blif_info_line5(col_mblif_xcos2+2)+"_"+Macroblif_name+"_"+ele_index(4)+"_"+ele_index(5);
                    mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
                    mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
                    No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_mblif_xcos2=col_mblif_xcos2+1;col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                end
                if para_typ_comp=="3" then // cap
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;sum_p=sum_p+1;
                    temp_a=strsplit(str_temp(col_blif+1),'#',5);
                    match_ele(No_ele,col_match)=temp_a(2);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=string(No_rpar);
                    mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
                    mblif_xcos(4,2*col_mblif_xcos+3)=blif_info_line4(2*col_mblif_xcos2+3)+"_"+Macroblif_name+"_"+ele_index(4)+"_"+ele_index(5);
                    mblif_xcos(4,2*col_mblif_xcos+4)=str_temp(col_blif+2); temp_b=str_temp(col_blif+2);
                    if temp_b == "1" | temp_b == "2" | temp_b == "4" then col_blif=col_blif+1;
                    elseif temp_b == "3" | temp_b == "5" | temp_b == "6" then col_blif=col_blif+4;
                    elseif temp_b == "7" then col_blif=col_blif+7;
                    end
                    mblif_xcos(5,col_mblif_xcos+2)=blif_info_line5(col_mblif_xcos2+2)+"_"+Macroblif_name+"_"+ele_index(4)+"_"+ele_index(5);
                    mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
                    mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
                    No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_mblif_xcos2=col_mblif_xcos2+1;col_match=col_match+1;col_bi=col_bi+1;
                end
            end
        end
        mclose(fd_r1);
        
        mgetl(fd_r, 1); // 9th line
        ele_index=mgetl(fd_r, 1); ele_index=strsplit(ele_index,' ',100);
    end
    
    mblif_xcos(3,1)=string(col_mblif_xcos-1+1);
    mblif_xcos(1,4)=string(col_mblif_xcos-1+1+2);
    mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
    mblif_xcos(4,2*col_mblif_xcos+3)="fix_loc''";
    mblif_xcos(4,2*col_mblif_xcos+4)="[0;0;0]";
    mblif_xcos(5,col_mblif_xcos+2)="fix_loc";
    mblif_xcos(6,1)=string(col_mblif_xcos-1);
    mblif_xcos(7,1)=string(No_ele);mblif_xcos(7,2)=string(vcc_flag);mblif_xcos(7,3)=string(gnd_flag);
    
    mclose(fd_r);
    
    for i=1:No_ele
        for j=1:No_ele
            if match_ele(i,2) == match_ele(j,2) & i ~= j then messagebox("""mblif_num"" should not be overlapped.", "mblif_num error", "error"); abort; end
        end
    end
    
    //disp(mblif_xcos);
    //disp(match_ele);
    
    
    
    
    
    
    
    
    
    

    
    disp("Macro-BLIF block has been generated.");
    //disp(string(No_of_para_sci2blif)+"="+string(No_of_para_xcos)+"? (should be same.)")
    filebrowser();
    
endfunction
