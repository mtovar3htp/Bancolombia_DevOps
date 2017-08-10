<#
Activa el despliegue de un proceso de App y verifica si ya acabo el proceso en UCD

#>


#Pass arguments
[string] $authtoken = $args[0]
[string] $weburl  =  $args[1]
[string] $JSON_FILE = $args[2]
 
echo "Waiting for load version UCD..." 
Start-Sleep -s 5 
echo "Start process in UCD..." 
[string] $idrequest

function Get-logs {
Remove-Item appProcessRequest* -Recurse -Force
Remove-Item *.zip -Force
#Trae el ID del work flow para hacer la solicitud de los logs
$salida = cmd.exe /C curl -k -u PasswordIsAuthToken:$authtoken $weburl/cli/applicationProcessRequest/$idrequest | ConvertFrom-Json
$wfr = $salida.workflowTraceId
#echo $wfr

#Descarga logs
cmd.exe /C curl -LOk -u PasswordIsAuthToken:$authtoken $weburl/rest/workflow/$wfr/fullTraceWithLogs

#Cambia nombre de archivo descargado a .zip y se descomprime
cmd.exe /C REN fullTraceWithLogs fullTraceWithLogs.zip

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("E:\IBM\udclient\fullTraceWithLogs.zip", "E:\IBM\udclient")

#echo "SUCCESS"
#echo "More details in:"
#echo $weburl"/#applicationProcessRequest/"$idrequest
Start-Sleep -s 3

#Hace recorrido en los dir de los pasos y muestra los logs en pantalla
$table = get-childitem -recurse |  Where-Object { $_.Name -eq "stdOut.txt" }| where {! $_.PSIsContainer}
foreach($file in $table){
    echo "============================================================================================="
    echo $file.Directory
    echo "==============================================================================================="
    cat $file.FullName
}
echo "More details in:"
echo $weburl"/#applicationProcessRequest/"$idrequest
} 

If ($args.count -eq 3) {

Try
{
	$idrequest = $(.\..\..\udclient -authtoken $authtoken -weburl  $weburl requestApplicationProcess $JSON_FILE | %{$_.split(':')[1]} | %{$_ -replace '"', ''} | %{$_ -replace '}', ''} | %{$_ -replace ' ', ''})
	echo "Process Started ID :  $idrequest"
}
Catch
{
   echo "ERROR starting process UrbanCode"
   $ErrorMessage = $_.Exception.Message
   echo "The error message was $ErrorMessage"
   Exit(1)
}

DO {
$Output = .\..\..\udclient -authtoken $authtoken -weburl $weburl getApplicationProcessRequestStatus -request $idrequest
echo "Working..."
echo $Output

$REQUEST_STATE = ($Output | %{$_ -replace '{', ''} | %{$_ -replace '}', ''} | %{$_ -replace '"', ''} | %{$_ -replace ':', ''} | %{$_ -replace ',', ''} | %{$_ -replace '  ', ''} | %{$_ -replace "", ''} | %{$_ -replace 'status ', ''} | %{$_ -replace 'result ', ''})
$VAR = $REQUEST_STATE -join " " | %{$_.split(' ')[1]} 
Start-Sleep -s 7
} While ($VAR -ne "CLOSED")

#echo $VAR
$REQUEST_STATE2 = ($Output | %{$_ -replace '{', ''} | %{$_ -replace '}', ''} | %{$_ -replace '"', ''} | %{$_ -replace ':', ''} | %{$_ -replace ',', ''} | %{$_ -replace '  ', ''} | %{$_ -replace "", ''} | %{$_ -replace 'status ', ''} | %{$_ -replace 'result ', ''})
$VAR2 = $REQUEST_STATE2 -join " " | %{$_.split(' ')[2]} 
echo "FINAL STATUS: $VAR2"

if ($VAR2 -eq "SUCCEEDED"){
Get-logs
exit 0
} else {
#echo "FAILED"
Get-logs
exit 1
}

}
else{
echo "Missing parameters, please enter all parameters"
}