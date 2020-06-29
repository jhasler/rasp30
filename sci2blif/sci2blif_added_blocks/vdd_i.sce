//************************** VDD IN Analog *****************************
if(blk_name.entries(bl)=='vdd_i')  then
    chgnet_dict=[chgnet_dict;'net'+ string(blk(blk_objs(bl),2+numofip))+"_..",'vcc ']
    chgnet_tf=%t;
end
