//  Xcos
//
//  Copyright (C) INRIA - METALAU Project <scicos@inria.fr>
//  Copyright 2011 - Bernard DUJARDIN <bernard.dujardin@contrib.scilab.org>
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

function [x,y,typ] = div_by_n(job,arg1,arg2)
x=[];y=[];typ=[];
select job
 case 'plot' then
  graphics=arg1.graphics;
  ierr=execstr('(evstr(graphics.exprs(3))==1)','errcatch')
  if ierr<>0 then graphics.exprs(3)='1';end
  if (evstr(graphics.exprs(3))==1) then
  from=graphics.exprs(1)
  to=graphics.exprs(2)
  else
  from=graphics.exprs(2)
  to=graphics.exprs(1)
  end
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
    [ok,nofinputs,divN,rule,exprs]=scicos_getvalue([msprintf(gettext("Set %s block parameters"), "Counter"); " "; ..
        gettext("Div by N Clock Generator");" "], ..
        [gettext("no OF OUTPUTS"); gettext("divNum"); ..
          gettext("Rule (1:Increment, 2:Decrement)");], ..
        list('vec',1,'vec',1,'vec',1),exprs);

    if ~ok then break,end
    divN=int(divN);nofinputs=int(nofinputs);

    if divN < nofinputs then
        block_parameter_error(msprintf(gettext("Wrong values for ''divNum'' and ''nofinputsum'' parameters: %d &lt; %d"), nofinputs, divN), ..
            msprintf(gettext("''Minimum'' must be less than ''divNum''.")));
    elseif (rule <> 1 & rule <> 2) then
        block_parameter_error(msprintf(gettext("Wrong value for ''Rule'' parameter: %d"), rule), ..
            msprintf(gettext("Must be in the interval %s."), "[1,2]"));
    else
      graphics.exprs=exprs
      model.dstate=0
      model.ipar=[rule;divN;nofinputs]
      x.graphics=graphics;x.model=model
      break
    end
  end
case 'define' then
  nofinputs=2
  in=2
  divN=2
  rule=1
  model=scicos_model()
  model.sim=list('div_func',5)
  //model.evtin=1
  model.in=-[1:in]'
  model.intyp=-ones(in,1)
  model.out=-[1:nofinputs]'
  model.outtyp=-ones(nofinputs,1)
  //model.dstate=0
  model.rpar=divN;
  model.ipar=[rule;divN;nofinputs]
  model.blocktype='c'
  model.dep_ut=[%t %f]

  exprs=[string(nofinputs);string(divN);string(rule)]
  gr_i=['text=[''Clk'';'' Reset''];';'xstringb(orig(1),orig(2),text,sz(1),sz(2),''fill'');']
  x=standard_define([11 10],model,exprs,gr_i)
end
endfunction
