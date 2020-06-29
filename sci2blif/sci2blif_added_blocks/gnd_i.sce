//************************** GND IN Analog ********************************
if(blk_name.entries(bl)=='gnd_i')  then
    chgnet_dict=[chgnet_dict;'net'+ string(blk(blk_objs(bl),2+numofip))+"_..",'gnd ']
    chgnet_tf=%t;
end
