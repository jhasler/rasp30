global file_name;
//get filename, path and extension
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

//while 1==1,
//    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/ttyUSB1/ -speed 115200 "+hid_dir+"/tunnel_revtun_SWC.elf");
//    if (b1==0) then break end // 0 if no error occurred, 1 if error.
//    disp("connection issue -> it is trying again");
//    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
//    sleep(2000);
//end
//
//while 1==1,
//    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/ttyUSB1/ -speed 115200 "+hid_dir+"/tunnel_revtun_CAB.elf");
//    if (b1==0) then break end // 0 if no error occurred, 1 if error.
//    disp("connection issue -> it is trying again");
//    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
//    sleep(2000);
//end

unix_w("sudo chmod 777 /dev/rasp30");
while 1==1,
    [a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -speed 115200 "+hid_dir+"/tunnel_revtun_SWC_CAB.elf");
    if (b1==0) then break end // 0 if no error occurred, 1 if error.
    disp("connection issue -> it is trying again");
    unix_w('/home/ubuntu/rasp30/sci2blif/usbreset');
    sleep(2000);
end
