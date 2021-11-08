# TP2 : Explorer et manipuler le système

## 1. Nommer la machine

🌞 **Changer le nom de la machine**
```bash
yce@yce-vm:~$ sudo hostname node1.tp2.linux
[sudo] password for yce: 
yce@yce-vm:~$ sudo nano /etc/hostname
```
On restart la vm est :
```bash
yce@node1:~$ 
```
## 2. Config réseau

🌞 **Config réseau fonctionnelle**
### Ping 1.1.1.1
```bash
yce@node1:~$ ping 1.1.1.1
PING 1.1.1.1 (1.1.1.1) 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=63 time=29.9 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=63 time=31.4 ms
^C
--- 1.1.1.1 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 29.948/30.677/31.407/0.729 ms
```
### Ping ynov.com
```bash
yce@node1:~$ ping ynov.com
PING ynov.com (92.243.16.143) 56(84) bytes of data.
64 bytes from xvm-16-143.dc0.ghst.net (92.243.16.143): icmp_seq=1 ttl=63 time=24.4 ms
^C
--- ynov.com ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 24.376/24.376/24.376/0.000 ms
```
### Ping <IP_VM>
```bash
ynce@MacBook-Pro-de-Yanice ~ % ping 192.168.57.6
PING 192.168.57.6 (192.168.57.6): 56 data bytes
64 bytes from 192.168.57.6: icmp_seq=0 ttl=64 time=0.402 ms
^C
--- 192.168.57.6 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 0.402/0.402/0.402/0.000 ms
```
# Partie 1 : SSH

🌞 Installer le paquet openssh-server
```bash
yce@node1:~$ sudo apt install openssh-server
[sudo] password for yce: 
Reading package lists... Done
Building dependency tree       
Reading state information... Done
openssh-server is already the newest version (1:8.2p1-4ubuntu0.3).
0 upgraded, 0 newly installed, 0 to remove and 89 not upgraded.
```
### 2. Lancement du service SSH

🌞 Lancer le service ssh
```bash
yce@node1:~$ systemctl start ssh
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to start 'ssh.service'.
Authenticating as: yce,,, (yce)
Password: 
==== AUTHENTICATION COMPLETE ===
```
#### Vérifier que le service est actuellement actif 
```bash
yce@node1:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 15:33:17 CEST; 1h 26min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
    Process: 527 ExecStartPre=/usr/sbin/sshd -t (code=exited, status=0/SUCCESS)
   Main PID: 558 (sshd)
      Tasks: 1 (limit: 2312)
     Memory: 4.1M
     CGroup: /system.slice/ssh.service
             └─558 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

oct. 25 15:33:16 yce-vm systemd[1]: Starting OpenBSD Secure Shell server...
oct. 25 15:33:17 yce-vm sshd[558]: Server listening on 0.0.0.0 port 22.
oct. 25 15:33:17 yce-vm sshd[558]: Server listening on :: port 22.
oct. 25 15:33:17 yce-vm systemd[1]: Started OpenBSD Secure Shell server.
oct. 25 16:05:19 node1.tp2.linux sshd[1386]: Accepted password for yce from 192.168.57.1 port 57428 ssh2
oct. 25 16:05:19 node1.tp2.linux sshd[1386]: pam_unix(sshd:session): session opened for user yce by (uid=0)
```
#### Vous pouvez aussi faire en sorte que le service SSH se lance automatiquement au démarrage
```bash
yce@node1:~$ sudo systemctl enable ssh
[sudo] password for yce: 
Synchronizing state of ssh.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable ssh
```
### 3. Etude du service SSH
🌞 Analyser le service en cours de fonctionnement
#### Afficher le statut du service
```bash
yce@node1:~$ systemctl status ssh
● ssh.service - OpenBSD Secure Shell server
     Loaded: loaded (/lib/systemd/system/ssh.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-10-25 15:33:17 CEST; 1h 32min ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 558 (sshd)
      Tasks: 1 (limit: 2312)
     Memory: 4.1M
     CGroup: /system.slice/ssh.service
             └─558 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups

oct. 25 15:33:16 yce-vm systemd[1]: Starting OpenBSD Secure Shell server...
oct. 25 15:33:17 yce-vm sshd[558]: Server listening on 0.0.0.0 port 22.
oct. 25 15:33:17 yce-vm sshd[558]: Server listening on :: port 22.
oct. 25 15:33:17 yce-vm systemd[1]: Started OpenBSD Secure Shell server.
oct. 25 16:05:19 node1.tp2.linux sshd[1386]: Accepted password for yce from 192.168.57.1 port 57428 ssh2
oct. 25 16:05:19 node1.tp2.linux sshd[1386]: pam_unix(sshd:session): session opened for user yce by (uid=0)
```
#### Afficher le/les processus liés au service ssh
```bash
yce@node1:~$ ps -ef  | grep ssh
root         558       1  0 15:33 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root        1386     558  0 16:05 ?        00:00:00 sshd: yce [priv]
yce         1463    1386  0 16:05 ?        00:00:00 sshd: yce@pts/1
```

#### Afficher le port utilisé par le service ssh
```bash
yce@node1:~$ sudo ss -ltnp
LISTEN              0                   128                                       [::]:22                                     [::]:*                 users:(("sshd",pid=558,fd=4))
```
#### Afficher les logs du service ssh

```bash
yce@node1:/var/log$ sudo journalctl -ef  | grep ssh
nov. 07 00:03:20 yce-vm sshd[543]: Server listening on 0.0.0.0 port 22.
nov. 07 00:03:20 yce-vm sshd[543]: Server listening on :: port 22.
nov. 07 00:07:49 yce-vm sshd[1288]: Accepted password for yce from 192.168.57.1 port 53881 ssh2
nov. 07 00:07:49 yce-vm sshd[1288]: pam_unix(sshd:session): session opened for user yce by (uid=0)
```
```bash
yce@node1:/var/log$ cd /var/log
yce@node1:/var/log$ ls
alternatives.log  boot.log fontconfig.log  lastlog 
bootstrap.log     dpkg.log    gpu-manager.log   lightdm  syslog             
auth.log          faillog        kern.log      ubuntu-advantage.log   Xorg.0.log
```
🌞 Connectez vous au serveur
```bash
ynce@MacBook-Pro-de-Yanice ~ % ssh yce@192.168.57.6
no such identity: /Users/ynce/.ssh/id_ed2551: No such file or directory
yce@192.168.57.6's password: 
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.11.0-38-generic x86_64)
yce@node1:~$ 
```
### 4. Modification de la configuratiion du serveur
🌞 Modifier le comportement du service
```bash
yce@node1:/etc/ssh/sshd_config.d$ cd /etc/ssh/sshd_config.d
yce@node1:/etc/ssh/sshd_config.d$ sudo nano /etc/ssh/sshd_config
yce@node1:/etc/ssh/sshd_config.d$ sudo cat /etc/ssh/sshd_config
#	$OpenBSD: sshd_config,v 1.103 2018/04/09 20:41:22 tj Exp $

# This is the sshd server system-wide configuration file.  See
# sshd_config(5) for more information.

# This sshd was compiled with PATH=/usr/bin:/bin:/usr/sbin:/sbin

# The strategy used for options in the default sshd_config shipped with
# OpenSSH is to specify options with their default value where
# possible, but leave them commented.  Uncommented options override the
# default value.

Include /etc/ssh/sshd_config.d/*.conf

#Port 2500
#AddressFamily any
#ListenAddress 0.0.0.0
#ListenAddress ::
yce@node1:/etc/ssh/sshd_config.d$ ss -l | grep ssh
u_str   LISTEN   0        4096             /run/user/1000/gnupg/S.gpg-agent.ssh 25834                                           * 0                             
u_str   LISTEN   0        10                         /run/user/1000/keyring/ssh 26398                                           * 0                             
u_str   LISTEN   0        128                   /tmp/ssh-SpYnnEOiiqGE/agent.830 26122                                           * 0                             
tcp     LISTEN   0        128                                           0.0.0.0:ssh                                       0.0.0.0:*                             
tcp     LISTEN   0        128                                              [::]:ssh                                          [::]:*                             
```
### 2. Lancement du service FTP
🌞 Lancer le service vsftpd
```bash
yce@node1:/etc/ssh/sshd_config.d$ sudo apt install vsftpd
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following NEW packages will be installed:
  vsftpd
0 upgraded, 1 newly installed, 0 to remove and 89 not upgraded.
Need to get 115 kB of archives.
After this operation, 338 kB of additional disk space will be used.
Get:1 http://fr.archive.ubuntu.com/ubuntu focal/main amd64 vsftpd amd64 3.0.3-12 [115 kB]
Fetched 115 kB in 0s (661 kB/s)
Preconfiguring packages ...
Selecting previously unselected package vsftpd.
(Reading database ... 199642 files and directories currently installed.)
Preparing to unpack .../vsftpd_3.0.3-12_amd64.deb ...
Unpacking vsftpd (3.0.3-12) ...
Setting up vsftpd (3.0.3-12) ...
Created symlink /etc/systemd/system/multi-user.target.wants/vsftpd.service → /lib/systemd/system/vsftpd.service.
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for systemd (245.4-4ubuntu3.11) ...
```
🌞 Lancer le service vsftpd
```bash
yce@node1:/etc/ssh/sshd_config.d$ systemctl restart vsftpd.service
==== AUTHENTICATING FOR org.freedesktop.systemd1.manage-units ===
Authentication is required to restart 'vsftpd.service'.
Authenticating as: yce,,, (yce)
Password: 
==== AUTHENTICATION COMPLETE ===
yce@node1:/etc/ssh/sshd_config.d$ systemctl status vsftpd.service 
● vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-11-08 09:10:46 CET; 25s ago
    Process: 18037 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCESS)
   Main PID: 18038 (vsftpd)
      Tasks: 1 (limit: 2312)
     Memory: 528.0K
     CGroup: /system.slice/vsftpd.service
             └─18038 /usr/sbin/vsftpd /etc/vsftpd.conf

nov. 08 09:10:46 node1.tp2.linux systemd[1]: Starting vsftpd FTP server...
nov. 08 09:10:46 node1.tp2.linux systemd[1]: Started vsftpd FTP server.
```
🌞 Analyser le service en cours de fonctionnement
```bash
yce@node1:/etc/ssh/sshd_config.d$ systemctl status vsftpd.service 
● vsftpd.service - vsftpd FTP server
     Loaded: loaded (/lib/systemd/system/vsftpd.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2021-11-08 09:10:46 CET; 25s ago
    Process: 18037 ExecStartPre=/bin/mkdir -p /var/run/vsftpd/empty (code=exited, status=0/SUCCESS)
   Main PID: 18038 (vsftpd)
      Tasks: 1 (limit: 2312)
     Memory: 528.0K
     CGroup: /system.slice/vsftpd.service
             └─18038 /usr/sbin/vsftpd /etc/vsftpd.conf

nov. 08 09:10:46 node1.tp2.linux systemd[1]: Starting vsftpd FTP server...
nov. 08 09:10:46 node1.tp2.linux systemd[1]: Started vsftpd FTP server.
```
```bash
yce@node1:/etc/ssh/sshd_config.d$ ps -ef | grep vsftpd
root       18038       1  0 09:10 ?        00:00:00 /usr/sbin/vsftpd /etc/vsftpd.conf
yce        18080    2061  0 09:16 pts/2    00:00:00 grep --color=auto vsftpd
```
```bash
yce@node1:/$ cd /var/log
yce@node1:/var/log$ sudo journalctl -ef  | grep vsftpd.service
nov. 08 09:09:31 node1.tp2.linux polkitd(authority=local)[461]: Operator of unix-process:17976:868909 successfully authenticated as unix-user:yce to gain ONE-SHOT authorization for action org.freedesktop.systemd1.manage-units for system-bus-name::1.140 [systemctl restart vsftpd.service] (owned by unix-user:yce)
nov. 08 09:09:31 node1.tp2.linux systemd[1]: vsftpd.service: Succeeded.
nov. 08 09:10:39 node1.tp2.linux polkitd(authority=local)[461]: Operator of unix-process:18023:875339 successfully authenticated as unix-user:yce to gain ONE-SHOT authorization for action org.freedesktop.systemd1.manage-units for system-bus-name::1.150 [systemctl restart vsftpd.service vsftpd.service] (owned by unix-user:yce)
nov. 08 09:10:39 node1.tp2.linux systemd[1]: vsftpd.service: Succeeded.
nov. 08 09:10:46 node1.tp2.linux polkitd(authority=local)[461]: Operator of unix-process:18023:875339 successfully authenticated as unix-user:yce to gain ONE-SHOT authorization for action org.freedesktop.systemd1.manage-units for system-bus-name::1.150 [systemctl restart vsftpd.service vsftpd.service] (owned by unix-user:yce)
nov. 08 09:10:46 node1.tp2.linux systemd[1]: vsftpd.service: Succeeded.
```






