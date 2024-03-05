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
$ignore = @('system idle process','system','registry')
$products = ((Invoke-WebRequest -Uri https://raw.githubusercontent.com/Action1Corp/Remote-Agent-Catalog/main/rmm.csv -UseBasicParsing).Content | `
             ConvertFrom-Csv) | `
             select Software, Executables | `
             Where-Object {$_.Executables -ne ''}

$processes = Get-WmiObject Win32_Process | Where-Object {-not ($ignore -contains $_.Name)}


Foreach ($process in $processes){
    Foreach($product in $products){
        $bins = $product.Executables -Split ','
        foreach($bin in $bins){
         if($bin -like $process.Name){
            $return += New-Object psobject -Property  ([ordered]@{Message="Found possible remote control application.";
                                                                  Product=$product.Software;
                                                                  ProcessName=$process.Name;
                                                                  Version=(Get-Process -Id $process.ProcessId -FileVersionInfo).FileVersion;
                                                                  PID=$process.ProcessId;
                                                                  MD5Hash=(Get-FileHash -Path (Get-Process -Id $process.ProcessId -FileVersionInfo).FileName -Algorithm MD5).Hash;
                                                                  A1_Key=$process.Name})
         }
        }
    }
}
if($return.Length -eq 0){$return += New-Object psobject -Property  ([ordered]@{Message="No remote control applications found.";
                                                                  Product='';
                                                                  ProcessName='';
                                                                  Version='';
                                                                  PID='';
                                                                  MD5Hash='';
                                                                  A1_Key='default'})
}

$return
