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
\textbf{Question 1}


- plusieurs questions successives vont vous être posées
  - expliquez avec des mots, de façon concise, ce que signifie chacune des questions
  - expliquez pourquoi vous répondez telle ou telle réponse (avec la sécurité en tête)

> Il existe des tonnes de guides sur internet pour expliquer ce que fait cette commande et comment répondre aux questions, afin d'augmenter le niveau de sécurité de la base.

---

🌞 **Préparation de la base en vue de l'utilisation par NextCloud**

- pour ça, il faut vous connecter à la base
- il existe un utilisateur `root` dans la base de données, qui a tous les droits sur la base
- si vous avez correctement répondu aux questions de `mysql_secure_installation`, vous ne pouvez utiliser le user `root` de la base de données qu'en vous connectant localement à la base
- donc, sur la VM `db.tp5.linux` toujours :

```bash
# Connexion à la base de données
# L'option -p indique que vous allez saisir un mot de passe
# Vous l'avez défini dans le mysql_secure_installation
$ sudo mysql -u root -p
```

Puis, dans l'invite de commande SQL :

```sql
# Création d'un utilisateur dans la base, avec un mot de passe
# L'adresse IP correspond à l'adresse IP depuis laquelle viendra les connexions. Cela permet de restreindre les IPs autorisées à se connecter.
# Dans notre cas, c'est l'IP de web.tp5.linux
# "meow" c'est le mot de passe :D
CREATE USER 'nextcloud'@'10.5.1.11' IDENTIFIED BY 'meow';

# Création de la base de donnée qui sera utilisée par NextCloud
CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;

# On donne tous les droits à l'utilisateur nextcloud sur toutes les tables de la base qu'on vient de créer
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.5.1.11';

# Actualisation des privilèges
FLUSH PRIVILEGES;
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

- vous utiliserez la commande `dnf provides` pour trouver dans quel paquet se trouve cette commande

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

---

C'est bon ? Ca tourne ? [**Go installer NextCloud maintenant !**](./web.md)

![To the cloud](./pics/to_the_cloud.jpeg)
