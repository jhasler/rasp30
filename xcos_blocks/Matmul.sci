function [x,y,typ]=Matmul(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,Matmul_A,Matmul_b,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'Matmul_A';'Matmul_b';'fix_loc'],list('vec',-1,'vec',-1,'mat',[-1,-1],'mat',[-1,-1],'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                num_st=4;
                model.ipar=[num_of_blk,mblif_num];
                model.state=[ones(num_st,1);ones(num_st,1)];
                model.rpar=[Matmul_A,Matmul_b,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
	Matmul_A=[1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9,2e-9,2e-9,2e-9,1e-6];
        Matmul_b=[1e-6 1e-6 1e-6 1e-6];
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('Matmul_c',5);
	model.in=[1;1]
	model.out=4
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[Matmul_A,Matmul_b,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(Matmul_A);sci2exp(Matmul_b);sci2exp(fix_loc)];
        gr_i=['text=[''Matmul''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
