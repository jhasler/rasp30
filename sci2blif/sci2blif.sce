//***********************************
//SCRIPT TO READ FROM XCOS MODEL FILE
//***********************************
vpr_path='/home/ubuntu/rasp30/vtr_release/vtr_flow/'

clear blk blk_objs jlist cat_num loctmp loctmp2;
global file_name jlist cat_num board_num addvmm plcvpr pass_num chip_num cap_info show_dsgnmatrics;
global sft_chk ramp_chk;

importXcosDiagram(file_name);
disp("Compiling...");

select board_num 
case 2 then arch = 'rasp3'; brdtype = ''; loc_num=1;
case 3 then arch = 'rasp3a'; brdtype = ' -'+arch; loc_num=2;
case 4 then arch = 'rasp3n'; brdtype = ' -'+arch; loc_num=3;
case 5 arch = 'rasp3h'; brdtype = ' -'+arch; loc_num=4;
else disp("1111");messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort; end

if chip_num == [] then messagebox('Please enter the FPAA board number that you are using.', "No FPAA Board Number Entered", "error"); abort; end
[path,fname,extension]=fileparts(file_name); //get filename, path and extension
cd(path); deletefile(fname+'.blif'); deletefile(fname+'.blk'); deletefile('info.txt');
hid_dir=path+'.'+fname;
unix_s('mkdir -p '+hid_dir);
deletefile(hid_dir + '/' + fname + '.pads'); 

global dac_array dac_array_map gpin_array gpin_array_map number_samples period b_elements;
b_elements = tlist(['b_element','b_ota', 'b_fgota', 'b_nfet', 'b_pfet', 'b_cap', 'b_tgate', 'b_nmirror', 'b_ble','b_ibias'],0,0,0,0,0,0,0,0,0)
dac_array = [0]; dac_array_map = ""; gpin_array = [0]; gpin_array_map = ""; number_samples = 0; period = "0x03e8";
blname = "";
numofip=0; numofop=0; numofblk=0; numoflink=0;
inps=0; accblk=1;
blk_name=cell([1,1]); link_blk=cell([1,1]); spl_blk=cell([1 1]); cat_num =cell([1 1]); junc_unq = cell([1 1]);
arb_gen = cell([1 1]); gpin = cell([1 1]); ga_idx = cell(); gpin_idx = cell();
no=length(scs_m.objs); link_name=zeros(1,no); numipsofblk=zeros(no,2);
j=1; net=1;
objnum=1; ip_count=1; op_count=1;
prime_ips=[]; prime_ops=[]; blk_objs=[];
vmm_ct=0; split = %f; spl_src = [];
ga_blk_num= 0; gpin_blk_num= 0; genarb_dac=[]; genarb_gpin=[]; dc_dac=[];
fix_gnd=0; fix_vdd=0; ramp_adc=0; mite_adc=0;

global RAMP_ADC_check sftreg_check Signal_DAC_check GPIO_IN_check MITE_ADC_check plcloc ladder_count ONchip_ADC Onchip_ADC_num Counter_class mite_count lpf_ota_count mite_adc_number;
RAMP_ADC_check=0; sftreg_check=0; Signal_DAC_check=0; GPIO_IN_check=0; MITE_ADC_check=0; ladder_count=0; ONchip_ADC =0; sftreg_count=0;Onchip_ADC_num(1,1:2) =0;Counter_class=0;mite_count=0;lpf_ota_count=0;mite_adc_number=0;
add_clk=[]; dig_blk=0; netout=[]; addvmm = %f; plcvpr = %f;
plcloc = [];
nfetloc = 1; pfetloc = 1;
chgnet = [0,0,0,0,0,0]; //gnd_i gnd gnd_dig vdd vdd_o vdd_dig
chgnet_dict= []; chgnet_tf= %f; makeblk = %f; spl_fix = []; spl_fix_chg= %f; blk_in=[]; blk_out=[];
internal_number = 1; add_tgates4logic = 0; number_tgates = 0;
dac_loc_idx=0; dac_buf_loc_idx=0; gpin_loc_idx=0; adc_loc_idx=0; adc_ip_idx1=1; adc_ip_idx2=1; adc_ip_net=[1 2];

dac_loc= cell(); dac_buf_loc= cell(); gpin_loc= cell(); adc_locin= cell(); adc_loc= cell(); iopad_loc= cell();
exec("/home/ubuntu/rasp30/sci2blif/io_info/io_info_rasp30.sce",-1);
exec("/home/ubuntu/rasp30/sci2blif/io_info/io_info_rasp30a.sce",-1);

// Get net & block information (connection, block parameters)
for i =1:no
    if(length(scs_m.objs(i) )==8)  then numoflink=numoflink+1; link_name(1,numoflink)=i;
    else
        blk(j,1)=i;
        if(scs_m.objs(i).gui== "dac") then prime_ips(ip_count)=j; ip_count=ip_count+1; blk_name.entries(j)= scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "dc_out1") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "dac_o") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
//        elseif (scs_m.objs(i).gui== "adc1") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
//        elseif (scs_m.objs(i).gui== "adc2") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "adc_ip") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_in") then prime_ips(ip_count)=j; ip_count=ip_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_ina") then prime_ips(ip_count)=j; ip_count=ip_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_ind") then prime_ips(ip_count)=j; ip_count=ip_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_out") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_outa") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        elseif (scs_m.objs(i).gui== "pad_outd") then prime_ops(op_count)=j; op_count=op_count+1; blk_name.entries(j)=  scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
        else    
            blk_name.entries(j)=scs_m.objs(i).gui; blk_objs(objnum)=j; objnum=objnum+1;
            //counting extra primary inputs for references of output otas of vmm
            if (scs_m.objs(i).gui =='vmm_4') then vmm_ct= vmm_ct+8;
            elseif (scs_m.objs(i).gui =='meas_volt') then mite_adc = 1;
            elseif (scs_m.objs(i).gui =="sr_ni_1o")|(scs_m.objs(i).gui== "sr_4i_1o") then sft_chk = 1;
            elseif (scs_m.objs(i).gui =='Ramp_ADC') then ramp_chk = 1;ramp_adc=1;
            elseif (scs_m.objs(i).gui =='TIA') then mite_adc = 1;
            elseif (scs_m.objs(i).gui =='GENARB_f')  then ga_blk_num = ga_blk_num+1; ga_idx(ga_blk_num,1).entries(1,1)=i; ga_idx(ga_blk_num,1).entries(1,2)=size(evstr(scs_m.objs(i).model.opar(1)), "r");
            elseif (scs_m.objs(i).gui =='gpio_in' | scs_m.objs(i).gui =='gpio_in_fixloc')  then gpin_blk_num = gpin_blk_num+1; gpin_idx(gpin_blk_num,1).entries(1,1)=i; gpin_idx(gpin_blk_num,1).entries(1,2)=size(evstr(scs_m.objs(i).model.opar(1)), "r");
            elseif (scs_m.objs(i).gui== "vdd_i") then fix_vdd = 1;
            elseif (scs_m.objs(i).gui== "gnd_i") then fix_gnd = 1;
            elseif (scs_m.objs(i).gui== "lkuptb") then
            if scs_m.objs(i).model.ipar(1) ~= 4 then fix_gnd = 1; fix_vdd = 1; add_tgates4logic = 1; number_tgates = max(4-scs_m.objs(i).model.ipar(1),number_tgates); end
            elseif (scs_m.objs(i).gui== "gnd_dig") then fix_gnd = 1; fix_vdd = 1;
            elseif (scs_m.objs(i).gui== "vdd_dig") then fix_vdd = 1;
            elseif (scs_m.objs(i).gui== "dc_in") then fix_vdd = 1;
            elseif (scs_m.objs(i).gui== "generic_dig") then dig_blk = 1;
            elseif (scs_m.objs(i).gui== "nfet_gldn") | (scs_m.objs(i).gui== "pfet_gldn") | (scs_m.objs(i).gui== "speech")|(scs_m.objs(i).gui== "sr_16i_1o") then plcvpr = %t;
            elseif (scs_m.objs(i).gui== "vmm_wta") then fix_gnd = 1;
            elseif (scs_m.objs(i).gui== "Ramp_ADC") | (scs_m.objs(i).gui== "TIA_ramp") then ramp_adc = 1;  
            elseif (scs_m.objs(i).gui== "vmmwta") then plcvpr = %t;
            elseif (scs_m.objs(i).gui== "in_port") then makeblk = %t;
            elseif (scs_m.objs(i).gui== "hystdiff") then fix_gnd = 1; fix_vdd = 1;
            end
        end
        j=j+1;
        numofblk=numofblk+1;
        //save the number of inputs for each block
        if((length(scs_m.objs(i).model.in2)==1)&(scs_m.objs(i).model.in2 ~= -1)) then numipsofblk(i,2)= scs_m.objs(i).model.in*scs_m.objs(i).model.in2;
        elseif((length(scs_m.objs(i).model.in2)==1)&(scs_m.objs(i).model.in2 == -1)) then numipsofblk(i,2)=1; 
        else numipsofblk(i,2)=length(scs_m.objs(i).model.in);  
        end

        if(length(scs_m.objs(i).model.in)>numofip) then numofip=length(scs_m.objs(i).model.in); end;
        if(length(scs_m.objs(i).model.out)>numofop) then numofop=length(scs_m.objs(i).model.out); end; 
    end;
end;
// Get pad information from pad blocks
file_list=listfiles("/home/ubuntu/rasp30/sci2blif/sci2pads_added_blocks/*.sce");
size_file_list=size(file_list);
if file_list ~= [] then
    for bl=1:length(blk_objs)
        for i=1:size_file_list(1)
            exec(file_list(i),-1);
        end
    end
end
numofio=numofip+numofop;//blknumber+ip+op

blk=[blk,zeros(numofblk,numofio)];
link_blk=link_name(1, 1:numoflink);

for m=1:numoflink
    curblk=scs_m.objs(link_blk(1,m)).from(1,1);
    for r=1:numofblk
        if(blk(r,1)==curblk) then
            outofblk=scs_m.objs(link_blk(1,m)).from(1,2);
            idx=1+numofip+outofblk;
            if(scs_m.objs(curblk).gui=='SPLIT_f') then                   
                spl_net=spl_blk(curblk,1).entries;
                blk(r,idx)=spl_net;
                split = %t;
                if pass_num == 1 then
                    c_splt = scs_m.objs(link_blk(1,m)).to(1,1);
                    if scs_m.objs(c_splt).model.sim(2) ~= 4 then
                        cap_info(spl_src(curblk))(2,1) = cap_info(spl_src(curblk))(2,1)+ 1;
                    elseif scs_m.objs(c_splt).model.equations ~= list() then
                        modblk = scs_m.objs(c_splt).model.equations.model;
                        mod_blk = isfile(%MODELICA_USER_LIBS+'/'+modblk+'.mo');
                        if mod_blk == %t then
                            cap_info(spl_src(curblk))(2,1) = cap_info(spl_src(curblk))(2,1)+ 1;
                        end
                    end
                end
            elseif(scs_m.objs(curblk).gui=='join') then
                blk(r,idx)=net;
                if pass_num == 1 then
                    c_splt = scs_m.objs(link_blk(1,m)).to(1,1);
                    if scs_m.objs(c_splt).model.sim(2) == 4 then
                        cap_info(spl_src(curblk))(2,1) = cap_info(spl_src(curblk))(2,1)- 1;
                    elseif scs_m.objs(c_splt).model.equations ~= list() then
                        modblk = scs_m.objs(c_splt).model.equations.model;
                        mod_blk = isfile(%MODELICA_USER_LIBS+'/'+modblk+'.mo');
                        if mod_blk == %f then
                            cap_info(spl_src(curblk))(2,1) = cap_info(spl_src(curblk))(2,1)- 1;
                        end
                    end
                end
            else
                blk(r,idx)=net;
                if pass_num == 1 then
                    cap_info(1) = [cap_info(1), 'net'+string(net)];
                    cap_info('net'+string(net))(1,1) = curblk;
                    cap_info('net'+string(net))(1,2) = 0;
                end

            end
            break;
        end
    end
    curblk=scs_m.objs(link_blk(1,m)).to(1,1);
    for r=1:numofblk
        if(blk(r,1)==curblk) then
            inofblk=scs_m.objs(link_blk(1,m)).to(1,2);
            idx=1+inofblk;
            c_fpaa=size(scs_m.objs(curblk).model.sim);
            outblk=scs_m.objs(link_blk(1,m)).from(1,1);
            if(scs_m.objs(curblk).gui=='SPLIT_f') then
                spl_blk(curblk,1).entries=net;
                if pass_num == 1 then
                    cap_info('net'+string(net))(2,1) = 0;
                    spl_src(curblk)= 'net'+string(net);
                end
            elseif(scs_m.objs(curblk).gui=='join') then
                if pass_num == 1 then
                    cap_info('net'+string(net))(2,1) = scs_m.objs(curblk).model.rpar;
                    spl_src(curblk)= 'net'+string(net);
                end
            elseif pass_num == 1 & split == %f & c_fpaa(1) == 2 & scs_m.objs(outblk).gui ~= 'join' then
                if scs_m.objs(curblk).model.sim(2) ~= 4  then
                    cap_info('net'+string(net))(2,1) = 1;
                end
            end

            if(split == %t) then
                blk(r,idx)=spl_net;
                split = %f;
            else
                blk(r,idx)=net;
                net=net+1;
            end
            break;
        end
    end
end

// primary input string
if dig_blk==1 then prime_ip_string= '.inputs rst'; 
else prime_ip_string= '.inputs';
end
pad_in_string="#";

//prime_ipnet=string(blk(prime_ips(1),2+numofip)); 
if ga_blk_num ~= 0 then
    for ga = 1:ga_blk_num
        ga_blk_num2 =ga_idx(ga,1).entries(1,2);
        for ga2 = 1:ga_blk_num2
            prime_ip_string=strcat([prime_ip_string," net",string(blk(ga_idx(ga,1).entries(1,1),2+numofip)), "_",string(ga2) ]);
        end
    end
end
if gpin_blk_num ~= 0 then
    for gpin = 1:gpin_blk_num
        gpin_blk_num2 =gpin_idx(gpin,1).entries(1,2);
        for gpin2 = 1:gpin_blk_num2
            prime_ip_string=strcat([prime_ip_string," net",string(blk(gpin_idx(gpin,1).entries(1,1),2+numofip)), "_",string(gpin2) ]);
        end
    end
end
for s=1: length(prime_ips)    
    for ss=1:scs_m.objs(prime_ips(s)).model.ipar(1)
        prime_ip_string=strcat([prime_ip_string," net",string(blk(prime_ips(s),2+numofip)),"_",string(ss) ]);
        pad_in_string=pad_in_string+" "+string(scs_m.objs(prime_ips(s)).model.rpar(ss));
    end

end
pad_in_string = pad_in_string + " pad_in";

orignet = net;
//extra primary inputs for vmm output ota
for s=1: vmm_ct
    prime_ip_string=strcat([prime_ip_string," net",string(net)]);
    net = net+1;
end

// adding gnd/vdd as an input
if fix_vdd == 1 then prime_ip_string=strcat([prime_ip_string," vcc"]); end
if fix_gnd == 1 then prime_ip_string=strcat([prime_ip_string," gnd"]); end
if (ramp_adc==1)|(ramp_chk==1) then prime_ip_string=strcat([prime_ip_string," clear"]); end

prime_op_string= '.outputs'; //primary o/p string
pad_out_string="#";

for s=1: length(prime_ops)
    if blk_name(prime_ops(s)).entries == 'dc_out1' then
        for ss=1:scs_m.objs(prime_ops(s)).model.ipar(1)
            prime_op_string= prime_op_string + ' net'+ string(blk(prime_ops(s),2+numofip))+ "_" + string(ss);
        end
    elseif blk_name(prime_ops(s)).entries == 'pad_in' then
        for ss=1:scs_m.objs(prime_ops(s)).model.ipar(1)
            prime_op_string= prime_op_string + ' net'+ string(blk(prime_ops(s),2+numofip))+ "_" + string(ss);
        end
//    elseif blk_name(prime_ops(s)).entries == 'adc1' then
//            prime_op_string= prime_op_string + ' out_adc_1';
//    elseif blk_name(prime_ops(s)).entries == 'adc2' then
//            prime_op_string= prime_op_string + ' out_adc_2';
    elseif blk_name(prime_ops(s)).entries == 'adc_ip' then
            prime_op_string= prime_op_string + ' out_adc_'+string(adc_ip_net(adc_ip_idx1)); adc_ip_idx1=adc_ip_idx1+1;
    else
        for ss=1:scs_m.objs(prime_ops(s)).model.ipar(1)
            prime_op_string= prime_op_string + ' net'+ string(blk(prime_ops(s),2)) + "_" + string(ss);
            pad_out_string=pad_out_string+" "+string(scs_m.objs(prime_ops(s)).model.rpar(ss));
        end
    end //assuming need to account for a dac for the voltage measurement and net is the next wire number
end
pad_out_string = pad_out_string + " pad_out";

// adding gnd/vdd as an output
if mite_adc == 1 then
    for i=1:numofblk
        if blk_name.entries(i)=='meas_volt' then
            if mite_adc_number==0
                mite_adc_number=1;
                prime_op_string=strcat([prime_op_string," out_mite_adc_"+string(mite_adc_number)]);
            else
                mite_adc_number=mite_adc_number+1;
                prime_op_string=strcat([prime_op_string," out_mite_adc_"+string(mite_adc_number)]);
            end
        end
    end
end//needs to be generalized
if ramp_adc == 1 then prime_op_string=strcat([prime_op_string," out_ramp_adc"]); end

//Writing output to blif file and make pads file
if makeblk == %f then
    fd_w= mopen (fname+'.blif','wt'); mputl(strcat([".model"," ",fname])  ,fd_w); mputl(prime_ip_string,fd_w); mputl(prime_op_string,fd_w); mputl(pad_in_string,fd_w); mputl(pad_out_string,fd_w); mputl("  ",fd_w); mclose(fd_w);
    // restrict the one digital component (ex. inverter) that vpr needs to work
    fd_io= mopen(fname+'.pads','wt'); mclose(fd_io);
    if fix_gnd == 1 then fd_io= mopen (fname+'.pads','a+'); mputl('gnd 7 0 4 #int[4]',fd_io); mclose(fd_io); end
    if fix_vdd == 1 then fd_io= mopen (fname+'.pads','a+'); mputl('vcc 7 0 5 #int[5]',fd_io); mclose(fd_io); end
    if dig_blk == 1 then fd_io= mopen(fname+'.pads','a+'); mputl('rst 8 0 0  #tgate[0]',fd_io); mclose(fd_io); end    
end

if makeblk then
    // tgates for logics
    fl_name= basename(file_name)+'.blk';
    fd_w= mopen (fl_name,'a');
    if add_tgates4logic == 1 then
        mputl("# tgates for logic",fd_w);
        for i=1:number_tgates
            tg4logic_str=".subckt tgate in[0]=vcc in[1]=gnd out=tg4logic_"+string(i);mputl(tg4logic_str,fd_w);mputl("  ",fd_w);
        end
    end
else
    // tgates for logics
    fl_name= basename(file_name)+'.blif';
    fd_w= mopen (fl_name,'a');
    if add_tgates4logic == 1 then
        mputl("# tgates for logic",fd_w);
        for i=1:number_tgates
            tg4logic_str=".subckt tgate in[0]=vcc in[1]=gnd out=tg4logic_"+string(i);mputl(tg4logic_str,fd_w);mputl("  ",fd_w);
        end
    end
end

// write blif information
file_list=listfiles("/home/ubuntu/rasp30/sci2blif/sci2blif_added_blocks/*.sce");
size_file_list=size(file_list);
if file_list ~= [] then
    for bl=1:length(blk_objs)
        for i=1:size_file_list(1)
            exec(file_list(i),-1);
        end
    end
end

if makeblk == %f then mputl(".end",fd_w); end
mclose(fd_w);

if makeblk then ext = '.blk ';
else ext = '.blif ';
end

exec('~/rasp30/sci2blif/retool.sce',-1);

if chgnet_tf == %t then retool(chgnet_dict,path,fname,ext); end
if spl_fix_chg == %t then retool(spl_fix,path,fname,ext); retool(spl_fix,path,fname,'.pads '); end

exec("~/rasp30/prog_assembly/libs/scilab_code/make_input_vector_file.sce",-1);
make_input_vector_file();

if(makeblk) then 
    exec('~/rasp30/sci2blif/blif4blk.sce',-1);
    mkblk(fd_w,blk,blk_objs);
    disp('Done!');
else
    if plcvpr then
        if addvmm then unix_s('/home/ubuntu/rasp30/vtr_release/vpr/vpr /home/ubuntu/rasp30/vpr2swcs/./arch/'+arch+'_arch.xml ' + path + fname + '  -route_chan_width 17 -timing_analysis off -fix_pins ' + path + fname + '.pads -nodisp');
        else unix_s('/home/ubuntu/rasp30/vtr_release/vpr/vpr /home/ubuntu/rasp30/vpr2swcs/./arch/'+arch+'_arch.xml ' + path + fname + '  -route_chan_width 17 -timing_analysis off -fix_pins ' + path + fname + '.pads -nodisp');
        end

        plcfile=mopen(path + fname + '.place','r'); tmpplc=mgetl(plcfile); mclose(plcfile);

        for plcidx=6:size(tmpplc,'r') 
            if size(strsplit(tmpplc(plcidx),"/\s\s/")','c') == 1 then
                loctmp(plcidx-5,:)=strsplit(tmpplc(plcidx),"/\s/")'; //has net names
                loctmp2(plcidx-5) = strcat(loctmp(plcidx-5,2:4), ' ');
            else
                loctmp(plcidx-5,:)=[strsplit(tmpplc(plcidx),"/\s\s/")' ' ' ' ' ' ']; //has net names
                tmploc =strsplit(loctmp(plcidx-5,2), '/\t/');
                tmploc = strcat(tmploc, ' ');
                tmploc = strsubst(tmploc,"/#.*/",'','r');
                loctmp2(plcidx-5) = stripblanks(tmploc)
            end
        end

        loc_matrix=[loctmp(:,1) loctmp2]; //disp(loc_matrix)
        l_loc_matrix=size(loc_matrix,"r");
        l_plcloc=size(plcloc,"r");
        for i_plcloc=1:l_plcloc
            for i_loc_matrix=1:l_loc_matrix
                if loc_matrix(i_loc_matrix,1) == plcloc(i_plcloc,1) then
                    for j_loc_matrix=1:l_loc_matrix
                        if loc_matrix(j_loc_matrix,2) == plcloc(i_plcloc,2) then
                            loc_matrix(j_loc_matrix,2) = loc_matrix(i_loc_matrix,2);
                        end
                    end
                    loc_matrix(i_loc_matrix,2) = plcloc(i_plcloc,2);
                end
            end
        end
        loc_matrix(:,3)=loc_matrix(:,1)+" "+loc_matrix(:,2);
        plcfile=mopen(path + fname + '.place','wt'); mputl(tmpplc(1:5),plcfile); mclose(plcfile);
        plcfile=mopen(path + fname + '.place','a'); mputl(loc_matrix(:,3),plcfile); mclose(plcfile);

        // generate switches
        unix_s('python /home/ubuntu/rasp30/vpr2swcs/genswcs.py -c ' + path + fname + ' -d '+ path + ' -route' + brdtype);
    else
        unix_s('python /home/ubuntu/rasp30/vpr2swcs/genswcs.py -c ' + path + fname + ' -d '+ path + brdtype);
    end
    unix_s('mv ' + fname' + '.pads ' + fname + '.place ' + fname + '.net ' + fname + '.route ' +hid_dir);
    
    if show_dsgnmatrics == 1 then cap_info = caps4sim(cap_info); end

    unix_s('mv ' + fname' + '.caps ' +hid_dir);
    if show_dsgnmatrics == 1 & pass_num == 2 then exec("~/rasp30/prog_assembly/libs/scilab_code/MakeProgramlilst_CompileAssembly.sce",-1); end
    if show_dsgnmatrics == 0 then exec("~/rasp30/prog_assembly/libs/scilab_code/MakeProgramlilst_CompileAssembly.sce",-1); end
    
    disp("Compilation Completed. Ready to Program.");
end
if show_dsgnmatrics == 1 then cap_infos = cap_info; end

