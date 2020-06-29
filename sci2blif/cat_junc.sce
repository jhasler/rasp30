function fin_cat = junc(junc_num)
    global cat_num jlist

    jtmp1 = jlist(junc_num,1).entries
    if jtmp1 ~= [] then
        cat_num(1,1).entries=cat(2, cat_num(1,1).entries,jtmp1)
        jlist(junc_num,1).entries = []
        junc(jtmp1)
    else
        fin_cat = %t
        return
    end

    jtmp2 = jlist(junc_num,2).entries
    if jtmp2 ~= [] then
        cat_num(1,1).entries=cat(2,cat_num(1,1).entries,jtmp2)
        jlist(junc_num,2).entries = []
        junc(jtmp2)
        fin_cat = cat_num(1,1).entries
        return
    else
        fin_cat = cat_num(1,1).entries
        return
    end
//here
endfunction
