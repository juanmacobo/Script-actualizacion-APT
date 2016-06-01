#!/bin/bash

#P16. Escribe un script que se ejecute una vez al día en el equipo que realice una actualización de APT y envíe a root un informe con el resultado:
#    - No hay nada que actualizar.
#    - Hay actualizaciones pendientes de los paquetes: paq1, paq2, paq3, etc.

#comprobamos si es el usuario root el que ejecuta el script
if [ $(whoami) != "root" ]
then
	echo "Debes ejecutar el script como root."
	exit
else	
	
	#comprobamos si tenemos instalado el paquete mailutils para enviar un informe a root con el 		resultado de la actualización.. 
	echo "Comprobando si está instalado el paquete mailutils...."
	state="Estado: instalado"

	estado=$(aptitude show mailutils | grep -iE '(estado)')


	if [[ $estado = $state ]]
	then
		echo "El programa ya está instalado"
		echo ""
	else
		echo "El programa no está instalado. ¿Quiere instalarlo?(S/N)"
		read instalacion
		if [[ "$instalacion" = "S" || "$instalacion" = "s" ]]
		then
			echo "Instalando el paquete mailutils...."
			apt-get -y install mailutils
		elif [[ "$instalacion" = "N" || "$instalacion" = "n" ]]
		then
			echo ""
			echo "No se instalará el paquete mailutils y no podremos mandarle el informe a root. 				Saldremos del script."
			echo ""
			exit
		else
			echo ""
			echo "Opción incorrecta. Saliendo del script..."
			echo ""
			exit
		fi
	fi


	#realizamos la actualización apt.
	echo "Resultado de la actualización apt:"
	actualizaciones=$(apt-get upgrade -s -u | grep -v ':' | grep -v '^Leyendo' | grep -v 'Creando' | grep -v 'Conf' | grep -v 'Inst')

	#vemos el resultado y le mandamos un correo a root.
	mensaje="Actualizacion APT"

	siactualizaciones=$(apt-get -s -u upgrade | grep -v ':' | grep -v '^Leyendo' | grep -v 'Creando' | grep -v 'Conf' | grep -v 'Inst' | sed '/^[0-9]/d')

	noactualizaciones=$(apt-get -s -u upgrade | grep -v ':' | grep -v '^Leyendo' | grep -v 'Creando' | grep -v 'Conf' | grep -v 'Inst' | cut -d " " -f 1 | sed '/^[A-Z,a-z]/d')


	echo ""
	if [ $noactualizaciones -eq "0" ]
	then
		echo "Enviando mail a root..."
		echo ""
		echo "No hay nada que actualizar." | mail -s "$mensaje" root
	else
		echo "Enviando mail a root..."
		echo ""
		echo "Hay actualizaciones pendientes de los paquetes:  $siactualizaciones" | mail -s "$mensaje" root
	fi
fi

