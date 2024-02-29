# Name: DisplayPublicIPAddress.ps1
# Description: Data source that uses ifconfig.me to query public IP address and showcase this in the Action1 reporting section
# Copyright (C) 2024 Action1 Corporation
# Documentation: https://github.com/Action1Corp
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
