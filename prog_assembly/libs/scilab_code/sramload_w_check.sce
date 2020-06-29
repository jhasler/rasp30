function [ok0_error1]=sramload_w_check(x, y)
    upload_fname=x; //'input_vector';
    upload_address= msscanf(y,"%x"); //msscanf('0x4300',"%x"); //sprintf('%4.4x', 16)
    
    complete_index=0; // 0: Not finised, 1:Finished.
    loop_num=1;
    while complete_index == 0
        if loop_num == 1 then 
            [aaa,upload_e01]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address "+"0x"+sprintf('%4.4x', upload_address)+" -input_file_name "+upload_fname);
            [x, ierr] = fileinfo(upload_fname);inputfile_size=round(x(1)/7);
        end
        [aaa,upload_e02]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address "+"0x"+sprintf('%4.4x', upload_address)+" -length "+string(inputfile_size)+" -output_file_name comp_temp");
        clear input_vec comp_vec; input_vec=["" ""]; comp_vec=["uploaded" "" "" ""];
        fd_1_a = mopen(upload_fname,'r'); fd_1_b = mopen('comp_temp','r');
        j=1;
        for i=1:inputfile_size
            input_vec(i,1)=mgetstr(6,fd_1_a);
            dummy1=mgetstr(1,fd_1_a);
            input_vec(i,2)=mgetstr(6,fd_1_b);
            dummy2=mgetstr(1,fd_1_b);
            if input_vec(i,1) ~= input_vec(i,2) then
                comp_vec(j,1)=string(i);
                comp_vec(j,2)=string(sprintf('%4.4x', 2*(i-1)+upload_address));
                comp_vec(j,3)=input_vec(i,1);
                comp_vec(j,4)=input_vec(i,2);
                j=j+1;
            end
        end
        mclose(fd_1_a); mclose(fd_1_b);
        disp(comp_vec);
        disp("No. of loops is "+string(loop_num));
    
        if comp_vec(1,1) ~= "uploaded" then
            for i=1:size(comp_vec,1)
                temp_string=comp_vec(i,3); fd = mopen('temp','wt'); mputl(temp_string, fd); mclose(fd);
                unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x"+comp_vec(i,2)+" -input_file_name temp");
            end
        end
        if comp_vec(1,1) == "uploaded" then complete_index=1; disp("sram data uploaded"); end
        if loop_num == 10 then complete_index=1; disp("sram data upload failed"); end
        loop_num=loop_num+1;
    end
    
    if (upload_e01==0) & (upload_e02==0) then ok0_error1 = 0;
    else ok0_error1 =1;
    end
endfunction
