#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

#
# Install microk8s
#

echo Installing microk8s...

sudo amazon-linux-extras install -y epel
cd /etc/yum.repos.d && sudo wget https://people.canonical.com/~mvo/snapd/amazon-linux2/snapd-amzn2.repo
sudo yum install -y snapd-2.51-1.amzn2.1
sudo systemctl enable --now snapd.socket

echo Letting snapd settle...
sleep 5

sudo snap install microk8s --classic
sudo snap install microk8s --classic
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube

#
# Install docker
#

echo Installing docker...

sudo yum install -y docker
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

#
# Clone the appropriate repos
#

echo Installing git...

sudo yum install -y git

echo Cloning the demo repositories...

cd $SCRIPT_DIR
git clone https://github.com/newrelic/demo-nodetron.git
git clone https://github.com/newrelic/demo-javatron.git
git clone https://github.com/newrelic/demo-pythontron.git
git clone https://github.com/newrelic/demo-simulator.git

#
# Now add aliases
#

echo "alias kubectl='microk8s kubectl'" >> ~/.bashrc
echo "alias helm='microk8s helm3'" >> ~/.bashrc
