#!/bin/bash
#
# Este script genera un JSON llamado app.json el cual es utilizado para realizar ejecuciones de UCD via UDCliente
#
#
#
#
# params:
#  1 = Name Application UCD
#  2 = Name Process Application UCD
#  3 = Enviroment Process Aplication UCD
#  
#  4 = Componente
#  5 = version
#  
#  para más de un componente se deben agregar más parametros en el orden Componente  Version
#
#
#  Ejemplo con un Componente:
#
#  ./createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3 
#
#  Ejemplo con más de un componente:
#
#
#
#  ./createJson.sh AplicacionTest ProcessDeploy Development componenteSQL 2.3 ComponenteWeb 1.1
#
###########################################################################################################################

app=$1
process=$2
enviroment=$3
component=$4
version=$5

total_args=$#
#echo $total_args
echo "ejecutando script $0"
if [ $total_args -eq 5 ];then
	#echo "vamos a generar con estos datos : $app - $process - $component - $version - $enviroment"
    echo "{" > app.json
    echo "\"application\": \"$app\"," >> app.json
    echo "\"applicationProcess\": \"$process\"," >> app.json
    echo "\"environment\": \"$enviroment\","  >> app.json
    echo "\"onlyChanged\": \"true\","   >> app.json
    echo "\"versions\": [{" >> app.json
    echo "    \"component\": \"$component\"," >>  app.json
    echo "    \"version\": \"$version\"" >>  app.json
    echo "  }]" >>  app.json
    echo "}" >>  app.json
elif [ $total_args -gt 5 ];then
	#echo "Mas de 5"
	#echo "vamos a generar con estos datos : $app - $process - $component - $version - $enviroment"
    echo "{" > app.json
    echo "\"application\": \"$app\"," >> app.json
    echo "\"applicationProcess\": \"$process\"," >> app.json
    echo "\"environment\": \"$enviroment\","  >> app.json
    echo "\"onlyChanged\": \"true\","   >> app.json
    echo "\"versions\": [{" >> app.json
	i=1
	p=0
	array_tot=$@
	for param in $array_tot
	do
		
		if [ $i -gt 3 ]; then
		  #echo -e "\tParámetro : $param - $i"
		  
		  if [ $p -eq 0 ]; then
		  	echo "    \"component\": \"$param\"," >>  app.json
			p=`expr $i + 1`
		  else
			  if [ $i -eq $total_args ]; then
				  echo "    \"version\": \"$param\"" >>  app.json
			  else
				  echo "    \"version\": \"$param\"," >>  app.json
			  fi
		   p=0
		  fi
		  
		fi
		i=`expr $i + 1`
	done
    echo "  }]" >>  app.json
    echo "}" >>  app.json	
	
else
    echo "No puede traer menos de 5 paramentros"
fi

cat app.json