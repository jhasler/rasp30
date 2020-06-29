function arb_gpin_compile = genarb_gpin_compile(x,y,z,regen)
    global gpin_array gpin_array_map number_samples period chip_num board_num;
    
    select board_num 
    case 2 then brdtype = '';
    case 3 then brdtype = '_30a';
    case 4 then brdtype = '_30n';
    case 5 brdtype = '_30h';
    else messagebox('Please select the FPAA board that you are using.', "No Selected FPAA Board", "error"); abort;
    end
    
    mat_sz = size(evstr(x));
    m = mat_sz(1,2);
    var=evstr(x);
    mat_sz2 = size(z);  // z : GPIO In information matrix
    l = mat_sz2(1,2);
    
    j=1;
    for i=1:l
        gpin_array(z(i)+1,1) = 1; gpin_array(z(i)+1,2) = 1;
        if regen == 0 then gpin_array_map(z(i)+1)=x+'_'+string(j); end
        if regen == 1 then gpin_array_map(z(i)+1)=x; end
        for k=1:m
            //gpin_array(z(i)+1,k+2) = modulo(var(j,k),2)*2^z(i);
            gpin_array(z(i)+1,k+2) = modulo(var(j,k),2);
        end
        j=j+1;
    end
    
    number_samples=m;
    period = '0x'+ string(sprintf('%4.4x', (1/y)*1E05));
    
    arb_gpin_compile = 1;
    
endfunction
