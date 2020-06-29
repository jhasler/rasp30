fgota,2,1,7
2,1,2
5,3,4,5,6,7
num_of_blk,1,mblif_num,0,ibias,10e-9,p_ibias,10e-9,n_ibias,10e-9,smcap,1,fix_loc',[0;0;0]
num_of_blk,mblif_num,ibias,p_ibias,n_ibias,smcap,fix_loc
4,1,13,1,16,1,19,1,22
1,0,0
fgota,1,1,2,1,4,1,1,1,2,1,1,1,fgota_bias,1,1,fgota_p_bias,2,1,fgota_n_bias,3,5,fgota_small_cap,4
//------ Here, everything should be in Order with no space ------//
// Xcos block name, # of input, # of output, # of Xcos paramters (exprs)
// # of ipar, order
// # of rpar, order
// Xcos parameter, default value, ...
// Xcos parameters - exprs
// # of user defined rpars, BLIF block #, column #, ...
// # of BLIF blocks,vcc_flag,gnd_flag
// 1st block name, mblif #, vectorized #, # of input, # of output, # of BLIF parameters, input type(0:internal,1:external,2:vcc,3:gnd), number/name, output type, number/name, BLIF parameters type(0:connection,1:bias,2:bias(hidden),3:cap,4:cap(hidden),5:smcap,6:smcap(hidden)), name, value / Xcos parameter # in rpar 
