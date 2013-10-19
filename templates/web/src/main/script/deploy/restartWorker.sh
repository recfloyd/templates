#!/bin/sh
sh /export/script/killProcess.sh worker.sh;
rm -rf /export/log/worker*;
nohup sh /export/worker/worker.sh 1>/dev/null 2>&1 &
for ip in `cat /root/batchScript/iplist.txt`; do
    echo "$ip";
    ssh root@$ip 'sh /export/script/killProcess.sh worker.sh; rm -rf /export/log/worker*; nohup sh /export/worker/worker.sh 1>/dev/null 2>&1 &'
done;
echo "all worker started"
echo "localhost"
ps aux | grep worker.sh
for ip in `cat /root/batchScript/iplist.txt`; do
    echo "$ip";
    ssh root@$ip 'ps aux | grep worker.sh'
done;