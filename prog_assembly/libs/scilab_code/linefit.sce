function [first, last, mmax, bmax, Nmax]=linefit(x, y, epsilon)
    first=0;
    last=0;
    mmax=0;
    bmax=0;
    Nmax=0;
    
    i=1;
    while i<length(x),
        R2=1;
        N=1;
        sumX=x(i);
        sumX2=x(i)*x(i);
        sumY=y(i);
        sumY2=y(i)*y(i);
        sumXY=x(i)*y(i);
        j=i;
        while (j<length(x)) & (R2>1-epsilon),
            j=j+1;
            N=N+1;
            sumX=sumX+x(j);
            sumX2=sumX2+x(j)*x(j);
            sumY=sumY+y(j);
            sumY2=sumY2+y(j)*y(j);
            sumXY=sumXY+x(j)*y(j);
            SXX=sumX2-sumX*sumX/N;
            SYY=sumY2-sumY*sumY/N;
            SXY=sumXY-sumX*sumY/N;
            m=SXY/SXX;
            b=(sumY-m*sumX)/N;
            R2=SXY*SXY/(SXX*SYY);
        end
//        if ((N>10) & (abs(m)>abs(mmax))),
        if ((N>5) & (abs(m)>abs(mmax))),
            first=i;
            last=j;
            mmax=m;
            bmax=b;
            Nmax=N;
        end
        i=j;
    end
endfunction
