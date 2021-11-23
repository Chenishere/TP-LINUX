#🌞 Choisissez et définissez une IP à la VM
```bash
[yce@localhost ~]$ ip a | grep -w inet | sed -n '3p'
    inet 10.250.1.2/24 brd 10.250.1.255 scope global noprefixroute enp0s8
```
