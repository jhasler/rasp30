function [Is, VT, kappa]=ekvfit_diodeADC(Vout, Isat, epsilon, plotting)
    
    Vout_2=Vout/2;
    Is = 0;
    VT = 0;
    kappa = 0;
    
    [WIfirst, WIlast, WIm, WIb, WIN]=linefit(Vout_2, log(Isat), epsilon);
    if WIN==0
        error('Could not find a weak-inversion region.');
    end
    if plotting == 'on_all'
        scf(1);clf(1);
        plot2d("nl", Vout, Isat, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off";
        plot2d("nl", Vout(WIfirst:WIlast), Isat(WIfirst:WIlast), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        plot2d("nl", Vout, exp(WIm*Vout_2 + WIb), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
        legend("Data","Data for linefit","linefit","in_lower_right");
        //a=gca();a.data_bounds=[0 1e-10; 2.5 1e-3];
        xtitle("","Vout(V)","Isat(A)");
        title('Weak-Inversion Fit');
    end
//    if min(abs(Isat(WIfirst:WIlast)))>1e-6
//        error('Identified a candidate weak-inversion region, but all current levels exceed typical weak-inversion currents.');
//    end
//    if max(abs(Isat(WIfirst:WIlast)))>1e-6
//        warning('Identified a candidate weak-inversion region, but some current levels exceed typical weak-inversion currents.');
//    end
    
    [SIfirst, SIlast, SIm, SIb, SIN]=linefit(Vout_2, sqrt(Isat), epsilon);
    if SIN==0
        error('Could not find a strong-inversion region.');
    end
    if plotting == 'on_all'
        scf(2);clf(2);
        plot2d("nn", Vout, sqrt(Isat), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off";
        plot2d("nn", Vout(SIfirst:SIlast), sqrt(Isat(SIfirst:SIlast)), style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        plot2d("nn", Vout, SIm*Vout_2 + SIb, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
        legend("Data","Data for linefit","linefit","in_lower_right");
        //a=gca();a.data_bounds=[0 0; 2.5 1e-2];
        xtitle("","Vout(V)","Isat(A)");
        title('Strong-Inversion Fit');
    end
//    if max(abs(Isat(SIfirst:SIlast)))<0.1e-6
//        error('Identified a candidate strong-inversion region, but all current levels are lower than typical strong-inversion currents.');
//    end
//    if min(abs(Isat(SIfirst:SIlast)))<0.1e-6
//        warning('Identified a candidate strong-inversion region, but some current levels are lower than typical strong-inversion currents.');
//    end

    if SIfirst>WIlast
        first = WIfirst;
        last = SIlast;
    elseif WIfirst>SIlast
        first = SIfirst;
        last = WIlast;
    else
        error('Weak-inversion and strong-inversion regions found were not disjoint.');
    end
    
    VT=-SIb/SIm; 
    //Is=2*spline(Vout(first:last), Isat(first:last), VT);
    splin_Is=2*splin(Vout_2(first:last), Isat(first:last));
    Is=interp(VT,Vout_2(first:last), Isat(first:last),splin_Is);

    R=0.61803399;
    C=1.-R;
    tol=1e-4;

    x0=0.1*Is;
    x1=Is;
    x2=(1.+9.*C)*Is;
    x3=10.*Is;
    dVout=diff(Vout_2(first:last));
    
    temp=diff(log(exp(sqrt(Isat(first:last)/x1))-1))./dVout;
    f1=stdev(temp)/mean(temp);
    temp=diff(log(exp(sqrt(Isat(first:last)/x2))-1))./dVout;
    f2=stdev(temp)/mean(temp);
    
    while abs(x3-x0)>tol*(abs(x1)+abs(x2)),
        if f2<f1,
            x0=x1; x1=x2; x2=R*x1+C*x3;
            f1=f2;
            temp=diff(log(exp(sqrt(Isat(first:last)/x2))-1))./dVout;
            f2=stdev(temp)/mean(temp);
            if plotting == 'on_all'
                [EKVfirst, EKVlast, m, b, N]=linefit(Vout_2(first:last), log(exp(sqrt(Isat(first:last)/x2))-1), epsilon);
//                scf(3);clf(3);
//                plot2d("nl", Vout(first:last), exp(sqrt(Isat(first:last)/x2))-1, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
//                plot2d("nl", Vout(first:last), exp(m*Vout(first:last)+b), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//                legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_lower_right");
//                xtitle("","Vout(V)","Isat(A)");
//                title(['Optimizing Specific Current: I_s = ', string(x2), 'A']);
            end
        else
            x3=x2; x2=x1; x1=R*x2+C*x0;
            f2=f1;
            temp=diff(log(exp(sqrt(Isat(first:last)/x1))-1))./dVout;
            f1=stdev(temp)/mean(temp);
            if plotting == 'on_all'
                [EKVfirst, EKVlast, m, b, N]=linefit(Vout_2(first:last), log(exp(sqrt(Isat(first:last)./x1))-1), epsilon);
//                scf(4);clf(4);
//                plot2d("nl",Vout(first:last), exp(sqrt(Isat(first:last)/x1))-1, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
//                plot2d("nl", Vout(first:last), exp(m*Vout(first:last)+b), style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
//                legend(" Data1","Polynomial Model1","Data2","Polynomial Model2","in_lower_right");
//                xtitle("","Vout(V)","Isat(A)");
//                title(['Optimizing Specific Current: I_s = ', string(x1), 'A']);
            end
        end
    end

    if f1<f2,
        Is=x1;
    else
        Is=x2;
    end
    [EKVfirst, EKVlast, m, b, N]=linefit(Vout_2(first:last), log(exp(sqrt(Isat(first:last)./Is))-1), epsilon);
    VT=-b/m;
    kappa=2*m*0.0258;
    if plotting == 'on_all' | plotting == 'on_final'
        scf(5);clf(5);
        plot2d("nl",Vout, Isat, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off"; 
        plot2d("nl",Vout(WIfirst:WIlast), Isat(WIfirst:WIlast), style=2);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        plot2d("nl",Vout(SIfirst:SIlast), Isat(SIfirst:SIlast), style=2);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        //c=log(1+exp(kappa*(Vout_2-VT)/(2*0.0258))).^2;
        plot2d("nl", Vout, Is*(log(1+exp(kappa*(Vout_2-VT)/(2*0.0258)))).^2, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
        legend("Data","Data for sub Vt linefit","Data for above Vt linefit","EKV fit","in_lower_right");
        //a=gca();a.data_bounds=[0 1e-10; 2.5 1e-3];
        xtitle("","Vout(V)","Isat(A)");
        title(['EKV Fit: I_s = '+string(Is)+'A, V_T = '+string(VT)+'V, Kappa = '+string(kappa)]);
        scf(6);clf(6);
        plot2d("nn",Vout, Isat, style=1);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 1; p.children.line_mode="off"; 
        plot2d("nn",Vout(WIfirst:WIlast), Isat(WIfirst:WIlast), style=2);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        plot2d("nn",Vout(SIfirst:SIlast), Isat(SIfirst:SIlast), style=2);p = get("hdl"); p.children.mark_style = 9; p.children.thickness = 3; p.children.line_mode="off";
        //c=log(1+exp(kappa*(Vout_2-VT)/(2*0.0258))).^2;
        plot2d("nn", Vout, Is*(log(1+exp(kappa*(Vout_2-VT)/(2*0.0258)))).^2, style=1);p = get("hdl"); p.children.line_style = 1; p.children.thickness = 3; p.children.thickness = 3;p.children.line_mode="on";
        legend("Data","Data for sub Vt linefit","Data for above Vt linefit","EKV fit","in_upper_left");
        //a=gca();a.data_bounds=[0 1e-10; 2.5 1e-3];
        xtitle("","Vout(V)","Isat(A)");
        title(['EKV Fit: I_s = '+string(Is)+'A, V_T = '+string(VT)+'V, Kappa = '+string(kappa)]);
    end
endfunction
