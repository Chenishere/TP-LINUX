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

```

