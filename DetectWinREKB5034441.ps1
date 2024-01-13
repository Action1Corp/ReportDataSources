# Name: DetectWinREKB5034441.ps1
# Description: Data Source used to identify systems for WinRe Fix
# Copyright (C) 2024 Action1 Corporation
# Documentation: https://github.com/Action1Corp/PSAction1/
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# LIMITATION OF LIABILITY. IN NO EVENT SHALL ACTION1 OR ITS SUPPLIERS, OR THEIR RESPECTIVE 
# OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE WITH RESPECT TO THE WEBSITE OR
# THE COMPONENTS OR THE SERVICES UNDER ANY CONTRACT, NEGLIGENCE, TORT, STRICT 
# LIABILITY OR OTHER LEGAL OR EQUITABLE THEORY (I)FOR ANY AMOUNT IN THE AGGREGATE IN
# EXCESS OF THE GREATER OF FEES PAID BY YOU THEREFOR OR $100; (II) FOR ANY INDIRECT,
# INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY KIND WHATSOEVER; (III) FOR
# DATA LOSS OR COST OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; OR (IV) FOR ANY
# MATTER BEYOND ACTION1 S REASONABLE CONTROL. SOME STATES DO NOT ALLOW THE
# EXCLUSION OR LIMITATION OF INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THE ABOVE
# LIMITATIONS AND EXCLUSIONS MAY NOT APPLY TO YOU.


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
