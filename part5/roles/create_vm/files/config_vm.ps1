param(
$vswitch,
$rootpath
)

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
            VhdPath         = Join-Path $rootpath "\Master\Master.vhdx"
            SecureBoot = $false
            EnableGuestService = $true
            ProcessorCount  = 2
            Generation      = 2
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            State           = "Running"
            WaitForIP       = $true
        }
                xVMHyperV Worker01 {
            Name            = "K8sclu_Worker-01"
            SwitchName      = $vswitch
            ProcessorCount  = 2
            VhdPath         = Join-Path $rootpath "\Worker01\Worker01.vhdx"
            Generation      = 2
            EnableGuestService = $true
            State           = "Running"
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            WaitForIP       = $WaitForIP
            SecureBoot = $false
    }
        xVMHyperV Worker02 {
            Name            = "K8sclu_Worker-02"
            SwitchName      = $vswitch
            VhdPath         = Join-Path $rootpath "\Worker02\Worker02.vhdx"
            ProcessorCount  = 2
            Generation      = 2
            SecureBoot = $false
            EnableGuestService = $true
            MaximumMemory   = 2GB
            MinimumMemory   = 512MB
            RestartIfNeeded = $true
            WaitForIP       = $true
            State           = "Running"
        }
    }
}

CreateFolder -rootpath $rootpath -vswitch $vswitch | out-null
Start-DscConfiguration -ComputerName localhost -Path  $pwd\CreateFolder -Wait -Verbose -f
