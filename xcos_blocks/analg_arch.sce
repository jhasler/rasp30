.model ota
.inputs in[0] in[1]
.outputs out
.blackbox
.end

.model cap
.inputs in
.outputs out
.blackbox
.end

.model nfet
.inputs in[0] in[1]
.outputs out
.blackbox
.end

.model pfet
.inputs in[0] in[1]
.outputs out
.blackbox
.end

.model tgate
.inputs in[0] in[1]
.outputs out
.blackbox
.end

.model nmirror
.inputs in[0]
.outputs out
.blackbox
.end

.model volswc
.inputs in[0] in[1] in[2] in[3] in[4] in[5] in[6] in[7] ci[0] ci[1] ci[2] 
.outputs out co[0] co[1] co[2]
.blackbox
.end