global file_name path fname extension chip_num board_num brdtype macrocab_name folder_name bl_level;

function dir_callback()
    disp("   ");
endfunction

function MC_folder_name_callback()
    global folder_name;
    folder_name_obj = findobj('tag','MC_folder_name');
    folder_name = folder_name_obj.string;
endfunction

function MC_block_name_callback()
    global macrocab_name;
    block_name_obj = findobj('tag','MC_block_name');
    macrocab_name = block_name_obj.string;
endfunction

function MC_bl_level_callback()
    global bl_level;
    bl_level="5"; // 5: "Mixed sp" 1_1: "level 1" 2: "level 2"
    bl_level_obj = findobj('tag','Block_level');
    bl_level = bl_level_obj.value;
    if bl_level_obj.value == 1 then messagebox('Please define level of the block.', "Block category error", "error"); abort;
    elseif bl_level_obj.value == 2 then bl_level="1_1"; // Level 1
    elseif bl_level_obj.value == 3 then bl_level="2"; // Level 2
    end
endfunction

function Start_MC_design_callback()
    global macrocab_name folder_name;
    
    // Macro cab block name overlap check
    fd_r = mopen("/home/ubuntu/rasp30/vpr2swcs/block_list",'r');block_list=mgetl(fd_r);mclose(fd_r);  // Default value: frame. 
    l_block_list=size(block_list,1);
    for ii=1:l_block_list
        if block_list(ii) == macrocab_name then messagebox('Please change the name of macro-cab block.', "Macroblock name error", "error"); abort; end
    end
    file_list=listfiles("/home/ubuntu/rasp30/xcos_blocks/*.sci");
    l_file_list=size(file_list,1);
    for ii=1:l_file_list
        if file_list(ii) == "/home/ubuntu/rasp30/xcos_blocks/"+macrocab_name+".sci" then messagebox('Please change the name of macro-cab block.', "Macroblock name error", "error"); abort; end
    end
    
    temp_string="/home/ubuntu/RASP_Workspace/"+folder_name;
    mkdir(temp_string);
    cd(temp_string);
    unix_g("cp /home/ubuntu/rasp30/sci2blif/xcos_ref/macrocab_generation/macrocab_xcosref_30_30a.xcos "+macrocab_name+".xcos");
    xcos(macrocab_name+".xcos");
    messagebox('Make changes based on the provided xcos and Save it',"Design Macro-CAB block", "info", ["OK"], "modal");
endfunction

function Generate_MC_callback()
    clear blk;
    global macrocab_name bl_level;
    
    xcos(macrocab_name+".xcos");
    importXcosDiagram(macrocab_name+".xcos");
    no=length(scs_m.objs);
    
    objnum=1; numoflink=0; numofblk=0; blk_objs=[]; link_name=zeros(1,no);
    
    j=1;
    for i =1:no
        if(length(scs_m.objs(i))==5)  then // Blocks
            blk(j,1)=i;
            blk_name.entries(j)=scs_m.objs(i).gui;
            blk_objs(objnum)=j; //BLOCK NUMBER actually stored
            objnum=objnum+1;
            j=j+1;
            numofblk=numofblk+1;
        end
    end
    
    // Get block information
    input_matrix=[0 0]; output_matrix=[0 0]; 
    j_fgswc=1; fgswc_matrix=["" ""]; 
    j_fgota=1; fgota_matrix=["" ""];
    j_ota=1; ota_matrix=["" ""];
    j_cap=1; cap_matrix=["" ""];
    sum_p=0; // # of rpar parameter in an element
    for bl=1:length(blk_objs)
        if (blk_name.entries(bl)=='macrocab_in')  then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                input_matrix(strtod(scs_m.objs(bl).model.rpar(1))+1,1)=strtod(scs_m.objs(bl).model.rpar(1));
                input_matrix(strtod(scs_m.objs(bl).model.rpar(1))+1,2)=scs_m.objs(bl).model.ipar(1); 
            end
        end
        if (blk_name.entries(bl)=='macrocab_out')  then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                output_matrix(strtod(scs_m.objs(bl).model.rpar(1))+1,1)=strtod(scs_m.objs(bl).model.rpar(1));
                output_matrix(strtod(scs_m.objs(bl).model.rpar(1))+1,2)=scs_m.objs(bl).model.ipar(1); 
            end
        end
        if (blk_name.entries(bl)=='macrocab_fgswc')  then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                fgswc_matrix(j_fgswc,1) = scs_m.objs(bl).model.rpar(1);
                fgswc_matrix(j_fgswc,2) = string(scs_m.objs(bl).model.ipar(1));
                fgswc_matrix(j_fgswc,3) = string(scs_m.objs(bl).model.ipar(2));
                if scs_m.objs(bl).model.rpar(1) == "T" then
                    fgswc_matrix(j_fgswc,4) = scs_m.objs(bl).model.rpar(2);
                    fgswc_matrix(j_fgswc,5) = scs_m.objs(bl).model.rpar(3);
                    sum_p=sum_p+1;
                end
                j_fgswc=j_fgswc+1;
            end
        end
        if (blk_name.entries(bl)=='macrocab_fgota0') | (blk_name.entries(bl)=='macrocab_fgota1') then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                for ii=1:7
                    fgota_matrix(j_fgota,ii) = scs_m.objs(bl).model.rpar(ii+1);
                end
                for ii=1:10
                    fgota_matrix(j_fgota,ii+7) = string(scs_m.objs(bl).model.ipar(ii));
                end
                j_fgota=j_fgota+1;
                sum_p=sum_p+3;
            end
        end
        if (blk_name.entries(bl)=='macrocab_ota0') | (blk_name.entries(bl)=='macrocab_ota1') then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                ota_matrix(j_ota,1) = scs_m.objs(bl).model.rpar(2);
                ota_matrix(j_ota,2) = scs_m.objs(bl).model.rpar(3);
                ota_matrix(j_ota,3) = string(scs_m.objs(bl).model.ipar(1));
                ota_matrix(j_ota,4) = string(scs_m.objs(bl).model.ipar(2));
                j_ota=j_ota+1;
                sum_p=sum_p+1;
            end
        end
        if (blk_name.entries(bl)=='macrocab_cap0') | (blk_name.entries(bl)=='macrocab_cap1') | (blk_name.entries(bl)=='macrocab_cap2') | (blk_name.entries(bl)=='macrocab_cap3') then
            if scs_m.objs(bl).model.rpar(1) ~= "-" then
                cap_matrix(j_cap,1) = scs_m.objs(bl).model.rpar(2);
                cap_matrix(j_cap,2) = string(scs_m.objs(bl).model.ipar(1));
                cap_matrix(j_cap,3) = string(scs_m.objs(bl).model.ipar(2));
                cap_matrix(j_cap,4) = string(scs_m.objs(bl).model.ipar(3));
                cap_matrix(j_cap,5) = string(scs_m.objs(bl).model.ipar(4));
                cap_matrix(j_cap,6) = string(scs_m.objs(bl).model.ipar(5));
                cap_matrix(j_cap,7) = string(scs_m.objs(bl).model.ipar(6));
                j_cap=j_cap+1;
                sum_p=sum_p+1;
            end
        end
    end
    
    //disp(input_matrix); disp(output_matrix); disp(fgswc_matrix); disp(fgota_matrix); disp(ota_matrix); disp(cap_matrix);
    
    numofinput = size(input_matrix,1);
    numofoutput = size(output_matrix,1);
    numoffgswc = size(fgswc_matrix,1); if fgswc_matrix == ["" ""] then numoffgswc =0; end
    numoffgota = size(fgota_matrix,1); if fgota_matrix == ["" ""] then numoffgota =0; end
    numofota = size(ota_matrix,1); if ota_matrix == ["" ""] then numofota =0; end
    numofcap = size(cap_matrix,1); if cap_matrix == ["" ""] then numofcap =0; end
    
    // arch
    fd_w= mopen("rasp3_arch_"+macrocab_name+"_1.xml",'wt');
    mputl(msprintf("\t\t")+"<model name="""+macrocab_name+""">",fd_w);
    mputl(msprintf("\t\t\t")+"<input_ports>",fd_w);
    mputl(msprintf("\t\t\t\t")+"<port name=""in""/>",fd_w);
    mputl(msprintf("\t\t\t")+"</input_ports>",fd_w);
    mputl(msprintf("\t\t\t")+"<output_ports>",fd_w);
    mputl(msprintf("\t\t\t\t")+"<port name=""out""/>",fd_w);
    mputl(msprintf("\t\t\t")+"</output_ports>",fd_w);
    mputl(msprintf("\t\t")+"</model>",fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp3_arch_"+macrocab_name+"_2.xml",'wt');
    mputl(msprintf("\t\t\t")+"<pb_type name="""+macrocab_name+""" blif_model=""."+macrocab_name+""" num_pb=""1"">",fd_w);
    mputl(msprintf("\t\t\t\t")+"<input name=""in"" num_pins="""+string(numofinput)+"""/>",fd_w);
    mputl(msprintf("\t\t\t\t")+"<output name=""out"" num_pins="""+string(numofoutput)+"""/>",fd_w);
    mputl(msprintf("\t\t\t\t")+"<delay_constant max=""1.667e-9"" in_port="""+macrocab_name+".in"" out_port="""+macrocab_name+".out""/>",fd_w);
    mputl(msprintf("\t\t\t")+"</pb_type>",fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp3_arch_"+macrocab_name+"_3.xml",'wt');
    if numofinput == 1 then mputl(msprintf("\t\t\t\t")+"<complete name=""crossbar"" input=""cab.I[12:0]"" output="""+macrocab_name+".in[0]""/>",fd_w); end
    if numofinput ~= 1 then mputl(msprintf("\t\t\t\t")+"<complete name=""crossbar"" input=""cab.I[12:0]"" output="""+macrocab_name+".in["+string(numofinput-1)+":0]""/>",fd_w); end
    if numofoutput == 1 then mputl(msprintf("\t\t\t\t")+"<complete name=""crossbar"" input="""+macrocab_name+"[0].out[0]"" output=""cab.O[4]""/>",fd_w); end
    if numofoutput ~= 1 then mputl(msprintf("\t\t\t\t")+"<complete name=""crossbar"" input="""+macrocab_name+"[0].out["+string(numofoutput-1)+":0]"" output=""cab.O[4:"+string(4-(numofoutput-1))+"]""/>",fd_w); end
    mclose(fd_w);
    
    // python
    fd_w= mopen("rasp30_"+macrocab_name+"_2_1.py",'wt');
    if numofoutput == 1 then mputl(",''"+macrocab_name+"[0].out[0]''",fd_w); end
    if numofoutput ~= 1 then mputl(",''"+macrocab_name+"[0].out[0:"+string(numofoutput-1)+"]''",fd_w); end
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_3_1.py",'wt');
    if numofinput == 1 then mputl(",''"+macrocab_name+"[0].in[0]''",fd_w); end
    if numofinput ~= 1 then mputl(",''"+macrocab_name+"[0].in[0:"+string(numofinput-1)+"]''",fd_w); end
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_4.py",'wt');
    if numofoutput == 1 then mputl(msprintf("\t\t\t")+"''"+macrocab_name+"[0].out[0]'',[0,"+string(output_matrix(1,2))+"],",fd_w); end
    if numofoutput ~= 1 then 
        output_string_temp="["+string(output_matrix(1,2));
        for ii=2:numofoutput
            output_string_temp=output_string_temp+","+string(output_matrix(ii,2));
        end
        output_string_temp=output_string_temp+"]";
        mputl(msprintf("\t\t\t")+"''"+macrocab_name+"[0].out[0:"+string(numofoutput-1)+"]'',[0,"+output_string_temp+"],",fd_w);
    end
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_5.py",'wt');
    if numofinput == 1 then mputl(msprintf("\t\t\t")+"''"+macrocab_name+"[0].in[0]'',["+string(input_matrix(1,2))+",0],",fd_w); end
    if numofinput ~= 1 then 
        input_string_temp="["+string(input_matrix(1,2));
        for ii=2:numofinput
            input_string_temp=input_string_temp+","+string(input_matrix(ii,2));
        end
        input_string_temp=input_string_temp+"]";
        mputl(msprintf("\t\t\t")+"''"+macrocab_name+"[0].in[0:"+string(numofinput-1)+"]'',["+input_string_temp+",0],",fd_w);
    end
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_7.py",'wt');
    mputl("+[''"+macrocab_name+"'']*1",fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_8_1.py",'wt');
    mputl(",''"+macrocab_name+"_in'':"+string(numofinput),fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_8_2.py",'wt');
    mputl(",''"+macrocab_name+"_out'':"+string(numofoutput),fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_9.py",'wt');
    mputl(msprintf("\t\t\t")+"''"+macrocab_name+"[0]'',[0,0],",fd_w);
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_10.py",'wt');
    ls_temp = msprintf("\t\t\t")+"''"+macrocab_name+"_ls[0]'',[";    // ls: local switch
    comma_string="";
    ls_flag=0; // 0: off, 1: on
    if numoffgswc ~= 0 then
        for ii=1:numoffgswc
            if fgswc_matrix(ii,1) == "C" then ls_temp=ls_temp+comma_string+"["+fgswc_matrix(ii,2)+","+fgswc_matrix(ii,3)+"]";comma_string=","; ls_flag=1; end
        end
    end
    if numoffgota ~= 0 then
        for ii=1:numoffgota
            if fgota_matrix(ii,7) == "0" then ls_temp=ls_temp+comma_string+"["+fgota_matrix(ii,14)+","+fgota_matrix(ii,15)+"],["+fgota_matrix(ii,16)+","+fgota_matrix(ii,17)+"]"; comma_string=","; ls_flag=1; end
        end
    end
    ls_temp = ls_temp + "],";
    if ls_flag == 1 then mputl(ls_temp,fd_w); end
    
    if numofcap ~= 0 then
        for ii=1:numofcap   // cs: cap switch
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+cap_matrix(ii,1)+"_4x_cs[0]'',["+cap_matrix(ii,2)+","+cap_matrix(ii,3)+"],",fd_w);
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+cap_matrix(ii,1)+"_2x_cs[0]'',["+cap_matrix(ii,4)+","+cap_matrix(ii,5)+"],",fd_w);
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+cap_matrix(ii,1)+"_1x_cs[0]'',["+cap_matrix(ii,6)+","+cap_matrix(ii,7)+"],",fd_w);
        end
    end
    if numoffgota ~= 0 then
        for ii=1:numoffgota
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+fgota_matrix(ii,1)+"[0]'',["+fgota_matrix(ii,8)+","+fgota_matrix(ii,9)+"],",fd_w);
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+fgota_matrix(ii,3)+"[0]'',["+fgota_matrix(ii,10)+","+fgota_matrix(ii,11)+"],",fd_w);
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+fgota_matrix(ii,5)+"[0]'',["+fgota_matrix(ii,12)+","+fgota_matrix(ii,13)+"],",fd_w);
        end
    end
    if numofota ~= 0 then
        for ii=1:numofota
            mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+ota_matrix(ii,1)+"[0]'',["+ota_matrix(ii,3)+","+ota_matrix(ii,4)+"],",fd_w);
        end
    end
    if numoffgswc ~= 0 then
        for ii=1:numoffgswc
            if fgswc_matrix(ii,1) == "T" then mputl(msprintf("\t\t\t")+"''"+macrocab_name+"_"+fgswc_matrix(ii,4)+"[0]'',["+fgswc_matrix(ii,2)+","+fgswc_matrix(ii,3)+"],",fd_w); end
        end
    end
    mclose(fd_w);
    
    fd_w= mopen("rasp30_"+macrocab_name+"_11.py",'wt');
    append1_temp = msprintf("\t\t\t\t\t\t\t\t")+"elif swc_name1 in [";    // append1: local target (FGs)
    comma_string="";
    append1_flag=0; // 0: off, 1: on
    if numoffgswc ~= 0 then
        for ii=1:numoffgswc
            if fgswc_matrix(ii,1) == "T" then append1_temp=append1_temp+comma_string+"''"+macrocab_name+"_"+fgswc_matrix(ii,4)+"[0]''";comma_string=","; append1_flag=1; end
        end
    end
    append1_temp = append1_temp + "]:";
    if append1_flag == 1 then mputl(append1_temp,fd_w); mputl(msprintf("\t\t\t\t\t\t\t\t\t")+"swcx.append(1)",fd_w); end
    
    append2_temp = msprintf("\t\t\t\t\t\t\t\t")+"elif swc_name1 in [";    // append2: ota bias
    comma_string="";
    append2_flag=0; // 0: off, 1: on
    if numofota ~= 0 then
        for ii=1:numofota
            append2_temp=append2_temp+comma_string+"''"+macrocab_name+"_"+ota_matrix(ii,1)+"[0]''"; comma_string=","; append2_flag=1;
        end
    end
    if numoffgota ~= 0 then
        for ii=1:numoffgota
            append2_temp=append2_temp+comma_string+"''"+macrocab_name+"_"+fgota_matrix(ii,1)+"[0]''"; comma_string=","; append2_flag=1;
        end
    end
    append2_temp = append2_temp + "]:";
    if append2_flag == 1 then mputl(append2_temp,fd_w); mputl(msprintf("\t\t\t\t\t\t\t\t\t")+"swcx.append(2)",fd_w); end
    
    append3_temp = msprintf("\t\t\t\t\t\t\t\t")+"elif swc_name1 in [";    // append3: fgota input FG bias
    comma_string="";
    append3_flag=0; // 0: off, 1: on
    if numoffgota ~= 0 then
        for ii=1:numoffgota
            append3_temp=append3_temp+comma_string+"''"+macrocab_name+"_"+fgota_matrix(ii,3)+"[0]''"; comma_string=",";
            append3_temp=append3_temp+comma_string+"''"+macrocab_name+"_"+fgota_matrix(ii,5)+"[0]''"; comma_string=",";
            append3_flag=1;
        end
    end
    append3_temp = append3_temp + "]:";
    if append3_flag == 1 then mputl(append3_temp,fd_w); mputl(msprintf("\t\t\t\t\t\t\t\t\t")+"swcx.append(3)",fd_w); end
    mclose(fd_w);
    
    
    // genswcs.py
    fd_w= mopen("genswcs_"+macrocab_name+"_2_1.py",'wt');
    if numofoutput > 1 then mputl(",''"+macrocab_name+"[0]''",fd_w); end
    mclose(fd_w);
    
    fd_w= mopen("genswcs_"+macrocab_name+"_4_1.py",'wt');
    if numofoutput > 1 then mputl(",''"+macrocab_name+"[0]''",fd_w); end
    mclose(fd_w);
    
    fd_w= mopen("genswcs_"+macrocab_name+"_5.py",'wt');
    mputl(msprintf("\t\t\t\t")+"elif subckt in [''"+macrocab_name+"'']:",fd_w);
    mputl(msprintf("\t\t\t\t\t")+"key=ports["+string(numofinput)+"]",fd_w);
    mclose(fd_w);
    
    
    dir_frame ="/home/ubuntu/rasp30/vpr2swcs/macroblk_generation/frame/";
    
    // .xml (arch)
    rasp_xml_list={"rasp3";"rasp3a";};
    l_rasp_xml_list=size(rasp_xml_list,1);
    for ii=1:l_rasp_xml_list
        unix_w("cat "+dir_frame+rasp_xml_list(ii)+"_arch_frame1.xml rasp3_arch_"+macrocab_name+"_1.xml > "+rasp_xml_list(ii)+"_arch_gen1.xml");
        unix_w("cat "+dir_frame+rasp_xml_list(ii)+"_arch_frame2.xml rasp3_arch_"+macrocab_name+"_2.xml > "+rasp_xml_list(ii)+"_arch_gen2.xml");
        unix_w("cat "+dir_frame+rasp_xml_list(ii)+"_arch_frame3.xml rasp3_arch_"+macrocab_name+"_3.xml > "+rasp_xml_list(ii)+"_arch_gen3.xml");
    end
    
    // .py (python)
    rasp_py_list={"rasp30";"rasp30a";};
    l_rasp_py_list=size(rasp_py_list,1);
    for ii=1:l_rasp_py_list
        //unix_w("cp "+dir_frame+rasp_py_list(ii)+"_frame1.py .");
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame2_1.py",'r');temp2=mgetl(fd_r);mclose(fd_r); 
        fd_r = mopen("rasp30_"+macrocab_name+"_2_1.py",'r');temp2=temp2+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_frame2_1.py",'wt');mputl(temp2,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame2_2.py",'r');temp2=temp2+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_gen2.py",'wt');mputl(temp2,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame3_1.py",'r');temp3=mgetl(fd_r);mclose(fd_r); 
        fd_r = mopen("rasp30_"+macrocab_name+"_3_1.py",'r');temp3=temp3+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_frame3_1.py",'wt');mputl(temp3,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame3_2.py",'r');temp3=temp3+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_gen3.py",'wt');mputl(temp3,fd_w);mclose(fd_w);
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame4.py rasp30_"+macrocab_name+"_4.py > "+rasp_py_list(ii)+"_gen4.py");
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame5.py rasp30_"+macrocab_name+"_5.py > "+rasp_py_list(ii)+"_gen5.py");
        //unix_w("cp "+dir_frame+rasp_py_list(ii)+"_frame6.py .");
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame7.py",'r');temp7=mgetl(fd_r);mclose(fd_r); 
        fd_r = mopen("rasp30_"+macrocab_name+"_7.py",'r');temp7=temp7+mgetl(fd_r);mclose(fd_r); 
        fd_w= mopen(rasp_py_list(ii)+"_gen7.py",'wt');mputl(temp7,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame8_1.py",'r');temp8_1=mgetl(fd_r);mclose(fd_r);
        fd_r = mopen("rasp30_"+macrocab_name+"_8_1.py",'r');temp8_1=temp8_1+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_frame8_1.py",'wt');mputl(temp8_1,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame8_2.py",'r');temp8_2=mgetl(fd_r);mclose(fd_r);
        fd_r = mopen("rasp30_"+macrocab_name+"_8_2.py",'r');temp8_2=temp8_2+mgetl(fd_r);mclose(fd_r);
        fd_w= mopen(rasp_py_list(ii)+"_frame8_2.py",'wt');mputl(temp8_2,fd_w);mclose(fd_w);
        fd_r = mopen(dir_frame+rasp_py_list(ii)+"_frame8_3.py",'r');temp8=temp8_1+temp8_2+mgetl(fd_r);mclose(fd_r); 
        fd_w= mopen(rasp_py_list(ii)+"_gen8.py",'wt');mputl(temp8,fd_w);mclose(fd_w);
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame9.py rasp30_"+macrocab_name+"_9.py > "+rasp_py_list(ii)+"_gen9.py");
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame10.py rasp30_"+macrocab_name+"_10.py > "+rasp_py_list(ii)+"_gen10.py");
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame11.py rasp30_"+macrocab_name+"_11.py > "+rasp_py_list(ii)+"_gen11.py");
        //unix_w("cp "+dir_frame+rasp_py_list(ii)+"_frame12.py .");
    end
    
    // genswcs.py
    fd_r = mopen(dir_frame+"genswcs_frame2_1.py",'r');temp2=mgetl(fd_r);mclose(fd_r);
    fd_r = mopen("genswcs_"+macrocab_name+"_2_1.py",'r');temp2=temp2+mgetl(fd_r);mclose(fd_r);
    fd_w= mopen("genswcs_frame2_1.py",'wt');mputl(temp2,fd_w);mclose(fd_w);
    fd_r = mopen(dir_frame+"genswcs_frame2_2.py",'r');temp2=temp2+mgetl(fd_r);mclose(fd_r);
    fd_w= mopen("genswcs_gen2.py",'wt');mputl(temp2,fd_w);mclose(fd_w);
    fd_r = mopen(dir_frame+"genswcs_frame4_1.py",'r');temp4=mgetl(fd_r);mclose(fd_r);
    fd_r = mopen("genswcs_"+macrocab_name+"_4_1.py",'r');temp4=temp4+mgetl(fd_r);mclose(fd_r);
    fd_w= mopen("genswcs_frame4_1.py",'wt');mputl(temp4,fd_w);mclose(fd_w);
    fd_r = mopen(dir_frame+"genswcs_frame4_2.py",'r');temp4=temp4+mgetl(fd_r);mclose(fd_r);
    fd_w= mopen("genswcs_gen4.py",'wt');mputl(temp4,fd_w);mclose(fd_w);
    unix_w("cat "+dir_frame+"genswcs_frame5.py genswcs_"+macrocab_name+"_5.py > genswcs_gen5.py");
    
    
    
    ////////////////////////////////////////////////////////////
    // Make Block information matrix (mblif_xcos, match_ele)
    ///////////////////////////////////////////////////////////
    clear mblif_xcos match_ele;
    mblif_xcos(1,1)=macrocab_name;
    
    mblif_xcos(1,2)=string(numofinput);
    mblif_xcos(1,3)=string(numofoutput);
    
    mblif_xcos(2,1)="2";mblif_xcos(2,2)="1";mblif_xcos(2,3)="2";
    mblif_xcos(3,1)=string(sum_p+1);
    mblif_xcos(4,1)="num_of_blk";mblif_xcos(4,2)="1";mblif_xcos(4,3)="mblif_num";mblif_xcos(4,4)="0";
    mblif_xcos(5,1)="num_of_blk";mblif_xcos(5,2)="mblif_num";
    
    No_ele=1; // Row in match_ele
    col_match=1; // column in match_ele
    match_ele=[""];
    
    match_ele(No_ele,col_match)=macrocab_name;col_match=col_match+1; // blif block name
    match_ele(No_ele,col_match)=string(1);col_match=col_match+1; // mblif number
    match_ele(No_ele,col_match)=string(1);col_match=col_match+1; // vectorized number
    match_ele(No_ele,col_match)=string(numofinput);col_match=col_match+1; // # of input
    match_ele(No_ele,col_match)=string(numofoutput);col_match=col_match+1; // # of output
    if ls_flag == 0 then // # of blif parameters without ls
        match_ele(No_ele,col_match)=string(sum_p);col_match=col_match+1;
    end 
    if ls_flag == 1 then // # of blif parameters with ls
        match_ele(No_ele,col_match)=string(sum_p+1);col_match=col_match+1; 
    end
    
    No_rpar=1; // rpar number
    col_mblif_xcos=1; // column in bmlif xcos
    ele_index=["#" macrocab_name "bl_no" "1" "1"];
//    col_blif=1; // column in blif
    
    for ii=1:numofinput // Inputs
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // external
        match_ele(No_ele,col_match)=string(ii);col_match=col_match+1;
    end
    for ii=1:numofoutput // Outputs
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // external
        match_ele(No_ele,col_match)=string(ii+numofinput);col_match=col_match+1;
    end
    
    if ls_flag == 1 then // # of blif parameters with ls
        match_ele(No_ele,col_match)="0";col_match=col_match+1;
        match_ele(No_ele,col_match)=macrocab_name+"_ls";col_match=col_match+1;
        match_ele(No_ele,col_match)="0";col_match=col_match+1;
    end
    
    // Parameter order (Important): 1.fgswc 2.fgota 3.ota 4.cap
    for ii=1:numoffgswc
        if fgswc_matrix(ii,1) == "T" then
            match_ele(No_ele,col_match)="1";col_match=col_match+1; //1:bias
            match_ele(No_ele,col_match)=macrocab_name+"_"+fgswc_matrix(ii,4);col_match=col_match+1;
            match_ele(No_ele,col_match)=string(No_rpar);
            mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
            mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+fgswc_matrix(ii,4);
            mblif_xcos(4,2*col_mblif_xcos+4)=fgswc_matrix(ii,5);
            mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+fgswc_matrix(ii,4);
            mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
            mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
            No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1;
        end
    end
    for ii=1:numoffgota // Ibias -> pbias -> nbias
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // 1:bias
        match_ele(No_ele,col_match)=macrocab_name+"_"+fgota_matrix(ii,1);col_match=col_match+1; // Ibias
        match_ele(No_ele,col_match)=string(No_rpar);
        mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
        mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+fgota_matrix(ii,1);
        mblif_xcos(4,2*col_mblif_xcos+4)=fgota_matrix(ii,2);
        mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+fgota_matrix(ii,1);
        mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
        mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
        No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1;
        
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // 1:bias
        match_ele(No_ele,col_match)=macrocab_name+"_"+fgota_matrix(ii,3);col_match=col_match+1; // Ibias_p
        match_ele(No_ele,col_match)=string(No_rpar);
        mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
        mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+fgota_matrix(ii,3);
        mblif_xcos(4,2*col_mblif_xcos+4)=fgota_matrix(ii,4);
        mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+fgota_matrix(ii,3);
        mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
        mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
        No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1; 
        
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // 1:bias
        match_ele(No_ele,col_match)=macrocab_name+"_"+fgota_matrix(ii,5);col_match=col_match+1; // Ibias_n
        match_ele(No_ele,col_match)=string(No_rpar);
        mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
        mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+fgota_matrix(ii,5);
        mblif_xcos(4,2*col_mblif_xcos+4)=fgota_matrix(ii,6);
        mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+fgota_matrix(ii,5);
        mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
        mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
        No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1; 
    end
    for ii=1:numofota
        match_ele(No_ele,col_match)="1";col_match=col_match+1; // 1:bias
        match_ele(No_ele,col_match)=macrocab_name+"_"+ota_matrix(ii,1);col_match=col_match+1; // Ibias
        match_ele(No_ele,col_match)=string(No_rpar);
        mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
        mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+ota_matrix(ii,1);
        mblif_xcos(4,2*col_mblif_xcos+4)=ota_matrix(ii,2);
        mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+ota_matrix(ii,1);
        mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
        mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
        No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1;
    end
    for ii=1:numofcap
        match_ele(No_ele,col_match)="3";col_match=col_match+1; // 3:Cap
        match_ele(No_ele,col_match)=macrocab_name+"_"+cap_matrix(ii,1);col_match=col_match+1;
        match_ele(No_ele,col_match)=string(No_rpar);
        mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
        mblif_xcos(4,2*col_mblif_xcos+3)=macrocab_name+"_"+cap_matrix(ii,1);
        mblif_xcos(4,2*col_mblif_xcos+4)="1";
        mblif_xcos(5,col_mblif_xcos+2)=macrocab_name+"_"+cap_matrix(ii,1);
        mblif_xcos(6,2*col_mblif_xcos)=string(No_ele);
        mblif_xcos(6,2*col_mblif_xcos+1)=string(col_match-2);
        No_rpar=No_rpar+1;col_mblif_xcos=col_mblif_xcos+1;col_match=col_match+1;
    end
    
    mblif_xcos(3,1)=string(No_rpar);
    mblif_xcos(1,4)=string(No_rpar+2);
    mblif_xcos(3,col_mblif_xcos+1)=string(col_mblif_xcos+2);
    mblif_xcos(4,2*col_mblif_xcos+3)="fix_loc''";
    mblif_xcos(4,2*col_mblif_xcos+4)="[0;0;0]";
    mblif_xcos(5,col_mblif_xcos+2)="fix_loc";
    mblif_xcos(6,1)=string(sum_p);
    mblif_xcos(7,1)=string(No_ele);mblif_xcos(7,2)="0";mblif_xcos(7,3)="0"; // vcc_flag=0, gnd_flag=0
    
//    disp(fgswc_matrix);
//    disp(fgota_matrix);
//    disp(ota_matrix);
//    disp(cap_matrix);
//    disp(mblif_xcos);
//    disp(match_ele);
    
    
    //////////////////////////////////
    // Write Block information file 
    //////////////////////////////////
    fd_w= mopen("/home/ubuntu/rasp30/sci2blif/block_info/bi_"+macrocab_name+".sci",'wt');
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
    fd_r = mopen("/home/ubuntu/rasp30/sci2blif/block_info/bi_"+macrocab_name+".sci",'r');
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
    fd_w= mopen ("/home/ubuntu/rasp30/xcos_blocks/"+macrocab_name+".sci",'wt');
    //fd_w= mopen (macrocab_name+"_xcos.sci",'wt');
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
    mputl("        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block",fd_w);
    mputl("    end",fd_w);
    mputl("endfunction",fd_w);
    mclose(fd_w);
    
    
    //////////////////////////////////////////////
    // Generate rasp_design function 
    //////////////////////////////////////////////
    fd_w= mopen ("/home/ubuntu/rasp30/sci2blif/rasp_design_added_blocks/"+macrocab_name+".sce",'wt');
    //fd_w= mopen (macrocab_name+"_rasp_design.sce",'wt');
    mputl("style.fontSize=12;",fd_w);
    mputl("style.displayedLabel="""+mblif_name+""";",fd_w);
    mputl("pal"+bl_level+"=xcosPalAddBlock(pal"+bl_level+","""+mblif_name+""",[],style);",fd_w);
    mclose(fd_w);
    
    
    //////////////////////////////////////////////
    // Generate sci2blif function
    //////////////////////////////////////////////
    blif_bl_num=strtod(mblif_xcos_r(7,1)); // # of BLIF blocks
    fd_w= mopen ("/home/ubuntu/rasp30/sci2blif/sci2blif_added_blocks/"+macrocab_name+".sce",'wt');
    //fd_w= mopen (macrocab_name+"_sci2blif.sce",'wt');
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
                str_line=str_line+1;
                if j==1 then sci2blif_str(str_line)="        sci2blif_str=sci2blif_str+"" #"""; end
                if j~=1 then sci2blif_str(str_line)="        sci2blif_str=sci2blif_str+""&"""; end
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
        sum_p=sum_p+1;
        mputl("        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+string(sum_p)+"-1)+1) == 1 then",fd_w);
        mputl("            plcvpr = %t;",fd_w);
        mputl("            plcloc=[plcloc;''net''+string(blk(blk_objs(bl),2+numofip))+""_""+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+string(sum_p)+"-1)+1+2*ss-1))+'' ''+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*("+string(sum_p)+"-1)+1+2*ss))+'' 0''];",fd_w);
        mputl("        end",fd_w);
    end
    mputl("    end",fd_w);
    //mputl("    mputl("""",fd_w);",fd_w);
    mputl("end",fd_w);
    mclose(fd_w);
    
    
    dir_py="/home/ubuntu/rasp30/vpr2swcs/";
    dir_arch="/home/ubuntu/rasp30/vpr2swcs/arch/";
    
    ////////////////////////////
    // Update files to folders
    ///////////////////////////
    for ii=1:l_rasp_xml_list
        unix_w("cp "+rasp_xml_list(ii)+"_arch_gen1.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame1.xml");
        unix_w("cp "+rasp_xml_list(ii)+"_arch_gen2.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame2.xml");
        unix_w("cp "+rasp_xml_list(ii)+"_arch_gen3.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame3.xml");
    end
    for ii=1:l_rasp_xml_list
        unix_w("cat "+dir_frame+rasp_xml_list(ii)+"_arch_frame1.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame2.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame3.xml "+dir_frame+rasp_xml_list(ii)+"_arch_frame4.xml "+"> "+dir_arch+rasp_xml_list(ii)+"_arch.xml");
    end
    for ii=1:l_rasp_py_list
        unix_w("cp "+rasp_py_list(ii)+"_frame2_1.py "+dir_frame+rasp_py_list(ii)+"_frame2_1.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen2.py "+dir_frame+rasp_py_list(ii)+"_gen2.py");
        unix_w("cp "+rasp_py_list(ii)+"_frame3_1.py "+dir_frame+rasp_py_list(ii)+"_frame3_1.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen3.py "+dir_frame+rasp_py_list(ii)+"_gen3.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen4.py "+dir_frame+rasp_py_list(ii)+"_frame4.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen5.py "+dir_frame+rasp_py_list(ii)+"_frame5.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen7.py "+dir_frame+rasp_py_list(ii)+"_frame7.py");
        unix_w("cp "+rasp_py_list(ii)+"_frame8_1.py "+dir_frame+rasp_py_list(ii)+"_frame8_1.py");
        unix_w("cp "+rasp_py_list(ii)+"_frame8_2.py "+dir_frame+rasp_py_list(ii)+"_frame8_2.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen8.py "+dir_frame+rasp_py_list(ii)+"_gen8.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen9.py "+dir_frame+rasp_py_list(ii)+"_frame9.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen10.py "+dir_frame+rasp_py_list(ii)+"_frame10.py");
        unix_w("cp "+rasp_py_list(ii)+"_gen11.py "+dir_frame+rasp_py_list(ii)+"_frame11.py");
    end
    for ii=1:l_rasp_py_list
        unix_w("cat "+dir_frame+rasp_py_list(ii)+"_frame1.py "+dir_frame+rasp_py_list(ii)+"_gen2.py "+dir_frame+rasp_py_list(ii)+"_gen3.py "+dir_frame+rasp_py_list(ii)+"_frame4.py "+dir_frame+rasp_py_list(ii)+"_frame5.py "+dir_frame+rasp_py_list(ii)+"_frame6.py "+dir_frame+rasp_py_list(ii)+"_frame7.py "+dir_frame+rasp_py_list(ii)+"_gen8.py "+dir_frame+rasp_py_list(ii)+"_frame9.py "+dir_frame+rasp_py_list(ii)+"_frame10.py "+dir_frame+rasp_py_list(ii)+"_frame11.py "+dir_frame+rasp_py_list(ii)+"_frame12.py "+"> "+dir_py+rasp_py_list(ii)+".py");
    end
    unix_w("cp genswcs_frame2_1.py "+dir_frame+"genswcs_frame2_1.py");
    unix_w("cp genswcs_gen2.py "+dir_frame+"genswcs_gen2.py");
    unix_w("cp genswcs_frame4_1.py "+dir_frame+"genswcs_frame4_1.py");
    unix_w("cp genswcs_gen4.py "+dir_frame+"genswcs_gen4.py");
    unix_w("cp genswcs_gen5.py "+dir_frame+"genswcs_frame5.py");
    unix_w("cat "+dir_frame+"genswcs_frame1.py "+dir_frame+"genswcs_gen2.py "+dir_frame+"genswcs_frame3.py "+dir_frame+"genswcs_gen4.py "+dir_frame+"genswcs_frame5.py "+dir_frame+"genswcs_frame6.py > "+dir_py+"genswcs.py");
    
    /////////////////////////////////////////////////////
    // Macro cab block name update for overlap checking
    ////////////////////////////////////////////////////
    fd_r = mopen("/home/ubuntu/rasp30/vpr2swcs/block_list",'r');block_list=mgetl(fd_r);mclose(fd_r);  // Default value: frame. 
    l_block_list=size(block_list,1);
    block_list(l_block_list+1)=macrocab_name;
    fd_w = mopen("/home/ubuntu/rasp30/vpr2swcs/block_list",'wt');mputl(block_list,fd_w);mclose(fd_w);
    
    unix_w("cp "+macrocab_name+".xcos /home/ubuntu/rasp30/sci2blif/xcos_ref/macrocab_generation/");
    
    disp("Macro-CAB block has been generated.");
    filebrowser();
    
endfunction






