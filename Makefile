KUBECTL_VERSION="v1.0.7"
GITVERSION=$(shell git describe --abbrev=8 --dirty --always 2>/dev/null)

kubectl/kubectl:
	mkdir -p kubectl
	docker pull gcr.io/google_containers/kubectl:${KUBECTL_VERSION}
	docker save gcr.io/google_containers/kubectl:${KUBECTL_VERSION} | tar x -C kubectl
	cd kubectl && awk -F, '{print $$(NF)}' manifest.json | sed 's:^"::g' | sed 's:".*$$::' | xargs tar xf

all: push

build: kubectl/kubectl
	docker build -t acasajus/k8s-aerospike:${GITVERSION} .

push: build
	docker push acasajus/k8s-aerospike:${GITVERSION}