#!/bin/bash
#....b
#..........
IFS=$'\n\n'
while true
do
#...........
du -am $1>/data/shell/old.txt
for file1 in `cat /data/shell/old.txt`
do
        if [ -f $(echo "$file1"|awk '{print $2}') ];then
        echo "$file1        0        0        0" >>/data/shell/old1.txt
        fi
done
#....
echo '*************************************************************'
echo '*                 zui da de 30 ge file                      *'
echo '*************************************************************'
echo 'now    filename    initial    growth    total'
sort -rn /data/shell/old1.txt|head -30
#..60s
sleep 30
#..60s.........
du -am $1>/data/shell/new.txt
#..........
for file in `cat /data/shell/old.txt`
do

#.......
if [ -f $(echo "$file"|awk '{print $2}') ];then
value=`echo "$file"|awk '{print $1}'`
name=`echo "$file"|awk -F' ' '{print $2}'`
newvalue=`cat /data/shell/new.txt|grep "$name$"|awk -F' ' '{print $1}'`
a=$(($newvalue - $value))
#..1............
echo "$a        $name        $value        $newvalue">>/data/shell/now.txt
fi
done
#....
echo '*************************************************************'
echo '*                last minute growth 20 ge                   *'
echo '*************#***********************************************'
echo 'growth    filename          initial        now          total'
sort -rn /data/shell/now.txt|head -20
echo -e "\033[41;33m --------------------------------------------------------------------------------------------------------- \033[0m"
echo -e "\033[41;33m ----------------------.---------------------.-----------------------------.--------------------------- \033[0m"
echo -e "\033[41;33m --------------------------------------------------------------------------------------------------------- \033[0m"
echo '' >/data/shell/now.txt
echo '' >/data/shell/old1.txt
sleep 3
clear
done