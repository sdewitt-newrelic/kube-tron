# kube-tron

An Ansible playbook and helm chart for deploying the New Relic demo-* apps on
K8s using microk8s on Amazon Linux 2.

## Prerequisites

* You must have [Ansible](https://www.ansible.com/resources/get-started)
  installed locally.
* You must have an AWS account.

## Getting Started

1. Create a new EC2 instance with the following specifications
   * Amazon Linux 2 AMI
   * t2.large
   * 30 GB storage

1. Clone this repository locally
1. Create an Ansible hosts file and add your EC2 information to it, including
   your PEM file. For example:

```sh
kube-tron ansible_host=ec2-54-173-49-45.compute-1.amazonaws.com ansible_user=ec2-user ansible_ssh_private_key_file=/Users/sdewitt/.ssh/nr-es-sdewitt.pem ansible_python_interpreter=auto
```

4. Open a terminal in the repository directory
4. Run the following command

```sh
ansible-playbook -i /path/to/hosts/file ./playbook.yml
```

You should now have a running cluster including a simulator pod that drives
transactions between the various services.

## Installing Pixie

You can now use the guided install to generate the shell commands to run to
install Pixie on your EC2 instance.