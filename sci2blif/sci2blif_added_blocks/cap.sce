//****************************** CAP ***********************************
if (blk_name.entries(bl) =='cap') then
    for ss=1:scs_m.objs(bl).model.ipar(1)
        mputl("# cap "+string(bl)+" "+string(scs_m.objs(bl).model.ipar(2))+" "+string(ss),fd_w);
        cap_str = ".subckt cap in[0]=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" out[0]=net"+ string(blk(blk_objs(bl),2+numofip))+"_" + string(ss);
        capcap = scs_m.objs(blk_objs(bl)).model.rpar(ss)
        select capcap
        case 1 then cap_str=cap_str+" #cap_1x_cs =1";
        case 2 then cap_str=cap_str+" #cap_2x_cs =2";
        case 3 then cap_str=cap_str+" #cap_1x_cs =3"+"&cap_2x_cs =0";
        case 4 then cap_str=cap_str+" #cap_4x_cs =4";
        case 5 then cap_str=cap_str+" #cap_1x_cs =5"+"&cap_4x_cs =0";
        case 6 then cap_str=cap_str+" #cap_2x_cs =6"+"&cap_4x_cs =0";
        case 7 then cap_str=cap_str+" #cap_1x_cs =7"+"&cap_2x_cs =0"+"&cap_4x_cs =0";
        else error("Capacitor cannot be compiled.");
        end
        mputl(cap_str,fd_w);
        mputl("  ",fd_w);
        if scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1) == 1 then
            plcvpr = %t;
            plcloc=[plcloc;'net'+string(blk(blk_objs(bl),2+numofip))+'_'+string(ss),string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss-1))+' '+string(scs_m.objs(bl).model.rpar(scs_m.objs(bl).model.ipar(1)*(2-1)+1+2*ss))+' 0'];
        end
    end
end
