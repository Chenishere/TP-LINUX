# Partie 3 : Setup des clients NFS : `web.tp6.linux` et `db.tp6.linux`

Ok, ça va être rapide cette partie : on va tester que `web.tp6.linux` et `db.tp6.linux` peuvent correctement accéder aux répertoires partagés par `backup.tp6.linux`.

---

On commence par `web.tp6.linux`.

🌞 **Install'**

- le paquet à install pour obtenir un client NFS c'est le même que pour le serveur : `nfs-utils`

🌞 **Conf'**

- créez un dossier `/srv/backup` dans lequel sera accessible le dossier partagé
- pareil que pour le serveur : fichier `/etc/idmapd.conf`

```bash
# Trouvez la ligne "Domain =" et modifiez la pour correspondre à notre domaine :
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
  - preuve avec une commande `df -h` que la partition est bien montée
  - prouvez que vous pouvez lire et écrire des données sur cette partition
- définir un montage automatique de la partition (fichier `/etc/fstab`)
  - vous vérifierez que votre fichier `/etc/fstab` fonctionne correctement

---

🌞 **Répétez les opérations sur `db.tp6.linux`**

- le point de montage sur la machine `db.tp6.linux` est aussi sur `/srv/backup`
- le dossier à monter est `/backup/db.tp6.linux/`
- vous ne mettrez dans le compte-rendu pour `db.tp6.linux` que les preuves de fonctionnement :
  - preuve avec une commande `df -h` que la partition est bien montée
  - preuve que vous pouvez lire et écrire des données sur cette partition
  - preuve que votre fichier `/etc/fstab` fonctionne correctement

---

Final step : [mettre en place la sauvegarde, c'est la partie 4](./part4.md).
