function [x,y,typ]=vmm16x16_sr(job,arg1,arg2)
    // Copyright INRIA
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,in_out_num,fix_loc,weight_vec,exprs]=getvalue('Set VMM_16x16 Parameters',['Number of Outputs';'Fix_location(1/0,sr,vmm8x8)';'Weight vector name'],list('vec',1,'vec',-1,'str',1),exprs)

            if ~ok then break,end

            if ok then
                model.in=[1;1;1;1];
                model.out=[1;1;1;1];
                model.ipar=in_out_num;
                model.rpar= [fix_loc'];
                model.opar=list(weight_vec);
                graphics.exprs=exprs; x.graphics=graphics; x.model=model;
                break
            end
        end
    case 'define' then
        in_out_num =1;
        fix_loc=[0;0;0;0;0;0;0;0;0;0;0];
        weight_vec="weight16x16"
        model=scicos_model()
        model.in=[1;1;1;1]
        model.in2=[1;1;1;1]
        model.intyp=[-1;-1;-1;-1;]
        model.out=[1;1;1;1]
        model.out2=[1;1;1;1]
        model.outtyp=[-1;-1;-1;-1]
        model.ipar=in_out_num;
        model.rpar= [fix_loc'];
        model.opar=list(weight_vec);
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(in_out_num);sci2exp(fix_loc);weight_vec];
        gr_i=['txt=''vmm_16x16_sr'';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([7 3],model,exprs,gr_i);
    end
endfunction
