class FG_PFET_mod "FLOATING GATE PFET" 
  parameter Real K=0.7 "kappa";
  parameter Real UT=25.0e-3 "Thermal Voltage";
  parameter Real Ith=5e-8"Current";
  parameter Real Vdd=2.5 "Supply";
  parameter Real sig=5e-3 "Sigma";
  parameter Real VT0=0.5 "Threshold Voltage";
  parameter Real C1=256e-15;
  parameter Real Cw=60e-15;
  parameter Real Cov=15e-15;
  parameter Real Cox=25e-15;
  parameter Real Vfg0=0.1 "Initial Vfg Offset";

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
Real cx,cy,cz;

  
equation 
  
   G.v=Vg;
   S.v=Vs;
   D.v=Vd;
   B.v=Vb;
   
   /* For MITE block ,
   cx=160.468e-15;cy=25.4783e-15;cz=25.4783e-15;
   */
   
   cx=0;cz=0;cy=0;
   
   CT=cx+cy+cz+Cw+Cov+(Cox*(1-K))+C1;
   
   //Vfg= (Vfg0) + ((C1/CT)*Vg) + ((Cov/CT)*Vd) + ((Cw/CT)*Vdd);
   Vfg=(Vfg0);
   //EKV equation
   id=  (Ith* (log(1+ exp((K*(Vb-Vfg-VT0)-(Vb-Vd)+sig*(Vb-Vs))/(2*UT))))^2) -(Ith* (log(1+ exp((K*(Vb-Vfg-VT0)-(Vb-Vs)+sig*(Vb-Vd))/(2*UT))))^2 );
   
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
   

end FG_PFET_mod;
