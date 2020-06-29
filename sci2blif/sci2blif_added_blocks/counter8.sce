//**************************** Counter 8 ******************************
if (blk_name.entries(bl) =='counter8') then
    mputl("# counter8",fd_w);
    for ss=1:scs_m.objs(bl).model.ipar(1)
        counter8_str= ".subckt counter8 clk=net"+string(blk(blk_objs(bl),2))+"_"+string(ss)+" reset=net"+string(blk(blk_objs(bl),3))+"_"+string(ss); 
        for ss_out=1:3 
            counter8_str=counter8_str+" out["+string(ss_out-1)+"]=net"+string(blk(blk_objs(bl),ss_out+1+numofip))+"_"+string(ss);
        end
        mputl(counter8_str,fd_w);
        mputl("  ",fd_w);
    end
end
