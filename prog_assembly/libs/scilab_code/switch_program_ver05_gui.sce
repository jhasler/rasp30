global file_name showprog;
//get filename, path and extension
[path,fname,extension] = fileparts(file_name);
hid_dir = path + '.' + fname;
select board_num 
case 2 then brdtype = '';
case 3 then brdtype = '_30a';
case 4 then brdtype = '_30n';
case 5 then brdtype = '_30h';
else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
end
//exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_diodeADC.sce",-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2i.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_i2v.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_v2h.sce',-1);
exec('~/rasp30/prog_assembly/libs/scilab_code/diodeADC_h2v.sce',-1);
exec("~/rasp30/prog_assembly/libs/scilab_code/sramload_w_check.sce",-1);

switch_list = fscanfMat(hid_dir+'/switch_list');temp_size= size(switch_list); n=temp_size(1,1);

// Check the size of switches and divide files
n_temp = n;
maximum_swc_number = 1000; //120; It has been increased because of the sctipt to fix sram writing error.
number_of_switchfiles = int(n/maximum_swc_number);
if number_of_switchfiles < n/maximum_swc_number then
    number_of_switchfiles = number_of_switchfiles + 1;
end
fd = mopen(hid_dir+'/switch_info','r'); clear switch_info_data; switch_info_data = [1:3];
str_temp = mgetstr(7,fd);
for i=1:n
    switch_info_data(i,1) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,2) = msscanf(mgetstr(7,fd),"%x"); switch_info_data(i,3) = msscanf(mgetstr(7,fd),"%x");
end
mclose(fd);

k=1;
for j=1:number_of_switchfiles
    if n_temp < maximum_swc_number then
        temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', n_temp)) + ' ';
        for i=1:n_temp
            temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' ';
            k=k+1;
        end
        fd = mopen('switch_info_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
    else
        temp = ''; temp = temp + '0x' + string(sprintf('%4.4x', maximum_swc_number)) + ' ';
        for i=1:maximum_swc_number
            temp = temp + '0x' + string(sprintf('%4.4x', switch_info_data(k,1))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,2))) + ' 0x' + string(sprintf('%4.4x', switch_info_data(k,3))) + ' ';
            k=k+1;
        end
        fd = mopen('switch_info_'+string(j),'wt'); mputl(temp, fd); mclose(fd);
    end
    n_temp = n_temp - maximum_swc_number;
end

unix_g('mv switch_info_* ' + hid_dir);

// Execute Assembly codes
j=1;
//for j=1:number_of_switchfiles
while j <= number_of_switchfiles,
    unix_w("sudo chmod 777 /dev/rasp30");
    //[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x7000 -input_file_name "+hid_dir+"/switch_info_"+string(j));
    b1=sramload_w_check(hid_dir+"/switch_info_"+string(j),"0x5500");
    if (b1==0) then
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/switch_program.elf");
        //[a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 7000 -output_file_name swc_pgm_result_"+string(j)+".hex");
        [a3,b3]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x4100 -length 4100 -output_file_name swc_pgm_result_"+string(j)+".hex");
    end
    if (b1==0) & (b2==0) & (b3==0) then j=j+1; end // 0 if no error occurred, 1 if error.
    if (b1==1) | (b2==1) | (b3==1) then disp("connection issue -> it is trying again"); unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); sleep(2000); end
end

// Read into scilab
m=n+2;
n_temp = n; k=3;; clear data; data = [1:m];
for l=1:number_of_switchfiles
    fd = mopen('swc_pgm_result_'+string(l)+'.hex','r');
    str_temp = mgetstr(7,fd);
    j=1;
    while str_temp ~= "0xffff ",
        data(j,1) = msscanf(str_temp,"%x");
        data(j,2) = data(j,2) + msscanf(mgetstr(7,fd),"%x");
        k_temp=k;
        if n_temp < maximum_swc_number then
            for i=1:n_temp
                data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                k_temp=k_temp+1;
            end
        else
            for i=1:maximum_swc_number
                data(j,k_temp) = msscanf(mgetstr(7,fd),"%x");
                k_temp=k_temp+1;
            end
        end
        str_temp = mgetstr(7,fd);
        j=j+1;
    end
    mclose(fd);
    k=k+maximum_swc_number;
    n_temp = n_temp - maximum_swc_number;
end
data(:,2)=data(:,2)*1e-3;
//disp(data)

clear output_file;
output_file=[switch_list(:,1:2) data(:,3:n+2)'];
output_file(:,3)=diodeADC_v2i(diodeADC_h2v(output_file(:,3),chip_num,brdtype),chip_num,brdtype);
output_file(:,4)=diodeADC_v2i(diodeADC_h2v(output_file(:,4),chip_num,brdtype),chip_num,brdtype);
fprintfMat("Switch_program_Current"+fname+".data", output_file, "%5.15f");

if showprog == 1 then    // Result graphs
    scf(3); clf(3);
    j=1; clear legend_switch_list; legend_switch_list = ('a');
    for i=1:n
        temp=modulo(i,7)+1;
        plot2d("nl", data(:,2), output_file(i,3:4)', style=temp); p = get("hdl"); p.children.mark_mode = "on"; p.children.mark_style = 9; p.children.thickness = 3; p.children.mark_foreground = temp;
        legend_switch_list(i,1)='Row. ' + string(output_file(i,1)) + ', Col. ' + string(output_file(i,2));
    end
    legend(legend_switch_list(:,1),"in_lower_right"); xtitle("","time [s]", "Id [A]"); a=gca(); 
    a.data_bounds(1,1)=0;a.data_bounds(1,2)=1D-10;a.data_bounds(2,1)=a.data_bounds(2,1)*2;a.data_bounds(2,2)=1D-04; //a.data_bounds=[0 1D-10; 20 1D-04]
end

j=1;
clear unprogrammed_switches; unprogrammed_switches = [1 1 1 0];
a_temp=size(switch_info_data);
for i=1:a_temp(1,1)
    //if output_file(i,4) < 1E-06 then
    if output_file(i,4) < 100E-09 then
        unprogrammed_switches(j,1)=switch_info_data(i,1);
        unprogrammed_switches(j,2)=switch_info_data(i,2);
        unprogrammed_switches(j,3)=switch_info_data(i,3);
        unprogrammed_switches(j,4)=0;
        j=j+1;
    end
end
fprintfMat("unprogrammed_switches",unprogrammed_switches,"%5.15f");

unix_g('mv *.hex Switch_program_Current' + fname + '.data unprogrammed_switches ' + hid_dir);
