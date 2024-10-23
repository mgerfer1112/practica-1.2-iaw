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

**Creación de index.php**

Fuera de la carpeta scripts crearemos la carpeta **PHP** donde almacenaremos *index.php* el cual contendrá:

```
<?php
phpinfo();
?>
```

**Copiamos el scritp de prueba php**

```cp ../php/index.php /var/www/html```

**Modificamos el propietario y el grupo del archivo index.php**

```chown -R www-data:www-data /var/www/html```

Podemos comprobar el funcionamiento de PHP buscando nuestra IP seguida de index.php (el archivo que hemos creado anteriormente)

En nuestro caso sería: 