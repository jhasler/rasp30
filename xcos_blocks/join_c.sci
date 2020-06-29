function block=join_c(block,flag)
    if flag==1 
        for r = 1:block.rpar(1)
            block.outptr(r)=block.inptr(1);
        end
    end
endfunction
