//load "ota.sci"
//load "ota_func.sci"
//***********************************
//SCRIPT TO READ FROM MODEL FILE
//***********************************
cd /usr/lib/scicoslab-gtk-4.4.1/macros/scicos_blocks/cadsp/
//LOAD OBJECT FILE
load "expt1.cos";
disp("Hello World");
//disp(scs_m.objs(1).gui);
//COMPARE OBJECT NAME TO FIND CORRESP. NETLIST
if scs_m.objs(1).gui== "ota_new" then 
  disp("Hurray!"),..
  //OPEN FILE TO WRITE NETLIST
 fd_w= mopen ("./netlist.txt",'wt')
  //mputl(".INCLUDE fpaa_tech.sp",fd_w);
  mputl(".model ota",fd_w)
  mputl(".inputs vinp vinn",fd_w)
  mputl(".outputs vout",fd_w)
  mputl(".blackbox",fd_w)
  mputl(".end",fd_w)
  //mputl("Xota Vp vout vout OTA PARAMS: Ib=1e-6",fd_w);
  mclose(fd_w);
  disp("Done writing!")
  
  else disp("Bummer!"),..
  end
  //READ FROM WRITTEN FILE
  fd_2= mopen ("./netlist.txt",'rt')
  mgetl(fd_2);
  mclose(fd_2);
  disp("DOne reading!");
  j=1
  //CHECK FOR SCICOS LINK OBJECTS
  //global variable to store
  blk=zeros(1,(length(scs_m.objs)))
  no=length(scs_m.objs);
  for i =1:no,
  if ( length(scs_m.objs(i) )==8)  then 
    disp("Scicos_link block ",i);
  elseif ( length(scs_m.objs(i) )==1) then
  disp("deleted block",i);
  else
    disp ("Obj code ",i);
    blk(j)=i;
    j=j+1
    end,
    end;

  
