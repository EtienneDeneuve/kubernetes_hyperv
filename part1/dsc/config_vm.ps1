Configuration CreateFolder
{
    param(
        $vhdsource,
        $rootpath,
        $vswitch
    )
    Import-DscResource -module xHyper-V
    node "localhost"
    {

        # File FolderRoot {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     Type            = "Directory" # Default is "File".
        #     DestinationPath = Join-Path $rootpath "Kubernetes"
        # }
        # File FolderRootMaster {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     Type            = "Directory" # Default is "File".
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Master"
        # }
        # File FolderRootWorker1 {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     Type            = "Directory" # Default is "File".
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Worker01"
        # }
        # File FolderRootWorker2 {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     Type            = "Directory" # Default is "File".
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Worker02"

        # }
        # File FolderRootMasterVhd {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Master\K8sclu_Master-ubuntu.vhd"
        #     SourcePath      = $vhdsource

        # }
        # File FolderRootWorker1vhd {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Worker01\Worker01-ubuntu.vhd"
        #     SourcePath      = $vhdsource
        # }
        # File FolderRootWorker2vhd {
        #     Ensure          = "Present"  # You can also set Ensure to "Absent"
        #     DestinationPath = Join-Path $rootpath "Kubernetes\Worker02\Worker02-ubuntu.vhd"
        #     SourcePath      =         $vhdsource
        # }

        # # xVHD Worker01 {
        # #     Name             = "Worker01-ubuntu.vhd"
        # #     Path             = Join-Path $rootpath "Kubernetes\Worker01\"
        # #     MaximumSizeBytes = 30GB
        # #     Generation       = "Vhd"
        # #     Ensure           = "Present"
        # # }

        # # xVHD master {
        # #     Name             = "K8sclu_Master-ubuntu.vhd"
        # #     Path             = Join-Path $rootpath "Kubernetes\Master\"
        # #     MaximumSizeBytes = 30GB
        # #     Generation       = "Vhd"
        # #     Ensure           = "Present"
        # # }

        # # xVHD Worker02 {
        # #     Name             = "Worker02-ubuntu.vhd"
        # #     Path             = Join-Path $rootpath "Kubernetes\Worker02\"
        # #     MaximumSizeBytes = 30GB
        # #     Generation       = "Vhd"
        # #     Ensure           = "Present"
        # # }

        xVMHyperV Worker01 {
            Name            = "K8sclu_Worker-01"
            SwitchName      = $vswitch
            ProcessorCount  = 2
            VhdPath         = Join-Path $rootpath "Kubernetes\Worker01\Worker01.vhdx"
            Generation      = 2
            EnableGuestService = $true
            State           = "Running"
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            WaitForIP       = $WaitForIP
            SecureBoot = $false
          #  DependsOn       = '[xVHD]Worker01'
        }

        xVMHyperV master {
            Name            = "K8sclu_Master"
            SwitchName      = $vswitch
            VhdPath         = Join-Path $rootpath "Kubernetes\Master\Master.vhdx"
            SecureBoot = $false
            EnableGuestService = $true
            ProcessorCount  = 2
            Generation      = 2
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            State           = "Running"
            WaitForIP       = $true
           # DependsOn       = '[xVHD]master'
        }
        xVMHyperV Worker02 {
            Name            = "K8sclu_Worker-02"
            SwitchName      = $vswitch
            VhdPath         = Join-Path $rootpath "Kubernetes\Worker02\Worker02.vhdx"
            ProcessorCount  = 2
            Generation      = 2
            SecureBoot = $false
            EnableGuestService = $true
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            WaitForIP       = $true
            State           = "Running"
            #DependsOn       = '[xVHD]Worker02'
        }
    }
}

CreateFolder -vhdsource 'C:\Users\Administrator\Documents\git\webcast\part1\packer\output-hyperv-iso\Virtual Hard Disks\ubuntu-bionic.vhdx' -rootpath "c:\" -vswitch 'packer-hyperv-iso' | out-null
Start-DscConfiguration -ComputerName localhost -Path  $pwd\CreateFolder -Wait -Verbose -f
