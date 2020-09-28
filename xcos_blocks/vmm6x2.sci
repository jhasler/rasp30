function [x,y,typ]=vmm6x2(job,arg1,arg2)
    x=[];y=[];typ=[];
    select job
    case 'plot' then standard_draw(arg1)
    case 'getinputs' then [x,y,typ]=standard_inputs(arg1)
    case 'getoutputs' then [x,y,typ]=standard_outputs(arg1)
    case 'getorigin' then [x,y]=standard_origin(arg1)
    case 'set' then
        x=arg1;graphics=arg1.graphics;model=arg1.model;exprs=graphics.exprs;
        while %t do
            [ok,num_of_blk,mblif_num,vmm6x2_wp12,vmm6x2_wn12,vmm6x2_fgtia,vmm6x2_fgpntia,vmm6x2_otatia,vmm6x2_offset,fix_loc,exprs]=scicos_getvalue('New Block Parameter',['num_of_blk';'mblif_num';'vmm6x2_wp12';'vmm6x2_wn12';'vmm6x2_fgtia';'vmm6x2_fgpntia';'vmm6x2_otatia';'vmm6x2_offset';'fix_loc'],list('vec',-1,'vec',-1,'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'mat',[-1,-1],'vec',-1),exprs);
            if ~ok then break,end
            if ok then
                num_st=1;
                model.ipar=[num_of_blk,mblif_num];
                model.state=[ones(num_st,1);ones(num_st,1)];
                model.rpar=[vmm6x2_wp12,vmm6x2_wn12,vmm6x2_fgtia,vmm6x2_fgpntia,vmm6x2_otatia,vmm6x2_offset,fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end
        end
    case 'define' then
        num_of_blk=1;
        mblif_num=0;
	vmm6x2_wp12=[1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9];
        vmm6x2_wn12=[1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9,2e-9,2e-9,2e-9,1e-6,2e-9];
	vmm6x2_fgtia=[20e-9,20e-9];
	vmm6x2_fgpntia=[50e-9,50e-9,50e-9,50e-9];
	vmm6x2_otatia=[10e-6,10e-6];
	vmm6x2_offset=[10e-9,10e-9];
        fix_loc=[0;0;0];
        model=scicos_model();
        model.sim=list('vmm6x2_c',5);
	model.in=[6;6;1]
	model.out=[1;1]
        model.ipar=[num_of_blk,mblif_num];
        model.rpar=[vmm6x2_wp12,vmm6x2_wn12,vmm6x2_fgtia,vmm6x2_fgpntia,vmm6x2_otatia,vmm6x2_offset,fix_loc'];
        model.blocktype='d';
        model.dep_ut=[%f %t]; //[block input has direct feedthrough to output w/o ODE   block always active]
        
        exprs=[sci2exp(num_of_blk);sci2exp(mblif_num);sci2exp(vmm6x2_wp12);sci2exp(vmm6x2_wn12);sci2exp(vmm6x2_fgtia);sci2exp(vmm6x2_fgpntia);sci2exp(vmm6x2_otatia);sci2exp(vmm6x2_offset);sci2exp(fix_loc)];
        gr_i=['text=[''vmm6x2''];';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'');']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
