
$iso_path = "C:\Users\etienne_deneuve\Downloads\en_windows_server_version_1903_x64_dvd_58ddff4b.iso"
$root_vm_path = "C:\Users\etienne_deneuve\Documents\VM\windows2019.vhdx"

$vm_settings = @{
    "Name"               = "Windows 2019"
    "MemoryStartupBytes" = 2GB
    "Generation"         = 2
    "SwitchName"         = "External - Wire"
}

if (Test-Path($root_vm_path) ) {
    $vm_settings.Add("VHDPath", $root_vm_path)
	
}
else {
    $vm_settings.Add("NewVHDPath", $root_vm_path)
    $vm_settings.Add("NewVHDSizeBytes", 127GB)
}

$vm = New-VM @vm_settings 
$DVD = Add-VMDvdDrive -VMName $VM.VMName -Path $iso_path -Passthru
Set-VMFirmware -VM $VM -FirstBootDevice $DVD
Set-VMProcessor -ExposeVirtualizationExtensions $true -VM $vm
