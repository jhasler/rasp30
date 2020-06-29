function [x,y,typ]=hhneuron(job,arg1,arg2)
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
            [ok,in_out_num,lbias,vinbias,nabias,kbias,pfetbias,nabiasp,nabiasn,kbiasp,kbiasn,exprs]=getvalue('Set HH Neuron Parameters',['Number of HH Neuron blocks';'Leak Bias';'Vin Bias';'Na Bias';'K Bias';'FG pfet bias';'Na bias p';'Na bias n';'K bias p';'K bias n'],list('vec',1,'vec',1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1,'vec',-1),exprs)

            if ~ok then break,end
            
            if length(lbias) ~= in_out_num then
                message('The number of leak biases that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end

            if length(vinbias) ~= in_out_num then
                message('The number of Vin biases that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(nabias) ~= in_out_num then
                message('The number of Na biases that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(kbias) ~= in_out_num then
                message('The number of K biases that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(nabiasp) ~= in_out_num then
                message('The number of Na biases p that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(nabiasn) ~= in_out_num then
                message('The number of Na biases n that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(kbiasp) ~= in_out_num then
                message('The number of K biases p that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(kbiasn) ~= in_out_num then
                message('The number of K biases n that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            if length(pfetbias) ~= in_out_num then
                message('The number of FG pfet biases that you have entered does not match the number of HH Neuron blocks.');
                ok=%f;
            end
            
            if ok then
                model.in=[in_out_num;in_out_num;in_out_num;in_out_num]
                model.out=[in_out_num;in_out_num;in_out_num]
                model.ipar=in_out_num
                model.rpar = [lbias;vinbias;nabias;kbias;pfetbias;nabiasp;nabiasn;kbiasp;kbiasn]
                model.state = zeros(2*in_out_num,1)
                graphics.exprs=exprs;
                x.graphics=graphics;x.model=model
                break
            end
        end
    case 'define' then
        lbias=1e-9
        vinbias = 100e-9
        nabias = 100e-9
        kbias = 100e-9
        pfetbias = 1e-6
        nabiasn = 100e-9
        nabiasp = 100e-9
        kbiasn = 100e-9
        kbiasp = 100e-9
        xx=zeros(2,1)
        in_out_num =1
        model=scicos_model()
        model.sim=list('hhneuron_c',5)
        model.in=[in_out_num;in_out_num;in_out_num;in_out_num]
        model.in2=[1;1;1;1]
        model.intyp=[-1;-1;-1;-1]
        model.out=[in_out_num;in_out_num;in_out_num]
        model.out2=[1;1;1]
        model.outtyp=[-1;-1;-1]
        model.rpar = [lbias;vinbias;nabias;kbias;pfetbias;nabiasp;nabiasn;kbiasp;kbiasn]
        model.ipar=in_out_num
        model.state=xx
        model.blocktype='d'
        model.dep_ut=[%f %t]

        exprs=[sci2exp(in_out_num); sci2exp(lbias);sci2exp(vinbias) ; sci2exp(nabias) ; sci2exp(kbias) ; sci2exp(pfetbias) ; sci2exp(nabiasp) ; sci2exp(nabiasn) ; sci2exp(kbiasp) ; sci2exp(kbiasn)]
        gr_i=['txt=''HH Neuron'';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([11 6],model,exprs,gr_i)
    end
endfunction
