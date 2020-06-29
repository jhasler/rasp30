class NMOS_mod "Simple MOS Transistor" 
  parameter Real K=0.7 "kappa";
  parameter Real UT=25.0e-3 "Thermal Voltage";
  parameter Real Ith=1.0e-6 "Current";
  parameter Real Vdd=2.5 "Supply";
  parameter Real sig=1.43 "Sigma";
  parameter Real VT0=0.5 "Threshold Voltage";

  Pin D "Drain";
  Pin G "Gate";
  Pin S "Source";
  Pin B "Bulk";


Real id;
Real Vg;
Real Vs;
Real Vd;

  
equation 
  
   G.v=Vg;
   S.v=Vs;
   D.v=Vd;
   //EKV equation
   id= (Ith* (log(1+ exp((K*(Vg-VT0)-Vs+sig*Vd)/(2*UT))))^2 ) -  (Ith* (log(1+ exp((K*(Vg-VT0)-Vd+sig*Vs)/(2*UT))))^2);
     /* if(Vg<VT0) then
        id= Ith * exp((K*(Vg-VT0)-Vs+sig*Vd)/UT);
    else
        id=Ith * ((K*(Vg-VT0)-Vs)^2 - (K*(Vg-VT0)-Vd)^2);
        end if;   
        */
   D.i=id;
   B.i=0;
   G.i=0;
   S.i=-D.i;
   

end NMOS_mod;
