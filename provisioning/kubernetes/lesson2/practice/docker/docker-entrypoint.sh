#!/usr/bin/env bash

DIR="etc/nginx"

log() {
	case $1 in
		error)
			LOG_LEVEL="error"
			;;
	  notice)
			LOG_LEVEL="notice"
			;;
	esac

	timestamp="$(date +"Y/%m/%d %H:%M:%S")"
	echo -e "$timestamp [$LOG_LEVEL] $0: $2"
}

getmd5() {
	tar -C / -cf - $DIR | md5sum | awk '{print $1}'
}

if [ ! -d $DIR ];then
	log error "/$DIR not found"
	exit 1
fi

if ! [ -x "$(command -v nginx)" ];then
	log error "Nginx is not installed"
	exit 1
fi

log notice "starting Nginx process..."
nginx -g 'daemon off;' &

log notice "warning /$DIR for changes..."
checksum_initial=$(getmd5)

trap "exit 0" SIGINT SIGTERM
while true; do
	ls /proc | grep '[0-9]' | xargs -I {} grep -s "master nginx" {}/cmdline | grep "matches"
	NGINX_STATUS=$?
	if [ $? -ne 0 ];then
		log error "Nginx exited. Stopping entrypoint script..."
		exit 1
	fi
	checksum_current=$(getmd5)
	if [ "$checksum_initial" != "$checksum_current" ];then
		checksum_initial=$checksum_current

		nginx -tq
		NGINX_CONF_STATUS=$?
		if [ $NGINX_CONF_STATUS -ne 0 ];then
			log error "couldn't reload Nginx due to an error in the config file."
			continue
		fi

		nginx -s reload
		log notice "reloading Nginx config"
	fi
	sleep 5
done
