class PMOS_ekv "Simple MOS Transistor" 
  parameter Real K=0.7 "kappa";
  parameter Real UT=25.0e-3 "Thermal Voltage";
  parameter Real Ith=1.0e-6 "Threshold Current";
  parameter Real sig=1e-4 "Sigma";
  parameter Real VT0=0.45 "Threshold Voltage";

  Pin D "Drain";
  Pin G "Gate";
  Pin S "Source";
  Pin B "Bulk";


Real id;
Real Vg;
Real Vs;
Real Vd;
Real Vb;

  
equation 
  
   G.v=Vg;
   S.v=Vs;
   D.v=Vd;
   B.v=Vb;
   // EKV equation
   //id= (Ith* (log(1+ exp((K*(Vb-Vg-VT0)-(Vb-Vs)+sig*(Vb-Vd))/2*UT)))^2 ) -  (Ith* (log(1+ exp((K*(Vb-Vg-VT0)-(Vb-Vd)+sig*(Vb-Vs))/2*UT)))^2);
      id= (Ith* (log(1+ exp((K*(Vg-VT0)-Vs+sig*Vd)/2*UT)))^2 ) -  (Ith* (log(1+ exp((K*(Vg-VT0)-Vd+sig*Vs)/2*UT)))^2);
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
   

end PMOS_ekv;
