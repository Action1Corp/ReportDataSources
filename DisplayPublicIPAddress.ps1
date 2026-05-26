# Name: DisplayPublicIPAddress.ps1
# Description: Data source that uses ifconfig.me to query public IP address and showcase this in the Action1 reporting section

# Documentation: https://github.com/Action1Corp
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

$result = New-Object System.Collections.Arraylist;
$numerator = 0;

$myIP = (Invoke-Webrequest -uri "https://ifconfig.me/ip" -UseBasicParsing) | Select-Object Content

$myIP | ForEach-Object {
$currentOutput = "" | Select-Object content, A1_Key;
$currentoutput.content = $_.content;
$currentoutput.A1_Key = [string]$numerator + ':' + [string]($_.content);

$result.Add($currentOutput) | Out-Null;
$numerator = ($numerator + 1)
}
$result;
