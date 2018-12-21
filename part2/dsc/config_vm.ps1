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
