function block=sftreg_c(block,flag)
    if flag==1 then
        block.outptr(1)=block.inptr(1);
    end
endfunction    
