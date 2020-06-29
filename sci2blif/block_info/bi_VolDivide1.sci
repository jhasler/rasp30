VolDivide1,1,1,7
2,1,2
5,3,4,5,6,7
num_of_blk,1,mblif_num,0,VolDivide1_fgota0_ibias,2e-6,VolDivide1_fgota0_pbias,2e-6,VolDivide1_fgota0_nbias,2e-6,VolDivide1_ota0_ibias,2e-6,fix_loc',[0;0;0]
num_of_blk,mblif_num,VolDivide1_fgota0_ibias,VolDivide1_fgota0_pbias,VolDivide1_fgota0_nbias,VolDivide1_ota0_ibias,fix_loc
4,1,14,1,17,1,20,1,23
1,0,0
VolDivide1,1,1,1,1,5,1,1,1,2,0,VolDivide1_ls,0,1,VolDivide1_fgota0_ibias,1,1,VolDivide1_fgota0_pbias,2,1,VolDivide1_fgota0_nbias,3,1,VolDivide1_ota0_ibias,4
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar
