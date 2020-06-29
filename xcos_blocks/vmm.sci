function [x,y,typ]=vmm(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
   case 'getinputs' then //** GET INPUTS 
    [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then
    [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then
    [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1.graphics
  model=arg1.model
  exprs=graphics.exprs
  while %t do
    [ok,ipsize,Wts,exprs]=scicos_getvalue('Set VMM Block',['Input Dimension';'Weight MAtrix'],list('vec',-1,'vec',-1),exprs)

    if ~ok then break,end
    nout=[size(ipsize,1) size(Wts,2)];
    nin=size(ipsize);
    if find(nout==0)<>[] then
        block_parameter_error(msprintf(gettext("Wrong size for ''%s'' parameter"), gettext("Constant Value")), gettext("Constant value must have at least one element."));
     elseif(size(Wts,1)~= size(ipsize,2)) then
          block_parameter_error(msprintf(gettext("Wrong size %s"), gettext("Weight MAtrix")), gettext("Wts row must be equal to Input vector column size"));
    else
	model.sim=list('vmm_c',5)
	model.opar=list(Wts)
	if (type(Wts)==1) then
		 if isreal(Wts) then
      		     ot=1
                 it=1
		 else
		     ot=2
             it=2
		 end
	elseif (typeof(Wts)=="int32") then
	 ot=3
	elseif (typeof(Wts)=="int16") then
	ot=4
	elseif (typeof(Wts)=="int8") then
	ot=5
	elseif (typeof(Wts)=="uint32") then
	ot=6
	elseif (typeof(Wts)=="uint16") then
	ot=7
	elseif (typeof(Wts)=="uint8") then
	ot=8
	else
      block_parameter_error(msprintf(gettext("Wrong type for ''%s'' parameter"), gettext("Constant Value")), ..
          gettext("Value type must be a numeric type (double, complex, int, int8, ...)."));
//ok=%f;
	end

	if ok then
	   model.rpar=[]
	   [model,graphics,ok]=set_io(model,graphics,list(nin,it),list(nout,ot),[],[])
      	    graphics.exprs=exprs;
            x.graphics=graphics;x.model=model
            break;
	end
    end
  end
case 'define' then
  Wts=[1 0; 0 1]
  ipsize=[1 1]
  model=scicos_model()
  model.sim=list('vmm_c',5)
  model.in=size(ipsize,1)
  model.out=size(Wts,1)
  model.in2=size(ipsize,2)
  model.out2=size(Wts,2)
  model.rpar=Wts
  model.opar=list()
  model.blocktype='d'
  model.dep_ut=[%t %f]
  
  exprs=[sci2exp(ipsize) ;sci2exp(Wts)]
  gr_i=['txt='' VMM '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
  x=standard_define([2 3],model, exprs,gr_i)
end
endfunction
