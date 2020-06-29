global Ut_sim Kappa_sim Sigma_sim;

function block=common_source_c(block,flag)
    if flag ==1
        in_out_num = block.ipar(1);
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        Vdc1=1.5;
        Vdc2=1.5;
        block.outptr(1)(row_vec_io)=-Kappa_sim/Sigma_sim*(block.inptr(1)(row_vec_io)-Vdc1)+Vdc2;
    end
endfunction
