// Shift 2, 20th Jan
//vchar id i2vout adc
diode_ivdd25V=[
// 2.10 0.005e-9 0.688 hex2dec('0969');
 2.15 0.152e-9 0.985 hex2dec('0bea');
 2.18 1.573e-9 1.072 hex2dec('0de4');
 2.20 2.723e-9 1.105 hex2dec('14b1');
 2.25 11.83e-9 1.204 hex2dec('157e');
 2.30 13.41e-9 1.338 hex2dec('1760');
 2.35 62.54e-9 1.404 hex2dec('17ae');
 2.40 0.241e-6 1.508 hex2dec('1996');
 2.45 0.794e-6 1.609 hex2dec('1bd6');
 2.50 2.032e-6 1.705 hex2dec('1dec');
 2.55 4.459e-6 1.797 hex2dec('1ff4');
 2.60 8.370e-6 1.885 hex2dec('21dc');
 2.65 13.78e-6 1.968 hex2dec('239c');
 2.70 20.70e-6 2.047 hex2dec('2555');
 2.75 28.93e-6 2.124 hex2dec('26f1');
 2.80 37.38e-6 2.191 hex2dec('284a');
 2.85 48.66e-6 2.269 hex2dec('29ee');
 2.90 59.58e-6 2.334 hex2dec('2b46');
 2.95 72.19e-6 2.401 hex2dec('2cbb');
 3.00 83.11e-6 2.452 hex2dec('2e5e');
 3.05 94.05e-6 2.499 hex2dec('3141');
 3.10 105.2e-6 2.543 hex2dec('39f5');
// 3.15 101.8e-6 2.509 hex2dec('03c8');
];

//polyfit
//[p1,S1]=polyfit(diode_ivdd25V(:,4), log(diode_ivdd25V(:,2)),10);
[p1,S1]=polyfit(diode_ivdd25V(:,4), log(diode_ivdd25V(:,2)),5);
//[p_i2vout,S_i2vout]=polyfit(diode_ivdd25V(1:21,4), diode_ivdd25V(1:21,3),1);

// Eval
ADC_range_ivdd25V = hex2dec('0bea'):1:hex2dec('39f5');
diode_fit_ivdd25V = polyval(p1,ADC_range_ivdd25V,S1);
//i2vout_fit_ivdd25V = polyval(p_i2vout,ADC_range_ivdd25V,S_i2vout);
ADC_Current=[ADC_range_ivdd25V(:) exp(diode_fit_ivdd25V(:))];

ADC_Current_copy = ADC_Current;
ADC_Current_copy_size = size(ADC_Current_copy);
Current_to_ADC = [10E-06; 100E-09; 30E-09; 20E-09; 5E-09; 1E-09; 100E-12];
Current_to_ADC_size=size(Current_to_ADC);

for k=1:Current_to_ADC_size(1,1)
    ADC_Current_copy(:,3)=abs(ADC_Current_copy(:,2)-Current_to_ADC(k,1));
    min_value = min(ADC_Current_copy(:,3));
    for h=1:ADC_Current_copy_size(1,1)
        if ADC_Current_copy(h,3) == min_value then
            Current_to_ADC(k,2) = ADC_Current_copy(h,1);
        end
    end
end

//disp(Current_to_ADC)

//// Plot the data
//scf(1);
//clf(1);
//plot(diode_ivdd25V(:,4), log10(diode_ivdd25V(:,2)),"+");
//plot(ADC_range_ivdd25V, log10(exp(diode_fit_ivdd25V)),"g-")
//legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_upper_left");
//xtitle("","ADC data","Ichar(A)");
//
//scf(2);
//clf(2);
//plot(diode_ivdd25V(:,4), diode_ivdd25V(:,2),"+");
//plot(ADC_range_ivdd25V,exp(diode_fit_ivdd25V),"g-")
//legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_upper_left");
//xtitle("","ADC data","Ichar(A)");

//polyfit
//[p1_r,S1_r]=polyfit(log(diode_ivdd25V(:,2)), diode_ivdd25V(:,4),10);
//
//// Eval
//Current_range_ivdd25V = log(0.050e-9):0.001:log(108.3e-6);
//diode_fit_ivdd25V_r = polyval(p1_r,Current_range_ivdd25V,S1_r);

//// Plot the data
//scf(1);
//clf(1);
//plot(log10(diode_ivdd25V(:,2)), diode_ivdd25V(:,4),"+");
//plot(log10(exp(Current_range_ivdd25V)), diode_fit_ivdd25V_r,"g-")
//legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_upper_left");
//xtitle("","Ichar(A)","ADC data");
