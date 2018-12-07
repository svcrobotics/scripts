#!/bin/bash

# variable ip permetant de récupérer l'adresse ip de la machine sur laquelle s'exécute le script
ip="$(hostname -I)"

# mkpassword doit etre installer au préalable
# en éxécutant apt-get install whois

user_password=$(mkpasswd user)

# chaque PC : ip, hostname, user, password group id
pc2=(192.168.100.23 machine2 user02 user abeille 2002)
pc1=(192.168.10O.22 machine1 user01 user abeille 2001)
pc6=(192.168.101.10 machine6 user06 user baobab 3001)
pc11=(192.168.0.2 serveurFTP user user cacao 4001)

pc4=(192.168.100.23 machine2 user02 user abeille 2004)
pc5=(192.168.100.23 machine2 user02 user abeille 2005)
pc7=(192.168.100.23 machine2 user02 user baobab 3007)
pc8=(192.168.100.23 machine2 user02 user baobab 3008)
pc9=(192.168.100.23 machine2 user02 user baobab 3009)
pc10=(192.168.100.23 machine2 user02 user baobab 3010)
pc3=(192.168.100.23 machine2 user02 user abeille 2003)

# On va itérer sur cette liste qui nous renvoie à l'addresse ip de chaque PC 
# ${pc1[0]} veut dire récupère la première valeur du tableau pc1 soit 192.168.100.22
# on peut aussi l'écrire de cette façon ${pc1}
PC="${pc1[0]} ${pc2} ${pc3} ${pc4} ${pc5} ${pc6} ${pc7} ${pc8} ${pc9} ${pc10} ${pc11}"

# on compte chaque passage(itération) à partir de 1
n=1

# Pour chaque élément i dans la liste PC faire:
for i in $PC
do 
	# Si l'élement i est égal à l'adresse ip de la machine faire:
	if [ $i = $ip ]
	then
		# Je force la création de groups, par la suite je vais ratacher des utiisateurs a chaque group
		`echo groupadd -f -g 2000 abeille`
		`echo groupadd -f -g 3000 baobab`
		`echo groupadd -f -g 4000 cacao`

		# pc1 correspond à la première iteration mise dans la variable n pc2 a la deuxième etc...
		# Dans le cas de figure ou nous sommes sur n=1 par exemple alors faire:
		case $n in
			# éxecute hostname "nom du hostname" que l'on va chercher dans le tableau
			1)
				echo `echo ${pc1[1]} > /etc/hostname`
				echo `echo "127.0.0.1    ${pc1[1]}" > /etc/hosts`
  				echo `echo "${pc1[0]}    ${pc1[1]}" >> /etc/hosts`

				if ! id -u ${pc1[2]} ; then useradd -u ${pc1[5]} -g ${pc1[4]} -m -s /bin/bash -p $user_password ${pc1[2]} ; fi
				echo "passwd -e ${pc1[2]}" | (read VAR ; echo `$VAR`)
				;;
			# Une autre façon d'écrire la même chose 
			2)echo "hostname ${pc2[1]}" | (read VAR ; echo `$VAR`) ;;			
			3)echo "hostname ${pc3[1]}" | (read VAR ; echo `$VAR`) ;;
			4)echo "hostname ${pc4[1]}" | (read VAR ; echo `$VAR`) ;;
			5)echo "hostname ${pc5[1]}" | (read VAR ; echo `$VAR`) ;;
			6)
				echo `echo ${pc6[1]} > /etc/hostname`
				echo `echo "127.0.0.1    ${pc6[1]}" > /etc/hosts`
  				echo `echo "${pc6[0]}    ${pc6[1]}" >> /etc/hosts`
				# Création d'un compte utilisateur
				# Si l'utilisateur en question n'existe pas alors faire:
				# l'ajouter avec useradd lui donner un id, le faire apartenir au groupe prédefini, creer un home avec -m, 
				# lui fournir un password pour son compte et bien sur un nom d'utilisateur
				if ! id -u ${pc6[2]} ; then useradd -u ${pc6[5]} -g ${pc6[4]} -m -s /bin/bash -p $user_password ${pc6[2]} ; fi
				# Obliger l'utisateur à ça première connection à changer son password par defaut
				echo "passwd -e ${pc6[2]}" | (read VAR ; echo `$VAR`)
				;;
			7)echo "hostname ${pc7[1]}" | (read VAR ; echo `$VAR`) ;;
			8)echo "hostname ${pc8[1]}" | (read VAR ; echo `$VAR`) ;;
			9)echo "hostname ${pc9[1]}" | (read VAR ; echo `$VAR`) ;;
			10)echo "hostname ${pc10[1]}" | (read VAR ; echo `$VAR`) ;;
			11)
				# hostname FTP sera perdu au prochain redémarrage
				echo `hostname ${pc11[1]}`
				# Ajout de la persistence à hostname
				echo `echo ${pc11[1]} > /etc/hostname`
				echo `echo "127.0.0.1    ${pc11[1]}" > /etc/hosts`
  				echo `echo "${pc11[0]}    ${pc11[1]}" >> /etc/hosts`
				# Création d'un compte utilisateur
				# Si l'utilisateur en question n'existe pas alors faire:
				# l'ajouter avec useradd lui donner un id 4001 le faire apartenir au groupe cacao de ce cas, creer un home avec -m, 
				# lui fournir un password pour son compte et bien sur un nom d'utilisateur ici "user"
				if ! id -u ${pc11[2]} ; then useradd -u ${pc11[5]} -g ${pc11[4]} -m -s /bin/bash -p $user_password ${pc11[2]} ; fi
				# Obliger l'utisateur à ça première connection à changer son password par defaut
				echo "passwd -e ${pc11[2]}" | (read VAR ; echo `$VAR`)
				;;
		esac
	else
		echo "ne rien faire"
		
	fi
# on enregistre l'itération suivante
n=$((n+1))
done	
