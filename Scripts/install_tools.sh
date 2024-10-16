#/bin/bash

#Configuramos para mostrar los comandos del script y 
#para que la ejecución se detenga cuando hay un error.
set -ex

#Actualizamos los paquetes del sistema.
dnf update -y

#Instalamos las dependencias necesarias para phpMyAdmin
sudo dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y

#Reiniciamos el servicio de apache
systemctl restart httpd

#Instalamos la herramienta wget
sudo dnf install wget -y

#Descargamos el codigo fuente de phpMyAdmin
sudo wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -P /var/www/html

#Descargamos el tar en /var/www/html
sudo tar xvf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html

#Eliminamos el archivo tar .gz
rm -rf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz

#Eliminamos instalaciones previas de phpMyAdmin
rm -rf /var/www/html/phpmyadmin

#Renombramos el nombre del directorio de phpMyAdmin
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

#Cambiamos el propietario y el grupo del directorio.
sudo chown -R apache:apache /var/www/html
