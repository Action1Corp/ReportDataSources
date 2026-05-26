# Name: DellWarrantyCheck.ps1
# Description: Will check against Dell's API and present Warranty information on your Dell devices

# Documentation: https://www.action1.com/documentation/data-sources/
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

# MAKE SURE TO INSERT DELL API AND SECRET BELOW

# Obtain system details
$manufacturer = (Get-CimInstance Win32_ComputerSystem).Manufacturer
$serviceTag = (Get-CimInstance Win32_BIOS).SerialNumber

if ($manufacturer -notlike "*Dell*") {
    Write-Host "This system is not a Dell machine. No warranty data retrieved."
    return
}

# Replace with valid credentials and endpoints as needed
$ClientID = "InsertID"
$ClientSecret = "InsertSecret"
$AuthUrl = "https://apigtwb2c.us.dell.com/auth/oauth/v2/token"
$WarrantyUrl = "https://apigtwb2c.us.dell.com/PROD/sbil/eapi/v5/asset-entitlements?servicetags=$serviceTag"

$result = New-Object System.Collections.ArrayList

try {
    # Obtain OAuth token
    $Body = "client_id=$ClientID&client_secret=$ClientSecret&grant_type=client_credentials"
    $TokenResponse = Invoke-RestMethod -Method POST -Uri $AuthUrl -Body $Body -ContentType "application/x-www-form-urlencoded" -ErrorAction Stop
    $AccessToken = $TokenResponse.access_token
} catch {
    Write-Host "Failed to retrieve OAuth token."
    return
}

$Headers = @{
    Authorization = "Bearer $AccessToken"
    Accept        = "application/json"
}

try {
    # Retrieve warranty data
    $WarrantyResponse = Invoke-RestMethod -Method GET -Uri $WarrantyUrl -Headers $Headers -ErrorAction Stop
} catch {
    Write-Host "Failed to retrieve warranty information."
    return
}

# Ensure the response is an array
if ($WarrantyResponse -isnot [System.Collections.IEnumerable]) {
    $WarrantyResponse = @($WarrantyResponse)
}

foreach ($Asset in $WarrantyResponse) {
    if ($Asset.invalid -eq $true) {
        # If invalid, we skip this asset
        continue
    }

    $Entitlements = $Asset.entitlements
    if ($Entitlements) {
        foreach ($E in $Entitlements) {
            # Include A1_Key field in the output
            $currentOutput = "" | Select-Object "Service Tag", "Warranty Description", "Start Date", "End Date", "Entitlement Type", A1_Key
            $currentOutput."Service Tag" = $Asset.serviceTag
            $currentOutput."Warranty Description" = $E.serviceLevelDescription
            $currentOutput."Start Date" = $E.startDate
            $currentOutput."End Date" = $E.endDate
            $currentOutput."Entitlement Type" = $E.entitlementType
            # Match A1_Key to the service tag
            $currentOutput.A1_Key = $Asset.serviceTag
            
            $result.Add($currentOutput) | Out-Null
        }
    } else {
        # If no entitlements, still output a line with A1_Key
        $currentOutput = "" | Select-Object "Service Tag", "Warranty Description", "Start Date", "End Date", "Entitlement Type", A1_Key
        $currentOutput."Service Tag" = $serviceTag
        $currentOutput."Warranty Description" = "No entitlements found"
        $currentOutput."Start Date" = ""
        $currentOutput."End Date" = ""
        $currentOutput."Entitlement Type" = ""
        $currentOutput.A1_Key = $serviceTag
        
        $result.Add($currentOutput) | Out-Null
    }
}

$result
