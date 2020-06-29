function retool(dict,path,fname,ext)
    dict=msprintf('\''%s\'':\''%s\'',',dict)
    dict=part(dict,1:length(dict)-1)
    dict=msprintf('\""%s\""',dict)
    unix_s('python /home/ubuntu/rasp30/sci2blif/retool.py ' + path + fname + ext + dict)
endfunction
