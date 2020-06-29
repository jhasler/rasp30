I_SenseAmp,2,1,9
2,1,2
7,3,4,5,6,7,8,9
num_of_blk,1,mblif_num,0,I_SenseAmp_fgota0_ibias,2e-6,I_SenseAmp_fgota0_pbias,2e-6,I_SenseAmp_fgota0_nbias,2e-6,I_SenseAmp_ota0_ibias,2e-6,I_SenseAmp_cap0,1,I_SenseAmp_cap1,1,fix_loc',[0;0;0]
num_of_blk,mblif_num,I_SenseAmp_fgota0_ibias,I_SenseAmp_fgota0_pbias,I_SenseAmp_fgota0_nbias,I_SenseAmp_ota0_ibias,I_SenseAmp_cap0,I_SenseAmp_cap1,fix_loc
6,1,16,1,19,1,22,1,25,1,28,1,31
1,0,0
I_SenseAmp,1,1,2,1,7,1,1,1,2,1,3,0,I_SenseAmp_ls,0,1,I_SenseAmp_fgota0_ibias,1,1,I_SenseAmp_fgota0_pbias,2,1,I_SenseAmp_fgota0_nbias,3,1,I_SenseAmp_ota0_ibias,4,3,I_SenseAmp_cap0,5,3,I_SenseAmp_cap1,6
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar
