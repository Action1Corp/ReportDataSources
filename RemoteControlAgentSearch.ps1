# Name: Detect possible remote control agents, add/remove as needed.
# Description: A comprehensive but not exhaustive list of potential remote control agents on endpoints.
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

$return = @()
$agents = @('aeroadmin','agentmon','ammyy','anydesk','atera','auvik','awesome-rat','basup','ccme_sm','chaos','chrome remote desktop','connectwise','dameware','deployment tools','domotz','ehorus','fixme','flawedammyy','friendspeak','get2','getandgo','getasrsettings','goto','intelliadmin','ir_agent','klnagent','konea','kworking','logmein','ltaservice','ltclient','ltsvcmon','meshcentral','mremoteng','napclt','netsupport','ngrok','ninja','nssm','ocs agent','pdqdeploy','plink','pulseway','putty','quickassist','radmin','remote','rustdesk','screenconnect','splashtop','sragent','srutility','supremo','syncro','tacticalrmm','takecontrolrdviewer','tanium','teamviewer','tmate','ultraviewer','vnc','wapt','webex','za_access_my_department','za_connect','zohoassist')
foreach ($process in $(Get-Process)){
    foreach ($agent in $agents) {
        if ($process.ProcessName -like "*$agent*"){$return += New-Object -TypeName psobject -Property $([ordered]@{message="Potential suspicious process found: $($process.ProcessName)";A1_Key='AgentSearch'})}
    }
}
if($return.Count -eq 0){$return += New-Object -TypeName psobject -Property $([ordered]@{message='No suspicious process found.';A1_Key='AgentSearch'})}
$return
