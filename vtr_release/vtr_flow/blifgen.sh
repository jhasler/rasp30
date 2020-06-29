#!/bin/bash
j=2
filename=$1
echo $filename

list_fl= "$filename_list.txt"
blif_fl= "$filename.blif"
pre_vpr="$filename.pre-vpr.blif"
#finding inputs
numips=$(awk ' /numips/ {print $2}' $list_fl )
	for i in  {1..$numips }
	do
		ips[$i]=$(awk ' /inputs/ {print $('$j')}' $list_fl )
		old_ips[$i]=$(awk ' /.inputs/ {print $('$j')}' temp/$blif_fl )
		$j=(($j+1))
	done

#finding ouputs
	u=2
	numops=$(awk ' /numops/ {print $2}' $list_fl )
	for l in {1..$numops	}
	do
	ops[$l]=$(awk ' /outputs/ {print $('$u')}' $list_fl )
	old_ops[$l]=$(awk ' /.outputs/ {print $('$u')}' temp/$blif_fl )
	$u=(($u+1))
	done

#object_code
obj_name=$(awk ' /obj/ {print $2}' $list_fl )

$OBJ="top"
echo $a
#$inputs=$0
#var1=2
cp temp/$pre_vpr temp/$blif_fl
DPATH="/home/ubuntu/Downloads/vtr_release/vtr_flow/temp/$blif_fl"
for f in $DPATH
do
  if [ -f $f -a -r $f ]; then
	for s in {1.. $numips }
		do
    			sed -i "s/$old_ips[$s]/$ips[$s]/g" "$f"
		done
	for m in {1.. $numops } 
		do  			  
  			sed -i "s/$old_ops[$m]/$ops[$m]/g" "$f"
		done
   	sed -i "s/$OBJ/$obj_name/g" "$f"
   else
    echo "Error: Cannot read $f"
  fi
done

#echo $var1 
echo "I'm done Bebe!!"
