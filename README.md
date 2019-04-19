# projet_formation script de transfert
#Le script necessite d'avoir accès au root de la machine.
#Il fonctionne avec en parametre une version snapshot ou release.
#Il recupére en fonction du type de version (snapshot ou release) le bon server .jar correspondant.
#Il crée si un fichier /data a la racine du poste distant via un script.
#Il envoie le fichier via scp dans le dossier crée.
#Toutes mauvaise executions d'une action résulte un echo avec un message et un exit en erreur 1. Cette erreur est reconnue par le jenkins qui sort en erreur a son tour.
