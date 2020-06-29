function block=div2_c(block,flag)
        if flag==1 then
           //for j=1:block.insz(1)
           j=1
                block.outptr(1)(j)=block.inptr(1)(j)/block.rpar(1);
           //end
      end
endfunction       
