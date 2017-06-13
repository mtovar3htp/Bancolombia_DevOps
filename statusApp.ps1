<#
Este script activa el despliegue de un proceso de App
Ejemplo con un Componente:

  /createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3 

  Ejemplo con más de un componente:
 /createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3 ComponenteWeb 1.1
#>

#Pass arguments
[string] $authtoken = $args[0]
[string] $weburl  =  $args[1]
[string] $JSON_FILE = $args[2]


$idrequest = $(.\..\..\..\..\udclient\udclient -authtoken $authtoken -weburl  $weburl requestApplicationProcess $JSON_FILE | %{$_.split(':')[1]} | %{$_ -replace '"', ''} | %{$_ -replace '}', ''} | %{$_ -replace ' ', ''})
Write-Host $idrequest

DO {
$REQUEST_STATE = (.\..\..\..\..\udclient\udclient -authtoken $authtoken -weburl  $weburl getApplicationProcessRequestStatus -request $idrequest | %{$_ -replace '{', ''} | %{$_ -replace '}', ''} | %{$_ -replace '"', ''} | %{$_ -replace ':', ''} | %{$_ -replace ',', ''} | %{$_ -replace '  ', ''} | %{$_ -replace "", ''} | %{$_ -replace 'status ', ''} | %{$_ -replace 'result ', ''})
$VAR = $REQUEST_STATE -join " " | %{$_.split(' ')[1]} 
echo "Working..."
Start-Sleep -s 7
} While ($VAR -ne "CLOSED")

echo $VAR
$REQUEST_STATE2 = (.\..\..\..\..\udclient\udclient -authtoken $authtoken -weburl  $weburl getApplicationProcessRequestStatus -request $idrequest | %{$_ -replace '{', ''} | %{$_ -replace '}', ''} | %{$_ -replace '"', ''} | %{$_ -replace ':', ''} | %{$_ -replace ',', ''} | %{$_ -replace '  ', ''} | %{$_ -replace "", ''} | %{$_ -replace 'status ', ''} | %{$_ -replace 'result ', ''})
$VAR2 = $REQUEST_STATE2 -join " " | %{$_.split(' ')[2]} 
echo $VAR2

if ($VAR2 -eq "SUCCEEDED"){
#echo "SUCCESS"
exit 0
} else {
#echo "FAILED"
exit 1
}
