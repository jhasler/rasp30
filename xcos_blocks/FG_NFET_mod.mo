class FG_NFET_mod "FLOATING GATE NFET" 
  parameter Real K=0.7 "kappa";
  parameter Real UT=25.0e-3 "Thermal Voltage";
  parameter Real Ith=5e-8 "Current";
  parameter Real Vdd=0.25 "Supply";
  parameter Real sig=5e-2 "Sigma";
  parameter Real VT0=0.5 "Threshold Voltage";
  parameter Real C1=256e-15;
  parameter Real Cw=60e-15;
  parameter Real Cov=25e-15;
  parameter Real Cox=20e-15;
  parameter Real Vfg0=0.1 "Initial Vfg";

  Pin D "Drain";
  Pin G "Gate";
  Pin S "Source";
  Pin B "Bulk";


Real id;
Real Vg;
Real Vs;
Real Vd;
Real Vb;
Real Vfg;
Real CT;

  
equation 
  
   G.v=Vg;
   S.v=Vs;
   D.v=Vd;
   B.v=Vb;
   
   CT=C1+Cw+Cov+(Cox*(1-K));
   
   Vfg= (Vfg0) + ((C1/CT)*Vg) + ((Cov/CT)*Vs) + ((Cw/CT)*Vdd);

   //EKV equation
   id= (Ith* (log(1+ exp((K*(Vfg-VT0)-Vs+sig*Vd)/(2*UT))))^2 ) -  (Ith* (log(1+ exp((K*(Vfg-VT0)-Vd+sig*Vs)/(2*UT))))^2);
   
   /* if(Vg<VT0) then
        id= Ith * exp((K*(Vb-Vg-VT0)-(Vb-Vs)+sig*(Vb-Vd))/UT);
    else
        id=Ith * ((K*(Vb-Vg-VT0)-(Vb-Vs))^2 - (K*(Vb-Vg-VT0)-(Vb-Vd)^2));
        end if;   
        */   
   D.i=id;
   B.i=0;
   G.i=0;
   S.i=-D.i;
   

end FG_NFET_mod;
