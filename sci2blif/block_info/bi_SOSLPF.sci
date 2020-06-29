SOSLPF,1,1,11
2,1,2
9,3,4,5,6,7,8,9,10,11
num_of_blk,1,mblif_num,0,SOSLPF_Ibias2,2e-7,SOSLPF_FG2p,1e-6,SOSLPF_FG2n,1e-6,SOSLPF_Ibias1,2e-7,SOSLPF_FG1p,1e-6,SOSLPF_FG1n,1e-6,SOSLPF_Feedback,4e-9,SOSLPF_Buffer,1e-6,fix_loc',[0;0;0]
num_of_blk,mblif_num,SOSLPF_Ibias2,SOSLPF_FG2p,SOSLPF_FG2n,SOSLPF_Ibias1,SOSLPF_FG1p,SOSLPF_FG1n,SOSLPF_Feedback,SOSLPF_Buffer,fix_loc
8,1,14,1,17,1,20,1,23,1,26,1,29,1,32,1,35
1,0,0
SOSLPF,1,1,1,1,9,1,1,1,2,0,SOSLPF_ls,0,1,SOSLPF_Ibias2,1,1,SOSLPF_FG2p,2,1,SOSLPF_FG2n,3,1,SOSLPF_Ibias1,4,1,SOSLPF_FG1p,5,1,SOSLPF_FG1n,6,1,SOSLPF_Feedback,7,1,SOSLPF_Buffer,8
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks, # of rpar BLIF parameters,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar
