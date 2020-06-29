function block=dc_in_c(block,flag)
    if flag==1 then    
        j = 1:block.ipar(1)
        block.outptr(1)(j)=block.rpar(j);
    end
endfunction    
