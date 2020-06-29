class MITE_mod "MITE" 
  parameter Real K=0.7 "kappa";
  parameter Real UT=25.0e-3 "Thermal Voltage";
  parameter Real Ith=5e-8"Current";
  parameter Real Vdd=2.5 "Supply";
  parameter Real sig=5e-3 "Sigma";
  parameter Real VT0=0.5 "Threshold Voltage";
  parameter Real Vfg_programmed=0.5 "Programmed FG Voltage";
  parameter Real Cw=60e-15;
  parameter Real Cov=15e-15;
  parameter Real Cox=25e-15;

  Pin D "Drain";
  Pin G0 "Floating Gate0";
  Pin G1 "Floating Gate1";
  Pin S "Source";
  Pin B "Bulk";


Real id;
Real Vs;
Real Vd;
Real Vb;
Real Vfg0;
Real Vfg1;
Real Vfg;
Real CT;
Real cx,cy,cz;

  
equation 
  
   G0.v=Vfg0;
   G1.v=Vfg1;
   S.v=Vs;
   D.v=Vd;
   B.v=Vb;
   
   /* For MITE block ,
   cx=160.468e-15;cy=25.4783e-15;cz=25.4783e-15;
   */
   
   cx=160.468e-15;
   cy=25.4783e-15;
   cz=25.4783e-15;
   
   CT=cx+cy+cz+Cw+Cov+(Cox*(1-K));
   
   Vfg= ((cx/CT)*Vfg0) + ((cy/CT)*Vfg1)+ ((cz/CT)*0.6)+ ((Cov/CT)*Vd) + ((Cw/CT)*Vdd) +Vfg_programmed;

   
   //EKV equation
   id=  (Ith* (log(1+ exp((K*(Vb-Vfg-VT0)-(Vb-Vd)+sig*(Vb-Vs))/(2*UT))))^2) -(Ith* (log(1+ exp((K*(Vb-Vfg-VT0)-(Vb-Vs)+sig*(Vb-Vd))/(2*UT))))^2 );
   
   
   D.i=id;
   B.i=0;
   G0.i=0;
   G1.i=0;
   S.i=-D.i;
   

end MITE_mod;
