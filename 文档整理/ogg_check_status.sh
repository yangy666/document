#!/bin/bash
echo "info all"|/ogg/ggsci |egrep -v 'Program|^GGSCI|^Oracle|^Version|^Copyright|^Operating|^$|^Linux' > /tmp/ogg_check_status1.txt
a=`cat /tmp/ogg_check_status1.txt |awk '{print $2}'|grep -v '^$'|grep -v 'RUNNING'`
if [ $? -eq 0 ];then
        for i in $a
        do
        echo -n "status:$i group:`cat /tmp/ogg_check_status1.txt|grep $i|awk '{print $3}'`   " >>/tmp/ogg_check_status2.txt
#       echo "{ \"result\" : false
#  \"message\": GG}"
done
echo "{ \"result\" : false
  \"message\": `cat /tmp/ogg_check_status2.txt`}"
else
        echo "{ \"result\" : true
  \"message\": OK }"
fi
>/tmp/ogg_check_status2.txt