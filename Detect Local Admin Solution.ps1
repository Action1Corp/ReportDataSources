$U = "A1Admin"
($(Invoke-Expression -Command "net user $U") -split '`n') | %{if($_ -match "^Account|^Password|^Last"){$kvp=($_ -split '\ \ +');New-Object -TypeName psobject -Property $([ordered]@{Attribute=$kvp[0];Value=$kvp[1];A1_Key=[System.GUID]::NewGuid()})}}
