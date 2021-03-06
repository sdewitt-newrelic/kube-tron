#!/bin/bash

#
# Enable helm and a few other things
#

microk8s enable helm3 dns storage

#
# Build the local docker images
#

echo Building images...

bash -c "cd ../demo-nodetron && docker build -t nodetron:1.0.0 ."
bash -c "cd ../demo-javatron && docker build -t javatron:1.0.0 ."
docker build -t pythontron:1.0.0 -f ./Dockerfile-pytron ../demo-pythontron
bash -c "cd ../demo-simulator && docker build -t simtron:1.0.0 ."

#
# Export/Import images
#

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