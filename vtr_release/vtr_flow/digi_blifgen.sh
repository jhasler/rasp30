#!/bin/bash
a=$(awk ' /inputs/ {print $2}' div2_list.txt )
b=$(awk ' /inputs/ {print $3}' div2_list.txt )
c=$(awk ' /outputs/ {print $2}' div2_list.txt )
obj_name=$(awk ' /obj/ {print $2}' div2_list.txt )
echo $a
#$inputs=$0
#var1=2
cp temp/divBy2.pre-vpr.blif temp/div2.blif
awk '/.inputs/ ' temp/div2.blif
OLD="top^ip1"	
NEW="net$a"
OLD1="top^reset"
NEW1="net$b"
OLD2="top^op1"
NEW2="net$c"
DPATH="/home/ubuntu/Downloads/vtr_release/vtr_flow/temp/div2.blif"
for f in $DPATH
do
  if [ -f $f -a -r $f ]; then
    sed -i "s/$OLD/$NEW/g" "$f"
    sed -i "s/$OLD1/$NEW1/g" "$f"
   sed -i "s/$OLD2/$NEW2/g" "$f"
sed -i "s/"top^"/$obj_name/g" "$f"
   else
    echo "Error: Cannot read $f"
  fi
done

#echo $var1 
echo "hello"
