#Gather data from winre
[string]$nfo = reagentc /info
if($nfo -match ".*Windows RE status:.*Enabled.*"){ #Verify if WINRE is enabled, if so proceed.
$nfo -match ".*Windows RE location.*harddisk(\d+)" | Out-Null #Locate the disk number it is on.
$disk = $Matches[1]
$nfo -match ".*Windows RE location.*partition(\d+)" | Out-Null #Locate the partition it is on.
$partition = $Matches[1]
New-Object -TypeName psobject -Property $([ordered]@{Enabled='True';Disk=$disk;Partition=$partition;Resizable=(((Get-Disk -Number $disk | Get-Partition).PartitionNumber | Measure-Object -Maximum).Maximum -eq $partition);CurrentSize=([string]((Get-Disk -Number $disk | Get-Partition | Where-Object PartitionNumber -eq $partition).Size / 1MB) +'MB');A1_Key=[System.GUID]::NewGuid()})
}else{
New-Object -TypeName psobject -Property $([ordered]@{Enabled='False';Disk='N/A';Partition='N/A';Resizable='N/A';CurrentSize='N/A';A1_Key=[System.GUID]::NewGuid()})
}