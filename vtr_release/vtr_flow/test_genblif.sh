#!/bin/sh
j=2

filename=$1
echo $filename;
t="_list.txt"
blext=".blif"
pvpr=".pre-vpr.blif"

listfl=$filename$t
echo $listfl
blif_fl=$filename$blext
pre_vpr=$filename$pvpr
echo $pre_vpr 

