global file_name path fname extension chip_num board_num brdtype Macroblif_name folder_name bl_level;

function dir_callback()
    disp("   ");
endfunction

function MB_folder_name_callback()
    global folder_name;
    folder_name_obj = findobj('tag','MB_folder_name');
    folder_name = folder_name_obj.string;
endfunction

function MB_block_name_callback()
    global Macroblif_name;
    block_name_obj = findobj('tag','MB_block_name');
    Macroblif_name = block_name_obj.string;
endfunction

function MB_bl_level_callback()
    global bl_level;
    bl_level="5"; // 5: "Mixed sp" 1_1: "level 1" 2: "level 2"
    bl_level_obj = findobj('tag','Block_level');
    bl_level = bl_level_obj.value;
    if bl_level_obj.value == 1 then messagebox('Please define level of the block.', "Block category error", "error"); abort;
    elseif bl_level_obj.value == 2 then bl_level="1_1"; // Level 1
    elseif bl_level_obj.value == 3 then bl_level="2"; // Level 2
    end
endfunction

function Start_MB_design_callback()
    global Macroblif_name folder_name;
    
    // Macro cab block name overlap check
    file_list=listfiles("/home/ubuntu/rasp30/xcos_blocks/*.sci");
    l_file_list=size(file_list,1);
    for ii=1:l_file_list
        if file_list(ii) == "/home/ubuntu/rasp30/xcos_blocks/"+Macroblif_name+".sci" then messagebox('Please change the name of macro-cab block.', "Macroblock name error", "error"); abort; end
    end
    
    temp_string="/home/ubuntu/RASP_Workspace/"+folder_name;
    mkdir(temp_string);
    cd(temp_string);
    xcos(Macroblif_name+".xcos");
    messagebox('Use Macro-BLIF blocks and Save it',"Design Macro-BLIF block", "info", ["OK"], "modal");
endfunction

function Generate_MB_callback()
    global Macroblif_name file_name path fname extension board_num chip_num bl_level;
    
    // Compile and generate blif,pad files
    file_name = "/home/ubuntu/RASP_Workspace/"+folder_name+"/"+Macroblif_name+".xcos";
    show_dsgnmatrics=0;board_num=2;chip_num="21";
    extension = '.xcos';
    Compile_Design_callback();
    
    
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
                if in_typ_comp=="0" then // internal
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
                    match_ele(No_ele,col_match)=blif_temp1(col_bi)+"_"+Macroblif_name+"_"+match_ele(No_ele,2)+"_"+match_ele(No_ele,3);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
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
                    match_ele(No_ele,col_match)=blif_temp1(col_bi)+"_"+Macroblif_name+"_"+match_ele(No_ele,2)+"_"+match_ele(No_ele,3);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
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
                    //match_ele(No_ele,col_match)=temp_a(2);
                    match_ele(No_ele,col_match)=blif_temp1(col_bi);col_match=col_match+1;col_bi=col_bi+1;col_blif=col_blif+1;
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
            disp("aaaa")
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
    
    disp(mblif_xcos);
    disp(match_ele);
    
    //////////////////////////////////
    // Write Block information file 
    //////////////////////////////////
    fd_w= mopen("/home/ubuntu/rasp30/sci2blif/block_info/bi_"+Macroblif_name+".sci",'wt');
    str_temp01=mblif_xcos(1,1)+","+mblif_xcos(1,2)+","+mblif_xcos(1,3)+","+mblif_xcos(1,4);
    str_temp02=mblif_xcos(2,1)+","+mblif_xcos(2,2)+","+mblif_xcos(2,3);
    str_temp03=mblif_xcos(3,1);
    str_temp04=mblif_xcos(4,1)+","+mblif_xcos(4,2)+","+mblif_xcos(4,3)+","+mblif_xcos(4,4);
    str_temp05=mblif_xcos(5,1)+","+mblif_xcos(5,2);
    str_temp06=mblif_xcos(6,1);
    j=1;
    for i=1:strtod(mblif_xcos(6,1))
        str_temp03=str_temp03+","+mblif_xcos(3,i+1);
        str_temp04=str_temp04+","+mblif_xcos(4,2*i+3)+","+mblif_xcos(4,2*i+4);
        str_temp05=str_temp05+","+mblif_xcos(5,i+2);
        str_temp06=str_temp06+","+mblif_xcos(6,2*i)+","+mblif_xcos(6,2*i+1);
        j=i+1;
    end
    str_temp03=str_temp03+","+mblif_xcos(3,j+1);
    str_temp04=str_temp04+","+mblif_xcos(4,2*j+3)+","+mblif_xcos(4,2*j+4);
    str_temp05=str_temp05+","+mblif_xcos(5,j+2);
    str_temp07=mblif_xcos(7,1)+","+mblif_xcos(7,2)+","+mblif_xcos(7,3);
    mputl(str_temp01,fd_w);mputl(str_temp02,fd_w);mputl(str_temp03,fd_w);mputl(str_temp04,fd_w);mputl(str_temp05,fd_w);mputl(str_temp06,fd_w);mputl(str_temp07,fd_w);
    
    for i=1:strtod(mblif_xcos(7,1))
        temp_col=7;
        str_temp=match_ele(i,1)+","+match_ele(i,2)+","+match_ele(i,3)+","+match_ele(i,4)+","+match_ele(i,5)+","+match_ele(i,6);
        for j=1:strtod(match_ele(i,4))
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
        end
        for j=1:strtod(match_ele(i,5))
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
        end
        for j=1:strtod(match_ele(i,6))
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
            str_temp=str_temp+','+match_ele(i,temp_col);temp_col=temp_col+1;
        end
        mputl(str_temp,fd_w);
    end
    
    mputl("//------ Here, everything should be in Order with no space ------//",fd_w);
    mputl("// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)",fd_w);
    mputl("// # of ipar, order",fd_w);
    mputl("// # of rpar, order",fd_w);
    mputl("// Xcos parameter, default value, ...",fd_w);
    mputl("// Xcos parameters - exprs",fd_w);
    mputl("// # of user defined rpars, BLIF block #, column #, ...",fd_w);
    mputl("// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag",fd_w);
    mputl("// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar",fd_w);
    
    mclose(fd_w);
    
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
    
    
    /////////////////////
    // Make Xcos block
    /////////////////////
    mblif_name=mblif_xcos_r(1,1); // mblif name
    input_num=strtod(mblif_xcos_r(1,2)); // # of inputs
    output_num=strtod(mblif_xcos_r(1,3)); // # of outputs
    ipar_num=strtod(mblif_xcos_r(2,1)); // # of ipar
    rpar_num=strtod(mblif_xcos_r(3,1)); // # of rpar
    ipar_rpar_num=ipar_num+rpar_num; // # of ipar + # of rpar
    set_str1="";set_str2="";set_str3="";set_ipar="";set_rpar="";define_str=[""];model_in="";model_out="";exprs_str="";
    for i=1:ipar_rpar_num
        set_str1=set_str1+mblif_xcos_r(5,i);
        set_str2=set_str2+"''"+mblif_xcos_r(5,i)+"''";
        set_str3=set_str3+"''vec'',-1";
        define_str(i)="        "+mblif_xcos_r(5,i)+"="+mblif_xcos_r(4,2*i)+";";
        exprs_str=exprs_str+"sci2exp("+mblif_xcos_r(5,i)+")";
        if i~=ipar_rpar_num then set_str1=set_str1+",";set_str2=set_str2+";";set_str3=set_str3+","; exprs_str=exprs_str+";"; end
    end
    for i=1:ipar_num
        set_ipar=set_ipar+mblif_xcos_r(4,2*i-1);
        if i~=ipar_num then set_ipar=set_ipar+","; end
    end
    for i=1:rpar_num
        set_rpar=set_rpar+mblif_xcos_r(4,2*i+3);
        if i~=rpar_num then set_rpar=set_rpar+","; end
    end
    for i=1:input_num
        model_in=model_in+"-1";
        if i~=input_num then model_in=model_in+";"; end
    end
    for i=1:output_num
        model_out=model_out+"-1";
        if i~=output_num then model_out=model_out+";"; end
    end
    fd_w= mopen ("/home/ubuntu/rasp30/xcos_blocks/"+Macroblif_name+".sci",'wt');
    //fd_w= mopen (mblif_name+"_xcos.sci",'wt');
    mputl("function [x,y,typ]="+mblif_name+"(job,arg1,arg2)",fd_w);
    mputl("    x=[];y=[];typ=[];",fd_w);
    mputl("    select job",fd_w);
    mputl("    case ''plot'' then standard_draw(arg1)",fd_w);
    mputl("    case ''getinputs'' then [x,y,typ]=standard_inputs(arg1)",fd_w);
    mputl("    case ''getoutputs'' then [x,y,typ]=standard_outputs(arg1)",fd_w);
    mputl("    case ''getorigin'' then [x,y]=standard_origin(arg1)",fd_w);
    mputl("    case ''set'' then",fd_w);
    mputl("        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;",fd_w);
    mputl("        while %t do",fd_w);
    mputl("            [ok,"+set_str1+",exprs]=scicos_getvalue(''New Block Parameter'',["+set_str2+"],list("+set_str3+"),exprs);",fd_w);
    mputl("            if ~ok then break,end",fd_w);
    mputl("            if ok then",fd_w);
    mputl("                model.ipar=["+set_ipar+"];",fd_w);
    mputl("                model.rpar=["+set_rpar+"];",fd_w);
    mputl("                graphics.exprs=exprs;",fd_w);
    mputl("                x.graphics=graphics;",fd_w);
    mputl("                x.model=model",fd_w);
    mputl("                break;",fd_w);
    mputl("            end",fd_w);
    mputl("        end",fd_w);
    mputl("    case ''define'' then",fd_w);
    mputl(define_str,fd_w);
    mputl("        model=scicos_model();",fd_w);
    mputl("        model.sim=list(''"+mblif_name+"_c'',5);",fd_w);
    mputl("        model.in=["+model_in+"];",fd_w);
    mputl("        model.in2=["+model_in+"];",fd_w);
    mputl("        model.intyp=["+model_in+"];",fd_w);
    mputl("        model.out=["+model_out+"];",fd_w);
    mputl("        model.out2=["+model_out+"];",fd_w);
    mputl("        model.outtyp=["+model_out+"];",fd_w);
    mputl("        model.ipar=["+set_ipar+"];",fd_w);
    mputl("        model.rpar=["+set_rpar+"];",fd_w);
    mputl("        model.blocktype=''d'';",fd_w);
    mputl("        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]",fd_w);
    mputl("        ",fd_w);
    mputl("        exprs=["+exprs_str+"];",fd_w);
    mputl("        gr_i=[''text=[''''"+mblif_name+"''''];'';''xstringb(orig(1),orig(2),txt,sz(1),sz(2),''''fill'''');'']",fd_w);
    mputl("        x=standard_define([5 2],model, exprs,gr_i) //Numbers define the width and height of block",fd_w);
    mputl("    end",fd_w);
    mputl("endfunction",fd_w);
    mclose(fd_w);
    
    
    //////////////////////////////////////////////
    // Generate rasp_design function 
    //////////////////////////////////////////////
    fd_w= mopen ("/home/ubuntu/rasp30/sci2blif/rasp_design_added_blocks/"+Macroblif_name+".sce",'wt');
    //fd_w= mopen (mblif_name+"_rasp_design.sce",'wt');
    mputl("style.fontSize=12;",fd_w);
    mputl("style.displayedLabel="""+mblif_name+""";",fd_w);
    mputl("pal"+bl_level+"=xcosPalAddBlock(pal"+bl_level+","""+mblif_name+""",[],style);",fd_w);
    mclose(fd_w);
    
    
    //////////////////////////////////////////////
    // Generate sci2blif function
    //////////////////////////////////////////////
    blif_bl_num=strtod(mblif_xcos_r(7,1)); // # of BLIF blocks
    fd_w= mopen ("/home/ubuntu/rasp30/sci2blif/sci2blif_added_blocks/"+Macroblif_name+".sce",'wt');
    //fd_w= mopen (mblif_name+"_sci2blif.sce",'wt');
    mputl("//**************************** "+mblif_name+" **********************************",fd_w);
    mputl("if (blk_name.entries(bl) == """+mblif_name+""") then",fd_w);
    mputl("    for ss=1:scs_m.objs(bl).model.ipar(1)",fd_w);
    mputl("        mputl(""# "+mblif_name+" ""+string(bl)+"" ""+string(scs_m.objs(bl).model.ipar(2))+"" ""+string(ss),fd_w);",fd_w);
    
    for i=1:blif_bl_num
        sci2blif_str="";
        str_line=1;
        sci2blif_str(str_line)="        sci2blif_str= "".subckt "+ele_index_r(i,1)+"""";
        k=7;
        for j=1:strtod(ele_index_r(i,4)) // # of inputs
            sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" in["+string(j-1)+"]=";
            if strtod(ele_index_r(i,k))==0 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_"+"""+string(bl)+""_""+string(ss)"; end
            if strtod(ele_index_r(i,k))==1 then 
                if strtod(ele_index_r(i,k+1)) <= input_num then sci2blif_str(str_line)=sci2blif_str(str_line)+"net""+string(blk(blk_objs(bl),"+string(strtod(ele_index_r(i,k+1))+1)+"))+""_""+string(ss)"; end
                if strtod(ele_index_r(i,k+1)) > input_num then sci2blif_str(str_line)=sci2blif_str(str_line)+"net""+string(blk(blk_objs(bl),"+string(strtod(ele_index_r(i,k+1))+1-input_num)+"+numofip))+""_""+string(ss)"; end
            end
            if strtod(ele_index_r(i,k))==2 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+""""; end
            if strtod(ele_index_r(i,k))==3 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+""""; end
            k=k+2;
        end
        for j=1:strtod(ele_index_r(i,5)) // # of outputs
            sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" out["+string(j-1)+"]=";
            if strtod(ele_index_r(i,k))==0 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_"+"""+string(bl)+""_""+string(ss)"; end
            if strtod(ele_index_r(i,k))==1 then 
                if strtod(ele_index_r(i,k+1)) <= input_num then sci2blif_str(str_line)=sci2blif_str(str_line)+"net""+string(blk(blk_objs(bl),"+string(strtod(ele_index_r(i,k+1))+1)+"))+""_""+string(ss)"; end
                if strtod(ele_index_r(i,k+1)) > input_num then sci2blif_str(str_line)=sci2blif_str(str_line)+"net""+string(blk(blk_objs(bl),"+string(strtod(ele_index_r(i,k+1))+1-input_num)+"+numofip))+""_""+string(ss)"; end
            end
            k=k+2;
        end
        for j=1:strtod(ele_index_r(i,6)) // # of parameters
            if strtod(ele_index_r(i,k))==0 then 
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+" ="+ele_index_r(i,k+2)+"""";
            end
            if strtod(ele_index_r(i,k))==1 then 
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+" =""+string(sprintf(''%e'',scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss)))";
            end
            if strtod(ele_index_r(i,k))==2 then 
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+" ="+ele_index_r(i,k+2)+"""";
            end
            if strtod(ele_index_r(i,k))==3 then
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"""; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"""; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+";"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 1 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_1x_cs =1""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 2 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_2x_cs =2""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 3 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_1x_cs =3"+"&"+ele_index_r(i,k+1)+"_2x_cs =0""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 4 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_4x_cs =4""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 5 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_1x_cs =5"+"&"+ele_index_r(i,k+1)+"_4x_cs =0""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 6 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_2x_cs =6"+"&"+ele_index_r(i,k+1)+"_4x_cs =0""; end"; str_line=str_line+1;
                sci2blif_str(str_line)="        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss) == 7 then sci2blif_str=sci2blif_str+"""+ele_index_r(i,k+1)+"_1x_cs =7"+"&"+ele_index_r(i,k+1)+"_2x_cs =0"+"&"+ele_index_r(i,k+1)+"_4x_cs =0""; end"; str_line=str_line+1;
            end
            if strtod(ele_index_r(i,k))==4 then
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                if strtod(ele_index_r(i,k+2)) == 1 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_1x_cs =1"""; end
                if strtod(ele_index_r(i,k+2)) == 2 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_2x_cs =2"""; end
                if strtod(ele_index_r(i,k+2)) == 3 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_1x_cs =3"+"&"+ele_index_r(i,k+1)+"_2x_cs =0"""; end
                if strtod(ele_index_r(i,k+2)) == 4 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_4x_cs =4"""; end
                if strtod(ele_index_r(i,k+2)) == 5 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_1x_cs =5"+"&"+ele_index_r(i,k+1)+"_4x_cs =0"""; end
                if strtod(ele_index_r(i,k+2)) == 6 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_2x_cs =6"+"&"+ele_index_r(i,k+1)+"_4x_cs =0"""; end
                if strtod(ele_index_r(i,k+2)) == 7 then sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+"_1x_cs =7"+"&"+ele_index_r(i,k+1)+"_2x_cs =0"+"&"+ele_index_r(i,k+1)+"_4x_cs =0"""; end
            end
            if strtod(ele_index_r(i,k))==5 then
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+" =""+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+ele_index_r(i,k+2)+"-1)+ss))";
            end
            if strtod(ele_index_r(i,k))==6 then
                if j==1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+"" #"; end
                if j~=1 then sci2blif_str(str_line)=sci2blif_str(str_line)+"+""&"; end
                sci2blif_str(str_line)=sci2blif_str(str_line)+ele_index_r(i,k+1)+" ="+ele_index_r(i,k+2)+"""";
            end
            k=k+3;
        end
        mputl(sci2blif_str,fd_w);
        mputl("        mputl(sci2blif_str,fd_w);",fd_w);
        mputl("        mputl(""  "",fd_w);",fd_w);
    end
    mputl("    end",fd_w);
    //mputl("    mputl("""",fd_w);",fd_w);
    mputl("end",fd_w);
    mclose(fd_w);
    
    //////////////////////////////////////////////
    // Generate sci2blif function
    //////////////////////////////////////////////
    if vcc_flag == 1 | gnd_flag == 1 then
        fd_w= mopen ("/home/ubuntu/rasp30/sci2blif/sci2pads_added_blocks/"+Macroblif_name+".sce",'wt');
        mputl("if (blk_name.entries(bl) == """+Macroblif_name+""") then",fd_w);
        if vcc_flag then mputl("    fix_vdd = 1;",fd_w); end
        if gnd_flag then mputl("    fix_gnd = 1;",fd_w); end
        mputl("end",fd_w);
        mclose(fd_w);
    end
    
    unix_w("cp "+Macroblif_name+".xcos /home/ubuntu/rasp30/sci2blif/xcos_ref/macroblif_generation/");
    
    disp("Macro-BLIF block has been generated.");
    //disp(string(No_of_para_sci2blif)+"="+string(No_of_para_xcos)+"? (should be same.)")
    filebrowser();
    
endfunction
