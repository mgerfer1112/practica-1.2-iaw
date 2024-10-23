#!/bin/bash

#Para importar las variables.
source .env

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

#Descargamos el tar en /var/www/html. Con -C elegimos la ruta en la que lo queremos descomprimir.
sudo tar xvf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html

#Eliminamos el archivo tar .gz Para no dejar archivos basura.
rm -rf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz

#Eliminamos instalaciones previas de phpMyAdmin
rm -rf /var/www/html/phpmyadmin

#Renombramos el nombre del directorio de phpMyAdmin
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin

#Cambiamos el propietario y el grupo del directorio.
chown -R apache:apache /var/www/html

#Creamos el archivo de configuración a partir del archivo de ejemplo config.sample.inc.php.
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php

#De momento dejamos esto sin hacer para ver por qué nos hace falta. Nos camos a la configuración de la base dee datos de phpMyAdmin
#esto es un array accederemos mediante una clave
#cfg es la variable.
#No usamos nano porque lo queremos automatizar.
#vamos a utilizar la herramienta sed.
#-i hace que los cambios se guarden dentro del archivo.
#este archivo sudo cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
#Al poner \$ ya no considera al dolar como un caracter especial.

sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php

#Creación de la base de datos phpMyAdmin
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql

#Ahora solos faltaría tener usuarios.
#Definiremos estas variables en un .env
#3PMA_USER=pma_user
#PMA_PASS=pma_pass
#PMA_DB=phpmyadmin  -- es el nombre de usuario de phpMyadmin, si quiero tener acceso a todas tendría que ser root.

mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"
mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"


RANDOM_VALUE=`openssl rand -hex 16`

#
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php

#Añadimos la configuración del directorio temporal.
sed -i "/blowfish_secret/a \$cfg\['TempDir'\] = '/tmp' /var/www/html/phpmyadmin/config.inc.php;