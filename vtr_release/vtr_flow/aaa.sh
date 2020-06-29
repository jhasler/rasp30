#!/bin/bash
j=2
#finding inputs
numips=$(awk ' /numips/ {print $2}' div2_list.txt )
echo $numips
#for $y in { 1..10 }
	for ((i=0; i<= 2; i++))
	do
		echo $y		
		#ips[i]=$(awk ' /inputs/ {print $('$j')}' div2_list.txt )
		#old_ips[$i]=$(awk ' /.inputs/ {print $('$j')}' temp/div2.blif )
		#$j=($j+1)
	done
