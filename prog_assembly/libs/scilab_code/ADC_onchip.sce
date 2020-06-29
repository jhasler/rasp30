function [Out,out_volt] = ADC(samples)
    //samples is actually number of shifts
[path,fname,extension] = fileparts(file_name); 
hid_dir = path + '.' + fname;

select board_num 
case 2 then brdtype = '';
case 3 then brdtype = '_30a';
case 4 then brdtype = '_30n';
case 5 then brdtype = '_30h';
else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
end
global RAMP_ADC_check ONchip_ADC Onchip_ADC_num

if chip_num=='04' then
length_out=length(myVariable);
y = mopen(path+"output_vector','rt')
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



Onchip_ADC=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/ONchip.csv')

out_volt=interp1(Onchip_ADC(:,2),Onchip_ADC(:,1),Output_dec,'nearest')
fprintfMat(fname+'.data',out_volt, "%5.15f");
 

else
 //exec("~/rasp30/prog_assembly/libs/scilab_code/characterization/char_miteADC.sce",-1);

if Onchip_ADC_num(1,1)==1 then
    
[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg_miteADC ~/rasp30/prog_assembly/libs/asm_code/ADC_onchip.s43 16384 16384 16384")


if b1==1
disp('There is an error in your assembly file')
abort;
end





[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
[a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");


err=1;
while err==1
[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl '+path+'sftreg_miteADC.elf');
end


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
clear Output_dec1
m=1
while m<length_out+1
Output_dec1(m,:) = msscanf(New_output(m,:),'%x'); //scan with hexadecimal format   
m=m+1;
end
m=1
mclose(y)

//Onchip_ADC=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/ONchip.csv')

//out_volt=interp1(Onchip_ADC(:,2),Onchip_ADC(:,1),Output_dec,'nearest')


Onchip_ADC=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/ONchip.csv')
//polyfit
[p_Onchip_ADC,S_Onchip_ADC]=polyfit(Onchip_ADC(:,2), Onchip_ADC(:,1),2);
//size_a=size(Onchip_ADC);
//MITE_range_977 = mite_473_977_10uA(size_a(1,1),1):1:mite_473_977_10uA(1,1);
out_volt1 = polyval(p_Onchip_ADC,Output_dec1);


csvWrite(out_volt1,'Results1.csv')
csvWrite(Output_dec1,'Results_dec1.csv')

Out(1:length(Output_dec1),1)=0;
out_volt(1:length(out_volt1),1)=0;

Out(:,1)=Output_dec1(:,1);
out_volt(:,1)=out_volt1(:,1);

end



if Onchip_ADC_num(1,2)==1 then
    
[a1,b1]=unix_g("sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh ./sftreg_miteADC ~/rasp30/prog_assembly/libs/asm_code/ADC_onchip1.s43 16384 16384 16384")


if b1==1
disp('There is an error in your assembly file')
abort;
end





[a1,b1]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4300 -input_file_name "+hid_dir+"/input_vector");
[a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/write_mem2_NoRelease.tcl -start_address 0x4200 -input_file_name "+hid_dir+"/output_info");


err=1;
while err==1
[y,err]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/run.tcl '+path+'sftreg_miteADC.elf');
end


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
clear Output_dec2
m=1
while m<length_out+1
Output_dec2(m,:) = msscanf(New_output(m,:),'%x'); //scan with hexadecimal format   
m=m+1;
end
m=1
mclose(y)

//Onchip_ADC=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/ONchip.csv')

//out_volt=interp1(Onchip_ADC(:,2),Onchip_ADC(:,1),Output_dec,'nearest')


Onchip_ADC=csvRead('~/rasp30/prog_assembly/libs/scilab_code/characterization/char_csv/ONchip2.csv')
//polyfit
[p_Onchip_ADC,S_Onchip_ADC]=polyfit(Onchip_ADC(:,2), Onchip_ADC(:,1),2);
//size_a=size(Onchip_ADC);
//MITE_range_977 = mite_473_977_10uA(size_a(1,1),1):1:mite_473_977_10uA(1,1);
out_volt2 = polyval(p_Onchip_ADC,Output_dec2);


csvWrite(out_volt2,'Results2.csv')
csvWrite(Output_dec2,'Results_dec2.csv')

Out(1:length(Output_dec2),2)=0;
out_volt(1:length(out_volt2),2)=0;

Out(:,2)=Output_dec2(:,1);
out_volt(:,2)=out_volt2(:,1);

end
if Onchip_ADC_num(1,1)==1 then
figure(5);plot(out_volt1,'-o')
end
 if Onchip_ADC_num(1,2)==1 then
figure(5);plot(out_volt2,'-*')
end
end
endfunction
