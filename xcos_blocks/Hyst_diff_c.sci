global Ut_sim Kappa_sim;
function block=Hyst_diff_c(block,flag)
    //disp(flag)
    if flag==1
        
in_out_num = block.ipar(1); //Vectorized
row_vec_io = 1:in_out_num;  // Row vector for input & output 

        block.outptr(1)(row_vec_io)=block.x(2*row_vec_io); //Output
      
    elseif flag==0
        
in_out_num = block.ipar(1); //Vectorized
row_vec_io = 1:in_out_num;  // Row vector for input & output 
        Cout=1e-12;
        C=100e-15; 
        Ibias=block.rpar(row_vec_io)
      
      
              block.xd(2*row_vec_io)=(Ibias./Cout).*tanh((Kappa_sim*(block.inptr(1)(row_vec_io)- block.x(2*row_vec_io-1)))/(2*Ut_sim));
//OTA computation        
Ioffp=0;
Ioffn=0;
Voffp=0;
Voffn=0;
V1=block.inptr(1)(row_vec_io);
V2=block.x(2*row_vec_io-1)
m_tanh=tanh((Kappa_sim/(2*Ut_sim))*(V1-V2))
I1=Ibias*(0.5+0.5*m_tanh+Voffp)+Ioffp;
I2=Ibias*(0.5-0.5*m_tanh+Voffn)+Ioffn;

 sig=1e-4;
 Vdd=2.5
Iout=(-I1*(exp(-sig*block.x(2*row_vec_io) /Ut_sim))*(1-exp(-(Vdd-block.x(2*row_vec_io) )/Ut_sim)))+(I2*(exp(-sig*(Vdd-block.x(2*row_vec_io))/Ut_sim))*(1-exp(-block.x(2*row_vec_io)/Ut_sim)));
//
//disp(Iout)
block.xd(2*row_vec_io) =- Iout/Cout;        
//      
      
      
      
      
      
      
      
        Isatn=53.58e-9;
        Isatp=110e-9;
      sigma=5e-2
      Vtp=0.866;
      Vtn= 0.313;
        Inmos=Isatn * log(1 + exp((Kappa_sim*(block.x(2*row_vec_io)-Vtn) - block.x(2*row_vec_io-1) + sigma*2.5)/Ut_sim ))^2 -  Isatn * log(1 + exp((Kappa_sim*(block.x(2*row_vec_io)-Vtn) + sigma*block.x(2*row_vec_io-1) - 2.5)/Ut_sim ))^2
        Ipmos=Isatp * log(1 + exp((Kappa_sim*(2.5 - block.x(2*row_vec_io)-Vtp) - (2.5 - block.x(2*row_vec_io-1)) + sigma*2.5)/Ut_sim ))^2 -Isatp * log(1 + exp((Kappa_sim*(2.5 - block.x(2*row_vec_io)-Vtp) +sigma* (2.5 - block.x(2*row_vec_io-1)) - 2.5)/Ut_sim ))^2
       
  Iout1=Inmos - Ipmos;

block.xd(2*row_vec_io-1)=Iout1./C;//Vc of the hyst diff





    end
endfunction
