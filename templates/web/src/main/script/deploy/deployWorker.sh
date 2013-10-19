#!/bin/sh
cp -f /export/workspace/spider-fetcher/spider-fetcher/worker.sh /export/worker/
for ip in `cat /root/batchScript/iplist.txt`; do
    echo "$ip";
    scp /export/worker/worker.sh root@$ip:/export/worker/
done;
echo "worker.sh deploy done"