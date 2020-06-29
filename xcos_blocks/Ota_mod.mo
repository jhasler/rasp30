class Ota_mod "OTA"
  parameter Real K=0.75 "kappa";
  parameter Real UT=0.0258 "Thermal Voltage";
  parameter Real Vdd=2.5 "Supply";
  parameter Real Ibias=110e-9 "Bias current";
  //parameter Real sig=15.75e-3 "sigma";
  parameter Real sig=1e-4 "sigma";
  //use vref=0.555V and above sigma for vout vin overlap with 100n_0.5vpad,
  
  Pin in_p "Positive pin of the input port";
  Pin in_n "Negative pin of the input port";
  Pin out "Output pin";
    
    Real V1;
    Real V2;
    Real I1;
    Real I2;
    Real Iout;
    Real Vout;
    Real Ioffp;
    Real Ioffn;
    Real Voffp;
    Real Voffn;
equation    

  in_p.i = 0;
  in_n.i = 0;
  V1=in_p.v ;
  V2=in_n.v;
  Vout=out.v;
  Iout=out.i;
   Ioffp=0;
   Ioffn=0;
   //Voffp=-0.000000000001;
//      Voffp=0.07999995;
Voffp=0;
   Voffn=0;
  I1=Ibias*(0.5+0.5*tanh((K/(2*UT))*(V1-V2))+Voffp)+Ioffp;
  I2=Ibias*(0.5-0.5*tanh((K/(2*UT))*(V1-V2))+Voffn)+Ioffn;
     //Iout=I1-I2;
     
//  Iout=-I1*(1-exp(-(Vdd-Vout)/UT))+I2*(1-exp(-Vout/UT));
    Iout=(-I1*(exp(-sig*Vout/UT))*(1-exp(-(Vdd-Vout)/UT)))+(I2*(exp(-sig*(Vdd-Vout)/UT))*(1-exp(-Vout/UT)));
   //Iout=I1+I2;
  //out.I=-Iout
  //Iout=(Ibias/2)*(1+tanh((K/2*UT)*(V1-V2)))*(1-exp(-(Vdd-Vout)/UT))-(Ibias/2)*(1-tanh((K/2*UT)*(V1-V2)))*(1-exp(-(Vout)/UT));
  //Iout=Ibias*(V1-V2);
  //Iout=I1-I2;
  //Iout=I1+I2;
  
  //Modelica.utilities.Streams.print(Vout)
  
  
    //Modelica.utilities.Streams.print(Vout)
  
  
end Ota_mod;
