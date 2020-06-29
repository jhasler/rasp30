DAC_numbers=5
m=12
h=12
count=12
h_bar=25

if DAC_numbers==0 | DAC_numbers==2 | DAC_numbers==4 | DAC_numbers==6 | DAC_numbers==8 then
if m<10 then
DAC_cal_table(count,1) =string(0)+h;    
end
if m>10 then
DAC_cal_table(count,1) =h;
end
end
if DAC_numbers==1 | DAC_numbers==3 | DAC_numbers==5 | DAC_numbers==7 | DAC_numbers==9 then
if m<10 then
DAC_cal_table(count,1) =string(0)+h_bar;    
end
if m>10 then
DAC_cal_table(count,1) =h_bar;   
end
end
