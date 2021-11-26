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
[yce@db ~]$ ss -alnpt | grep 3306
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

![To the cloud](./pics/to_the_cloud.jpeg)
