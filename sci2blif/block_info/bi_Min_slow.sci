Min_slow,2,1,7
2,1,2
5,3,4,5,6,7
num_of_blk,1,mblif_num,0,Min_slow_Min,1e-12,Min_slow_leak,5e-12,Min_slow_ota,50e-9,Min_slow_buf,10e-6,fix_loc',[0;0;0]
num_of_blk,mblif_num,Min_slow_Min,Min_slow_leak,Min_slow_ota,Min_slow_buf,fix_loc
4,1,16,1,19,1,22,1,25
1,0,0
Min_slow,1,1,2,1,5,1,1,1,2,1,3,0,Min_slow_ls,0,1,Min_slow_Min,1,1,Min_slow_leak,2,1,Min_slow_ota,3,1,Min_slow_buf,4
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar
