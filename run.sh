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

kubectl proxy &
