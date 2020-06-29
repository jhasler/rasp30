global file_name;
//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

select board_num 
case 2 then
    brdtype = '';
case 3 then
    brdtype = '_30a';
case 4 then
    brdtype = '_30n';
case 5 
    brdtype = '_30h';
else
    messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error");
    abort
end

unix_w("cp ~/rasp30/prog_assembly/libs/chip_parameters/chip_para/chip_para_TR_chip"+chip_num+brdtype+".asm "+ path+'/chip_para_TR.asm');
unix_w("~/rasp30/prog_assembly/libs/sh/asm2ihex.sh tunnel_clb ~/rasp30/prog_assembly/libs/asm_code/tunnel_revtun_CLB_ver00.s43 16384 16384 16384");

unix_w("sudo chmod 777 /dev/rasp30");
while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 tunnel_clb.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end

unix_g('mv *.l43 *.o pmem.x pmem_defs.asm tunnel_clb.elf chip_para_TR.asm ' + hid_dir);
