#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#
# Enable helm and a few other things
#

microk8s enable helm3 dns storage

#
# Build the local docker images
#

echo Building images...

cd $SCRIPT_DIR/demo-nodetron && docker build -t nodetron:1.0.0 .
cd $SCRIPT_DIR/demo-javatron && docker build -t javatron:1.0.0 .
cd $SCRIPT_DIR && docker build -t pythontron:1.0.0 -f ./Dockerfile-pytron ./demo-pythontron
cd $SCRIPT_DIR/demo-simulator && docker build -t simtron:1.0.0 .

#
# Export/Import images
#

cd $SCRIPT_DIR

echo Importing nodetron...

docker save nodetron:1.0.0 > nodetron.tar
microk8s ctr image import nodetron.tar
rm nodetron.tar

echo Importing javatron...

docker save javatron:1.0.0 > javatron.tar
microk8s ctr image import javatron.tar
rm javatron.tar

echo Importing pythontron...

docker save pythontron:1.0.0 > pythontron.tar
microk8s ctr image import pythontron.tar
rm pythontron.tar

echo Importing simtron...

docker save simtron:1.0.0 > simtron.tar
microk8s ctr image import simtron.tar
rm simtron.tar

#
# Install the helm chart
#

echo Installing the kube-tron chart...

microk8s helm3 install ktron ./kube-tron/

#
# Wait on the pods
#

echo 'Wait until you see all these pods Running...'

microk8s kubectl get pods -w