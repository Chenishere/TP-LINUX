# TP4 :

## 🌞 Choisissez et définissez une IP à la VM
```bash
[yce@localhost ~]$ ip a | grep -w inet | sed -n '3p'
    inet 10.250.1.2/24 brd 10.250.1.255 scope global noprefixroute enp0s8
```

## 🌞 Choisissez et définissez une IP à la VM
```bash
[yce@localhost ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s8
TYPE=Ethernet
BOOTPROTO=static
NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
IPADDR=10.250.1.2
NETMASK=255.255.255.0
```
```bash
[yce@localhost ~]$ ip a | grep -w inet | tail -n 1
    inet 10.250.1.2/24 brd 10.250.1.255 scope global noprefixroute enp0s8
```
## 🌞 Vous me prouverez que :
#### le service ssh est actif sur la VM
```bash
[yce@localhost ~]$ systemctl status sshd.service
● sshd.service - OpenSSH server daemon
   Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
   Active: active (running) since Wed 2021-11-24 22:51:35 CET; 7min ago
     Docs: man:sshd(8)
           man:sshd_config(5)
 Main PID: 865 (sshd)
    Tasks: 1 (limit: 4946)
   Memory: 4.6M
   CGroup: /system.slice/sshd.service
           └─865 /usr/sbin/sshd -D -oCiphers=aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes256-ctr,aes256-cbc,aes128-gcm@openssh.com,aes128-ctr,aes128-cbc -oMACs=hmac-sha2-256-etm@openssh.com,h>

nov. 24 22:51:35 localhost.localdomain systemd[1]: Starting OpenSSH server daemon...
nov. 24 22:51:35 localhost.localdomain sshd[865]: Server listening on 0.0.0.0 port 22.
nov. 24 22:51:35 localhost.localdomain sshd[865]: Server listening on :: port 22.
nov. 24 22:51:35 localhost.localdomain systemd[1]: Started OpenSSH server daemon.
nov. 24 22:51:52 localhost.localdomain sshd[1485]: Accepted password for yce from 10.250.1.1 port 57768 ssh2
nov. 24 22:51:52 localhost.localdomain sshd[1485]: pam_unix(sshd:session): session opened for user yce by (uid=0)
```
##### Sur notre machine
```bash
ynce@MacBook-Pro-de-Yanice ~ % cat /Users/ynce/.ssh/id_rsa.pub
ssh-rsa   AAAAB3NzaC1yc2EAAAADAQABAAACAQDapARVmYCi+k9H6UT6h+0puB4acRCqtkCNVZvUKAuIS4MwvBT/gYCdo1tN4SlEggKYfWok7hQxEMirQsH0OXe2xs8IcprqSjeYeB0KGlsxUlG0oNFAUlh9ucso5L/4+RZZnyiEvPbjcptuL7ogP/xYrRp8KreCKjU7X5fUmDK63usDyufRJfVoyVHAxrPVDtCVFf1ROvQOKoRPBs6tVCYbQo4R1jHs1czvdB9u/o1LyzGtK7F+KFKAN4mOOK/Fx3LYTfAXLUEELuYQQYPqU0Lr5U/Bbqxhw751C2ogHR8ytLtdHO3ajqEEwEPl7mFMuMk8dzYt91Ai+IJCYpGruJQvvT9F+DoLdMHR3b8c6MYa1EgSP9bJlAfwLpp+vh+TMz5IH2n7aA4Yv9/Cye9/Jgr7nBArozjO5Hk55p7LyqtGugCKoYY984BJi2JoA4vapWkzO/AcJvoQksYKa8ruEfCrIWqNvXtOzkrKzP9aIkyfu2JXoekXJB5pq1cAmuQpyv8Ts9p+874SaqbiyiroQhgENVKa/+uV1/1O8jc4PNxUDStDpfU5V0tOH5/i3Qh/NjUmNnIBXMWE/0FR3Hl3C9qSecDJA6A5MOoEjE2SIl8nMjEML48784ci5nB6+i0AhsjW0wjn/dUYxqfVy6qvpfyCzfKNLea3S6OjmMLv6TOC5Q== ynce@MacBook-Pro-de-Yanice.local
```
##### Sur notre vm
```bash
[yce@localhost ~]$ cat /home/yce/.ssh/authorized_keys 
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDapARVmYCi+k9H6UT6h+0puB4acRCqtkCNVZvUKAuIS4MwvBT/gYCdo1tN4SlEggKYfWok7hQxEMirQsH0OXe2xs8IcprqSjeYeB0KGlsxUlG0oNFAUlh9ucso5L/4+RZZnyiEvPbjcptuL7ogP/xYrRp8KreCKjU7X5fUmDK63usDyufRJfVoyVHAxrPVDtCVFf1ROvQOKoRPBs6tVCYbQo4R1jHs1czvdB9u/o1LyzGtK7F+KFKAN4mOOK/Fx3LYTfAXLUEELuYQQYPqU0Lr5U/Bbqxhw751C2ogHR8ytLtdHO3ajqEEwEPl7mFMuMk8dzYt91Ai+IJCYpGruJQvvT9F+DoLdMHR3b8c6MYa1EgSP9bJlAfwLpp+vh+TMz5IH2n7aA4Yv9/Cye9/Jgr7nBArozjO5Hk55p7LyqtGugCKoYY984BJi2JoA4vapWkzO/AcJvoQksYKa8ruEfCrIWqNvXtOzkrKzP9aIkyfu2JXoekXJB5pq1cAmuQpyv8Ts9p+874SaqbiyiroQhgENVKa/+uV1/1O8jc4PNxUDStDpfU5V0tOH5/i3Qh/NjUmNnIBXMWE/0FR3Hl3C9qSecDJA6A5MOoEjE2SIl8nMjEML48784ci5nB6+i0AhsjW0wjn/dUYxqfVy6qvpfyCzfKNLea3S6OjmMLv6TOC5Q== ynce@MacBook-Pro-de-Yanice.local
```

#### Connexion en ssh
```bash
ynce@MacBook-Pro-de-Yanice ~ % ssh yce@10.250.1.2             
Activate the web console with: systemctl enable --now cockpit.socket

Last login: Wed Nov 24 22:51:52 2021 from 10.250.1.1
```

## 🌞 Prouvez que vous avez un accès internet
```bash
[yce@localhost ~]$ ping -c 2 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=63 time=11.8 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=63 time=18.5 ms

--- 8.8.8.8 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 11.759/15.125/18.492/3.368 ms
```
## 🌞 Prouvez que vous avez de la résolution de nom
```bash
[yce@localhost ~]$ ping -c 2 google.com
PING google.com (142.250.75.238) 56(84) bytes of data.
64 bytes from par10s41-in-f14.1e100.net (142.250.75.238): icmp_seq=1 ttl=63 time=12.9 ms
64 bytes from par10s41-in-f14.1e100.net (142.250.75.238): icmp_seq=2 ttl=63 time=17.8 ms

--- google.com ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 12.857/15.322/17.788/2.468 ms
```
## 🌞 Définissez node1.tp4.linux comme nom à la machine
```bash
[yce@localhost ~]$ cat /etc/hostname 
node1.tp4.linux
[yce@localhost ~]$ hostname
node1.tp4.linux
```

## 🌞 Installez NGINX en vous référant à des docs online
```bash
[yce@localhost ~]$ sudo dnf install nginx
Dernière vérification de l’expiration des métadonnées effectuée il y a 1 day, 6:16:56 le mar. 23 nov. 2021 17:16:48 CET.
Le paquet nginx-1:1.14.1-9.module+el8.4.0+542+81547229.x86_64 est déjà installé.
Dépendances résolues.
Rien à faire.
Terminé !
```
## 🌞 Analysez le service NGINX
```bash
[yce@localhost ~]$ ps -ef | grep nginx
yce         8470       1  0 23:48 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       8471    8470  0 23:48 ?        00:00:00 nginx: worker process
yce         8479    5795  0 23:48 pts/1    00:00:00 grep --color=auto ngin
```

```bash
[yce@localhost ~]$ sudo ss -ltpn | grep nginx
LISTEN 0      128          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=8471,fd=8),("nginx",pid=8470,fd=8))
LISTEN 0      128             [::]:80           [::]:*    users:(("nginx",pid=8471,fd=9),("nginx",pid=8470,fd=9))
```

```bash
[yce@localhost ~]$ ls -al /usr/share/nginx/
total 4
drwxr-xr-x.  4 root root   33 Nov 23 11:52 .
drwxr-xr-x. 91 root root 4096 Nov 23 11:52 ..
drwxr-xr-x.  2 root root   99 Nov 23 11:52 html
drwxr-xr-x.  2 root root  143 Nov 23 11:52 modules
```
# 🌞 Configurez le firewall pour autoriser le trafic vers le service NGINX
```bash
[yce@localhost yum.repos.d]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
```
#### 🌞 Tester le bon fonctionnement du service











































