# practica-1.2-iaw

La siguiente práctica tiene numerosas similitudes con la anterior [practica 1.1](https://github.com/mgerfer1112/practica-iaw-1.1/blob/main/README.md?plain=1) . Si bien podríamos describir el proceso paso a paso, voy a centrarme en destacar las principales diferencias entre ambas prácticas para evitar redundancias.

De esta manera, se optimiza la comprensión de los cambios clave sin reiterar procesos ya explicados.

# Creación de una instancia en AWS.

¡Ya sabemos crear una instancia! No obstante, en este caso, habrán pequeñas diferencias ya que vamos a trabajar con Red Hat.

Tal y como hicimos en la práctica anterior, para la creación de una nueva instancia solo tendremos que seleccionar la opción *nueva instancia*.

Los parámetros que configuraremos serán los siguientes:

**Nombre** El nombre no es determinante, pero un nombre capaz de identificar el propósito de la instancia en cuestión nos ayudará en un futuro. En mi caso la he llamado *practica 1.2*.

**Imagen de aplicaciones y sistemas operativos** En este caso elegiremos, tal y como hemos mencionado en la introducción, la opción **Red Hat Enterprise Linux 9 (HVM), SSD Volume Type**. Apto para la capa gratuita.

**Par de claves** Podemos usar el mismo par de claves que en la instancia anterior.

**Tipo de instancia** Seleeccionarmeos t2.medium.

**Configuraciones de red** Habiendo realizado la práctica 1.1, será interesante saber que podemos *seleccionar un grupo de seguridad existente*. De esta forma, no nos veremos en la obligación de volver a configurar los puertos HTTP, SSH o HTTPs.

**¿Cómo conecto mi máquina a Visual Code?**

[¿Necesito una IP elástica?](https://github.com/mgerfer1112/practica-iaw-1.1/blob/main/README.md#creaci%C3%B3n-de-una-ip-el%C3%A1stica). ¡Por supuesto! Así que clickando en el link podemos acceder a la explicación de la práctica anterior (solo si tenemos acceso al repositorio).

Ahora sí...

# LAMP Stack en Red Hat.

LAMP es el acrónimo de Linux, Apache, MySQL (o MariaDB) y PHP. El propósito de esta práctica será configurar Apache, MySQL y PHP en un Sistema Red Hat alojado en AWS (Amazon Web Services.)

El LAMP Stack permite crear aplicaciones web dinámicas, como sitios de comercio electrónico,blogs, foros o cualquier otro tipo de sitio que requiera de un servidor y un almacenaminto de datos en una base de datos.

# Desarrollo de install_lamp.sh

Alojaremos el script en la carpeta *scripts*.

**Funciones**

1. Actualizar los repositorios de paquetes.
2. Instalación de Apache.
3. Instalación de PHP y módulos relacionados.
4. Reinicio de Apache para aplicar los cambios.
5. Instalación de MySQL.

Este es el shebang que indica que el script debe ejecutarse con Bash, el intérprete de comandos de Linux.

```#!/bin/bash```

Lo primero que escribiremos en nuestro script será:

```set -ex```

-e indica que el script parará en caso de encontrar algún fallo en su ejecución.
-x indica que se mostrará en pantalla todo lo que se lleve a cabo.

## Actualización de repositorios y paquetes.

Lo primero que tendremos que hacer será actualizar el sistema utilizando el gestor de paquetes de Red Hat, DNF (Dandified Yum). Para ello, ejecutaremos el siguiente comando:

```dnf update -y```

Es importante no confundirnos, Red Hat utiliza DNF, no APT.

## Instalación de Apache.

Apache es un servidor web que gestiona solicitudes de navegadores y entrega páginas web. En la actualidad es uno de los más usados.

**Comando para instalar apache**

```dnf install httpd```

-y (yes) aprueba automáticamente cualquier pregunta que se realice en la instalación.

A diferencia de otras distribuciones de Linux, **en Red Hat Apache no se inicia automáticamente**. Por lo tanto, es necesario iniciarlo manualmente con el siguiente comando:

```systemctl start httpd```

Y además, habilitarlo para que se inicie siempre de forma automática, así no tendremos que recurrir al comando anterior cada vez que lo instalemos:

```systemctl enable httpd```

Esto crea un enlace simbólico en /usr/lib/systemd/system/httpd.service, que garantiza que Apache se ejecute después de cada reinicio.

## Instalación de MySQL Server.
MySQL es un sistema de gestión de base de datos utilizado comunmente para la gestión de grandes volúmenes de información.

Comando de instalación:

```dnf install mysql-server -y```

Al igual que con Apache, debemos iniciar y habilitar mysql para que se inicie automáticamente:


```
systemctl start mysqld
systemctl enable mysqld 
```

## Instalación de PHP.


PHP (Hypertext Preprocessor) es un lenguaje de programación utilizado para crear páginas web dinámicas.

Comando para instalar php:

```dnf install php -y```

Comando para instalar el controlador de MySQL para PHP:

```dnf install php-mysqlnd -y```

**Creación de index.php**

Fuera de la carpeta scripts crearemos la carpeta **PHP** donde almacenaremos *index.php* el cual contendrá:

```
<?php
phpinfo();
?>
```

Reiniciamos Apache
```systemctl restart httpd```

Copiamos el scritp de prueba php

```cp ../php/index.php /var/www/html```

**Modificamos el propietario y el grupo del archivo index.php**

```chown -R www-data:www-data /var/www/html```



Podemos comprobar el funcionamiento de PHP buscando nuestra IP seguida de index.php (el archivo que hemos creado anteriormente)

En nuestro caso sería: 

![image](https://github.com/user-attachments/assets/6f1d5a5e-02f1-4fd3-9136-64b8ec012407)

# Desarrollo de install.tools.sh

El script `install_tools.sh` tiene como propósito principal automatizar el proceso de instalación y configuración de **phpMyAdmin** en un servidor que utiliza el gestor de paquetes **DNF**. Este script se encarga de realizar las siguientes tareas:

1. Instalación de phpMyAdmin.
2. Creación de la Base de Datos y gestión de usuarios.
3. Gestión de seguridad.

A continuación detallaremos los detalles de su instalación.

Las primeras líneas serán similares a install_lamp.sh

``` 
#!/bin/bash

source .env

set -ex

dnf update -y
```

Podemos observar la adición de `source .env`. Lo cual enlaza .env, un documento en el que hemos definido las variables y establecido sus valores, a install_tools.sh, el cual las utilizará más adelante.

Para poder utilizar .env deberemos tener en cuenta lo siguiente.

**En el directorio raiz deberemos contar con *.gitignore*.**

.gitignore indica a GitHub que debe ignorar .env, esto es muy útil, ya que podemos hacer funcionar nuestro script, pero no mostrando los detalles sensibles como nombres de usuario y contraseñas.

Es importante aún así la creación de .env-example, el cual contendrá las variables sin valores. Este documento ayudará a otros desarrolladores a conocer las variables y poder inicilizarlas fácilmente.

.env-example:
```
PMA_USER=
PMA_PASS=
PMA_DB=
```
## Instalación de phpMyAdmin.

Comando para la instalación de las dependencias necesarias para phpMyAdmin:

```
dnf install php-mbstring php-zip php-json php-gd php-fpm php-xml -y
```

Reinicio de apache.

```
systemctl restart httpd
```

A continuación, instalaremos la herramienta wget, la cual nos ayudará a descargar archivos desde la web. 


```
dnf install wget -y
````
Una vez que la instalación se haya completado, procederemos a descargar el archivo comprimido que contiene la última versión de phpMyAdmin. Utilizaremos el siguiente comando:

```
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz -P /var/www/html
```

Este comando descargará el archivo *phpMyAdmin-latest-all-languages.tar.gz* y lo guardará en el directorio /var/www/html, que es el lugar donde Apache busca los archivos que necesita.

A continuación descomprimiremos el .zip.

```
tar xvf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html
```

Para asegurar que en el sistema no quedan archivos innecesario eliminaremos el .zip y otras instalaciones previvas de pypMyAdmin.

```
rm -rf /var/www/html/phpMyAdmin-latest-all-languages.tar.gz

rm -rf /var/www/html/phpmyadmin
```

Para facilitar el uso cambiaremos el nombre de phpmyadmin

```
mv /var/www/html/phpMyAdmin-5.2.1-all-languages /var/www/html/phpmyadmin
```

Para que apache pueda acceder a la carpeta será necesario que le añadamos como propietario de ésta.

```
chown -R apache:apache /var/www/html
```

Una vez que phpMyAdmin está instalado y el directorio está configurado correctamente, creamos un archivo de configuración a partir del archivo de ejemplo que viene incluido en la instalación. Esto se realiza con el siguiente comando:

```
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
```

Podemos verificar la instalación buscando la IP seguida de /phpmyadmin

![image](https://github.com/user-attachments/assets/b6f7ec52-27f7-4ec7-950d-f74a3502425d)


## MySQL Gestión de usuarios.

En primer lugar crearemos la base de datos.

```
mysql -u root < /var/www/html/phpmyadmin/sql/create_tables.sql

mysql -u root <<< "DROP USER IF EXISTS $PMA_USER@'%'"

mysql -u root <<< "CREATE USER $PMA_USER@'%' IDENTIFIED BY '$PMA_PASS'"

mysql -u root <<< "GRANT ALL PRIVILEGES ON $PMA_DB.* TO $PMA_USER@'%'"

```

## Seguridad.

Para aumentar la seguridad de la instalación de phpMyAdmin, generamos un valor aleatorio que se utilizará como la clave secreta de Blowfish. Este valor se almacena en la configuración de phpMyAdmin para encriptar las cookies:

```
RANDOM_VALUE=`openssl rand -hex 16`
```

Actualizamos el archivo de configuración de phpMyAdmin para incluir este valor:

```
sed -i "s/\(\$cfg\['blowfish_secret'\] =\).*/\1 '$RANDOM_VALUE';/" /var/www/html/phpmyadmin/config.inc.php
```

Finalmente, añadimos una configuración adicional para establecer un directorio temporal que phpMyAdmin utilizará. Esto se hace con el siguiente comando:

```
sed -i "/blowfish_secret/a \$cfg\['TempDir'\] = '/tmp';" /var/www/html/phpmyadmin/config.inc.php
```

![image](https://github.com/user-attachments/assets/c8bc1f89-93cf-4e14-a330-7fba5b39e9a3)
ss
