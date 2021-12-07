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

🌞 **Install du serveur NFS**

- installez le paquet `nfs-utils`

🌞 **Conf du serveur NFS**

- fichier `/etc/idmapd.conf`

```bash
# Trouvez la ligne "Domain =" et modifiez la pour correspondre à notre domaine :
Domain = tp6.linux
```

- fichier `/etc/exports`

```bash
# Pour ajouter un nouveau dossier /toto à partager, en autorisant le réseau `192.168.1.0/24` à l'utiliser
/toto 192.168.1.0/24(rw,no_root_squash)
```

Dans notre cas, vous n'ajouterez pas le dossier `/toto` à ce fichier, mais évidemment `/backup/web.tp6.linux/` et `/backup/db.tp6.linux/` (deux partages donc).  
Aussi, le réseau à autoriser n'est PAS `192.168.1.0/24` dans ce TP, à vous d'adapter la ligne.

Les machins entre parenthèses `(rw,no_root_squash)` sont les options de partage. **Vous expliquerez ce que signifient ces deux-là.**

🌞 **Démarrez le service**

- le service s'appelle `nfs-server`
- après l'avoir démarré, prouvez qu'il est actif
- faites en sorte qu'il démarre automatiquement au démarrage de la machine

🌞 **Firewall**

- le port à ouvrir et le `2049/tcp`
- prouvez que la machine écoute sur ce port (commande `ss`)

---

Ok le service est up & runnin ! Reste plus qu'à le tester : go sur [la partie 3 pour setup les clients NFS](./part3.md).
