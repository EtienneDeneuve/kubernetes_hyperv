
[![HitCount](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv.svg)](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv)

# Create a Kubernetes Cluster on Hyper V

## Prerequisites

You need a Windows Server 2019 VM with nested virtualization enabled at least 8 Go of Ram in the VM:  
    [Setup Guide for Hyper V](https://docs.microsoft.com/fr-fr/virtualization/hyper-v-on-windows/user-guide/nested-virtualization)
or or Windows 10 with a recent build and 8 go of ram (each Kubernetes VM is sized with 2Gb)

## TL&DR

On a Windows 10 host :

1. Install [WSL](#WSL)
1. [Hyper V](#Hyper-V)
1. Activate [WinRM](#Configure-WinRM-for-Ansible)
1. Install [packer](https://packer.io/downloads).  

In WSL:

1. Install the [dependencies](#Install-Ansible-in-WSL) 
1. Clone the project ``git clone https://github.com/EtienneDeneuve/kubernetes_hyperv/kubernetes_hyperv.git``
1. Update the credential for hyperv in ``inventory/hosts.yml`` 
1. Launch the playbook in ``part5`` : ``ansible-playbook -i inventory/hosts.yml part5/playbook.yml``
1. SSH into the master node and start playing with your Kubernetes Cluster !

## TODO

- [ ] Add Tests with [Molecule](https://molecule.readthedocs.io/en/latest/)
- [ ] Add Tests with [Pester](https://github.com/pester/Pester)
- [ ] Add Tests for Packer image generation
- [ ] Configure Travis for CI

### VM Setup

#### Hyper-V
In this vm you need Hyper V Feature enabled and Windows Subsystem Linux installed.

For Windows Server 2019 :

```Powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart 
```

For Windows 10 :

```PowerShell
Enable-WindowsOptionalFeature -Online -FeatureName:Microsoft-Hyper-V -All
```

#### WSL

For Windows Server 2019

```Powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Restart-Computer
```
For Windows 10

```Powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Then for Windows 10 and Windows Server 2019

```Powershell
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1604 -OutFile Ubuntu.zip -UseBasicParsing
Expand-Archive .\Ubuntu.zip c:\Distros\Ubuntu
Rename-Item c:\distros\ubuntu\ubuntu1804.exe c:\distros\ubuntu\ubuntu.exe
```

#### Configure WinRM for Ansible

Launch this script :  
[ConfigureRemotingForAnsible](https://github.com/ansible/ansible/blob/devel/examples/scripts/ConfigureRemotingForAnsible.ps1
)
or use the one in misc folder : [here](webcast\misc\host_preparation\01_config_winrm_ansible.ps1)

#### Install Ansible in WSL

Launch the ``04_configure.sh`` script in ``misc\wsl_preparation``: 
sudo .\04_configure.sh

## Generate ubuntu vhdx using Packer:

Update the inventory with our own credentials in ``inventory\hosts.yml`` and launch the first part:

```shell
ansible-playbook -i inventory\host.yml part1\part1_generate_vhdx.yml
```

You should now have a folder in ``part1\packer\`` named "output-hyperv-iso" with a folder named ``Virtual Hard Disks``.

## Create VMs Using Ansible & Powershell DSC

```shell
ansible-playbook -i inventory\host.yml part2\part2_create_vms.yml
```

You should have 3 VMS in your Hyper V manager, and a newly inventory in ``inventory`` folder named ``kube.yml``.

## Configure the VMS for Kubernetes

```shell
ansible-playbook -i inventory\kube.yml part3\part3_deploy_prerequistes.yml
```

Your vms are ready to launch kubeadm

## Create the Cluster and join nodes

```shell
ansible-playbook -i inventory\kube.yml part4\part4_create_cluster.yml
```

Now ssh to the master node and you should have a running Kubernetes cluster!

## Code of Conduct
This project has adopted the [Microsoft Open Source Code of
Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct
FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com)
with any additional questions or comments.
