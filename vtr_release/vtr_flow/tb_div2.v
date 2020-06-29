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
        	    ctr<=ctr+1;
       		     if(ctr==3'b111)
                	begin
			    op1<=!op1;
                	    ctr<=3'b000;
                	end
             	end
        

		
end
endmodule
module test_div2;

reg clk=0;
reg resett;

wire op1;

initial
begin
#1 resett=1'b0;
#20 resett=1'b1;
#20 resett=1'b0;
end



always #5 clk=!clk;

div2 div_clk(.reset (resett),
	     .ip1    (clk),
	      .op1   (op1)
	 );

initial
 begin
    $dumpfile("test.vcd");
    $dumpvars(0,test_div2);
 end
 

endmodule

