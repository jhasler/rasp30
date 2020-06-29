//  Scicos
//
//  Copyright (C) INRIA - METALAU Project <scicos@inria.fr>
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
//
// See the file ../license.txt
//

function [x,y,typ]=FG_Ota_mod(job,arg1,arg2)
x=[];y=[];typ=[];
select job
case 'plot' then
standard_draw(arg1,%f) 

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
    [ok,Ibias,Vfgp0,Vfgn0,C1,exprs]=scicos_getvalue('Set FG Ota parameters',..
	['Ibias [A]';
     'Vfgp0 [V]' ;
     'Vfgn0 [V]' ;
          'C1 [F]'; ..
	 ],      list('vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
	 
    if ~ok then break,end
    model.equations.parameters(2)=list(Ibias,Vfgp0,Vfgn0,C1)
    graphics.exprs=exprs
    x.graphics=graphics;x.model=model
    break
  end
case 'define' then
  model=scicos_model()
   
   
   Ibias=100e-9;
   Vfgp0=1;
   Vfgn0=1;
   C1=256e-15;
   
   
  model.sim='FG_Ota_mod'
  model.blocktype='c'
  model.dep_ut=[%t %f]
  mo=modelica()
  mo.model='FG_Ota_mod';
mo.inputs=['in_p';'in_n'];
  mo.outputs=['out'];
  mo.parameters=list(['Ibias';'Vfgp0';'Vfgn0';'C1'],[Ibias;Vfgp0;Vfgn0;C1])
  model.equations=mo
  model.in=ones(size(mo.inputs,'*'),1)
  model.out=ones(size(mo.outputs,'*'),1)
  exprs=[string(Ibias);string(Vfgp0);string(Vfgn0);string(C1)]
  gr_i=[' Thick=xget(''thickness'');xset(''thickness'',2);';
    'if orient then,'; 
        'x1=orig(1)+  [0, 15,15,15]*(sz(1)/32);';
		'x2=orig(1)+[17,17,19,19,32,19,19,17]*(sz(1)/32);';
		'x3=orig(1)+  [17,17,19,19,22, 22,27,32,27,22,22,19,19,17]*(sz(1)/32);';
		'x4=orig(1)+[17,17,19,19,32,19,19,17]*(sz(1)/32);';
    'else,';
        'x1=orig(1)+  [32, 17,17,17]*(sz(1)/32);';
		'x2=orig(1)+[15,15,13,13,0,13,13,15]*(sz(1)/32);';
		'x3=orig(1)+  [15,15,13,13,10, 10, 5, 0,05,10,10,13,13,15]*(sz(1)/32);';
		'x4=orig(1)+[15,15,13,13,0,13,13,15]*(sz(1)/32);';
    'end,'
	'y1=orig(2)+5+[27,27,48,27]*(sz(2)/70);';
	'y2=orig(2)+5+[48,40,40,44,44,44,48,48]*(sz(2)/70);';
	'y3=orig(2)+5+[30,23,23,27,27, 31,27,27,27,23,27,27,30,30]*(sz(2)/70);';
	'y4=orig(2)+5+[16,7,7, 11,11, 11, 16,16]*(sz(2)/70);';
	'xpoly(x1,y1);';
	'xpoly(x2,y2);';
	'xpoly(x3,y3);';
	'xpoly(x4,y4);';
 	'xset(''thickness'',Thick);'
	]
    
  x=standard_define([2 2],model,exprs,gr_i)
  x.graphics.in_implicit=['I';'I']
  x.graphics.out_implicit=['I']
end
endfunction


