function [x,y,typ]=cap(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,num_of_blk,mblif_num,capt,fix_loc,exprs]=getvalue('Capacitance parameters', ['No. of cap';'Macro-blif Number';'Capacitance [1-7X][1=64fF and 6=448fF]';'Fix_location'],list('vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                model.ipar=[num_of_blk,mblif_num];
                model.rpar=[capt,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
        capt=1;
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('ota_func',5);
        model.in=[-1;];
        model.in2=[-1;];
        model.intyp=[-1;]; 
        model.out=[-1;];
        model.out2=[-1;];
        model.outtyp=[-1;];
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[capt,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%t %f];

        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);string(capt);sci2exp(fix_loc)]
        gr_i=['txt=[''ota''];';'style=5;';'rectstr=stringbox(txt,orig(1),orig(2),0,style,1);';'if ~exists(''%zoom'') then %zoom=1, end;';'w=(rectstr(1,3)-rectstr(1,2))*%zoom;';'h=(rectstr(2,2)-rectstr(2,4))*%zoom;';'xstringb(orig(1)+sz(1)/2-w/2,orig(2)-h-4,txt,w,h,''fill'');';'e=gce();';'e.font_style=style;'];
        x=standard_define([4 2],model,exprs,gr_i);
    end
endfunction
