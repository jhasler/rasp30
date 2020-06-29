global bcd_file_name folder_name;

function dir_callback()
    disp("   ");
endfunction

function bcd_folder_name_callback()
    global folder_name;
    folder_name_obj = findobj('tag','bcd_folder_name');
    folder_name = folder_name_obj.string;
endfunction

function bcd_file_name_callback()
    global bcd_file_name;
    block_name_obj = findobj('tag','bcd_file_name');
    bcd_file_name = block_name_obj.string;
endfunction

function bcd_xcosgen_callback()
    global bcd_file_name folder_name;
    
    [temp_garbage,bcd_fname,bcd_extension]=fileparts(bcd_file_name);
    
    //unix_g("cd "+folder_name);
    
    //unix_g("cp /home/ubuntu/rasp30/sci2blif/bcd_added_blocks/bcd_frame01.sci bcd_frame01.sci");
    //unix_g("cp /home/ubuntu/rasp30/sci2blif/bcd_added_blocks/bcd_frame02.sci bcd_frame02.sci");
    //unix_w("sed -i "'s/bcd_cell_p/"+bcd_fname+"_cell_p"+"/g"' bcd_frame01.sci bcd_frame02.sci");
    //unix_w("sed -i "'s/bcd_cell_i/"+bcd_fname+"_cell_i"+"/g"' bcd_frame01.sci bcd_frame02.sci");
    
    fd_w= mopen (bcd_fname+".xcos",'wt');
    mputl("<?xml version=""1.0"" encoding=""UTF-8""?>",fd_w);
    mputl("<XcosDiagram background=""-1"" title=""Untitled"">",fd_w);
    mputl("<!--Xcos - 1.0 - scilab-5.4.1 - 20130329 1708-->",fd_w);
    mputl("<mxGraphModel as=""model"">",fd_w);
    mputl("<root>",fd_w);
    mputl("<mxCell id="""+bcd_fname+"_cell_p""/>",fd_w);
    mputl("<mxCell id="""+bcd_fname+"_cell_i"" parent="""+bcd_fname+"_cell_p""/>",fd_w);
    mputl("",fd_w);
    mclose(fd_w);
    
    i_block=1;  // block id
    i_link=1; // link id
    i_port=0; // # of ports
    net_map=[]; // Net info
    location_matrix = [50 50; 200 50; 350 50; 500 50; 650 50; 50 150; 200 150; 350 150; 500 150; 650 150;]; //x,y
    
    fd_r = mopen(bcd_file_name,'r');
    inputs_temp=mgetl(fd_r, 1); inputs_temp=strsplit(inputs_temp,',',100); No_inputs_temp=size(inputs_temp);
    while inputs_temp(1) == "b" | inputs_temp(1) == "c"
        
        if inputs_temp(1) == "b" then
            fd_r1 = mopen("/home/ubuntu/rasp30/sci2blif/bcd_added_blocks/bcd_"+inputs_temp(2)+".sci",'r');  // inputs_temp(2) : block name
            bcd_b_info1=mgetl(fd_r1, 1); bcd_b_info1=strsplit(bcd_b_info1,',',100); No_of_b_in=strtod(bcd_b_info1(2)); No_of_b_out=strtod(bcd_b_info1(3));
            No_of_exprs=strtod(bcd_b_info1(4)); //b_height=strtod(bcd_b_info1(4)); b_width=strtod(bcd_b_info1(5));
            bcd_b_info2=mgetl(fd_r1, 1); bcd_b_info2=strsplit(bcd_b_info2,',',100); No_of_ipar=strtod(bcd_b_info2(1));
            bcd_b_info3=mgetl(fd_r1, 1); bcd_b_info3=strsplit(bcd_b_info3,',',100); No_of_rpar=strtod(bcd_b_info3(1));
            mclose(fd_r1);
            
            block_id=bcd_fname+string(i_block);
            
            fd_w= mopen (bcd_fname+".xcos",'a');
            mputl("<BasicBlock blockType=""d"" dependsOnU=""1"" id="""+block_id+""" interfaceFunctionName="""+inputs_temp(2)+""" parent="""+bcd_fname+"_cell_i"" simulationFunctionName="""+inputs_temp(2)+"_c"" simulationFunctionType=""SCILAB"" style="""+inputs_temp(2)+""">",fd_w);
            
            i_col=3;
            i_inoutport=1;
            clear b_in_temp_fd_w b_out_temp_fd_w;
            
            i_b_in_fd_w=1;
            for i=1:No_of_b_in
                i_port=i_port+1;
                port_id=block_id+"_"+string(i_inoutport);
                net_map(i_port,1)=inputs_temp(i_col); net_map(i_port,2)=inputs_temp(2); net_map(i_port,3)= block_id; net_map(i_port,4)= port_id;// net name, block name, block id, port id
                net_map(i_port,5)= "target"; // source or target
                net_map(i_port,6)= string(location_matrix(i_block,1)+10); // Point x
                net_map(i_port,7)= string(location_matrix(i_block,2)+20); // Point y
                net_map(i_port,8)= string(16+10*(i-1)); // Geometry y
                
                b_in_temp_fd_w(i_b_in_fd_w)="<ExplicitInputPort dataColumns=""-1"" dataType=""UNKNOW_TYPE"" id="""+net_map(i_port,4)+""" ordering=""1"" parent="""+net_map(i_port,3)+""" style=""ExplicitInputPort;align=left;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""">";
                i_b_in_fd_w=i_b_in_fd_w+1;
                b_in_temp_fd_w(i_b_in_fd_w)="    <mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""-8.0"" y="""+net_map(i_port,8)+"""/>";
                i_b_in_fd_w=i_b_in_fd_w+1;
                b_in_temp_fd_w(i_b_in_fd_w)="</ExplicitInputPort>";
                i_b_in_fd_w=i_b_in_fd_w+1;
                
                i_inoutport=i_inoutport+1;
                i_col=i_col+1;
            end
            i_b_out_fd_w=1;
            for i=1:No_of_b_out
                i_port=i_port+1;
                port_id=block_id+"_"+string(i_inoutport);
                net_map(i_port,1)=inputs_temp(i_col); net_map(i_port,2)=inputs_temp(2); net_map(i_port,3)= block_id; net_map(i_port,4)= port_id;// net name, block name, block id, port id
                net_map(i_port,5)= "source"; // source or target
                net_map(i_port,6)= string(location_matrix(i_block,1)+100); // Point x
                net_map(i_port,7)= string(location_matrix(i_block,2)+20); // Point y
                net_map(i_port,8)= string(16+10*(i-1)); // Geometry y
                
                b_out_temp_fd_w(i_b_out_fd_w)="<ExplicitOutputPort dataColumns=""-1"" dataType=""UNKNOW_TYPE"" id="""+net_map(i_port,4)+""" ordering=""1"" parent="""+net_map(i_port,3)+""" style=""ExplicitOutputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=0"" value="""">";
                i_b_out_fd_w=i_b_out_fd_w+1;
                b_out_temp_fd_w(i_b_out_fd_w)="    <mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""100.0"" y="""+net_map(i_port,8)+"""/>";
                i_b_out_fd_w=i_b_out_fd_w+1;
                b_out_temp_fd_w(i_b_out_fd_w)="</ExplicitOutputPort>";
                i_b_out_fd_w=i_b_out_fd_w+1;
                
                i_inoutport=i_inoutport+1;
                i_col=i_col+1;
            end
            if No_of_exprs == 0 then
                mputl("    <ScilabString as=""exprs"" height=""1"" width=""1"">",fd_w);
                mputl("        <data column=""0"" line=""0"" value=""1""/>",fd_w);
                mputl("    </ScilabString>",fd_w);
            end
            if No_of_exprs ~= 0 then
                mputl("    <ScilabString as=""exprs"" height="""+string(No_of_exprs)+""" width=""1"">",fd_w);
                for i=1:No_of_exprs
                    mputl("        <data column=""0"" line="""+string(i-1)+""" value="""+inputs_temp(i_col+i-1)+"""/>",fd_w);
                end
                mputl("    </ScilabString>",fd_w);
            end
            if No_of_rpar == 0 then
                mputl("    <ScilabDouble as=""realParameters"" height=""1"" width=""1"">",fd_w);
                mputl("        <data column=""0"" line=""0"" realPart=""1.0""/>",fd_w);
                mputl("    </ScilabDouble>",fd_w);
            end
            if No_of_rpar ~= 0 then
                Real_No_of_rpar=0;
                clear rpar_temp_fd_w;
                for i=1:No_of_rpar
                    rpar_temp=inputs_temp(i_col+strtod(bcd_b_info3(i+1))-1);
                    rpar_temp=strsubst(rpar_temp,"[",""); rpar_temp=strsubst(rpar_temp,"]",""); rpar_temp=strsplit(rpar_temp,"/,| |;/",100);
                    size_rpar_temp=size(rpar_temp);
                    for j=1:size_rpar_temp(1)
                        Real_No_of_rpar=Real_No_of_rpar+1;
                        rpar_temp_fd_w(Real_No_of_rpar)="        <data column="""+string(Real_No_of_rpar-1)+""" line=""0"" realPart="""+rpar_temp(j)+"""/>";
                    end
                end
                mputl("    <ScilabDouble as=""realParameters"" height=""1"" width="""+string(Real_No_of_rpar)+""">",fd_w);
                mputl(rpar_temp_fd_w,fd_w);
                mputl("    </ScilabDouble>",fd_w);
            end
            if No_of_ipar == 0 then
                mputl("    <ScilabDouble as=""integerParameters"" height=""1"" width=""1"">",fd_w);
                mputl("        <data column=""0"" line=""0"" realPart=""1.0""/>",fd_w);
                mputl("    </ScilabDouble>",fd_w);
            end
            if No_of_ipar ~= 0 then
                Real_No_of_ipar=0;
                clear ipar_temp_fd_w;
                for i=1:No_of_ipar
                    ipar_temp=inputs_temp(i_col+strtod(bcd_b_info2(i+1))-1);
                    ipar_temp=strsubst(ipar_temp,"[",""); ipar_temp=strsubst(ipar_temp,"]",""); ipar_temp=strsplit(ipar_temp,"/,| |;/",100);
                    size_ipar_temp=size(ipar_temp);
                    for j=1:size_ipar_temp(1)
                        Real_No_of_ipar=Real_No_of_ipar+1;
                        ipar_temp_fd_w(Real_No_of_ipar)="        <data column="""+string(Real_No_of_ipar-1)+""" line=""0"" realPart="""+ipar_temp(j)+"""/>";
                    end
                end
                mputl("    <ScilabDouble as=""integerParameters"" height=""1"" width="""+string(Real_No_of_ipar)+""">",fd_w);
                mputl(ipar_temp_fd_w,fd_w);
                mputl("    </ScilabDouble>",fd_w);
            end
            
            mputl("    <Array as=""objectsParameters"" scilabClass=""ScilabList""/>",fd_w);
            mputl("    <ScilabDouble as=""nbZerosCrossing"" height=""1"" width=""1"">",fd_w);
            mputl("        <data column=""0"" line=""0"" realPart=""0.0""/>",fd_w);
            mputl("    </ScilabDouble>",fd_w);
            mputl("    <ScilabDouble as=""nmode"" height=""1"" width=""1"">",fd_w);
            mputl("        <data column=""0"" line=""0"" realPart=""0.0""/>",fd_w);
            mputl("    </ScilabDouble>",fd_w);
            mputl("    <Array as=""oDState"" scilabClass=""ScilabList""/>",fd_w);
            mputl("    <Array as=""equations"" scilabClass=""ScilabList""/>",fd_w);
            mputl("    <mxGeometry as=""geometry"" height=""40.0"" width=""100.0"" x="""+string(location_matrix(i_block,1))+""" y="""+string(location_matrix(i_block,2))+"""/>",fd_w);
            mputl("</BasicBlock>",fd_w);
            
            if No_of_b_in ~= 0 then mputl(b_in_temp_fd_w,fd_w); end
            if No_of_b_out ~= 0 then mputl(b_out_temp_fd_w,fd_w); end
            
            mputl("",fd_w);
            i_block=i_block+1;
            mclose(fd_w);
        end
        
        
        if inputs_temp(1) == "c" then
            clear source_info target_info;
            source_info=[];target_info=[];
            
            for i=1:i_port
                if net_map(i,1) == inputs_temp(2) then
                    if net_map(i,5) == "source" then source_info(1,:)=net_map(i,:); end
                    if net_map(i,5) == "target" then target_info(1,:)=net_map(i,:); end
                end
                if net_map(i,1) == inputs_temp(3) then
                    if net_map(i,5) == "source" then source_info(1,:)=net_map(i,:); end
                    if net_map(i,5) == "target" then target_info(1,:)=net_map(i,:); end
                end
            end
            
            link_id=bcd_fname+"_link_"+string(i_link);
            
            fd_w= mopen (bcd_fname+".xcos",'a');
            mputl("<ExplicitLink id="""+link_id+""">",fd_w);
            mputl("    <mxGeometry as=""geometry"">",fd_w);
            mputl("        <mxPoint as=""sourcePoint"" x="""+source_info(1,6)+""" y="""+source_info(1,7)+"""/>",fd_w);
            mputl("        <mxPoint as=""targetPoint"" x="""+target_info(1,6)+""" y="""+target_info(1,7)+"""/>",fd_w);
            mputl("    </mxGeometry>",fd_w);
            mputl("    <mxCell as=""parent"" id="""+bcd_fname+"_cell_i"" parent="""+bcd_fname+"_cell_p""/>",fd_w);
            mputl("    <ExplicitOutputPort as=""source"" dataColumns=""-1"" dataType=""UNKNOW_TYPE"" id="""+source_info(1,4)+""" ordering=""1"" parent="""+source_info(1,3)+""" style=""ExplicitOutputPort;align=right;verticalAlign=middle;spacing=10.0;rotation=0"" value="""">",fd_w);
            mputl("        <mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""100.0"" y="""+source_info(1,8)+"""/>",fd_w);
            mputl("    </ExplicitOutputPort>",fd_w);
            mputl("    <ExplicitInputPort as=""target"" dataColumns=""-1"" dataType=""UNKNOW_TYPE"" id="""+target_info(1,4)+""" ordering=""1"" parent="""+target_info(1,3)+""" style=""ExplicitInputPort;align=left;verticalAlign=middle;spacing=10.0;rotation=0;flip=false;mirror=false"" value="""">",fd_w);
            mputl("        <mxGeometry as=""geometry"" height=""8.0"" width=""8.0"" x=""-8.0"" y="""+target_info(1,8)+"""/>",fd_w);
            mputl("    </ExplicitInputPort>",fd_w);
            mputl("</ExplicitLink>",fd_w);
            mputl("",fd_w);
            
            i_link=i_link+1;
            mclose(fd_w);
        end
        
        
        //disp(inputs_temp(2));
        inputs_temp=mgetl(fd_r, 1); inputs_temp=strsplit(inputs_temp,',',100); No_inputs_temp=size(inputs_temp);
    end
    mclose(fd_r);
    
    fd_w= mopen (bcd_fname+".xcos",'a');
    mputl("</root>",fd_w);
    mputl("</mxGraphModel>",fd_w);
    mputl("<mxCell as=""defaultParent"" id="""+bcd_fname+"_cell_i"" parent="""+bcd_fname+"_cell_p""/>",fd_w);
    mputl("</XcosDiagram>",fd_w);
    mclose(fd_w);
    
    //xcos(bcd_file_name+".xcos");
    //messagebox('Make changes based on the provided xcos and Save it',"Design Macro-CAB block", "info", ["OK"], "modal");
endfunction

function bcd_sim_callback()
    clear blk;
    global bcd_file_name;
    
    disp("Macro-CAB block has been generated.");
    filebrowser();
    
endfunction






