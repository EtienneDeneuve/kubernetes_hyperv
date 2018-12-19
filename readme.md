
[![HitCount](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv.svg)](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv)

# Create a Kubernetes Cluster on Hyper V

## Prerequisites

You need a Windows Server 2019 VM with nested virtualization enabled and at least 8 Go of Ram:  
    [Setup Guide for Hyper V](https://docs.microsoft.com/fr-fr/virtualization/hyper-v-on-windows/user-guide/nested-virtualization)



### VM Setup

#### Hyper-V
In this vm you need Hyper V Feature enabled and Windows Subsystem Linux installed.
```Powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart 
```

#### WSL

```Powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Restart-Computer
```

Then

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
