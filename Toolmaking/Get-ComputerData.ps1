Function Get-ComputerData {
    [cmdletbinding()]
    param( [string[]]$ComputerName )


    foreach ($computer in $computerName) {
    Write-Verbose "Getting data from $computer"
    Write-Verbose "Win32_Computersystem"
 
    $cs = Get-WmiObject -Class Win32_Computersystem -ComputerName $Computer
    $bios = Get-WmiObject -Class Win32_Bios -ComputerName $Computer 
    $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $Computer
         
         #decode the admin password status
         Switch ($cs.AdminPasswordStatus) {
             1 { $aps="Disabled" }
             2 { $aps="Enabled" }
             3 { $aps="NA" }
             4 { $aps="Unknown" }
         }
 
         #Define a hashtable to be used for property names and values
         [pscustomobject]@{
         Computername=$cs.Name
         Workgroup=$cs.WorkGroup
         AdminPassword=$aps
         Model=$cs.Model
         Manufacturer=$cs.Manufacturer
         "SerialNumber"=$bios.SerialNumber
         OS = $os.Version
         ServicePackMajorVersion=$os.ServicePackMajorVersion
         }


} #foreach
}
Get-Computerdata -computername WL301514,localhost | export-csv c:\temp\CompData.csv -NoTypeInformation