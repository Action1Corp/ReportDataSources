# Name: Detect_W10_ESU.ps1
# Description: Determine if the system has ESU licensing installed OR not and details about OS.

# Documentation: https://github.com/Action1Corp/ReportDataSources
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

function ConvertTo-DateTime {
    param (
        [Parameter(Mandatory)]
        [string]$Value,
        [Parameter(Mandatory)]
        [string]$Format,
        [Parameter(Mandatory)]
        [ValidateSet("Local", "UTC")]
        [string]$TimeZone
    )
    try {
        $current_culture = Get-Culture -ErrorAction Stop
        $current_culture_date_time = [datetime]::Parse($Value, $current_culture)
        if ($TimeZone -ceq 'UTC') {
            $current_culture_date_time = $current_culture_date_time.ToUniversalTime()
        }
        if ($current_culture.LCID -ne 1033) {
            $en_us_culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('en-US')
            $formatted_date_time = $current_culture_date_time.ToString($Format, $en_us_culture)
        }
        else {
            $formatted_date_time = $current_culture_date_time.ToString($Format)
        }

        return $formatted_date_time
    }
    catch {}
}

function Get-ESUEligibilityDescription {
    param (
        [Parameter(Mandatory = $true)]
        [int]$ESUEligibility
    )

    $ESUEligibilityDescription = "Unknown"

    switch ($ESUEligibility) {
        0 { $ESUEligibilityDescription = "Unknown. Feature is not enabled." }
        1 { $ESUEligibilityDescription = "Ineligible" }
        2 { $ESUEligibilityDescription = "Eligible" }
        3 { $ESUEligibilityDescription = "Device Enrolled" }
        5 { $ESUEligibilityDescription = "MSA Enrolled" }
        8 { $ESUEligibilityDescription = "Login with Primary Account to Enroll" }
        default { $ESUEligibilityDescription = "Unrecognized value: $ESUEligibility" }
    }

    return $ESUEligibilityDescription
}

function Get-ESUEligibilityResultDescription {
    param (
        [Parameter(Mandatory = $true)]
        [int]$ESUEligibilityResult
    )

    $ESUEligibilityResultDescription = "Unknown"

    switch ($ESUEligibilityResult) {
        1 { $ESUEligibilityResultDescription = "Success" }
        3 { $ESUEligibilityResultDescription = "Non-Consumer Edition" }
        4 { $ESUEligibilityResultDescription = "Commercial Device" }
        5 { $ESUEligibilityResultDescription = "Non-Admin Account" }
        6 { $ESUEligibilityResultDescription = "Child Account" }
        7 { $ESUEligibilityResultDescription = "User Region is Embargoed" }
        8 { $ESUEligibilityResultDescription = "Azure Device" }
       11 { $ESUEligibilityResultDescription = "Unknown. Feature is not enabled." }
        default { $ESUEligibilityResultDescription = "Unrecognized value: $ESUEligibility" }
    }

    return $ESUEligibilityResultDescription
}

Start-Process -FilePath "$env:SystemRoot\System32\ClipESUConsumer.exe" -ArgumentList "-evaluateEligibility" -Wait -NoNewWindow

$result = New-Object System.Collections.ArrayList;
$currentOutput = "" | Select-Object "Endpoint Name", "ESUEligibility", "ESUEligibilityResult", "Timestamp", A1_Key;
$currentOutput."Endpoint Name" = $env:COMPUTERNAME;


$regPath = "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\ConsumerESU"
$values = Get-ItemProperty -Path $regPath -Name ESUEligibility, ESUEligibilityResult -ErrorAction SilentlyContinue

if ($values) {

	$currentOutput."ESUEligibility" = Get-ESUEligibilityDescription -ESUEligibility $values.ESUEligibility
	$currentOutput."ESUEligibilityResult" = Get-ESUEligibilityResultDescription -ESUEligibilityResult $values.ESUEligibilityResult
		
} else {
    $currentOutput."ESUEligibilityResult" = $currentOutput."ESUEligibility" = "The ConsumerESU registry path or values were not found.";
}

$date_time_now = [datetime]::Now.ToLocalTime()
$execution_date_time_format = 'MMM dd, yyyy hh:mm:ss tt zzz'
$currentOutput."Timestamp" = ConvertTo-DateTime -Value $date_time_now.ToString() -Format $execution_date_time_format -TimeZone Local


$currentOutput.A1_Key = $env:COMPUTERNAME;

$result.Add($currentOutput) | Out-Null;

$result;
