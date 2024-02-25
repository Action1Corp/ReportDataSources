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
$agents = @('AeroAdmin','AgentMon','Ammyy','AnyDesk','Atera','AteraAgent','AteraRC','Auvik.Agent','Auvik.Engine','awesome-rat','ccme_sm','chaos','Chrome Remote Desktop','ConnectWise','DameWare Mini Remote Control','Dameware','Deployment tools','Domotz','DomotzClient','eHorus','Fixme','FlawedAmmyy','friendspeak','Get2','getandgo','GetASRSettings','GoToAssist','Intelliadmin','ir_agent','klnagent','konea','kworking','LogMeIn','LogMeIn','LTAService','LTClient','LTSvcMon','MeshCentral','mRemoteNG','NAPClt','NetSupport','ngrok','NinjaRMM','NinjaRMM','NinjaRMMAgent','nssm','OCS Agent','PDQDeploy','Plink','Pulseway.TrayApp','PulsewayService','putty','QuickAssist','BASupSrvc','BASupSrvcCnfg','Radmin','RealVNC','Remote Manipulator System','Remote Utilities','RemotePC','rustdesk','ScreenConnect.Client','ScreenConnect.ClientService','ScreenConnect.Service','ScreenConnect.WindowsClient','ScreenConnect','Splashtop','SRAgent','SRUtility','SupRemo','Syncro','tacticalrmm','TacticalRMM','TakeControlRDViewer','Tanium','teamviewer','TigerVNC','TightVNC','tmate','UltraViewer','VncClient','VNCconnect','WAPT','Webex remote','winvnc','ZA_Connect','za_access_my_department','ZohoAssist')
foreach ($process in $(Get-Process)){
    foreach ($agent in $agents) {
        if ($process.ProcessName -like "*$agent*"){$return += New-Object -TypeName psobject -Property $([ordered]@{message="Potential suspicious process found: $($process.ProcessName)";A1_Key='AgentSearch'})}
    }
}
if($return.Count -eq 0){$return += New-Object -TypeName psobject -Property $([ordered]@{message='No suspicious process found.';A1_Key='AgentSearch'})}
$return
