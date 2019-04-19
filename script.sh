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

dossier=/home/slave-machine/fichier/dossier
version=$1
serveur_snapshot=http://192.168.100.93:8081/repository/maven-snapshots/com/lesformateurs/maven-project/server/$version
serveur_release=http://192.168.100.93:8081/repository/maven-releases/com/lesformateurs/maven-project/server/$version
host=192.168.100.110
user=slave-machine

echo $serveur_snapshot
echo $serveur_release
if (echo $version | grep "\-SNAPSHOT")
then
	serveurmavendata=$serveur_snapshot"/maven-metadata.xml"
	echo $serveurmavendata
	wget $serveurmavendata
	lastupdated=`tail maven-metadata.xml | grep "<value>"`
	lastupdated=`echo $lastupdated | sed -n 's,^.*<value>\(.*\)</value>.*$,\1,p'`
	fichier=server-$lastupdated.jar	
	serveur_snapshot=$serveur_snapshot/$fichier
	wget $serveur_snapshot	
	rm -f maven-metadata.xml
else
	fichier=server-$version.jar
	serveur_release=$serveur_release/$fichier
	wget $serveur_release
fi

ssh -t $user@$host dossier=$dossier "$(<./dossier.sh)"
	
scp ./$fichier $user@$host:$dossier
