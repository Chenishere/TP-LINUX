# TP 1 LINUX
L'objectif de ce tp de detruire des vm sous linux

🌞
## 1 
La commande "sudo rm -rf / --no-preserve-root" va nous permettre de supprimer l'integralité des fichier de la vm. Pour ce faire "sudo" pour donner les droits d’admin. Ensuite "rm-rf/" pour tout delete et "--no-preserve-root" lever la protection ou bien rm-rf/*" pour passer outre la sécurité. Au relancement la vm est complètement cassé et "no bootable"
## 2
Au début on se dit “rien que ca?” car la commande ":(){ :|:& };:" est un peu lente a la detente, mais on a creer un fichier qui fait des copies de lui meme en boucle, utilisant peu a peu plus de votre CPU jusqu’a crash et Boom plus de vm.
## 3
La commande "dd if=/dev/random of=/dev/sda" est comme la précédente un peu lente mais le résultat est tout aussi efficace car la commande effacera les donné du disque dur. au relancement de la vm un message d’erreur nous dit que la vm et non bootable et voilà mission réussie.
## 4
la commande "cp /dev/zero /dev/mem" disons.. hmm.. disons qu'elle creer des terminaux vers l'infini et au delà. Ce qui rend la vm très peu fonctionnelle je vous l'accorde.
## 5
la commande "mv ~ /dev/null" est très puissante car elle moove notre Directory dans le vide. Ici c'est le "mv" qui a pour fonction le moove. Le "~" représente lui le fichier /Home. Enfin le "/dev/nul" permet d'y moove le fichier Home et en écrasant et supprimants TOUTES les copies originales


# Merci
Voila je me suis contenté d'en faire que 5, meme si je le jure que j'aurais voulu en faire plus. Mais avec la gueule de mon niveau actuel je suis deja semi fière de moi. Merci du temps accordé 😊
