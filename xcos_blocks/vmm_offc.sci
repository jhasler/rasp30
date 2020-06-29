function [x,y,typ]=vmm_offc(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,vmm_offc_w16n,vmm_offc_w26n,vmm_offc_w16p,vmm_offc_w26p,vmm_offc_w15n,vmm_offc_w25n,vmm_offc_w15p,vmm_offc_w25p,vmm_offc_w14n,vmm_offc_w24n,vmm_offc_w14p,vmm_offc_w24p,vmm_offc_w13n,vmm_offc_w23n,vmm_offc_w13p,vmm_offc_w23p,vmm_offc_w12n,vmm_offc_w22n,vmm_offc_w12p,vmm_offc_w22p,vmm_offc_w11n,vmm_offc_w21n,vmm_offc_w11p,vmm_offc_w21p,vmm_offc_o2_fgibias,vmm_offc_o1_fgibias,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'vmm_offc_w16n';'vmm_offc_w26n';'vmm_offc_w16p';'vmm_offc_w26p';'vmm_offc_w15n';'vmm_offc_w25n';'vmm_offc_w15p';'vmm_offc_w25p';'vmm_offc_w14n';'vmm_offc_w24n';'vmm_offc_w14p';'vmm_offc_w24p';'vmm_offc_w13n';'vmm_offc_w23n';'vmm_offc_w13p';'vmm_offc_w23p';'vmm_offc_w12n';'vmm_offc_w22n';'vmm_offc_w12p';'vmm_offc_w22p';'vmm_offc_w11n';'vmm_offc_w21n';'vmm_offc_w11p';'vmm_offc_w21p';'vmm_offc_o2_fgibias';'vmm_offc_o1_fgibias';'fix_loc'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[vmm_offc_w16n,vmm_offc_w26n,vmm_offc_w16p,vmm_offc_w26p,vmm_offc_w15n,vmm_offc_w25n,vmm_offc_w15p,vmm_offc_w25p,vmm_offc_w14n,vmm_offc_w24n,vmm_offc_w14p,vmm_offc_w24p,vmm_offc_w13n,vmm_offc_w23n,vmm_offc_w13p,vmm_offc_w23p,vmm_offc_w12n,vmm_offc_w22n,vmm_offc_w12p,vmm_offc_w22p,vmm_offc_w11n,vmm_offc_w21n,vmm_offc_w11p,vmm_offc_w21p,vmm_offc_o2_fgibias,vmm_offc_o1_fgibias,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        vmm_offc_off1_ibias=5e-9;
        vmm_offc_off2_ibias=5e-9;
        vmm_offc_w16n=50e-9;
        vmm_offc_w26n=50e-9;
        vmm_offc_w16p=50e-9;
        vmm_offc_w26p=50e-9;
        vmm_offc_w15n=50e-9;
        vmm_offc_w25n=50e-9;
        vmm_offc_w15p=50e-9;
        vmm_offc_w25p=50e-9;
        vmm_offc_w14n=50e-9;
        vmm_offc_w24n=50e-9;
        vmm_offc_w14p=50e-9;
        vmm_offc_w24p=50e-9;
        vmm_offc_w13n=50e-9;
        vmm_offc_w23n=50e-9;
        vmm_offc_w13p=50e-9;
        vmm_offc_w23p=50e-9;
        vmm_offc_w12n=50e-9;
        vmm_offc_w22n=50e-9;
        vmm_offc_w12p=50e-9;
        vmm_offc_w22p=50e-9;
        vmm_offc_w11n=50e-9;
        vmm_offc_w21n=50e-9;
        vmm_offc_w11p=50e-9;
        vmm_offc_w21p=50e-9;
        vmm_offc_o2_fgibias=2e-6;
        vmm_offc_o2_pbias=50e-9;
        vmm_offc_o2_nbias=50e-9;
        vmm_offc_o1_fgibias=2e-6;
        vmm_offc_o1_pbias=50e-9;
        vmm_offc_o1_nbias=50e-9;
        vmm_offc_o1_ibias=10e-6;
        vmm_offc_o2_ibias=10e-6;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('vmm_offc_c',5);
        model.in=[-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];
        model.in2=[-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];
        model.intyp=[-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1;-1];
        model.out=[-1;-1];
        model.out2=[-1;-1];
        model.outtyp=[-1;-1];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[vmm_offc_w16n,vmm_offc_w26n,vmm_offc_w16p,vmm_offc_w26p,vmm_offc_w15n,vmm_offc_w25n,vmm_offc_w15p,vmm_offc_w25p,vmm_offc_w14n,vmm_offc_w24n,vmm_offc_w14p,vmm_offc_w24p,vmm_offc_w13n,vmm_offc_w23n,vmm_offc_w13p,vmm_offc_w23p,vmm_offc_w12n,vmm_offc_w22n,vmm_offc_w12p,vmm_offc_w22p,vmm_offc_w11n,vmm_offc_w21n,vmm_offc_w11p,vmm_offc_w21p,vmm_offc_o2_fgibias,vmm_offc_o1_fgibias,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(vmm_offc_w16n);sci2exp(vmm_offc_w26n);sci2exp(vmm_offc_w16p);sci2exp(vmm_offc_w26p);sci2exp(vmm_offc_w15n);sci2exp(vmm_offc_w25n);sci2exp(vmm_offc_w15p);sci2exp(vmm_offc_w25p);sci2exp(vmm_offc_w14n);sci2exp(vmm_offc_w24n);sci2exp(vmm_offc_w14p);sci2exp(vmm_offc_w24p);sci2exp(vmm_offc_w13n);sci2exp(vmm_offc_w23n);sci2exp(vmm_offc_w13p);sci2exp(vmm_offc_w23p);sci2exp(vmm_offc_w12n);sci2exp(vmm_offc_w22n);sci2exp(vmm_offc_w12p);sci2exp(vmm_offc_w22p);sci2exp(vmm_offc_w11n);sci2exp(vmm_offc_w21n);sci2exp(vmm_offc_w11p);sci2exp(vmm_offc_w21p);sci2exp(vmm_offc_o2_fgibias);sci2exp(vmm_offc_o1_fgibias);sci2exp(fix_loc)];
        gr_i=['text=[''vmm_offc''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
