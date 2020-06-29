function [x,y,typ]=nmirror(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; model=arg1.model; exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,fix_loc,exprs]=scicos_getvalue('N-mirror',['No. of Nmirrors';'Macro-blif Number';'Fix_location'],list('vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar= [fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.in=[-1];
        model.in2=[-1];
        model.intyp=[-1]; 
        model.out=[-1;];
        model.out2=[-1;];
        model.outtyp=[-1;];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar= [fix_loc'];
        model.state=zeros(1,1);
        model.blocktype='d';
        model.dep_ut=[%t %t];

        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(fix_loc)];
        gr_i=['txt='' Blank '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([5 2],model, exprs,gr_i); //Numbers define the width and height of block
    end
endfunction
