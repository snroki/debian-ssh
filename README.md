# Init :

`git clone git@github.com:snroki/debian-ssh.git`

`cd debian-ssh && make run`

`ssh root@localhost -p 2222`


# Debian :

## La base

- Mettre à jour la distrib :
`apt update && apt upgrade`

- Ajouter un nouvel utilisateur :
`adduser caca`

- Mettre à jour le mot de passe root :
`passwd`

- Optionnel : Mettre en place les mises à jours de sécurité automatiques :
https://www.cyberciti.biz/faq/how-to-keep-debian-linux-patched-with-latest-security-updates-automatically/

## Openssh

Dans le fichier suivant : `vim /etc/ssh/sshd_config`

- Désactiver le login en tant que root :
modifier la ligne `PermitRootLogin yes` en `PermitRootLogin no`

- Optionnel : Activer uniquement le login par ssh key
https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2
et modifier la ligne `PasswordAuthentication yes` en `PasswordAuthentication no`

- Optionnel : Changer le port ssh
modifier la ligne `#Port 22` en `Port *whatever*`

## Iptables

- Vérifier l'état actuel des tables : `iptables -L`, si la chain INPUT est en policy DROP jouer cette commande `iptables -t filter -P INPUT ACCEPT`

- Purger les règles existantes : `iptables -F`

- Rajouter une règle pour la connexion actuelle (histoire de pas perdre son shell ssh) : `iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT`

- Autoriser le loopback (permet la communication avec un dns local) : `iptables -A INPUT -i lo -j ACCEPT`

- Refuser n'importe quelle connexion entrante : `iptables -P INPUT DROP`

- Autoriser les connexions ssh : `iptables -A INPUT -p tcp --dport 22 -j ACCEPT`

- Autoriser les connexions web (port 80 et 443) : `iptables -A INPUT -p tcp --dport 80 -j ACCEPT` et `iptables -A INPUT -p tcp --dport 443 -j ACCEPT`

- Optionnel : Faire en sorte que ces règles restent même si votre serveur se redémarre : https://serversforhackers.com/video/firewall-persisting-iptables-rules

- Optionnel : Si votre serveur a un ipv6 il faut jouer les mêmes règles pour les ip6tables

## Fail2ban

- Installation du package : `apt install fail2ban`

- Editer la configuration : `vim /etc/fail2ban/jail.conf` (vous pouvez changer la conf pour la connexion ssh)

- Penser à rajouter des configurations pour vos applications ! (ex sur le login wordpress)

# MariaDB :

- Installation du package : `apt install mariadb-server`

- Rendre l'installation plus secure : `mysql_secure_installation` (supprime l'accès extérieur pour le user root + les databases de test + les users anonymes)

- Optionnel : Créer une database et un user (qui n'a accès qu'à cette base) pour chaque appli ! (ne pas utiliser le root)

# Php :

Pourquoi FPM : http://php.net/manual/en/install.fpm.php

- Installation du package : `apt install php7.0-fpm php7.0-cli php7.0-mysql`

- Optionnel : n'installer que les modules vraiment utiles

- Optionnel : utiliser le même utilisateur que pour nginx (www-data par exemple)

- Plus d'infos : https://www.cyberciti.biz/tips/php-security-best-practices-tutorial.html

# Nginx :

- Installation du package : `apt install nginx`

- Optionnel : change l'utilisateur (ex : www-data) `vim /etc/nginx/nginx.conf` et modifier la ligne `user` par `user www-data`

- Optionnel : mettre root directory dans le répertoire home de notre utilisateur

- Optionnel : configurer son site correctement pour bloquer certains headers + ssl

https://www.abyssproject.net/2016/11/a-la-recherche-de-la-configuration-parfaite-pour-nginx/
https://poweruphosting.com/blog/secure-nginx-server
https://gist.github.com/plentz/6737338

# Pour aller plus loin :

- installer à la mano sa distrib : https://blog.tetsumaki.net/articles/2017/07/installation-de-debian-9-stretch-depuis-debootstrap.html
- chiffrer intégralement son vps : https://blog.imirhil.fr/2017/07/22/stockage-chiffre-serveur.html
