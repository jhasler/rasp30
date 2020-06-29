//**************************** Join ********************************
if(blk_name.entries(bl)=='join')  then
    for ss= 1:scs_m.objs(blk_objs(bl)).model.rpar(1) 
        spl_fix=[spl_fix;'net'+ string(blk(blk_objs(bl),ss+1+numofip))+"_",'net'+string(blk(blk_objs(bl),2))+"_"]
        spl_fix=[spl_fix;'out:net'+ string(blk(blk_objs(bl),ss+1+numofip))+"_",'out:net'+string(blk(blk_objs(bl),2))+"_"]
        spl_fix_chg=%t;
       // disp(spl_fix)
    end
end
