# I. Setup DB

Côté base de données, on va utiliser MariaDB.

![Easy database](pics/easy_database.jpg)

## Sommaire

- [I. Setup DB](#i-setup-db)
  - [Sommaire](#sommaire)
  - [1. Install MariaDB](#1-install-mariadb)
  - [2. Conf MariaDB](#2-conf-mariadb)
  - [3. Test](#3-test)

## 1. Install MariaDB

> Pour rappel, le gestionnaire de paquets sous les OS de la famille RedHat, c'est pas `apt`, c'est `dnf`.

🌞 **Installer MariaDB sur la machine `db.tp5.linux`**
```bash
[yce@db ~]$ sudo dnf install mariadb-server 
[yce@db ~]$ rpm -qa | grep mariadb-server
mariadb-server-10.3.28-1.module+el8.4.0+427+adf35707.x86_64
mariadb-server-utils-10.3.28-1.module+el8.4.0+427+adf35707.x86_64
```
🌞 **Le service MariaDB**

```bash
[yce@db ~]$ systemctl start mariadb
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ====
Authentification requise pour démarrer « mariadb.service ».
Authenticating as: yce
Password: 
==== AUTHENTICATION COMPLETE ====
```

```bash
[yce@db ~]$ sudo systemctl enable mariadb
[sudo] Mot de passe de yce : 
Created symlink /etc/systemd/system/mysql.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/mysqld.service → /usr/lib/systemd/system/mariadb.service.
Created symlink /etc/systemd/system/multi-user.target.wants/mariadb.service → /usr/lib/systemd/system/mariadb.service.
```
```bash
[yce@db ~]$ systemctl status
● db.tp5.linux
    State: running
     Jobs: 0 queued
   Failed: 0 units
    Since: Thu 2021-11-25 17:25:50 CET; 12min ago
```
```bash
[yce@db ~]$ ss -altnp | tail -1
LISTEN 0      80                 *:3306            *:* 
```
```bash
[yce@db ~]$ ps -ef | grep mariadb
yce        26738    1509  0 17:46 pts/0    00:00:00 grep --color=auto mariadb
```
```bash
[yce@db ~]$ ps -ef | grep mariadb
yce        26738    1509  0 17:46 pts/0    00:00:00 grep --color=auto mariadb
```
Le processus est donc lancé par yce

🌞 **Firewall**

```bash
[yce@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[yce@db ~]$ sudo firewall-cmd --reload
success
```
## 2. Conf MariaDB

Première étape : le `mysql_secure_installation`. C'est un binaire qui sert à effectuer des configurations très récurrentes, on fait ça sur toutes les bases de données à l'install.  
C'est une question de sécu.

🌞 **Configuration élémentaire de la base**
```bash
[yce@db ~]$ mysql_secure_installation

NOTE: RUNNING ALL PARTS OF THIS SCRIPT IS RECOMMENDED FOR ALL MariaDB
      SERVERS IN PRODUCTION USE!  PLEASE READ EACH STEP CAREFULLY!

In order to log into MariaDB to secure it, we'll need the current
password for the root user.  If you've just installed MariaDB, and
you haven't set the root password yet, the password will be blank,
so you should just press enter here.
```

**Question 1**
```bash
Set root password? [Y/n]
```
change le mot de passe MySQL de l’administrateur root 

**Question 2**
```bash
Remove anonymous users? [Y/n]
```
supprime les utilisateurs anonymes

**Question 3**
```bash
Disallow root login remotely?
```
désactive l’accès distant à l’utilisateur root

**Question 4**
```bash
Remove test database and access to it? [Y/n]
```
supprimer la base de données de test

**Question 5**
```bash
Reload privilege tables now? [Y/n]
```
Nous demande si on veut supprimer la table des privileges

```bash
All done!  If you've completed all of the above steps, your MariaDB
installation should now be secure.

Thanks for using MariaDB!
[yce@db ~]$ 
```

> Il existe des tonnes de guides sur internet pour expliquer ce que fait cette commande et comment répondre aux questions, afin d'augmenter le niveau de sécurité de la base.

---

🌞 **Préparation de la base en vue de l'utilisation par NextCloud**

- pour ça, il faut vous connecter à la base
- il existe un utilisateur `root` dans la base de données, qui a tous les droits sur la base
- si vous avez correctement répondu aux questions de `mysql_secure_installation`, vous ne pouvez utiliser le user `root` de la base de données qu'en vous connectant localement à la base
- donc, sur la VM `db.tp5.linux` toujours :

```bash
[yce@db ~]$ sudo mysql -u root -p
[sudo] Mot de passe de yce : 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 64
Server version: 10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.
```

Puis, dans l'invite de commande SQL :

```sql
[yce@db ~]$ sudo mysql -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 66
Server version: 10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';
Query OK, 0 rows affected (0.001 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.000 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 0 rows affected, 1 warning (0.000 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)
```

## 3. Test

Bon, là il faut tester que la base sera utilisable par NextCloud.

Concrètement il va faire quoi NextCloud vis-à-vis de la base MariaDB ?

- se connecter sur le port où écoute MariaDB
- la connexion viendra de `web.tp5.linux`
- il se connectera en utilisant l'utilisateur `nextcloud`
- il écrira/lira des données dans la base `nextcloud`

Il faudrait donc qu'on teste ça, à la main, depuis la machine `web.tp5.linux`.

Bah c'est parti ! Il nous faut juste un client pour nous connecter à la base depuis la ligne du commande : il existe une commande `mysql` pour ça.

🌞 **Installez sur la machine `web.tp5.linux` la commande `mysql`**
```bash
[yce@web ~]$ sudo dnf install mysql
Dernière vérification de l’expiration des métadonnées effectuée il y a 0:11:24 le ven. 26 nov. 2021 15:34:27 CET.
Le paquet mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 est déjà installé.
Dépendances résolues.
Rien à faire.
Terminé !
```
```bash
[yce@web ~]$ sudo dnf provides mysql 
Dernière vérification de l’expiration des métadonnées effectuée il y a 0:10:16 le ven. 26 nov. 2021 15:34:27 CET.
mysql-8.0.26-1.module+el8.4.0+652+6de068a7.x86_64 : MySQL client programs and shared libraries
```
🌞 **Tester la connexion**

- utilisez la commande `mysql` depuis `web.tp5.linux` pour vous connecter à la base qui tourne sur `db.tp5.linux`
- vous devrez préciser une option pour chacun des points suivants :
  - l'adresse IP de la machine où vous voulez vous connectez `db.tp5.linux` : `10.5.1.12`
  - le port auquel vous vous connectez
  - l'utilisateur de la base de données sur lequel vous connecter : `nextcloud`
  - l'option `-p` pour indiquer que vous préciserez un password
    - vous ne devez PAS le préciser sur la ligne de commande
    - sinon il y aurait un mot de passe en clair dans votre historique, c'est moche
  - la base de données à laquelle vous vous connectez : `nextcloud`
- une fois connecté à la base en tant que l'utilisateur `nextcloud` :
  - effectuez un bête `SHOW TABLES;`
  - simplement pour vous assurer que vous avez les droits de lecture
  - et constater que la base est actuellement vide

> Je veux donc dans le compte-rendu la commande `mysql` qui permet de se co depuis `web.tp5.linux` au service de base de données qui tourne sur `db.tp5.linux`, ainsi que le `SHOW TABLES`.
```bash
[yce@web ~]$  mysql -u nextcloud -p -P 3306  -h 10.5.1.12 nextcloud
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 85
Server version: 5.5.5-10.3.28-MariaDB MariaDB Server

Copyright (c) 2000, 2021, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```
---

C'est bon ? Ca tourne ? [**Go installer NextCloud maintenant !**](./web.md)

# II. Setup Web

Comme annoncé dans l'intro, on va se servir d'Apache dans le rôle de serveur Web dans ce TP5. Histoire de varier les plaisirs è_é

![Linux is a tipi](./pics/linux_is_a_tipi.jpg)

## Sommaire

- [II. Setup Web](#ii-setup-web)
  - [Sommaire](#sommaire)
  - [1. Install Apache](#1-install-apache)
    - [A. Apache](#a-apache)
    - [B. PHP](#b-php)
  - [2. Conf Apache](#2-conf-apache)
  - [3. Install NextCloud](#3-install-nextcloud)
  - [4. Test](#4-test)

## 1. Install Apache

### A. Apache

🌞 **Installer Apache sur la machine `web.tp5.linux`**

```bash
[yce@web ~]$ sudo dnf install httpd
[sudo] Mot de passe de yce : 
Dernière vérification de l’expiration des métadonnées effectuée il y a 0:37:05 le ven. 26 nov. 2021 15:34:27 CET.
Dépendances résolues.
....
Installé:
  apr-1.6.3-12.el8.x86_64                                            apr-util-1.6.1-6.el8.1.x86_64                                   apr-util-bdb-1.6.1-6.el8.1.x86_64                                      
  apr-util-openssl-1.6.1-6.el8.1.x86_64                              httpd-2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64              httpd-filesystem-2.4.37-43.module+el8.5.0+714+5ec56ee8.noarch          
  httpd-tools-2.4.37-43.module+el8.5.0+714+5ec56ee8.x86_64           mod_http2-1.15.7-3.module+el8.5.0+695+1fa8055e.x86_64           rocky-logos-httpd-85.0-3.el8.noarch                                    

Terminé !
```

---

🌞 **Analyse du service Apache**

- lancez le service `httpd` et activez le au démarrage
- isolez les processus liés au service `httpd`
- déterminez sur quel port écoute Apache par défaut
- déterminez sous quel utilisateur sont lancés les processus Apache
```bash
[yce@web ~]$ sudo systemctl start httpd
[yce@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
```
```bash
[yce@web ~]$ ps -ef | grep httpd
root       24868       1  0 16:21 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24869   24868  0 16:21 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24870   24868  0 16:21 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24871   24868  0 16:21 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apache     24872   24868  0 16:21 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
yce        25147   24241  0 16:28 pts/0    00:00:00 grep --color=auto httpd
```
```bash
[yce@web ~]$ ss -altnp | tail -1
LISTEN 0      128                *:80              *:*    
```
```bash
[yce@web ~]$ ps -u | grep http
yce        25172  0.0  0.1 221928  1152 pts/0    S+   16:41   0:00 grep --color=auto http
```

---

🌞 **Un premier test**

- ouvrez le port d'Apache dans le firewall
- testez, depuis votre PC, que vous pouvez accéder à la page d'accueil par défaut d'Apache
  - avec une commande `curl`
  - avec votre navigateur Web
```bash
[yce@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
[sudo] Mot de passe de yce : 
success
```
```bash
[yce@web ~]$ curl 10.5.1.11
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
```
Sur le navigateur on met l'ip : 10.5.1.11 qui retourne :
"HTTP Server Test Page" une page verte en html (meme code source qu'avec le curl 10.5.1.11)

### B. PHP

NextCloud a besoin d'une version bien spécifique de PHP.  
Suivez **scrupuleusement** les instructions qui suivent pour l'installer.

🌞 **Installer PHP**

```bash
[yce@web ~]$  sudo dnf install epel-release
...
Installé:
  epel-release-8-13.el8.noarch                                                                                                                                                                            
Terminé !
```
```bash
[yce@web ~]$ sudo dnf update
Extra Packages for Enterprise Linux 8 - x86_64                                                                                                                            1.5 MB/s |  11 MB     00:07    
Extra Packages for Enterprise Linux Modular 8 - x86_64                                                                                                                    753 kB/s | 958 kB     00:01    
Dernière vérification de l’expiration des métadonnées effectuée il y a 0:00:01 le ven. 26 nov. 2021 19:10:01 CET.
Dépendances résolues.
Rien à faire.
Terminé !
```
```bash 
[yce@web ~]$ sudo dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm
...
Installé:
  remi-release-8.5-1.el8.remi.noarch                                                                                                                                                                      
Terminé !
```
```bash
[yce@web ~]$ sudo dnf module enable php:remi-7.4
...
Voulez-vous continuer ? [o/N] : o
Terminé !
```
```bash
[yce@web ~]$ sudo dnf install zip unzip libxml2 openssl php74-php php74-php-ctype php74-php-curl php74-php-gd php74-php-iconv php74-php-json php74-php-libxml php74-php-mbstring php74-php-openssl php74-php-posix php74-php-session php74-php-xml php74-php-zip php74-php-zlib php74-php-pdo php74-php-mysqlnd php74-php-intl php74-php-bcmath php74-php-gmp
...
Installé:
  environment-modules-4.5.2-1.el8.x86_64             gd-2.2.5-7.el8.x86_64                             jbigkit-libs-2.1-14.el8.x86_64                    libXpm-3.5.12-8.el8.x86_64                    
  libicu69-69.1-1.el8.remi.x86_64                    libjpeg-turbo-1.5.3-12.el8.x86_64                 libsodium-1.0.18-2.el8.x86_64                     libtiff-4.0.9-20.el8.x86_64                   
  libwebp-1.0.0-5.el8.x86_64                         oniguruma5php-6.9.7.1-1.el8.remi.x86_64           php74-libzip-1.8.0-1.el8.remi.x86_64              php74-php-7.4.26-1.el8.remi.x86_64            
  php74-php-bcmath-7.4.26-1.el8.remi.x86_64          php74-php-cli-7.4.26-1.el8.remi.x86_64            php74-php-common-7.4.26-1.el8.remi.x86_64         php74-php-fpm-7.4.26-1.el8.remi.x86_64        
  php74-php-gd-7.4.26-1.el8.remi.x86_64              php74-php-gmp-7.4.26-1.el8.remi.x86_64            php74-php-intl-7.4.26-1.el8.remi.x86_64           php74-php-json-7.4.26-1.el8.remi.x86_64       
  php74-php-mbstring-7.4.26-1.el8.remi.x86_64        php74-php-mysqlnd-7.4.26-1.el8.remi.x86_64        php74-php-opcache-7.4.26-1.el8.remi.x86_64        php74-php-pdo-7.4.26-1.el8.remi.x86_64        
  php74-php-pecl-zip-1.20.0-1.el8.remi.x86_64        php74-php-process-7.4.26-1.el8.remi.x86_64        php74-php-sodium-7.4.26-1.el8.remi.x86_64         php74-php-xml-7.4.26-1.el8.remi.x86_64        
  php74-runtime-1.0-3.el8.remi.x86_64                scl-utils-1:2.0.2-14.el8.x86_64                   tcl-1:8.6.8-2.el8.x86_64                         

Terminé !
```
## 2. Conf Apache

➜ Le fichier de conf utilisé par Apache est `/etc/httpd/conf/httpd.conf`.  
Il y en a plein d'autres : ils sont inclus par le premier.

➜ Dans Apache, il existe la notion de *VirtualHost*. On définit des *VirtualHost* dans les fichiers de conf d'Apache.  
On crée un *VirtualHost* pour chaque application web qu'héberge Apache.

> "Application Web" c'est le terme de hipster pour désigner un site web. Disons qu'aujourd'hui les sites peuvent faire tellement de trucs qu'on appelle plutôt ça une "application" à part entière. Une application web donc.

➜ Dans le dossier `/etc/httpd/` se trouve un dossier `conf.d`.  
Des dossiers qui se terminent par `.d`, vous en rencontrerez plein, ce sont des dossiers de *drop-in*.  
Plutôt que d'écrire 40000 lignes dans un seul fichier de conf, on l'éclate en plusieurs fichiers la conf.  
C'est + lisible et + facilement maintenable.

Les dossiers de *drop-in* servent à accueillir ces fichiers de conf additionels.  
Le fichier de conf principal a une ligne qui inclut tous les fichiers de conf contenus dans le dossier de *drop-in*.

---

🌞 **Analyser la conf Apache**

```bash
[yce@web ~]$ cat /etc/httpd/conf/httpd.conf | grep conf.d
# Load config files in the "/etc/httpd/conf.d" directory, if any.
IncludeOptional conf.d/*.conf
```
🌞 **Créer un VirtualHost qui accueillera NextCloud**

- créez un nouveau fichier dans le dossier de *drop-in*
  - attention, il devra être correctement nommé (l'extension) pour être inclus par le fichier de conf principal
- ce fichier devra avoir le contenu suivant :

```bash
[yce@web conf.d]$ sudo nano VirtualHost.conf
[yce@web conf.d]$ cat VirtualHost.conf
<VirtualHost *:80>
  DocumentRoot /var/www/nextcloud/html/  

  ServerName  web.tp5.linux  

  <Directory /var/www/nextcloud/html/>
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews

    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>

```

> N'oubliez pas de redémarrer le service à chaque changement de la configuration, pour que les changements prennent effet.

🌞 **Configurer la racine web**
```bash
[yce@web ~]$ cd var/
[yce@web var]$ cd www/
[yce@web www]$ sudo mkdir nextcloud
[yce@web www]$ cd nextcloud/
[yce@web nextcloud]$ sudo mkdir html
```
🌞 **Configurer PHP**
```bash
[yce@web nextcloud]$ cat /etc/opt/remi/php74/php.ini | grep date.timezone
; http://php.net/date.timezone
;date.timezone = "Europe/Paris"
```
## 3. Install NextCloud
```bash
[yce@web nextcloud]$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip
[yce@web nextcloud]$ ls
nextcloud-21.0.1.zip
```

🌞 **Récupérer Nextcloud**

```bash
# Petit tips : la commande cd sans argument permet de retourner dans votre homedir
$ cd

# La commande curl -SLO permet de rapidement télécharger un fichier, en HTTP/HTTPS, dans le dossier courant
$ curl -SLO https://download.nextcloud.com/server/releases/nextcloud-21.0.1.zip

$ ls
nextcloud-21.0.1.zip
```

🌞 **Ranger la chambre**

```bash
[yce@web ~]$ sudo chown -R apache:apache nextcloud
[yce@web ~]$ sudo mv nextcloud/* /var/www/nextcloud/html
[yce@web html]$ ls -l
total 4
drwxr-xr-x. 13 apache yce 4096 Apr  8  2021 nextcloud
```
## 4. Test

Bah on arrive sur la fin !

Si on résume :

- **un serveur de base de données : `db.tp5.linux`**
  - MariaDB installé et fonctionnel
  - firewall configuré
  - une base de données et un user pour NextCloud ont été créés dans MariaDB
- **un serveur Web : `web.tp5.linux`**
  - Apache installé et fonctionnel
  - firewall configuré
  - un VirtualHost qui pointe vers la racine `/var/www/nextcloud/html/`
  - NextCloud installé dans le dossier `/var/www/nextcloud/html/`

**Looks like we're ready.**

---

**Ouuu presque. Pour que NextCloud fonctionne correctement, il faut y accéder en utilisant un nom, et pas une IP.**  
On va donc devoir faire en sorte que, depuis votre PC, vous puissiez écrire `http://web.tp5.linux` plutôt que `http://10.5.1.11`.

➜ Pour faire ça, on va utiliser **le fichier `hosts`**. C'est un fichier présents sur toutes les machines, sur tous les OS.  
Il sert à définir, localement, une correspondance entre une IP et un ou plusieurs noms.  

C'est arbitraire, on fait ce qu'on veut.  
Si on veut que `www.ynov.com` pointe vers le site de notre VM, ou vers n'importe quelle autre IP, on peut.  
ON PEUT TOUT FAIRE JE TE DIS.  
Ce sera évidemment valable uniquement sur la machine où se trouve le fichier.

Emplacement du fichier `hosts` :

- MacOS/Linux : `/etc/hosts`
- Windows : `c:\windows\system32\drivers\etc\hosts`


**🔥🔥🔥 Baboom ! Un beau NextCloud.**

Naviguez un peu, faites vous plais', vous avez votre propre DropBox n_n

![Well Done](./pics/well_done.jpg)
