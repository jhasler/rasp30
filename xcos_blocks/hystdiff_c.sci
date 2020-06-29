function block=hystdiff_c(block,flag)
    if flag==1
        in_out_num = block.ipar(1); //Vectorized
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        block.outptr(1)(row_vec_io)=block.x(row_vec_io); //Output
    elseif flag==0
        //variables and ODE
        block.xd(row_vec_io)= block.inptr(1)(row_vec_io)
    end
endfunction
