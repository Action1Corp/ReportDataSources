# Name: Detect_W10_ESU.ps1
# Description: Determine if the system has ESU licensing installed OR not and details about OS.
# Copyright (C) 2025 Action1 Corporation
# Documentation: https://github.com/Action1Corp/ReportDataSources
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# LIMITATION OF LIABILITY. IN NO EVENT SHALL ACTION1 OR ITS SUPPLIERS, OR THEIR RESPECTIVE 
# OFFICERS, DIRECTORS, EMPLOYEES, OR AGENTS BE LIABLE WITH RESPECT TO THE WEBSITE OR
# THE COMPONENTS OR THE SERVICES UNDER ANY CONTRACT, NEGLIGENCE, TORT, STRICT 
# LIABILITY OR OTHER LEGAL OR EQUITABLE THEORY (I)FOR ANY AMOUNT IN THE AGGREGATE IN
# EXCESS OF THE GREATER OF FEES PAID BY YOU THEREFOR OR $100; (II) FOR ANY INDIRECT,
# INCIDENTAL, PUNITIVE, OR CONSEQUENTIAL DAMAGES OF ANY KIND WHATSOEVER; (III) FOR
# DATA LOSS OR COST OF PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; OR (IV) FOR ANY
# MATTER BEYOND ACTION1'S REASONABLE CONTROL. SOME STATES DO NOT ALLOW THE
# EXCLUSION OR LIMITATION OF INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THE ABOVE
# LIMITATIONS AND EXCLUSIONS MAY NOT APPLY TO YOU.

$key = Get-CimInstance -ClassName SoftwareLicensingProduct |
       Where-Object { $_.Description -match "ESU" } |
       Select-Object Description, LicenseStatus, PartialProductKey

$comp = Get-ComputerInfo

 if($null -ne $key) {
     New-Object -Type PSCustomObject -Property $([ordered]@{
            "Name" = $comp.WindowsProductName
            "Version" = $comp.OsVersion
            "Release" = $comp.OsDisplayVersion
            "Edition" = $comp.WindowsEditionId
            "Description" = ($Key.Description)
            "LicenseStatus" = ($Key.LicenseStatus)
            "PartialProductKey" = ($Key.PartialProductKey)
            A1_Key              = "$($env:COMPUTERNAME)"
        })
    }else{
     New-Object -Type PSCustomObject -Property $([ordered]@{
            "Name" = $comp.WindowsProductName
            "Version" = $comp.OsVersion
            "Release" = $comp.OsDisplayVersion
            "Edition" = $comp.WindowsEditionId
            "Description" = ("NO ESU Applied")
            "LicenseStatus" = ("N/A")
            "PartialProductKey" = ("N/A")
            A1_Key              = "$($env:COMPUTERNAME)"
        })
    }
