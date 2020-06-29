function block=output_func(block,flag)
    if flag==1 

        t = scicos_time();

        execstr('global ' + (block.opar(1)))
        execstr('var = ' + (block.opar(1)))

        period = 1/block.rpar(1)
        remainder = t-fix(t./(period)).*period

        if remainder <= (1D-10) then
            if t == 0 then
                clear var
                j = 1:block.rpar(2)
                var(j, 1) = block.inptr(1)(j)
                execstr((block.opar(1)) + ' = var')
            else
                mat_sz = size(var)
                j = 1:block.rpar(2)
                num_cols = mat_sz(1,2)
                var(j, num_cols + 1) = block.inptr(1)(j)
                execstr((block.opar(1)) + ' = var')
            end
        end
    end
endfunction
