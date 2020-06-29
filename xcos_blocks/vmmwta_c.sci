function block=vmm_wta_c(block,flag)
    if flag==1
        m=block.ipar(1)
        block.outptr(1)(1:m) = block.x(2*m+2:3*m+1)
         
    elseif flag==0
        m=block.ipar(1) //number of outputs-column dimension of FG Weights
        
        block.xd(1:m)=(1/block.rpar(1))*(-block.x(1:m)+ 2*(1 + (block.rpar(5)^2)*(block.inptr(1)'*block.inptr(1))*ones(block.ipar(1),1))+(sinh(block.rpar(5)*block.inptr(1))'*block.opar(1))'/block.ipar(2))
        
        block.xd(m+1:2*m)=(1/block.rpar(2))*(block.x(1:m) .* block.x(m+1:2*m)-(block.x(2*m+1)*(block.x(m+1:2*m)-0.0001)))
        
        block.xd(2*m+1)=(1/block.rpar(3))*(sum(block.x(m+1:2*m))-block.x(2*m+1))
         
        block.xd(2*m+2:3*m+1)=(0.0256/block.rpar(4))*(1- exp(-(1-block.x(2*m+2:3*m+1))/0.0256) - block.x(m+1:2*m) .* (1 - exp(-(block.x(2*m+2:3*m+1))/0.0256)) )        
       
    end
endfunction    
