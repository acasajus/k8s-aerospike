
GITVERSION=$(shell git describe --abbrev=8 --dirty --always 2>/dev/null)

all: push

build: 
	docker build -t acasajus/k8s-aerospike:${GITVERSION} .

push: build
	docker push acasajus/k8s-aerospike:${GITVERSION}