# Name: Detect possible remote control agents, add/remove as needed.
# Description: A comprehensive but not exhaustive list of potential remote control agents on endpoints.

# Documentation: https://github.com/Action1Corp
# Use Action1 Roadmap system (https://roadmap.action1.com/) to submit feedback or enhancement requests.

# WARNING: Carefully study the provided scripts and components before using them. Test in your non-production lab first.

# Action1 Public Repository Material
# Subject to TERMS_OF_USE.md (https://github.com/Action1Corp/PSAction1/blob/main/TERMS_OF_USE.md)
# Provided AS IS
# Use at your own risk
# Review and test before production deployment
# © Action1 Corporation

$return = @()
$ignore = @('action1_agent.exe','system idle process','system','registry')

try{$data = Invoke-WebRequest -UseBasicParsing -Uri https://raw.githubusercontent.com/Action1Corp/Remote-Agent-Catalog/main/rmm.csv}
    Catch{
        $return = New-Object psobject -Property  ([ordered]@{Message="Error downloading list: $($_). Scan aborted.";
                                                                  Product="";
                                                                  ProcessName="";
                                                                  Version="";
                                                                  PID="";
                                                                  MD5Hash="";
                                                                  A1_Key="default"})
    }

if (-not ($data -eq $null)){
    $products = (($data).Content | `
                 ConvertFrom-Csv) | `
                 select Software, Executables | `
                 Where-Object {$_.Executables -ne ''}

    $processes = Get-WmiObject Win32_Process | Where-Object {-not ($ignore -contains $_.Name)}


    Foreach ($process in $processes){
        Foreach($product in $products){
            $bins = $product.Executables -Split ','
            foreach($bin in $bins){
             if($process.Name -like $bin){
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
}

if($return.Length -eq 0){$return = New-Object psobject -Property  ([ordered]@{Message="No remote control applications found.";
                                                                  Product="";
                                                                  ProcessName="";
                                                                  Version="";
                                                                  PID="";
                                                                  MD5Hash="";
                                                                  A1_Key="default"})
}

$return
