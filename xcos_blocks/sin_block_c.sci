function block=sin_block_c(block,flag)
    if flag==1 then    
        t=scicos_time();
        j = 1:block.ipar(1)
        block.outptr(1)(j)=block.rpar(3*j-2).*sin(2*%pi*block.rpar(3*j-1)*t+block.rpar(3*j)*(%pi/180));
    end
endfunction
