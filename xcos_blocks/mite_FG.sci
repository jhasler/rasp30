function [x,y,typ]=mite_FG(job,arg1,arg2)
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
        graphics=arg1.graphics
        model=arg1.model
        exprs=graphics.exprs
        while %t do
            [ok, in_out_num,mite_current,fix_loc, exprs]=scicos_getvalue('New Block Parameter',['number of blocks','MITE_current','Fix_location'],list('vec',-1,'vec',-1,'vec',-1),exprs)
            
            if ~ok then break,end

            //Can check for consistency in the user's input or highlight a mistake

            if ok then
                // Any papermeters that may change 
                //can use set_io function: it updates the model and the graphic of a block by adjusting its input/output number size, type and data type & you can search for this function at www.scicos.org/Newblock.pdf
                model.opar=list(in_out_num,mite_current) //always a list
                model.rpar= [fix_loc'];
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
        // case 'compile' - This case is available for Scilab compiler to call the interfacing functions of Scilab and Modelica blocks with the job 'compile' during the compilation process to improve checks/sets of some block parameters (like input/output sizes and types...) 
    case 'define' then
        in_out_num=1
				mite_current=100e-9
        model=scicos_model()
        //There are more subcategories of model and descriptions refer to help.scilab.org/docs/5.4.1/en_US/scicos_model.html
        //Any negative number tell Scilab to figure it out
        //Can delete or comment out any model category not being used
        model.sim=list('mite_FG_c',5)
        fix_loc=[0;0;0];
        model.in=[-1;-1;-1] //first/row dimension
        model.in2=[-1;-1;-1] //second/column dimension
        model.intyp=[-1;-1;-1] 
        model.out=[-1]
        model.out2=[-1]
        model.outtyp=[-1]
        model.opar=list(in_out_num,mite_current) //always a list
        model.rpar= [fix_loc'];
        //model.state=zeros(1,1)
        //model.rpar= your_variable2
        model.ipar=in_out_num;
        model.blocktype='d'
        model.dep_ut=[%f %t] //[block input has direct feedthrough to output w/o ODE   block always active]

        exprs=[sci2exp(in_out_num);sci2exp(mite_current);sci2exp(fix_loc)] // exprs MUST BE semicolon separated & sci2exp() also converts an expression to string
        gr_i=['txt='' Blank '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([10 5],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
