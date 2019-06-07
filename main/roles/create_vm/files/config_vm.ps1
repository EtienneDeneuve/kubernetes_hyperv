param(
    $vms,
    $prefix,
    $vswitch,
    $rootpath
)

Configuration CreateVM
{
    param(
        $rootpath,
        $prefix,
        $vswitch,
        $vms
    )
    Import-DscResource -module xHyper-V
    node "localhost"
    {
        foreach ($vm in $vms) {
            xVMHyperV $vm {
                Name               = $($prefix + $vm)
                SwitchName         = $vswitch
                VhdPath         = Join-Path $rootpath "$($vm).vhdx"
                SecureBoot         = $false
                EnableGuestService = $true
                ProcessorCount     = 2
                Generation         = 2
                MaximumMemory      = 2GB
                MinimumMemory      = 512MB
                RestartIfNeeded    = $true
                State              = "Running"
                WaitForIP          = $true
            }
        }
         
    }
}

CreateVM -rootpath $rootpath -vms $vms -vswitch $vswitch | out-null
Start-DscConfiguration -ComputerName localhost -Path  $pwd\CreateFolder -Wait -Verbose -f
