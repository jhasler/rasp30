module  div_by_2( reset, ip1, op1);
//
//
//
input wire ip1;

input wire clk;

output reg op1;


always @(posedge ip1)
if(reset)
	begin
		op1<=1'b0;
	end
	else

		begin
			op1<= !op1;
		end


endmodule
