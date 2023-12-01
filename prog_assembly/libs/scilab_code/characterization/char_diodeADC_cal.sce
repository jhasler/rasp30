global file_name path fname extension chip_num board_num hex_1nA hex_1na;

mkdir diodeADC_data_files;
unix_g('sudo ~/rasp30/prog_assembly/libs/sh/asm2ihex.sh diode_ADC_char_cal ~/rasp30/prog_assembly/libs/asm_code/diode_ADC_char_cal.s43 16384 16384 16384'); //compiling into an elf file for diode adc hex value to be read and placed in SRAM 

unix_w("sudo chmod 777 /dev/prologix");
h=openserial("/dev/prologix", "9600,n,8,1"); //open port connected to ammeter
writeserial(h,"++addr 15"+ascii(10)); //ascii(10) is Line Feed or New Line
unix_w("sleep 1");
writeserial(h,"++auto 1"+ascii(10)); //Enable auto range
unix_w("sleep 1");
writeserial(h,"SYST:ZCH 0"+ascii(10)); // Disable zero check.

// IVDD 2.5V //
diode_CTRL = [
2.00 0 0 0; 2.05 0 0 0; 2.10 0 0 0; 2.15 0 0 0; 2.20 0 0 0; 2.25 0 0 0; 2.30 0 0 0; 2.35 0 0 0; 
2.40 0 0 0; 2.42 0 0 0; 2.45 0 0 0; 2.47 0 0 0; 2.50 0 0 0 ; 2.52 0 0 0; 2.55 0 0 0; 2.57 0 0 0; 2.60 0 0 0; 2.62 0 0 0; 2.65 0 0 0; 2.67 0 0 0; 2.70 0 0 0; 2.75 0 0 0; 
2.80 0 0 0; 2.85 0 0 0; 2.90 0 0 0; 2.92 0 0 0; 2.95 0 0 0; 2.95 0 0 0; 2.97 0 0 0; 3.0 0 0 0; 3.02 0 0 0; 3.05 0 0 0; 3.1 0 0 0; 3.12 0 0 0];  ///ICHAR values to be set by digilent board [column vector]
//diode_CTRL = [
// 2.10 0 0 0; 2.15 0 0 0; 2.20 0 0 0; 2.25 0 0 0;];  ///ICHAR values to be set by digilent board [column vector]
clear current;

a=size(diode_CTRL);
for i=1: a(1,1) //until the end of ICHAR values
    disp(i);
    
    unix_g('sudo dwfcmd connect target=analogout channel=0 enable=1 function=dc offset="+string(diode_CTRL(i,1))+"V run=0 start finish'); //Set ICHAR value on digilent board
    
    b=1;
    while b==1
        [a1,b1]=unix_g('sudo tclsh ~/rasp30/prog_assembly/libs/tcl/program.tcl -device /dev/rasp30/ -speed 115200 '+path+'/diode_ADC_char_cal.elf'); //place hex value in to SRAM
        [a2,b2]=unix_g("sudo tclsh ~/rasp30/prog_assembly/libs/tcl/read_mem2_NoRelease.tcl -device /dev/rasp30/ -start_address 0x5000 -length 1 -output_file_name '+path+'/diodeADC_data_files/ADC_value.hex"); //read ADC hex value from board
        disp(b2,b1,'b1') //michelle added
        if (b1==0) & (b2==0) then break end // 0 if no error occurred, 1 if error.
        if (b1==1) | (b2==1) then 
            disp("connection issue -> it is trying again"); 
            unix_w('/home/ubuntu/rasp30/sci2blif/usbreset'); 
            sleep(2000);
            sleep(10000);
            unix_w("sudo chmod 777 /dev/prologix");
            h=openserial("/dev/prologix", "9600,n,8,1"); //open port connected to ammeter
            writeserial(h,"++addr 15"+ascii(10)); //ascii(10) is Line Feed or New Line
            unix_w("sleep 1");
            writeserial(h,"++auto 1"+ascii(10)); //Enable auto range
            unix_w("sleep 1");
            writeserial(h,"SYST:ZCH 0"+ascii(10)); // Disable zero check.
        end
    end
    //xpause is in microseconds - 3000000us = 3s
    writeserial(h,"READ?"+ascii(10)); xpause(3000000); temp_a=readserial(h); temp_b=part(temp_a,1:14); current(1,1)=msscanf(temp_b,"%lg"); 
    average_low_current=1
    if abs(current)<1e-10 then
        while average_low_current<10
        
     writeserial(h,"READ?"+ascii(10)); xpause(3000000); temp_a=readserial(h); temp_b=part(temp_a,1:14); low_current(average_low_current,1)=msscanf(temp_b,"%lg");    
        unix_w("sleep 1")
      
      average_low_current=average_low_current+1;  
    end
    current(1,1)=mean(low_current)
    end
    
    while current ==[]
        writeserial(h,"READ?"+ascii(10)); xpause(3000000); temp_a=readserial(h); temp_b=part(temp_a,1:14); current(1,1)=msscanf(temp_b,"%lg");
    end
    while current >=9.900D+37
        writeserial(h,"READ?"+ascii(10)); xpause(3000000); temp_a=readserial(h); temp_b=part(temp_a,1:14); current(1,1)=msscanf(temp_b,"%lg");
    end
    
    
    if i < 3 then //michelle added
        disp(temp_a,temp_b)
    end
    
    b=1;
    while b==1
        [a1,b1]=unix_g('dwfcmd connect target=analogout channel=0 enable=1 function=dc offset="+string(diode_CTRL(i,1))+"V run=0 start watch=25s analogin record channel=1 enable=1 range=2V offset=0 frequency=50 run=1s start save=diodeADC_data_files/data_'+string(i)+'_25V.csv'); //record 10 voltage values
	disp(a1,'waveform output')
        [a1,b1]=unix_g('ls diodeADC_data_files/data_'+string(i)+'_25V.csv');
        if (b1==0) then break end // 0 if no error occurred, 1 if error.
    end
    
    diode_CTRL(i,2)=abs(current);
    M = csvRead('diodeADC_data_files/data_'+string(i)+'_25V.csv'); M = mean(M(20:30)); diode_CTRL(i,3)=M; // take the mean of the voltage values
    ADC_value=mopen(path+'/diodeADC_data_files/ADC_value.hex','rt'); ADC_hex_value=mgetl(ADC_value); mclose(ADC_value); diode_CTRL(i,4)=msscanf(ADC_hex_value,"%x");
    disp(diode_CTRL(i,:));
end
csvWrite(diode_CTRL,'data_diodeADC_ivdd25V');
disp("Diode_ADC calibration done");

//Ichar value, current, mean I2Vout voltage, ADC Hex value

