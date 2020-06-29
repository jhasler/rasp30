global Ut_sim Kappa_sim;

function block=ota_buf_c(block,flag)
    if flag ==1
        in_out_num = block.ipar(1);
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        block.outptr(1)(row_vec_io)=block.inptr(1)(row_vec_io);
    end
endfunction
