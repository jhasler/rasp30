function block=genarb_func(block,flag)
    if flag==1
        t = scicos_time();
        mat_sz = size(evstr(block.opar(1)))
        j = 1:mat_sz(1,1)
        period = 1/block.rpar(1)
        remainder = t-fix(t./(period)).*period
        if remainder <= (1D-10) then
            if t == 0 then
                var=evstr(block.opar(1))
                block.outptr(1)(j)=var(j,1)
            else
                n = round(t/period)
                var=evstr(block.opar(1))
                //disp('n',n,'size',size(t))
//                if t > 1.01 | t < 1.1 then
//                    disp('time',t,'n', n)
//                end
                if block.opar(2) == 'N' then
                    block.outptr(1)(j)=var(j,n+1)
                else
                    if n >= mat_sz(1,2) then
                        block.outptr(1)(j)=var(j,(modulo(n,mat_sz(1,2))+1))
                    else 
                        block.outptr(1)(j)=var(j,n+1)
                    end
                end
            end
        end
    end
endfunction
