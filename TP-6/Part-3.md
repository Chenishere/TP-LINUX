# Partie 3 : Setup des clients NFS : `web.tp6.linux` et `db.tp6.linux`

Ok, ça va être rapide cette partie : on va tester que `web.tp6.linux` et `db.tp6.linux` peuvent correctement accéder aux répertoires partagés par `backup.tp6.linux`.

---

On commence par `web.tp6.linux`.

🌞 **Install'**

- le paquet à install pour obtenir un client NFS c'est le même que pour le serveur : `nfs-utils`
```bash
[yce@web ~]$ sudo dnf install nfs-utils
[...]
Complete! 
```
🌞 **Conf'**

- créez un dossier `/srv/backup` dans lequel sera accessible le dossier partagé
```bash
[yce@web /]$ sudo mkdir /srv/backup

```
- pareil que pour le serveur : fichier `/etc/idmapd.conf`
```bash
[yce@web /]$ sudo cat /etc/idmapd.conf
Domain = tp6.linux
```

---

Eeeeet c'est tout ! Testons qu'on peut accéder au dossier partagé.  
Comment on fait ? Avec une commande `mount` !

Ui pareil qu'à la partie 1 ! Le dossier partagé sera vu comme une partition de type NFS.

La commande pour monter une partition en NFS :

```bash
$ sudo mount -t nfs <IP_SERVEUR>:</dossier/à/monter> <POINT_DE_MONTAGE>
```

Dans notre cas :

- le serveur NFS porte l'IP `10.5.1.13`
- le dossier à monter est `/backup/web.tp6.linux/`
- le point de montage, vous venez de le créer : `/srv/backup`

🌞 **Montage !**

- montez la partition NFS `/backup/web.tp6.linux/` avec une comande `mount`
  - la partition doit être montée sur le point de montage `/srv/backup`
```bash
[yce@web /]$ sudo mount -t nfs 10.5.1.13:/mnt/backup/web.tp6.linux/ /srv/backup

```
  - preuve avec une commande `df -h` que la partition est bien montée
```bash
[yce@web /]$ sudo df -h
[...]
10.5.1.13:/mnt/backup/web.tp6.linux  4.9G   20M  4.6G   1% /srv/backup

```
  - prouvez que vous pouvez lire et écrire des données sur cette partition
```bash
[yce@web /]$ cd /srv/backup/
[yce@web backup]$ ls
[yce@web backup]$ sudo nano test
[yce@web backup]$ sudo cat test
test

```
- définir un montage automatique de la partition (fichier `/etc/fstab`)
```bash
[yce@web backup]$ sudo cat /etc/fstab
...
10.5.1.13:/mnt/backup/web.tp6.linux /srv/backup nfs     defaults        0 0

```
  - vous vérifierez que votre fichier `/etc/fstab` fonctionne correctement
```bash
[yce@web backup]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
/srv/backup              : already mounted

```

---

🌞 **Répétez les opérations sur `db.tp6.linux`**

- le point de montage sur la machine `db.tp6.linux` est aussi sur `/srv/backup`
```bash
[yce@db ~]$ sudo mkdir /srv/backup
```
- le dossier à monter est `/backup/db.tp6.linux/`
```bash
[yce@db srv]$ sudo mount -t nfs 10.5.1.13:/mnt/backup/db.tp6.linux/ /srv/backup
```
- vous ne mettrez dans le compte-rendu pour `db.tp6.linux` que les preuves de fonctionnement :
  - preuve avec une commande `df -h` que la partition est bien montée
```bash
[yce@db srv]$ sudo df -h
[...]
10.5.1.13:/mnt/backup/db.tp6.linux  4.9G   20M  4.6G   1% /srv/backup

```
  - preuve que vous pouvez lire et écrire des données sur cette partition
```bash
[yce@db backup]$ sudo nano preuve
[yce@db backup]$ sudo cat preuve
jojjoo
```
  - preuve que votre fichier `/etc/fstab` fonctionne correctement
```bash
[yce@db backup]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
/srv/backup              : already mounted
```

---

![Me again](https://pbs.twimg.com/media/EpOjRzNXcAQBzOx.jpg)
