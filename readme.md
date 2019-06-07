
[![HitCount](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv.svg)](http://hits.dwyl.io/etiennedeneuve/kubernetes_hyperv)

# Create a Kubernetes Cluster on Hyper V

## Latest changes

- You don't need WSL in 2019 VM, you need just to configure WinRM on the Hyper-V and add the IP in inventory\host, and WSL a mac or linux for launching the playbook
- Added Group Vars in Part 5, so you don't need to change multiple stuff
- I'm working on the project to add a way to change number of each type of Kubernetes nodes - WIP

## Prerequisites

You need a Windows Server 2019 VM with nested virtualization enabled at least 8 Go of Ram in the VM:  
    [Setup Guide for Hyper V](https://docs.microsoft.com/fr-fr/virtualization/hyper-v-on-windows/user-guide/nested-virtualization)

## TL&DR

On a Windows 10 host :

~~1. Install [WSL](#WSL)~~
1. [Hyper V](#Hyper-V)
2. Activate [WinRM](#Configure-WinRM-for-Ansible)
3. Install [packer](https://packer.io/downloads).  

In WSL:

1. Install the [dependencies](#Install-Ansible-in-WSL)
1. Clone the project ``git clone https://github.com/EtienneDeneuve/kubernetes_hyperv/kubernetes_hyperv.git``
1. Update the credential for hyperv in ``inventory/hosts.yml``
2. Launch the playbook in ``part5`` : ``ansible-playbook -i inventory/hosts.yml main/playbook.yml``
3. SSH into the master node and start playing with your Kubernetes Cluster !

## TODO

- [ ] Add Tests with [Molecule](https://molecule.readthedocs.io/en/latest/)
- [ ] Add Tests with [Pester](https://github.com/pester/Pester)
- [ ] Add Tests for Packer image generation
- [ ] Configure CI/CD for test
- [ ] Add others distro for base os in Kubernetes
- [ ] Hardening and avoid snowflake 

### VM Setup

#### Hyper-V
In this vm you need Hyper V Feature enabled and Windows Subsystem Linux installed.

For Windows Server 2019 :

```Powershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
```

#### WSL

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


## Code of Conduct
This project has adopted the [Microsoft Open Source Code of
Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct
FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com)
with any additional questions or comments.
