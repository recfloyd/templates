sh killProcess.sh
nohup java -Xmx3072M -cp .:conf/*:lib/* com.jd.cis.spider.node.CrawlNode 1>/dev/null 2>&1 &
