module  div_by_2( reset, ip1, op1);
input ip1;
input reset;
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
module  div_by_2_2( reset1, ip11, op11);
input ip11;
input reset1;
output op11;
reg op11;

always @(posedge ip11)
begin
	if(reset1)
		begin
			op11<=1'b0;
		end
	else

		begin
			op11<= !op11;
		end

end
endmodule
module  div_by_2_1( reset2, ip12, op12);
input ip12;
input reset2;
output op12;
reg op12;

always @(posedge ip12)
begin
	if(reset2)
		begin
			op12<=1'b0;
		end
	else

		begin
			op12<= !op12;
		end

end
endmodule
