function block=ota_c(block,flag)
if flag==1
block.outptr(1)=block.x(1)
elseif flag==0
block.xd(1)=tanh((block.inptr(1)(1)-block.x(1)))/block.rpar;
end
endfunction       
