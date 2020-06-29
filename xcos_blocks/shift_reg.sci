function [x,y,typ]=shift_reg(job,arg1,arg2)
// Copyright INRIA
x=[];y=[];typ=[];
select job
case 'plot' then
  standard_draw(arg1)
case 'getinputs' then
  [x,y,typ]=standard_inputs(arg1)
case 'getoutputs' then
  [x,y,typ]=standard_outputs(arg1)
case 'getorigin' then
  [x,y]=standard_origin(arg1)
case 'set' then
  x=arg1;
  graphics=arg1.graphics;exprs=graphics.exprs
  model=arg1.model;
  while %t do
    [ok,in,exprs]=getvalue('Set shift register block parameters',..
	'Number of input ports or vector of sizes',list('vec',-1),exprs)
    if ~ok then break,end
    if size(in,'*')==1 then
      if in<1|in>31 then
	message('Block must have at least one input port and at most 31')
	ok=%f
      else
        it=-ones(in,1)
        ot=-1
        inp=[-[1:in]',ones(in,1)]
        oup=[0,1]
        [model,graphics,ok]=set_io(model,graphics,...
                                 list(inp,it),...
                                 list(oup,ot),[],[])
      end
    else
      if size(in,'*')==0| or(in==0)|size(in,'*')>31 then
	message(['Block must have at least one input port';
		 'and at most 31. Size 0 is not allowed. '])
	ok=%f
      else
	if min(in)<0 then nout=0,else nout=sum(in),end
        it=-ones(size(in,'*'),1)
        ot=-1
        inp=[in(:),ones(size(in,'*'),1)]
        oup=[nout,1]
        [model,graphics,ok]=set_io(model,graphics,...
                                 list(inp,it),...
                                 list(oup,ot),[],[])
      end
    end
    if ok then
      graphics.exprs=exprs;
      x.graphics=graphics;x.model=model
      break
    end
  end
 case 'define' then
  in=8
  model=scicos_model()
  model.sim=list('multiplex',4)
  model.in=-[1:in]'
  model.intyp=-ones(in,1)
  model.out=0
  model.outtyp=-1
  model.blocktype='c'
  model.dep_ut=[%t %f]

  exprs=string(in)
  gr_i=['txt=[''LPF''];'
        'style=5;'
        'rectstr=stringbox(txt,orig(1),orig(2),0,style,1);'
        'if ~exists(''%zoom'') then %zoom=1, end;'
        'w=(rectstr(1,3)-rectstr(1,2))*%zoom;'
        'h=(rectstr(2,2)-rectstr(2,4))*%zoom;'
        'xstringb(orig(1)+sz(1)/2-w/2,orig(2)-h-4,txt,w,h,''fill'');'
        'e=gce();'
        'e.font_style=style;']
  x=standard_define([10 5],model,exprs,gr_i)
end
endfunction
