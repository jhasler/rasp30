function [x,y,typ]=hhn_debug(job,arg1,arg2)
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
            [ok, in_out_num, hhn_debug_fgswc_ibias, hhn_debug_fgota1_ibias, hhn_debug_fgota1_pbias, hhn_debug_fgota1_nbias, hhn_debug_fgota0_ibias, hhn_debug_fgota0_pbias, hhn_debug_fgota0_nbias, hhn_debug_ota0_ibias, hhn_debug_ota1_ibias, hhn_debug_cap0, fix_loc,exprs]=scicos_getvalue('New Block Parameter',['number of blocks'; 'hhn_debug_fgswc_ibias'; 'hhn_debug_fgota1_ibias'; 'hhn_debug_fgota1_pbias'; 'hhn_debug_fgota1_nbias'; 'hhn_debug_fgota0_ibias'; 'hhn_debug_fgota0_pbias'; 'hhn_debug_fgota0_nbias'; 'hhn_debug_ota0_ibias'; 'hhn_debug_ota1_ibias'; 'hhn_debug_cap0_64fF_x_1to7';'Fix_location'],list('vec',-1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1, 'vec', -1,'vec',-1),exprs)
            
            if ~ok then break,end
            if ok then
                model.ipar=in_out_num
                model.rpar=[hhn_debug_fgswc_ibias hhn_debug_fgota1_ibias hhn_debug_fgota1_pbias hhn_debug_fgota1_nbias hhn_debug_fgota0_ibias hhn_debug_fgota0_pbias hhn_debug_fgota0_nbias hhn_debug_ota0_ibias hhn_debug_ota1_ibias hhn_debug_cap0 ,fix_loc']
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        in_out_num=1
        hhn_debug_fgswc_ibias=[50e-9];
        hhn_debug_fgota1_ibias=[2e-6];
        hhn_debug_fgota1_pbias=[2e-6];
        hhn_debug_fgota1_nbias=[2e-6];
        hhn_debug_fgota0_ibias=[2e-6];
        hhn_debug_fgota0_pbias=[2e-6];
        hhn_debug_fgota0_nbias=[2e-6];
        hhn_debug_ota0_ibias=2e-6;
        hhn_debug_ota1_ibias=2e-6;
        hhn_debug_cap0=[1];
        fix_loc=[0;0;0]
        model=scicos_model()
        model.sim=list('hhn_debug_c',5)
        model.in=[-1;-1;-1;-1;]
        model.in2=[-1;-1;-1;-1;]
        model.intyp=[-1;-1;-1;-1;]
        model.out=[-1;-1;-1;]
        model.out2=[-1;-1;-1;]
        model.outtyp=[-1;-1;-1;]
        model.ipar=in_out_num
        //model.state=zeros(1,1)
        model.rpar=[hhn_debug_fgswc_ibias hhn_debug_fgota1_ibias hhn_debug_fgota1_pbias hhn_debug_fgota1_nbias hhn_debug_fgota0_ibias hhn_debug_fgota0_pbias hhn_debug_fgota0_nbias hhn_debug_ota0_ibias hhn_debug_ota1_ibias hhn_debug_cap0 ,fix_loc']
        model.blocktype='d'
        model.dep_ut=[%f %t] //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(in_out_num);sci2exp(hhn_debug_fgswc_ibias);sci2exp(hhn_debug_fgota1_ibias);sci2exp(hhn_debug_fgota1_pbias);sci2exp(hhn_debug_fgota1_nbias);sci2exp(hhn_debug_fgota0_ibias);sci2exp(hhn_debug_fgota0_pbias);sci2exp(hhn_debug_fgota0_nbias);sci2exp(hhn_debug_ota0_ibias);sci2exp(hhn_debug_ota1_ibias);sci2exp(hhn_debug_cap0);sci2exp(fix_loc)]
        gr_i=['txt=[''hhn_debug''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 2],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
