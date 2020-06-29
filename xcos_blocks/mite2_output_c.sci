function block=mite2_output_c(block,flag)
    if flag==1

        block.outptr(1) = block.inptr(1)

    end
endfunction    
