#/bin/bash

#Configuramos para mostrar los comandos del script y 
#para que la ejecución se detenga cuando hay un error.
set -ex

#Actualizamos los paquetes del sistema.
dnf update -y

# !! Instalación de Apache.

#Instalamos el paquete del servidor web Apache.
sudo dnf install httpd -y

#En este momento el servicio no está iniciada, no es automático.
#Por ello hemos de iniciarlo de forma explícita.
sudo systemctl start httpd

#Habilitamos el servicio para que se inicie automáticamente 
#dspués de cada inicio.
sudo systemctl enable httpd

# /usr/lib/systemd/system/httpd.service. se crea un url simbólico en el que
#se alojan todos los servicios que se inician automáticamente.

# !! Instalación de MySQL servr.

#Instalamos MySQL Server
sudo dnf install mysql-server -y

#Iniciamos el servicio.
sudo systemctl start mysqld

#Habilitamos que se inicie después de cada reinicio.
sudo systemctl enable mysqld

systemctl restart httpd

cp ../php/index.php /var/www/html