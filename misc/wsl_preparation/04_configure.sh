#!/bin/bash
apt-get -y install apt-transport-https curl software-properties-common ca-certificates
apt-add-repository --yes --update ppa:ansible/ansible
apt-get -y install ansible python-pip
pip install pip --upgrade
pip install pywinrm