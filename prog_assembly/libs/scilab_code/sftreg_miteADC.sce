function [Out,out_volt] = sftreg_miteADC(samples)
    //samples is actually number of shifts
    exec('/home/ubuntu/rasp30/prog_assembly/libs/scilab_code/sramload_w_check.sce', -1)
 
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

select board_num 
case 2 then brdtype = '';
case 3 then brdtype = '_30a';
case 4 then brdtype = '_30n';
case 5 then brdtype = '_30h';
else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
end

 exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC.sce",-1);
 if samples==[]  then

[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg_miteADC ~/rasp30/prog_assembly/libs/asm_code/asm_code_test/sftreg_miteADC.s43 16384 16384 16384")
if b1==1
disp('There is an error in your assembly file')
a1
abort;
end

else
[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg_miteADC ~/rasp30/prog_assembly/libs/asm_code/asm_code_test/sftreg_miteADC_sample.s43 16384 16384 16384")
if b1==1
disp('There is an error in your assembly file')
disp(a1)
abort;
end
i_hex=dec2hex(samples);
i_hex_string=string(i_hex)
unix_g('>./shift_number')  
y=mopen('./shift_number','wb')
if samples<16 then
mputl('0x000'+string(i_hex),y)
elseif samples<256 then
mputl('0x00'+string(i_hex),y)
elseif samples<4096 then
mputl('0x0'+string(i_hex),y)
else 
mputl('0x'+string(i_hex),y)
end
mclose(y)

unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4002 -input_file_name ./shift_number");


end



[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");

[ok0_error1]=sramload_w_check(hid_dir+"/input_vector",'0x4300')
[a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");


err=1;
while err==1
[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl '+path+'sftreg_miteADC.elf');
end

if samples==[] then 
[y,err]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -device /dev/ttyUSB1/ -start_address 0x6000 -length 12 -output_file_name "+path+"output_vector.txt");
y = mopen(path+"output_vector.txt','rt')
Output=mgetl(y);
clear New_output
length_out=12
m=1
i=3
while m<length_out+1
New_output(m,1) = part(Output(1,1),i:i+3);
i=i+7;
m=m+1;
end
clear Output_dec
m=1
while m<length_out+1
Output_dec(m,:) = msscanf(New_output(m,:),'%x'); //scan with hexadecimal format   
m=m+1;
end
Out=Output_dec;
out_volt=polyval(p_mite_977_10uA,Out,S_mite_977_10uA)

else
//*************************    
    
unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x5000 -length 1 -output_file_name "+path+"output_vector.txt");
y = mopen(path+'output_vector.txt','rt')
Output=mgetl(y);
New_output(1,1) = part(Output(1,1),3:7);
Output_dec(1,:) = msscanf(New_output(1,:),'%x'); //scan with hexadecimal format

length_out= Output_dec(1) - 24576;
length_out=length_out/2;
disp(length_out)
unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -start_address 0x6000 -length "+string(length_out)+" -output_file_name "+path+"output_vector.txt");
y = mopen(path+"output_vector.txt','rt')
Output=mgetl(y);
m=1
i=3
while m<length_out+1
New_output(m,1) = part(Output(1,1),i:i+3);
m=m+1;
i=i+7;
end
clear Output_dec
m=1
while m<length_out+1
Output_dec(m,:) = msscanf(New_output(m,:),'%x'); //scan with hexadecimal format   
m=m+1;
end
m=1
Out=Output_dec;
out_volt=polyval(p_mite_977_10uA,Out,S_mite_977_10uA);

end
figure();plot(out_volt)
//mclose all;
endfunction
