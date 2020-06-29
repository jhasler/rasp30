function block=vmm_c(block,flag)
    if flag==1 then
        colsum_1=0;
        idx=1;
        idx1=1;
        for j=1:block.nout
            block.outptr(j)=0;
            for k=1:block.nin
                colsum_1= (block.rpar(idx)* block.inptr(k))+ colsum_1;
                 idx=idx+1;
            end  
            block.outptr(1)(1)=block.nout;
            idx1=idx1+1;
            colsum_1=0;
        end
    end
endfunction    
