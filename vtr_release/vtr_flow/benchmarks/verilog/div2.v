module  div2( reset, ip1, op1);
input ip1;
input reset;
output op1;
reg op1;
reg [2:0] ctr;

always @(posedge ip1)
begin
	if(reset)
		begin
			op1<=1'b0;
            		ctr<=3'b000;
		end
	else

		begin
        	    
       		     if(ctr==3'b111)
                	begin
			    op1<=!op1;
                	    ctr<=3'b000;
                	end
		else
			begin
			ctr<=ctr+1;
			end
             	end
        

		
end
endmodule
