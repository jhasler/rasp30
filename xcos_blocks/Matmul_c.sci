global Ut_sim Kappa_sim;
function block=Matmul_c(block,flag)
 if flag==1 then    
        m=4;
        block.outptr(1)(1:m) = block.x(1:m)
    elseif flag==0
        m=4; 
        kap = 0.75;
        Ut = 0.0258;
        C_T = 100e-15;
        Cg = 22e-15;
        VL=1;
        C=10e-12;
        

Vref=block.inptr(2)(1);
        
        block.xd(1)=(block.rpar(17).*tanh(block.inptr(1)(1)-Vref/VL)-(block.rpar(1).*tanh(block.x(1)-Vref/VL) +block.rpar(2).*tanh(block.x(2)-Vref/VL) + block.rpar(3).*tanh(block.x(3)-Vref/VL)+block.rpar(4).*tanh(block.x(4)-Vref/VL) ))/C;
	block.xd(2)=(block.rpar(18).*tanh(block.inptr(1)(1)-Vref/VL)-(block.rpar(5).*tanh(block.x(1)-Vref/VL)+block.rpar(6).*tanh(block.x(2)-Vref/VL)+block.rpar(7).*tanh(block.x(3)-Vref/VL)+block.rpar(8).*tanh(block.x(4)-Vref/VL)))/C;
        block.xd(3)=(block.rpar(19).*tanh(block.inptr(1)(1)-Vref/VL)-(block.rpar(9).*tanh(block.x(1)-Vref/VL)+block.rpar(10).*tanh(block.x(2)-Vref/VL)+block.rpar(11).*tanh(block.x(3)-Vref/VL)+block.rpar(12).*tanh(block.x(4)-Vref/VL)))/C;
        block.xd(4)=(block.rpar(20).*tanh(block.inptr(1)(1)-Vref/VL)-(block.rpar(13).*tanh(block.x(1)-Vref/VL)+block.rpar(14).*tanh(block.x(2)-Vref/VL)+block.rpar(15).*tanh(block.x(3)-Vref/VL)+block.rpar(16).*tanh(block.x(4)-Vref/VL)))/C;
        
        
        
        end
endfunction    

