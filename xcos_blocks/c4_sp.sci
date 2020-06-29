function [x,y,typ]=c4_sp(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1);
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1);
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1);
    case 'getorigin' then [x,y]=standard_origin(arg1);
    case 'set' then
        x=arg1; graphics=arg1.graphics; exprs=graphics.exprs; model=arg1.model;
        while %t do
            [ok,in_out_num,gbias,gbiasn,gbiasp,fbias,fbiasn,fbiasp,cap1,exprs]=getvalue('Set C4 Parameters',['Number of C4 blocks';'Gain Bias';'Gain bias n';'Gain bias p'; 'Feedback Bias';'Feedback Bias n';'Feedback Bias p'; 'Input Cap 64fF [1-6X]'],list('vec',1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)
            if ~ok then break,end
            if length(cap1) ~= in_out_num then message('The number of cap values that you have entered does not match the number of C4 blocks.'); ok=%f; end

            for ss= 1:in_out_num
                if (cap1(ss) == 0) | (cap1(ss) > 6) then message('One of the cap values that you have entered is not a number 1-6.'); ok=%f; end
            end

            if length(gbiasn) ~= in_out_num then message('The number of gain biasn that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if length(gbiasp) ~= in_out_num then message('The number of gain biasp that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if length(gbias) ~= in_out_num then message('The number of gain biases that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if length(fbias) ~= in_out_num then message('The number of feedback  biases that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if length(fbiasn) ~= in_out_num then message('The number of feedback  biasn that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if length(fbiasp) ~= in_out_num then message('The number of feedback  biasp that you have entered does not match the number of C4 blocks.'); ok=%f; end
            if ok then
                model.in=[1;in_out_num];
                model.out=in_out_num;
                model.ipar=in_out_num;
                model.rpar = [gbias;gbiasn;gbiasp;fbias;fbiasn;fbiasp;cap1];
                model.state = 1.25*ones(2*in_out_num,1);
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model;
                break
            end
        end
    case 'define' then
        gbias = 3e-6;
        gbiasn = 1e-6;
        gbiasp = 1e-6;
        fbias = 3e-9;
        fbiasn = 1e-9;
        fbiasp = 1e-9;
        cap1=6;
        xx=1.25*ones(2,1);
        in_out_num =1;
        model=scicos_model();
        model.sim=list('c4_sp_c',5);
        model.in=[1;in_out_num];
        model.in2=[1;1];
        model.intyp=[-1;-1];
        model.out=in_out_num;
        model.out2=1;
        model.outtyp=-1;
        model.rpar = [gbias;gbiasn;gbiasp;fbias;fbiasn;fbiasp;cap1];
        model.ipar=in_out_num;
        model.state=xx;
        model.blocktype='d';
        model.dep_ut=[%f %t];

        exprs=[sci2exp(in_out_num); sci2exp(gbias) ; sci2exp(gbiasn) ; sci2exp(gbiasp) ; sci2exp(fbias) ; sci2exp(fbiasn) ; sci2exp(fbiasp) ; sci2exp(cap1)];
        gr_i=['txt=''C4 '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')'];
        x=standard_define([8 2],model,exprs,gr_i);
    end
endfunction
