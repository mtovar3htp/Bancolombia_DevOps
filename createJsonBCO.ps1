<# Este script genera un JSON llamado app.json el cual es utilizado para realizar ejecuciones de UCD via UDCliente
 
params:
  1 = Name Application UCD
  2 = Name Process Application UCD
  3 = Enviroment Process Aplication UCD
  4 = Componente
  5 = version
 
  para más de un componente se deben agregar más parametros en el orden Componente  Version
 
  Ejemplo con un Componente:
 
  /createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3
 
  Ejemplo con más de un componente:
/createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3 ComponenteWeb 1.1
#>
 
 
#Write-Host "total params : " + $args.count
 
if (Test-Path app.json) {rm app.json}
[string] $app_ucd = $args[0]
[string] $prc_app =  $args[1]
[string] $enviroment = $args[2]
[string] $component1 =  $args[3]
[string] $version1 = $args[4]
 
[string] $json
 
If ($args.count -eq 5) {
                #Write-Host "SOLO UN COMPONENTE"
                #Write-Host "{"
                $json = "{"
    #Write-Host """application"": ""$app_ucd"","
                $json = $json +  """application"": ""$app_ucd"","
    #Write-Host """applicationProcess"": ""$prc_app"","
                $json = $json +  """applicationProcess"": ""$prc_app"","
    #Write-Host """environment"": ""$enviroment""," 
    $json = $json +     """environment"": ""$enviroment""," 
    #Write-Host """onlyChanged"": ""true""," 
    $json = $json +  """onlyChanged"": ""true""," 
    #Write-Host """versions"": [{"""
                $json = $json + """versions"": [{"
    #Write-Host """component"": ""$component"","
    $json = $json + """component"": ""$component3"","
    #Write-Host """version"": ""$version""" 
                $json = $json + """version"": ""$version3""" 
    #Write-Host "  }]"
                $json = $json + "  }]"
    #Write-Host "}"
                $json = $json + "}"
                }
	else {
		Write-Host "Error, the parameters is not completed" 
	}
                #Write-Host "Variable" + $json
               
                #New-Item E:\IBM\udclient\app.json -type file
                Add-content app.json $json
                if(Test-Path app.json){Write-Host "File created in D:\devops\udclient\script\app.json"}
                
	