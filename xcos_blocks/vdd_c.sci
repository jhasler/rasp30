function block=vdd_c(block,flag)
    if flag==1 then
            block.outptr(1)= block.opar(1);
    end
endfunction    
