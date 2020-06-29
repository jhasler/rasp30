global Ut_sim Kappa_sim;

function block=VolDivide1_c(block,flag)
    if flag ==1
        in_out_num = block.ipar(1);
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        Vdc1=1.5;
        block.outptr(1)(row_vec_io)=(block.inptr(1)(row_vec_io)-Vdc1)*block.rpar(4)/block.rpar(1)+Vdc1;
    end
endfunction
