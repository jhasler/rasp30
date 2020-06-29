function [x,y,typ]=mmap_local_swc(job,arg1,arg2)
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
        graphics=arg1.graphics;
        model=arg1.model;
        exprs=graphics.exprs;
        while %t do
            [ok,in_out_num,fix_loc,row_num,cal_bias,exprs]=scicos_getvalue('nfet_i2v parameters',['No. of In/Out';'Fix_location';'row number for cal';'calibration bias'],list('vec',1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end

            if ok then
                model.in=[in_out_num;in_out_num;in_out_num];
                model.out=[-1;-1;-1;-1];
                model.ipar=in_out_num;
                model.rpar= [fix_loc',row_num,cal_bias];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end

        end
    case 'define' then
        in_out_num=1;
        row_num=1;
        cal_bias=50e-9;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.in=[in_out_num;in_out_num;in_out_num];
        model.in2=[-1;-1;-1];
        model.out=[-1;-1;-1;-1];
        model.out2=[1;1;1;1];
        model.outtyp=[-1;-1;-1;-1];
        model.ipar=in_out_num;
        model.rpar= [fix_loc',row_num,cal_bias];
        model.state=zeros(1,1);
        model.blocktype='d';
        model.dep_ut=[%t %f];

        exprs=[sci2exp(in_out_num);sci2exp(fix_loc);sci2exp(row_num);sci2exp(cal_bias)];
        gr_i=['txt='' mmap_local_swc'';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([8 3],model, exprs,gr_i);
    end
endfunction
