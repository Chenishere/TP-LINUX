# Partie 1 : Préparation de la machine `backup.tp6.linux`

**La machine `backup.tp6.linux` sera chargée d'héberger les sauvegardes.**

Autrement dit, avec des mots simples : la machine `backup.tp6.linux` devra stocker des fichiers, qui seront des archives compressées.

Rien de plus simple non ? Un fichier, ça se met dans un dossier, et walou.

**ALORS OUI**, c'est vrai, mais on va aller un peu plus loin que ça :3

**Ce qu'on va faire, pour augmenter le niveau de sécu de nos données, c'est les stocker sur un espace vraiment dédié. C'est à dire une partition dédiée, sur un disque dur dédié.**

Au menu :

- ajouter un disque dur à la VM
- créer une nouvelle partition sur le disque avec LVM
- formater la partition pour la rendre utilisable
- monter la partition pour la rendre accessible
- rendre le montage de la partition automatique, pour qu'elle soit toujours accessible

> On ne travaille que sur `backup.tp6.linux` dans cette partie !

# I. Ajout de disque

Pour ajouter un disque, bah vous allez au magasin et vous achetez un disque ? n_n

Nan, en vrai, les VMs, c'est virtuel. Leurs disques sont virtuels. Donc on va simplement ajouter un disque virtuel à la VM, depuis VirtualBox.

Je vous laisse faire pour cette partie, avec vos ptites mains, vot' ptite tête et vot' p'tit pote Google. Rien de bien sorcier.

🌞 **Ajouter un disque dur de 5Go à la VM `backup.tp6.linux`**

- pour me prouver que c'est fait dans le compte-rendu, vous le ferez depuis le terminal de la VM
- la commande `lsblk` liste les périphériques de stockage branchés à la machine
- vous mettrez en évidence le disque que vous venez d'ajouter dans la sortie de `lsblk`
```bash
[yce@backup ~]$ lsblk
NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda           8:0    0    8G  0 disk
├─sda1        8:1    0    1G  0 part /boot
└─sda2        8:2    0    7G  0 part
  ├─rl-root 253:0    0  6.2G  0 lvm  /
  └─rl-swap 253:1    0  820M  0 lvm  [SWAP]
sdb           8:16   0    5G  0 disk
sr0          11:0    1 1024M  0 rom
```
# II. Partitioning

> [**Référez-vous au mémo LVM pour réaliser cette partie.**](../../cours/memos/lvm.md)

Le partitionnement est obligatoire pour que le disque soit utilisable. Ici on va rester simple : une seule partition, qui prend toute la place offerte par le disque.

Comme vu en cours, le partitionnement dans les systèmes GNU/Linux s'effectue généralement à l'aide de LVM.

Allons !

🌞 **Partitionner le disque à l'aide de LVM**

- créer un *physical volume (PV)* : le nouveau disque ajouté à la VM

`1`
```bash
[yce@backup ~]$ sudo pvcreate /dev/sdb
[sudo] password for yce:
  Physical volume "/dev/sdb" successfully created.
```
`2`
```bash
[yce ~]$ sudo pvs
  PV         VG Fmt  Attr PSize  PFree
  /dev/sda2  rl lvm2 a--  <7.00g    0
  /dev/sdb      lvm2 ---   5.00g 5.00g
```
- créer un nouveau *volume group (VG)*
`1`
```bash
[yce@backup ~]$ sudo vgcreate backup /dev/sdb
  Volume group "backup" successfully created
```
`2`
```bash
[yce@backup ~]$ sudo vgs
  VG     #PV #LV #SN Attr   VSize  VFree
  backup   1   0   0 wz--n- <5.00g <5.00g
  rl       1   2   0 wz--n- <7.00g     0
```
- créer un nouveau *logical volume (LV)* : ce sera la partition utilisable
`1`
```bash

```
`2`


🌞 **Formater la partition**

- vous formaterez la partition en ext4 (avec une commande `mkfs`)
  - le chemin de la partition, vous pouvez le visualiser avec la commande `lvdisplay`
  - pour rappel un *Logical Volume (LVM)* **C'EST** une partition

🌞 **Monter la partition**

- montage de la partition (avec la commande `mount`)
  - la partition doit être montée dans le dossier `/backup`
  - preuve avec une commande `df -h` que la partition est bien montée
  - prouvez que vous pouvez lire et écrire des données sur cette partition
- définir un montage automatique de la partition (fichier `/etc/fstab`)
  - vous vérifierez que votre fichier `/etc/fstab` fonctionne correctement

---

Ok ! Za, z'est fait. On a un espace de stockage dédié pour nos sauvegardes.  
Passons à la suite, [la partie 2 : installer un serveur NFS](./part2.md).

Ou alors passez au bonus ?

# III. Bonus

➜ Ajouter un deuxième disque de 5Go à la VM et faire une partition de 10Go

- faites en un PV
- ajoutez le au VG existant (il fait donc 10 Go maintenant)
- étendez la partition à 10Go
- prouvez que la partition utilisable fait 10Go désormais

![I Know LVM](./pics/i_know_lvm.jpg)
