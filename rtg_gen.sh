#!/bin/sh
echo "rawlim=["
grep d_data $1.DECO | uniq | awk '{print $7 " " $9}'
echo "];"
s=`grep d_raw $1.DECO`
if [ $? -eq 0 ]
then
 echo "amplim=["
 grep d_raw $1.DECO | uniq | awk '{print $7 " " $9}'
 echo "];"
fi
