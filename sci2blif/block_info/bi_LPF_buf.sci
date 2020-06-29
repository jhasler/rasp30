LPF_buf,1,1,5
2,1,2
3,3,4,5
num_of_blk,1,mblif_num,0,LPF_buf_lpf,1e-10,LPF_buf_Buff,10e-6,fix_loc',[0;0;0]
num_of_blk,mblif_num,LPF_buf_lpf,LPF_buf_Buff,fix_loc
2,1,14,1,17
1,0,0
LPF_buf,1,1,1,1,3,1,1,1,2,0,LPF_buf_ls,0,1,LPF_buf_lpf,1,1,LPF_buf_Buff,2
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar
