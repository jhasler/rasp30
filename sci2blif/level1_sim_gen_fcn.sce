global Ut_sim Kappa_sim L1_sim_name;;

function dir_callback()
    disp("   ");
endfunction

function L1_sim_name_callback()
    global L1_sim_name;
    block_name_obj = findobj('tag','L1_sim_name');
    L1_sim_name = block_name_obj.string;
endfunction

function Start_L1_sim_callback()
    global L1_sim_name;
    
    file_list=listfiles("/home/ubuntu/rasp30/xcos_blocks/*_c.sci");
    l_file_list=size(file_list,1);
    for ii=1:l_file_list
        if file_list(ii) == "/home/ubuntu/rasp30/xcos_blocks/"+L1_sim_name+"_c.sci" then messagebox('A Sim file with the same name exists. Please check it.', "Level 1 sim name error", "error"); abort; end
    end
    
    fd_w= mopen("./"+L1_sim_name+"_c_2.sci",'wt');
    mputl("        in_out_num = block.ipar(1);",fd_w);
    mputl("        row_vec_io = 1:in_out_num;  // Row vector for input & output ",fd_w);
    mputl("        C = 5e-12;",fd_w);
    mputl("        tau=1 ./(2*%pi*block.rpar(row_vec_io));",fd_w);
    mputl("        Ibias= (2*C*Ut_sim)./(Kappa_sim*tau);",fd_w);
    mputl("        block.xd(row_vec_io)=(Ibias/C).*tanh((Kappa_sim*(block.inptr(1)(row_vec_io)-block.x(row_vec_io)))/(2*Ut_sim));",fd_w);
    mclose(fd_w);
    
    editor("./"+L1_sim_name+"_c_2.sci");
    
    messagebox(["Complete ODE equations in "+L1_sim_name+"_c_2.sci and Save it." "We provide global variables for Ut_sim (=0.0256 V) and Kappa_sim (=0.7)."],"Design Macro-CAB block", "info", ["OK"], "modal");
    
endfunction

function Gen_L1_sim_callback()
    global L1_sim_name;
    
    fd_w= mopen("./"+L1_sim_name+"_c_1.sci",'wt');
    mputl("global Ut_sim Kappa_sim;",fd_w);
    mputl("",fd_w);
    mputl("function block="+L1_sim_name+"_c(block,flag)",fd_w);
    mputl("    if flag ==1",fd_w);
    mputl("        in_out_num = block.ipar(1);",fd_w);
    mputl("        row_vec_io = 1:in_out_num;  // Row vector for input & output ",fd_w);
    mputl("        block.outptr(1)(row_vec_io)=block.x(row_vec_io);",fd_w);
    mputl("    elseif flag ==0",fd_w);
    mclose(fd_w);
    
    fd_w= mopen("./"+L1_sim_name+"_c_3.sci",'wt');
    mputl("    end",fd_w);
    mputl("endfunction",fd_w);
    mclose(fd_w);
    
    unix_w("cat ./"+L1_sim_name+"_c_1.sci ./"+L1_sim_name+"_c_2.sci ./"+L1_sim_name+"_c_3.sci "+" > ./"+L1_sim_name+"_c.sci");
    unix_w("cp ./"+L1_sim_name+"_c.sci /home/ubuntu/rasp30/xcos_blocks/"+L1_sim_name+"_c.sci");
    
    disp("Level 1 simulation file for "+L1_sim_name+" has been generated.");
    filebrowser();
    
endfunction






