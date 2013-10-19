#!/bin/sh
#
#Author:yflijia@jd.com
#Date:2013.04.15
#Usage:auto update crawl rule from scheduler server

_RUNINTERVAL=${worker_run_interval}
_CHECKTIMEOUT=${worker_check_timeout}
_CHECKRETRY=${worker_check_retry}
_CHECKDELAY=${worker_check_delay}
_DOWNLOADTIMEOUT=${worker_download_timeout}
_DOWNLOADRETRY=${worker_download_retry}
_DOWNLOADDELAY=${worker_download_delay}

_VERSIONFILE=${worker_version_file}
_DOWNLOADFILE=${worker_download_file}
_WORKSPACE=${worker_workspace}
_CHECKURL='${worker_check_url}'
_DOWNLOADURL='${worker_download_url}'
_RESTARTSCRIPT=${worker_restart_script}
_LOGTEMP=${worker_log}

while [ true ]; do
    _TODAY=`date +%F`
	_LOGFILE=$_LOGTEMP$_TODAY.log
	echo "version check worker is running at `date +%F_%T` ..." >> $_LOGFILE

	#read local version
	_LOCALVERSION=-1
	if [ -f $_VERSIONFILE ];then
		_VERSIONSTRING=`cat $_VERSIONFILE`
		if [ -n $_VERSIONSTRING ];then
			_LOCALVERSION=$_VERSIONSTRING
		fi
	fi
	echo "local version is $_LOCALVERSION" >> $_LOGFILE

	#check net version
	_RESPONSE=`curl --fail --max-time $_CHECKTIMEOUT --retry $_CHECKRETRY --retry-delay $_CHECKDELAY --silent $_CHECKURL`
	_COMPLETEPACK=0
	_NETVERSION=-1
	if [ ${#_RESPONSE} -gt 0 ]; then
		_COMPLETEPACK=${_RESPONSE:0:1}
		_NETVERSION=${_RESPONSE:2}
		echo "version check net call ok, net version is $_NETVERSION, completePack is $_COMPLETEPACK" >> $_LOGFILE
	else
	        echo "version check net call fail" >> $_LOGFILE
	fi

	if [[ $_NETVERSION -gt $_LOCALVERSION ]];then
		#download new archive
		echo "perform a new version download" >> $_LOGFILE
		rm -f $_DOWNLOADFILE
		wget --quiet --output-document=$_DOWNLOADFILE --no-cache --no-cookies $_DOWNLOADURL
		_DOWNLOADSTATUS=$?
		
		if [[ $_DOWNLOADSTATUS -eq 0 ]];then
		    _FILEINFO=`ls -lht $_DOWNLOADFILE`
            echo "file info is $_FILEINFO" >> $_LOGFILE

			echo "kill process..." >> $_LOGFILE
			#kill process
			_PID=`ps aux | grep com.jd.cis.spider.node.CrawlNode | grep -v grep | grep -v worker | awk '{print $2}'`
			if [ -n "$_PID" ];then
				kill $_PID
				echo "kill old process $_PID" >> $_LOGFILE
			fi

			#wait for kill
			_PID=`ps aux | grep com.jd.cis.spider.node.CrawlNode | grep -v grep | grep -v worker | awk '{print $2}'`
			while [ -n "$_PID" ];do
				sleep 1
				_PID=`ps aux | grep com.jd.cis.spider.node.CrawlNode | grep -v grep | grep -v worker | awk '{print $2}'`
			done;

			echo "unzip..." >> $_LOGFILE
			#unzip
			if [ $_COMPLETEPACK -eq 1 ];then
				rm -rf $_WORKSPACE/*
				echo "remove old pack" >> $_LOGFILE
			fi
			unzip -qq -o $_DOWNLOADFILE -d $_WORKSPACE
			echo $_NETVERSION > $_VERSIONFILE

			echo "restart..." >> $_LOGFILE
			cd $_WORKSPACE/spider-fetcher
			sh $_RESTARTSCRIPT
			echo "restart complete" >> $_LOGFILE

		else echo "download archive fail" >> $_LOGFILE
		fi
	else echo "no need to update" >> $_LOGFILE
	fi
	
	echo -e "----------------------"  >> $_LOGFILE
	sleep $_RUNINTERVAL
done;