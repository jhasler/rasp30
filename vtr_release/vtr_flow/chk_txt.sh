#!/bin/bash
echo "Please enter filename:";
read filename;
cat $filename |while read line;do
    firstchar = ${line:0:1}
    if [ ! $firstchar == "#"]
    then
        echo $line;
    fi
done 
