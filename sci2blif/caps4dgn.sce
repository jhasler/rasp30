//parses capacitance values file for design generated with vpr2swcs
function cap_info_up = caps4sim(cap_info)

    global path fname //cap_info;

    caps = csvRead(path+fname+'.caps',',' ,'.' , 'string');

    for id=1:size(caps,1)
        und_cap = strindex(caps(id),'_');
        if size(und_cap,2) == 1 & part(caps(id),(1:3)) == 'net'  then //net_
            cap_net = part(caps(id), 1:und_cap(1)-1);
            cap_idx = strtod(part(caps(id),und_cap(1)+1:length(caps(id,1))));
        else //custom netname
            cap_net = caps(id);
            cap_indx=strindex(strcat(string(isdigit(cap_net))),'T');
            if cap_indx == [] then //custom net name without a number ex: some_var or somevar
                cap_idx = 1;
            else //custom net name with a number ex: some_var12 or somevar12
                cap_idx = strtod(part(cap_net,cap_indx(:)));
            end
        end

        cap_info(cap_net)(cap_idx,2) = strtod(caps(id,2));
    end
    cap_info_up = cap_info

endfunction

//For blocks with an out[0] that is not net#_#, but rather custom
//Example: Measure Voltage block type where blif is located before for loop 
//cap_info = cap_info2(cap_info,pass_num,'out_mite_adc', bl)
//where the only parameter that needs to change is the netname for any other blk
function cap_info=cap_info2(cap_info,pass_num, netname,blknum)
    //global cap_info;
    if pass_num == 1 then
        cap_info(1) = [cap_info(1), netname];
        cap_info(netname)(1,1) = blknum;
        cap_info(netname)(1,2) = 0;
    end
endfunction

//Calculates the total capacitance value, which inclues:
//global routing capacitance, # of inputs that the block's output is connected, # of internal macromodel routing lines
function c_blk = cap_add(c_blk, c_local, c_macro)
    c_blk = c_blk + c_local * 160e-15 + c_macro * 160e-15;
endfunction

//Stores the total number of CAB and CLB elements used in the design
//When creating a new block make sure to enter the number of elements used for a single block
//Example: LPFOTA type before for loop, where in this case one lpf only uses one ota in a CAB
//b_elements = elements_add(b_elements,scs_m.objs(bl).model.ipar(1),1, 0, 0, 0, 0, 0, 0,0)
//The values that change are the elements
//num_blk -(# of times blif should be generated) typically is saved in scs_m.objs(bl).model.ipar(1)
//Note the b_constant parameter accounts for the nfet in wta that remains one no matter how many branches
function b_elements = elements_add(b_elements,num_blk,b_ota, b_fgota, b_nfet, b_pfet, b_cap, b_tgate, b_nmirror,b_constant)
    b_elements.b_ota = b_elements.b_ota+b_ota*num_blk;
    b_elements.b_fgota = b_elements.b_fgota+b_fgota*num_blk;
    b_elements.b_nfet = b_elements.b_nfet+b_nfet*num_blk + b_constant;
    b_elements.b_pfet = b_elements.b_pfet+b_pfet*num_blk;
    b_elements.b_cap = b_elements.b_cap+b_cap*num_blk;
    b_elements.b_tgate = b_elements.b_tgate+b_tgate*num_blk;
    b_elements.b_nmirror = b_elements.b_nmirror+b_nmirror*num_blk;
    
endfunction
