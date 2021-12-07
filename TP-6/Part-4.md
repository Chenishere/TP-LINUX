# Partie 4 : Scripts de sauvegarde

Ok la dernière étape : faire en sorte que, à intervalles réguliers, on sauvegarde les données de NextCloud.

L'idée :

- un script tourne sur `web.tp6.linux`
  - il sauvegarde le dossier qui contient les fichiers de NextCloud
- un script tourne sur `db.tp6.linux`
  - il extrait le contenu de la base sous la forme d'un fichier
  - il sauvegarde ce fichier

> Par "sauvegarder" on entend : créer une archive compressée, la nommer correctement, la déplacer dans le bon dossier, et générer une ligne de log.

## I. Sauvegarde Web

🌞 **Ecrire un script qui sauvegarde les données de NextCloud**

- le script crée un fichier `.tar.gz` qui contient tout le dossier de NextCloud
- le fichier doit être nommé `nextcloud_yymmdd_hhmmss.tar.gz`
- il doit être stocké dans le répertoire de sauvegarde : `/srv/backup/`
- le script génère une ligne de log à chaque backup effectuée
  - message de log : `[yy/mm/dd hh:mm:ss] Backup /srv/backup/<NAME> created successfully.`
  - fichier de log : `/var/log/backup/backup.log`
- le script affiche une ligne dans le terminal à chaque backup effectuée
  - message affiché : `Backup /srv/backup/<NAME> created successfully.`

> Vu que l'archive est stockée dans `/srv/backup/`, en fait bah elle est stockée sur la machine `backup.tp6.linux`. Hé ui, c bo no ?

🌞 **Créer un service**

- créer un service `backup.service` qui exécute votre script
- ainsi, quand on lance le service avec `sudo systemctl start backup`, une backup est déclenchée

**NB : vous DEVEZ ajoutez la ligne `Type=oneshot` en dessous de la ligne `ExecStart=` dans votre service pour que tout fonctionne correctement avec votre script.**

🌞 **Vérifier que vous êtes capables de restaurer les données**

- en extrayant les données
- et en les remettant à leur place

🌞 **Créer un *timer***

- un *timer* c'est un fichier qui permet d'exécuter un service à intervalles réguliers
- créez un *timer* qui exécute le service `backup` toutes les heures

Pour cela, créer le fichier `/etc/systemd/system/backup.timer`.

> Notez qu'il est dans le même dossier que le service, et qu'il porte le même nom, mais pas la même extension.

Contenu du fichier `/etc/systemd/system/backup.timer` :

```bash
[Unit]
Description=Lance backup.service à intervalles réguliers
Requires=backup.service

[Timer]
Unit=backup.service
OnCalendar=hourly

[Install]
WantedBy=timers.target
```

Activez maintenant le *timer* avec :

```bash
# on indique qu'on a modifié la conf du système
$ sudo systemctl daemon-reload

# démarrage immédiat du timer
$ sudo systemctl start backup.timer

# activation automatique du timer au boot de la machine
$ sudo systemctl enable backup.timer
```

Enfin, on vérifie que le *timer* a été pris en compte, et on affiche l'heure de sa prochaine exécution :

```bash
$ sudo systemctl list-timers
```

## II. Sauvegarde base de données

🌞 **Ecrire un script qui sauvegarde les données de la base de données MariaDB**

- il existe une commande : `mysqldump` qui permet de récupérer les données d'une base SQL sous forme d'un fichier
  - le script utilise cette commande pour récup toutes les données de la base `nextcloud` dans MariaDB
  - on dit que le script "dump" la base `nextcloud`
  - petit point sur la commande `mysqldump` plus bas
- le script crée un fichier `.tar.gz` qui contient le fichier issu du `mysqldump`
- le fichier doit être nommé `nextcloud_db_yymmdd_hhmmss.tar.gz`
- il doit être stocké dans le répertoire de sauvegarde : `/srv/backup/`
- le script génère une ligne de log à chaque backup effectuée
  - message de log : `[yy/mm/dd hh:mm:ss] Backup /srv/backup/<NAME> created successfully.`
  - fichier de log : `/var/log/backup/backup_db.log`
- le script affiche une ligne dans le terminal à chaque backup effectuée
  - message affiché : `Backup /srv/backup/<NAME> created successfully.`

➜ **La commande `mysqldump`** fonctionne quasiment exactement pareil que la commande `mysql` dont vous vous êtes déjà servi.  
C'est un simple client SQL aussi.

La différence : `mysql` permet d'avoir un shell interactif, tandis que `mysqldump` se contente de lire toutes les données de la base et de les afficher dans le terminal.

Ainsi, si on est capable de se connecter à une base avec :

```bash
$ mysql -h 192.168.1.1 -p -u super_user super_base
```

Alors on pourra dump la base dans un fichier `super_dump.sql` avec :

```bash
$ mysqldump -h 192.168.1.1 -p -u super_user super_base > super_dump.sql
```

---

🌞 **Créer un service**

- créer un service `backup_db.service` qui exécute votre script
- ainsi, quand on lance le service, une backup de la base de données est déclenchée

**NB : vous DEVEZ ajoutez la ligne `Type=oneshot` en dessous de la ligne `ExecStart=` dans votre service pour que tout fonctionne correctement avec votre script.**

🌞 **Créer un `timer`**

- il exécute le service `backup_db.service` toutes les heures

## Conclusion

Dans ce TP, plusieurs notions abordées :

- partitionnement avec LVM
- gestion de partitions au sens large
- partage de fichiers avec NFS
- scripting

Et à la fin ? Toutes les données de notre cloud perso sont sauvegardéééééééééééééééées. Le feu.

![Backups everywhere](./pics/backups_everywhere.jpg)
