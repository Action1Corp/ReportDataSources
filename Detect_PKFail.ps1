# Name: Detect_PKFail.ps1
# Description: Detects use of the compromised AMI trusted root anchor keys in system's UEFI firmware.

# Documentation: https://github.com/Action1Corp/ReportDataSources
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

try
{
    $SecureBootUEFI = [System.Text.Encoding]::ASCII.GetString((Get-SecureBootUEFI PK -ErrorAction Stop).bytes) -match "DO NOT TRUST|DO NOT SHIP"
  }catch{
    $SecureBootUEFI="Error getting SecureBootUEFI information."
  }

  New-Object -Type PSCustomObject -Property $([ordered]@{
                     ISVulnerable=$SecureBootUEFI
                     A1_Key = "$($env:COMPUTERNAME)_SecureBootUEFI"
                    })