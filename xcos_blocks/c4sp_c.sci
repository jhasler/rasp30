function block=c4_sp_c(block,flag)
    rr = 1:block.ipar(1)
    c2 = 160e-15 * ones(block.ipar(1),1)
    c1 = 64e-15 * block.rpar(7*rr)
    cw = 160e-15 * ones(block.ipar(1),1)
    cL = 600e-15 * ones(block.ipar(1),1)
    Ceq = ((cL+c2).*(c1+c2+cw)-c2^2)./c2
    Alpha =(c1./c2).*((cL+c2)./Ceq)
    Beta = c1./Ceq
    if flag==1
        block.outptr(1)(rr)=block.x(2*rr-1)+ Beta.*block.inptr(2)(rr); //Vout=Vouta+Beta*Vin
    elseif flag==0
        j=block.ipar(1)
        jj = 1:j
        kap = 0.75
        Ut = 0.258
        Vref = block.inptr(1)
        C_T = 100e-15
        Cg = 22e-15
        VL = (C_T*Ut)/(Cg*kap)
        freq_c=block.rpar'
        //tau1=1 ./(2*%pi *freq_c(1:j))
       // tau2=1 ./(2*%pi*freq_c(3*j+1:3*j+j))
       // Ibias1=(((c1+c2+cw).*(cL+c2)-c2^2)* 2*Ut)./(kap*tau1.*c2)
       // Ibias2=(2*c2*Ut)./(kap*tau2)
       Ibias1=freq_c(1:j)
       Ibias2=freq_c(3*j+1:3*j+j)
       // disp(Ibias2,'I2',Ibias1,'I1')
        I1 = Ibias1.*tanh((kap/(2*Ut))*(Vref-(block.x(2*jj)+Alpha.*block.inptr(2)(jj))))
        I2 = Ibias2.*tanh((1/VL)*(block.x(2*jj-1)-block.x(2*jj)-(Alpha-Beta).*block.inptr(2)(jj)))
        block.xd(2*jj-1)=(1 ./Ceq).*(I2+((c1+c2+cw)./c2).*I1); //Vouta
        block.xd(2*jj)=(1 ./Ceq).*(I1+((cL+c2)./c2).*I2); //V2 = V1-Alpha*Vin
    end
endfunction
