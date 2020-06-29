module  div_by_2( reset, ip1, op1);
input ip1;
input clk;
output op1;
reg op1;

always @(posedge ip1)
begin
	if(reset)
		begin
			op1<=1'b0;
		end
	else

		begin
			op1<= !op1;
		end

end
endmodule
