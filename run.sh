#!/bin/bash
set -e

#$1 - parameter; $2 - value; $3 - default value; $4 - file;
Template() {
	[[ -z "$2" ]] &&  sed -i "s/{{ $1 }}/$3/g" $4 || sed -i "s/{{ $1 }}/$2/g" $4
}

CONF="/etc/aerospike/aerospike.conf"

Template as_namespace "$AS_NAMESPACE" data $CONF
Template as_memory_size_gb "$AS_MEMORY_SIZE_GB" 1 $CONF
Template as_default_ttl_days "$AS_DEFAULT_TTL_DAYS" 0 $CONF
Template as_file_size_gb "$AS_FILE_SIZE_GB" 1 $CONF

AddPeers() {
	dockerize -wait tcp://127.0.0.1:3002	
	dockerize -wait tcp://127.0.0.1:3000	

	iface=$(ip route | grep default | awk '{print $NF}')
	myIP=$(ip addr show dev eth0 | grep 'inet ' | awk '{print $2}' | sed 's:/.*$::')

	podIPs=$(dig ${AS_SERVICE:-"aerospike-svc.default"}.svc.cluster.local | grep 'IN A' | awk '{print $NF}')

	echo "All pods IP are: $podIPs"

	for podIP in $podIPs
	do
		if [ "$podIP" != "$myIP" ]; then
			dockerize -wait tcp://$podIP:3002
			asinfo -v "tip:host=$podIP;port=3002"
			echo "Added $podIP as peer"
		fi
	done
}

/etc/init.d/amc start
AddPeers & asd --foreground

