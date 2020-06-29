#!/bin/bash
j=2

filename=$1
echo $filename
txt="_list.txt"
blext=".blif"
pvpr=".pre-vpr.blif"

list_fl=$filename$txt
echo $listfl
blif_fl=$filename$blext
pre_vpr=$filename$pvpr

app="net"
#cp temp/divBy2.pre-vpr.blif temp/$blif_fl
#cp divBy2.pre-vpr.blif $blif_fl
#finding inputs
numips=$(awk ' /numips/ {print $2}' $list_fl )
#echo $numips
	for i in `seq 1 $numips`
	do
		ips[$i]=$(awk ' /inputs/ {print $('$j')}' $list_fl )
		#${ips[$i]}= $app ${ips[$i]}
		#old_ips[$i]=$(awk ' /.inputs/ {print $('$j')}' temp/$blif_fl )	
		old_ips[$i]=$(awk ' /.inputs/ {print $('$j')}' $blif_fl )
		#echo " loop: $i $j "
		#echo ${old_ips["$i"]}
		j=$(( $j +1 ))
	done
		
#finding ouputs
	u=2
	numops=$(awk ' /numops/ {print $2}' $list_fl )
	#echo $numops
	for l in `seq 1 $numops`
	do
		ops[$l]=$(awk ' /outputs/ {print $('$u')}' $list_fl )
		#$ops[$l]=$app$ops[$l]
		old_ops[$l]=$(awk ' /.outputs/ {print $('$u')}' $blif_fl )
		#old_ops[$l]=$(awk ' /.outputs/ {print $('$u')}' temp/$blif_fl )
		#echo " loop2: $l $u "
		#echo ${old_ops["$l"]}
		u=$(($u+1))
	done

#object_code
obj_name=$(awk ' /obj/ {print $2}' $list_fl )
#echo ${old_ops[1]}
OBJ="top^"
#echo $OBJ
#$inputs=$0
#var1=2	
MODEL=".model"
MODELN="#.model"
IPS=".inputs"
IPSN="#.inputs"
OPS=".outputs"
OPSN="#.outputs"
DEND=".end"
DENDN=" "
DPATH="$blif_fl" 
NAMES=".names"
LATCH=".latch "
LATCHN="#.latch"
LUT="1 1"
LUTN="01 1"

for f in $DPATH
do
  awk '{if ($1==".latch"){print ".subckt latch_custom D="$2 " clk=" $5 " reset=rst Q="$3 "\n" }}' $f >> $f
  
  if [ -f $f -a -r $f ]; then
	for s in `seq 1 $numips`
		do
    			sed -i "s/${old_ips[$s]}/${app}${ips[$s]}/g" "$f"
		done
    
	for m in `seq 1  $numops `
		do  			  
  			sed -i "s/${old_ops[$m]}/${app}${ops[$m]}/g" "$f"
		done
   	sed -i "s/$OBJ/$obj_name/g" "$f"
	sed -i "s/$MODEL/$MODELN/g" "$f"
	sed -i "s/$IPS/$IPSN/g" "$f"
	sed -i "s/$OPS/$OPSN/g" "$f"
	sed -i "s/$DEND/$DENDN/g" "$f"
	sed -i "s/$NAMES/\n$NAMES/g" "$f"
	sed -i "s/$LATCH/$LATCHN/g" "$f"
	sed -i "s/$LUT/$LUTN/g" "$f"
   else
    echo "Error: Cannot read $f"
  fi
done

