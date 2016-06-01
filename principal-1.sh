#!/bin/bash

#P16. Escribe un script que se ejecute una vez al día en el equipo que realice una actualización de APT y envíe a root un informe con el resultado:
#    - No hay nada que actualizar.
#    - Hay actualizaciones pendientes de los paquetes: paq1, paq2, paq3, etc.

echo ""
echo "---------------------------"
echo "Script actualizacion apt."
echo "---------------------------"
echo ""

#comprobamos si es el usuario root el que ejecuta el script
if [ $(whoami) != "root" ]
then
	echo "Debes ejecutar el script como root."
	exit
else
	#comprobamos si tenemos instalado el paquete cron para realizar la actualización una vez al día 	automaticamente. 
	echo "Comprobando si está instalado el paquete cron...."
	state="Estado: instalado"

	estado=$(aptitude show cron | grep -iE '(estado)')


	if [[ $estado = $state ]]
	then
		echo "El programa ya está instalado"
		echo ""
	else
		echo "El programa no está instalado. ¿Quiere instalarlo?(S/N)"
		read instalacion
		if [[ "$instalacion" = "S" || "$instalacion" = "s" ]]
		then
			echo "Instalando el paquete cron...."
			apt-get install cron 
		elif [[ "$instalacion" = "N" || "$instalacion" = "n" ]]
		then
			echo ""
			echo "No se instalará el paquete cron y saldremos del script."
			echo ""
			exit
		else
			echo ""
			echo "Opción incorrecta. Saliendo del script..."
			echo ""
			exit
		fi
	fi
	#configuramos cron
	echo "Iniciando el programa cron..."
	systemctl enable cron
	echo "30 11 * * * root /home/usuario/actualizacion-2.sh" >> /etc/crontab 
	echo "Realizando actualizacion APT..."
	echo ""
fi

