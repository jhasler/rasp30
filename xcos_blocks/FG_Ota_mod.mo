class FG_Ota_mod "FG OTA"
  parameter Real K=0.65 "kappa";
  parameter Real UT=0.0258 "Thermal Voltage";
  parameter Real Vdd=2.5 "Supply";
  parameter Real Ibias=100e-9 "Bias current";
  parameter Real Vfgp0=1 "Offset voltage";
  parameter Real Vfgn0=1"Offset voltage" ;
  parameter Real C1=100e-15;
  parameter Real Cw=60e-15;
  parameter Real Cov=25e-15;
  parameter Real Cox=20e-15;
    parameter Real sig=5.891e-2 "sigma";
  
  Pin in_p "Positive pin of the input port";
  Pin in_n "Negative pin of the input port";
  Pin out "Output pin";
      
    Real V1;
    Real V2;
    Real I1;
    Real I2;
    Real Iout;
    Real Vout;
    Real CT;
    Real Vfgp;
    Real Vfgn;
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
  CT=C1+Cw+Cov+(Cox*(1-K));
 Vfgp=((C1/CT)*V1) + Vfgp0;
 Vfgn=((C1/CT)*V2)+Vfgn0 ;
   //Ioffp=0.699999e-9;
   //Ioffn=-49.999998894e-9;
   //Voffp=-0.000000000001;
     // Voffp=-0.35;
   //Voffn=-0.00000001;
//Vfgp=V1;
//Vfgn=V2;
Ioffp=0;Ioffn=0;Voffp=0;Voffn=0;

  I1=Ibias*(0.5+0.5*tanh((K/(2*UT))*(Vfgp-Vfgn))+Voffp)+Ioffp;
  I2=Ibias*(0.5-0.5*tanh((K/(2*UT))*(Vfgp-Vfgn))+Voffn)+Ioffn;
 
  //Iout=-I1*(1-exp(-(Vdd-Vout)/UT))+I2*(1-exp(-Vout/UT));
    Iout=(-I1*(exp(-sig*Vout/UT))*(1-exp(-(Vdd-Vout)/UT)))+(I2*(exp(-sig*(Vdd-Vout)/UT))*(1-exp(-Vout/UT)));
  
  
  
end FG_Ota_mod;
