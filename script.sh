#!/bin/bash
#######################################################################################################################
#	V1 28/03/2019 : création du programme.                                                                        #
#	                                                                                                              #
#	                                                                                                              #
#	                                                                                                              #
#	                                                                                                              #
#	                                                                                                              #
#	                                                                                                              #
#######################################################################################################################

dossier=/data
version=$1
serveur_snapshot=http://192.168.100.93:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server/$version
serveur_release=http://192.168.100.93:8081/repository/maven-releases/com/lesformateurs/maven-project/server/$version
host=192.168.100.110
user=root


#Vérification si snapshot
if (echo $version | grep "\-SNAPSHOT")
then

#url de telechargement du metadata
	serveurmavendata=$serveur_snapshot"/maven-metadata.xml"

#Telechargement
	if !(wget $serveurmavendata)
	then
		echo "probleme telechargement"
		exit 103
	fi

#Recuperation de la valeur de la dernière version du fichier
	lastupdated=`tail maven-metadata.xml | grep "<value>"`
	lastupdated=`echo $lastupdated | sed -n 's,^.*<value>\(.*\)</value>.*$,\1,p'`

#concaténation du nom fichier
	fichier=server-$lastupdated.jar

#URL pour télécharger le fichier	
	serveur_snapshot=$serveur_snapshot/$fichier

#Telechargement
	if !( wget $serveur_snapshot)
	then
		echo "probleme telechargement"
		exit 104
	fi
#Cleans
	if (ls ./maven-metadata.xml)
	then
		rm -f maven-metadata.xml
	fi
else
	fichier=server-$version.jar
	serveur_release=$serveur_release/$fichier
	if !(wget $serveur_release)
	then 
		echo "probleme telechargement"
		exit 105
	fi	
fi

if !(ssh -t $user@$host dossier=$dossier "$(<./dossier.sh)")
then
	echo "erreur lors du ssh"
	exit 106
fi
	
if !(scp ./$fichier $user@$host:$dossier)
then
	echo "erreur lors du scp"
	exit 107
fi
