global Ut_sim Kappa_sim;

function block=lpfota_c(block,flag)
    if flag ==1
        in_out_num = block.ipar(1); //Vectorized
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        block.outptr(1)(row_vec_io)=block.x(row_vec_io); //Output
    elseif flag ==0
        in_out_num = block.ipar(1);
        row_vec_io = 1:in_out_num;  // Row vector for input & output 
        C = 5e-12;
        tau=1 ./(2*%pi*block.rpar(row_vec_io));
        Ibias= (2*C*Ut_sim)./(Kappa_sim*tau);
        block.xd(row_vec_io)=(Ibias/C).*tanh((Kappa_sim*(block.inptr(1)(row_vec_io)-block.x(row_vec_io)))/(2*Ut_sim));
    end
endfunction
