//**** Shift Register 16inputs 1output (non vecterized version) ********
if (blk_name.entries(bl) =='sr_16i_1o_nv') then
    addvmm = %t;
    mputl("# Shift register 16inputs 1output",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        sr_1i_16o_nv_str= ".subckt sftreg" 
        for m_loop=1:scs_m.objs(bl).model.rpar(1)
        sr_1i_16o_nv_str=sr_1i_16o_nv_str+" in["+string(m_loop-1)+"]=net"+string(blk(blk_objs(bl),m_loop+1))+"_"+string(ss) 
        end
        for m_loop=scs_m.objs(bl).model.rpar(1)+1:16
 
        sr_1i_16o_nv_str=sr_1i_16o_nv_str+" in["+string(m_loop-1)+"]=unconn"
        end
        
        sr_1i_16o_nv_str=sr_1i_16o_nv_str+" in[16]=net"+string(blk(blk_objs(bl),18))+"_1"+" in[17]=net"+string(blk(blk_objs(bl),19))+"_1"+" in[18]=net"+string(blk(blk_objs(bl),20))+"_1"+" out[0]=net"+string(blk(blk_objs(bl),2+numofip))+"_"+string(ss)+" out[1]=net"+string(blk(blk_objs(bl),3+numofip))+"_"+string(ss)+" out[2]=net"+string(blk(blk_objs(bl),4+numofip))+"_"+string(ss)+" out[3]=net"+string(blk(blk_objs(bl),5+numofip))+"_"+string(ss)+" #sftreg_fg =0";
        
        mputl(sr_1i_16o_nv_str,fd_w);
        mputl("  ",fd_w);
        select board_num
        case 2 then plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'11 '+string(ss+5)+' 0'];
        case 3 then plcloc=[plcloc;"net"+string(blk(blk_objs(bl),2+numofip))+"_1",'5 '+string(ss+5)+' 0'];  
        end
    end
end
