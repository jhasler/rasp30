function block=div_func(block,flag)
    if flag==1 then
        for j=1:block.outsz(1)
           block.outptr(1)(j)=block.inptr(1)(j)/block.ipar(2);
        end
      end
    endfunction
    
