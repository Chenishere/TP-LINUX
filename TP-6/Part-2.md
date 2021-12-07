# Partie 2 : Setup du serveur NFS sur `backup.tp6.linux`

Bon cette partie, je pense vous commencez à être rodés :

- install un paquet qui contient un service
- conf le service
- lancer le service
- analyser le service
- tester le service

Oè oè oè. Limite redondant l'histoire. Ca devrait pas poser de problème alors ? :)

Le principe d'un serveur NFS :

- on crée des dossiers sur le serveur NFS
- le service NFS a pour but de rendre accessibles ces dossiers sur le réseau
- pour ça, il faut qu'une autre machine utilise un client NFS : elle accédera alors au dossier qui se trouve en réalité sur le serveur NFS

> Un bête partage de dossier quoi.

🌞 **Préparer les dossiers à partager**

- créez deux sous-dossiers dans l'espace de stockage dédié
  - `/backup/web.tp6.linux/`
  - `/backup/db.tp6.linux/`
 ```bash
 [yce@backup ~]$ sudo mkdir /mnt/backup/web.tp6.linux
[yce@backup ~]$ sudo mkdir /mnt/backup/db.tp6.linux
```

🌞 **Install du serveur NFS**

- installez le paquet `nfs-utils`
```bash
[yce@backup ~]$ sudo dnf install nfs-utils
[...]
Complete!
```

🌞 **Conf du serveur NFS**

- fichier `/etc/idmapd.conf`

```bash
[yce@backup ~]$ sudo cat /etc/idmapd.conf
[General]
#Verbosity = 0
# The following should be set to the local NFSv4 domain name
# The default is the host's DNS domain name.
Domain = tp6.linux
```

- fichier `/etc/exports`

Dans notre cas, vous n'ajouterez pas le dossier `/toto` à ce fichier, mais évidemment `/backup/web.tp6.linux/` et `/backup/db.tp6.linux/` (deux partages donc).  
Aussi, le réseau à autoriser n'est PAS `192.168.1.0/24` dans ce TP, à vous d'adapter la ligne.

```bash
[yce@backup ~]$ sudo cat /etc/exports
/mnt/backup/web.tp6.linux/ 10.5.1.13/24(rw,no_root_squash)
/mnt/backup/db.tp6.linux/ 10.5.1.13/24(rw,no_root_squash)
```

🌞 **Démarrez le service**

- le service s'appelle `nfs-server`
- après l'avoir démarré, prouvez qu'il est actif
```bash
[yce@backup ~]$ sudo systemctl start nfs-server
[yce@backup ~]$ sudo systemctl status nfs-server
● nfs-server.service - NFS server and services
   Loaded: loaded (/usr/lib/systemd/system/nfs-server.service; disabled; vendor preset: disabled)
   Active: active (exited) since Tue 2021-11-30 17:54:59 CET; 19s ago
```
- faites en sorte qu'il démarre automatiquement au démarrage de la machine
```bash
[yce@backup ~]$ sudo systemctl enable nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
```
🌞 **Firewall**

- le port à ouvrir et le `2049/tcp`
```bash
[yce@backup ~]$ sudo firewall-cmd --add-port=2049/tcp --permanent
success
[yce@backup ~]$ sudo firewall-cmd --reload
success
```
- prouvez que la machine écoute sur ce port (commande `ss`)
```bash
[yce@backup ~]$ sudo ss -alntp
State    Recv-Q   Send-Q     Local Address:Port      Peer Address:Port   Process
LISTEN   0        128              0.0.0.0:22             0.0.0.0:*       users:(("sshd",pid=863,fd=5))
LISTEN   0        128              0.0.0.0:36023          0.0.0.0:*       users:(("rpc.statd",pid=3220,fd=10))
LISTEN   0        64               0.0.0.0:37115          0.0.0.0:*
LISTEN   0        64               0.0.0.0:2049           0.0.0.0:*
LISTEN   0        128              0.0.0.0:111            0.0.0.0:*       users:(("rpcbind",pid=3214,fd=4),("systemd",pid=1,fd=48))
LISTEN   0        128              0.0.0.0:20048          0.0.0.0:*       users:(("rpc.mountd",pid=3226,fd=8))
LISTEN   0        128                 [::]:22                [::]:*       users:(("sshd",pid=863,fd=7))
LISTEN   0        64                  [::]:2049              [::]:*
LISTEN   0        128                 [::]:53833             [::]:*       users:(("rpc.statd",pid=3220,fd=12))
LISTEN   0        64                  [::]:40045             [::]:*
LISTEN   0        128                 [::]:111               [::]:*       users:(("rpcbind",pid=3214,fd=6),("systemd",pid=1,fd=58))
LISTEN   0        128                 [::]:20048             [::]:*       users:(("rpc.mountd",pid=3226,fd=10))
```
---

![Heyyy](https://static.wikia.nocookie.net/great-teacher-onizuka-gto/images/9/90/Eikichi_Onizuka.png/revision/latest?cb=20170806215057)
