function GPIO = GPIO(time,single)
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

if single ==[] then

[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg ~/rasp30/prog_assembly/libs/asm_code/sftreg_GPIO.s43 16384 16384 16384")

if b1==1
disp('There is an error in your assembly file')
abort;
end

else

[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg ~/rasp30/prog_assembly/libs/asm_code/asm_code_test/sftreg_GPIO_single.s43 16384 16384 16384")

if b1==1
disp('There is an error in your assembly file')
abort;
end


i_hex=dec2hex(single);
i_hex_string=string(i_hex)
unix_g('>./shift_number')  
y=mopen('./shift_number','wb')
if time<16 then
mputl('0x000'+string(i_hex),y)
elseif time<256 then
mputl('0x00'+string(i_hex),y)
elseif time<4096 then
mputl('0x0'+string(i_hex),y)
else 
mputl('0x'+string(i_hex),y)
end
mclose(y)

unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4202 -input_file_name ./shift_number");




end


i_hex=dec2hex(time);
i_hex_string=string(i_hex)
unix_g('>./shift')  
y=mopen('./shift','wb')
if time<16 then
mputl('0x000'+string(i_hex),y)
elseif time<256 then
mputl('0x00'+string(i_hex),y)
elseif time<4096 then
mputl('0x0'+string(i_hex),y)
else 
mputl('0x'+string(i_hex),y)
end
mclose(y)


unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name ./shift");

 


unix_w("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name '+hid_dir+'/input_vector");


format("v",16);



err=1;
while err==1
[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl '+path+'sftreg.elf');
end

if err==0
disp('The script worked')
end

endfunction

