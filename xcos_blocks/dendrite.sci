function [x,y,typ]=dendrite(job,arg1,arg2)
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
            [ok,vector_num,LeakC,AxialC, exprs]=scicos_getvalue('Dendrite Block Dialog Box',['Vectorized number';'Leakage Conductance (nA)';'Axial conductance (nA)'],list('vec',-1,'vec',-1,'vec',-1),exprs)
            
            if ~ok then break,end

            //Can check for consistency in the user's input or highlight a mistake
//            if your_variable2 == 12 then
//                message('You have entered the number 12 for second variable.'); //or messagebox
//                ok=%f;
//            end

            if ok then
                // Any papermeters that may change 
                //can use set_io function: it updates the model and the graphic of a block by adjusting its input/output number size, type and data type & you can search for this function at www.scicos.org/Newblock.pdf
                //model.opar=list(your_variable1) //always a list
                model.rpar= [vector_num;LeakC;AxialC]
                graphics.exprs=exprs;
                x.graphics=graphics;
                x.model=model
                break;
            end

        end
        // case 'compile' - This case is available for Scilab compiler to call the interfacing functions of Scilab and Modelica blocks with the job 'compile' during the compilation process to improve checks/sets of some block parameters (like input/output sizes and types...) 
    case 'define' then
        vector_num=1
        LeakC=10
        AxialC=10
        model=scicos_model()
        //There are more subcategories of model and descriptions refer to help.scilab.org/docs/5.4.1/en_US/scicos_model.html
        //Any negative number tell Scilab to figure it out
        //Can delete or comment out any model category not being used
        model.sim=list('blank_c',5)
        model.in=[-1;1] //first/row dimension
        model.in2=[1;1] //second/column dimension
        model.intyp=[-1;-1] 
        model.out=-1
        model.out2=1
        model.outtyp=-1
        //model.opar=list(your_variable1) //always a list
        model.state=zeros(1,1)
        //model.rpar= your_variable2
        model.rpar= [vector_num;LeakC;AxialC]
        //model.ipar = [];
        model.blocktype='d'
        model.dep_ut=[%t %t] //[block input has direct feedthrough to output w/o ODE   block always active]

        exprs=[sci2exp(vector_num); sci2exp(LeakC);sci2exp(AxialC)] // exprs MUST BE semicolon separated & sci2exp() also converts an expression to string
        gr_i=['txt='' Dendrite '';';'xstringb(orig(1),orig(2),txt,sz(1),sz(2),''fill'')']
        x=standard_define([5 3],model, exprs,gr_i) //Numbers define the width and height of block
    end
endfunction
