# Name: Detect Local Admin Solution.ps1
# Description: Detect use of tool to create local admin account to use with remote access, that auto disables on first use. (Or any other account and status.)

# Documentation: https://github.com/Action1Corp/ReportDataSources
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

$U = "A1Admin"
($(Invoke-Expression "net user $U") -split '`n') | %{if($_ -match "^Account|^Password|^Last"){$V=($_ -split '\ \ +');New-Object -TypeName psobject -Property $([ordered]@{Attribute=$V[0];Value=$V[1];A1_Key=$V[0]})}}
