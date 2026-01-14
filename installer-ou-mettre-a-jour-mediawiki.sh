#!/bin/sh

######################
# Script shell POSIX #
######################

#######################################################################################################################
#######################################################################################################################
# 1) Placer le script installer-ou-mettre-a-jour-mediawiki.sh dans /var/www/

# 2) Démarrer le script :
# sh installer-ou-mettre-a-jour-mediawiki.sh

# Vérifier si le script est stable depuis un autre emplacement. ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#######################################################################################################################
#######################################################################################################################

###############################
# Mediawiki est déjà installé #
###############################
# ✅ Ce script vérifie si une mise à jour est disponible.
# ❌ Ce script propose de faire une sauvegarde de Mediawiki.
# ❌ Ce script propose de copier le répertoire existant de Mediawiki.
###############################

############################
# Maintenance de Mediawiki #
############################
# ✅ Ce script vérifie si une BDD existe déjà pour Mediawiki ...
# ❌ Lister toutes les bases de données existantes.
# ✅ Ce script propose de créer une nouvelle base de données pour Mediawiki ...
# ❌ Recréer une nouvelle BDD et la vider si il existe déjà du contenu dans la base de données ...
# ❌ Copier les données de la BDD de Mediawiki existante vers la nouvelle base de données créée pour Mediawiki ...

# ❌ Ce script propose de créer le nouveau répertoire de Mediawiki ...
# ❌ Ce script propose de copier / déplacer le répertoire existant de Mediawiki ...
# ❌ Télécharger le zip de Mediawiki puis décompresser Mediawiki dans le nouveau répertoire. (unzip) ...

# ❌ Ce script propose de sauvegarder les ACL ...
# ❌ Ce script propose d'appliquer les nouveaux chown/chmod ...
# ❌ Ce script propose un virtualhost pour Apache2 et Mediawiki ...
############################

#######################################
# Mediawiki n'est pas encore installé #
#######################################
# ❌ Ce script propose d'installer une version au choix de Mediawiki dans une nouvelle base de données avec le fichier LocalSettings correctement renseigné.
#######################################

#######################################################################################################################
#######################################################################################################################

#######################################################################################################################
#######################################################################################################################

#################################################
# IMPORTANT --> Adapter les variables suivantes #
#################################################

    # Répertoire recommandé pour copier le script installer-ou-mettre-a-jour-mediawiki.sh et pour démarrer l'installation :
    MW_Chemin_Du_Script="/var/www";

##########################################################
# SI MEDIAWIKI EST DEJA INSTALLÉ OU DOIT ÊTRE MIS À JOUR #
##########################################################

    # Nouvelle version attendue pour Mediawiki :
    MW_VERSION_ATTENDUE="1.44.0";

    # Nouvelle version attendue pour Mediawiki - Confirmation par la suite durant l'installation :
    MW_VERSION_ATTENDUE_CONFIRMATION="";

    # Nom du répertoire avec les fichiers de Mediawiki pour installer ou mettre à jour Mediawiki :
    MW_Chemin_Nom_Du_Site="archive.amis-sh.fr";

    # Chemin complet vers le répertoire de Mediawiki pour installer ou mettre à jour Mediawiki :
    MW_Chemin_Complet_Du_Site="/var/www/archive.amis-sh.fr";

##################################
# SI MEDIAWIKI EST DEJA INSTALLÉ #
##################################

    # Chemin vers le fichier LocalSettings.php :
    LOCALSETTINGS="$MW_Chemin_Complet_Du_Site/LocalSettings.php"

    # Renommer le dossier du site en production pour ne pas écraser les fichiers :
    MW_Chemin_Site_BAKUP="MEDIAWIKI-BAKUP";

#######
# BDD #
#######

    # Prefixe pour le nom des tables mediawiki dans votre Base de données MySQL :
    # Peut être vide si aucun préfixe n'a été utilisé.
    BDD_TABLE_PREFIXE=""

    # Cette variable n'est pas utilisée dans le script. (???)
    # Elle est présente dans LocalSettings.php pour indiquer le type de base de données a utiliser :
    BDD_TYPE="mysql";

    # Le script installer-ou-mettre-a-jour-mediawiki.sh va consulter le fichier LocalSettings.php pour utiliser les informations de connexion vers la Base de données existante.

############################################################
# Variables de connexion à votre base de données existante #
############################################################

    # Remplacer nom_bdd et user_bdd et password_bdd et le nom du serveur localhost avec les informations de connexion à votre Base de données.
    BDD_existe_NAME="NOM";
    BDD_existe_USER="USER";
    BDD_existe_PASSWORD="PASSWD";
    BDD_existe_SERVEUR="localhost";

######################################
# Créer une nouvelle base de données #
######################################

    # Créer une nouvelle base de données avec les informations ci-dessous :
    BDD_creer_NAME="nouvelle_bdd_mediawiki_archive";
    BDD_creer_USER="utilisateur_mysql_mediawiki_archive";
    # Le mot de passe de la nouvelle base de données est enregistré ici :
    BDD_creer_PASSWORD="password_utilisateur_mysql_mediawiki_archive";
    BDD_creer_SERVEUR="localhost";

#######################################################################################################################
#######################################################################################################################

#######################################################################################################################
#######################################################################################################################

#####################################
# Ne pas modifier le code suivant ! #
#####################################

#######################################################################################################################
#######################################################################################################################

#######################################################################################################################
#######################################################################################################################

######################
# Variables globales #
######################

# Afficher l'emplacement du chemin ou est lancé le script :
MW_Chemin_Actuel='pwd';

# Met en variable la version actuelle de Mediawiki si Mediawiki est installé :
MW_Version_Actuelle=$(grep 'MW_VERSION' "$MW_Chemin_Complet_Du_Site/includes/Defines.php" | sed "s/.*'\(.*\)'.*/\1/");

# URL pour récupérer la version de MediaWiki depuis une page spécifique :
MW_URL="https://www.mediawiki.org/wiki/Download";

# Toutes les versions en archive de Mediawiki :
MW_URL_ALL_VERSIONS="https://releases.wikimedia.org/mediawiki"

# Récupérer la dernière version de MediaWiki via curl et afficher uniquement le numéro de version :
MW_DERNIERE_VERSION=$(curl -s "$MW_URL" | grep -oP 'Download MediaWiki \K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1);


#############
# Fonctions #
#############

################################################
# Fonction réutilisable pour afficher le titre #
################################################
    afficher_titre() {
        # Vider l'écran du terminal :
        clear;
        local message="$1"
        echo "\033[32m #############################\033[0m"
        echo "\033[32m # $message #\033[0m"
        echo "\033[32m #############################\033[0m"
        echo "";
    }
    # Exemple pour afficher le titre :
    # afficher_titre "Installation de Mediawiki"

######################################################
# Fonction réutilisable pour afficher l'introduction #
######################################################
    afficher_introduction() {
        local introduction="$1"
        echo "\033[38;5;245m Note : $introduction\033[0m";
        echo "";
    }
    # Exemple pour afficher l'introduction :
    # afficher_introduction "Vérifier ceci cela ..."

##############################################################################
# Fonction réutilisable pour réafficher le curseur une fois le script arrêté #
##############################################################################
# Cacher le curseur au début du script :
ui_init() {
    stty -echoctl < /dev/tty
    printf '\033[?25l'
}

# Réafficher le curseur à la fin du script :
ui_cleanup() {
    printf '\033[?25h'
    stty sane < /dev/tty
}

trap 'ui_cleanup; exit 130' INT
trap 'ui_cleanup; exit 143' TERM
trap ui_cleanup EXIT

# Cacher le curseur au début du script :
printf '\033[?25l'

###############################################################################
# Fonction réutilisable pour mettre fin au sleep avec n'importe quelle touche #
###############################################################################
sleep_key() {
    timeout="$1"
    elapsed=0

    cleanup_exit() {
        stty sane < /dev/tty
        echo
    }

    # ✅ Effet : Le script nettoie correctement le terminal si le script est arrêté de l'extérieur.
    # ❌ Ctrl-C n'est pas concerné, le script reste libre de recevoir SIGINT normalement.
    # trap cleanup_exit TERM
    #
    # ✅ Effet : Protège le terminal mais on change le comportement attendu de Ctrl-C qui ne peut plus arrêter le script.
    # CTRL-C relance le timer -1 seconde et affiche une nouvelle ligne avec le timer.
    # trap cleanup_exit INT TERM
    #
    # ✅ Restaure le terminal à la fin, peu importe comment le script se termine.
    trap cleanup_exit EXIT

    stty -icanon -echo < /dev/tty

    printf "\n"

    while [ "$elapsed" -lt "$timeout" ]; do
        remaining=$((timeout - elapsed))
        printf "\r\033[32m ✅ Appuyer sur une touche pour continuer l'installation ... %2ds\033[0m" "$remaining"

    # Touche entrée fait défiler le temps d'attente sleep plus rapidement.
    # Touche espace met en pause le temps d'attente sleep.
    # Touche autres met fin au temps d'attente sleep.
    # CTRL + c met fin au temps d'attente sleep.
    # stty -icanon -isig min 0 time 10
    #
    # CTRL + c permet de quitter le script sans erreur :
    stty -icanon isig min 0 time 10

    read key
    stty icanon
    [ -n "$key" ] && break
        elapsed=$((elapsed + 1))
    done

    cleanup_exit
}
    # Exemple pour utiliser sleep_key :
    # sleep_key 15

########################################################################
# Fonction réutilisable pour afficher les 3 versions Stable Legacy LTS #
########################################################################
MAJORS=$(curl -fs "$MW_URL_ALL_VERSIONS/" \
  | sed -n 's/.*href="\([0-9]\+\.[0-9]\+\)\/".*/\1/p' \
  | sort -Vr \
  | head -n 3)

latest_minor() {
    curl -fs "$MW_URL_ALL_VERSIONS/$1/" \
      | sed -n 's/.*href="mediawiki-\('"$1"'\.[0-9]\+\)\.tar\.gz".*/\1/p' \
      | sort -Vr \
      | head -n 1
}

set -- $MAJORS

# Stable : Dernière version du répertoire le plus récent (Ex: 1.45.1)
VERSION_1=$(latest_minor "$1")
# Legacy : Dernière version du répertoire juste avant stable (Ex: 1.44.3)
VERSION_2=$(latest_minor "$2")
# LTS : Dernière version LTS dans le répertoire plus ancien (Ex: 1.43.6)
VERSION_3=$(latest_minor "$3")

# Utiliser les fonctions depuis un fichier externe.
# source ./fonctions-installer-mediawiki.sh

#######################################################################################################################
#######################################################################################################################

###########################
# Démarrer l'installation #
###########################

#######################################################################################################################
#######################################################################################################################

###################
# Début du script #
###################

clear;
afficher_titre "Installation de Mediawiki"

echo " Appuyer sur la touche espace de façon prolongée pour mettre en pause.";
echo "";
echo " Appuyer sur n'importe quelle touche du clavier pour passer à l'étape suivante.";
echo "";
echo " Appuyer sur la touche entrée pour accélérer le compteur et passer à l'étape suivante.";

    # Temps d'attente de 15 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 15


# Emplacement du script d'installation.
##########################################
# Afficher le titre vide l'écran :
afficher_titre "Installation de Mediawiki"
afficher_introduction "Vérifier l'emplacement du script installer-ou-mettre-a-jour-mediawiki.sh pour démarrer l'installation.";
##########################################

echo " Le répertoire recommandé pour placer le script d'installation est \"$MW_Chemin_Du_Script\".";
echo " Le répertoire dans lequel le script a été exécuté est \"$(eval $MW_Chemin_Actuel)\".";

echo "";

if [ "$MW_Chemin_Du_Script" = $(eval $MW_Chemin_Actuel) ]; then
    echo "\033[32m ✅ Le script est bien placé dans le répertoire recommandé $MW_Chemin_Du_Script.\033[0m";

    # Temps d'attente de 20 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 20;
else
    echo "\033[31m ❌ Le script n'est pas dans le répertoire recommandé $MW_Chemin_Du_Script.\n Fin de l'installation !\033[0m";
    exit;
fi


# Version installée ou a installer.
##########################################
# Afficher le titre vide l'écran :
afficher_titre "Installation de Mediawiki"
afficher_introduction "Vérifier la version installée de Mediawiki et vérifier si Mediawiki doit être mis à jour.";
##########################################

if [ -n "$MW_Version_Actuelle" ]; then
    # Si la variable n'est pas vide, il existe une version installée de Mediawiki :
    echo "\033[32m ✅ MediaWiki $MW_Version_Actuelle est actuellement installé dans le répertoire \"$MW_Chemin_Complet_Du_Site\".\033[0m";
else
    echo "\033[31m ❌ MediaWiki n'a pas été trouvé ou n'est pas installé.\033[0m"
fi

echo "";

# Afficher le numéro de version de Mediawiki renseigné au début du script pour être installé :
echo "\033[94m ✅ Mediawiki $MW_VERSION_ATTENDUE est la version renseignée au début du script comme étant la version a installer.\033[0m";

# Comparaison numérique simplifiée :
if [ "$(echo $MW_Version_Actuelle | cut -d'.' -f1,2,3)" \< "$(echo $MW_VERSION_ATTENDUE | cut -d'.' -f1,2,3)" ]; then
    echo "\033[31m ❌ La version actuellement installée de MediaWiki ($MW_Version_Actuelle) est inférieure à la version de Mediawiki renseignée au début du script ($MW_VERSION_ATTENDUE).\033[0m"

    echo "";

    echo "\033[32m ✅ Il est recommandé de continuer la mise à jour de Mediawiki :\033[0m";
    echo "\033[32m    - vers la version renseignée au début du script pour installer Mediawiki ($MW_VERSION_ATTENDUE).\033[0m";
    echo "\033[32m    - vers la dernière version stable de Mediawiki ($MW_DERNIERE_VERSION).\033[0m";
else
    echo "\033[31m ✅ La version actuellement installée de MediaWiki ($MW_VERSION_Actuelle) est supérieure ou égale à la version de Mediawiki renseignée au début du script ($MW_VERSION_ATTENDUE).\033[0m"
    echo "\033[31m ❌ Il n'est pas recommandé de continuer l'installation vers une ancienne version de Mediawiki !\n Fin de l'installation !\033[0m";

    echo "Continuer pour sauvegarder la version actuelle et réinstaller MediaWiki ? (o/N) : \c"
    read choix
    case "$choix" in
        o|O|oui|OUI)
            echo "\033[33m ⚠️  Continuer l'installation en cours...\033[0m"
            ### 👉 Code de réinstallation ici
            ;;
        *)
            echo "\033[31m Fin de l'installation !\033[0m"
            exit 1
            ;;
    esac
fi

echo "";
echo "\033[32m Dernières versions disponibles de MediaWiki :\033[0m"
[ -n "$VERSION_1" ] && echo "\033[32m 1) Stable $VERSION_1\033[0m"
[ -n "$VERSION_2" ] && echo "\033[32m 2) Legacy $VERSION_2\033[0m"
[ -n "$VERSION_3" ] && echo "\033[32m 3) LTS $VERSION_3\033[0m"
echo "";

################################################
# Lister les différentes versions de Mediawiki #
################################################
# Ne pas afficher le C^ du CTRL-C :
stty -echoctl < /dev/tty

while true; do
    printf "Afficher les dernières \"x\" versions de Mediawiki (Ex:3) ou appuyer sur \"c\" pour continuer : "
    read -r x

    case "$x" in
        c|C)
            break;
            ;;
    esac

    case "$x" in
        ''|*[!0-9]*)
            echo "❌ Saisir un nombre entier positif."
            continue
            ;;
    esac

    # 1️⃣  Récupérer les X branches majeures les plus récentes :
    MAJORS=$(curl -fs "$MW_URL_ALL_VERSIONS/" \
      | sed -n 's/.*href="\([0-9]\+\.[0-9]\+\)\/".*/\1/p' \
      | sort -Vr \
      | head -n "$x")

    # 2️⃣  Fonction pour récupérer toutes les sous-versions d'une branche :
    all_minors() {
        curl -fs "$MW_URL_ALL_VERSIONS/$1/" \
          | sed -n 's/.*href="mediawiki-\('"$1"'\.[0-9]\+\(-[0-9a-zA-Z.-]\+\)\?\)\.tar\.gz".*/\1/p' \
          | sort -Vr
    }

    # 3️⃣  Afficher les versions pour chaque branche :
    for branch in $MAJORS; do
        echo "📦 Versions pour la branche $branch :"
        all_minors "$branch"
        echo "------------------------------------"
    done

    break
done

    # Temps d'attente de 20 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 20;

echo "";

#################################################
# Confirmer la version de Mediawiki a installer #
#################################################
# Ne pas afficher le C^ du CTRL-C :
stty -echoctl < /dev/tty

while true; do
    # Confirmer le choix de l'utilisateur :
    printf " Confirmer une version de Mediawiki a installer (Ex: 1.45.1) ou appuyer sur \"c\" pour continuer avec la version de Mediawiki $MW_VERSION_ATTENDUE renseignée au début du script : "
    read -r MW_VERSION_ATTENDUE_CONFIRMATION

    # ✅ Quitter avec c ou C :
    case "$MW_VERSION_ATTENDUE_CONFIRMATION" in
        c|C|continuer)
            # ✅ Utiliser la version de Mediawiki $MW_VERSION_ATTENDUE renseignée au début du script.
            FLAG_MW_VERSION_CONFIRMEE=""
            break
            ;;
    esac

    # 1️⃣  Vérifier le format X.Y.Z avec case :
    case "$MW_VERSION_ATTENDUE_CONFIRMATION" in
        [0-9]*.[0-9]*.[0-9]*)
        FLAG_MW_VERSION_CONFIRMEE="$MW_VERSION_ATTENDUE_CONFIRMATION"
            ;;
        *)
            echo " ❌ Format invalide. Exemple attendu : 1.45.1"
            continue
            ;;
    esac
    # 2️⃣  Extraire le répertoire de la VERSION_PRINCIPALE (X.Y) pour construire l'URL :
    VERSION_PRINCIPALE="${MW_VERSION_ATTENDUE_CONFIRMATION%.*}"
    ZIP_URL="$MW_URL_ALL_VERSIONS/$VERSION_PRINCIPALE/mediawiki-$MW_VERSION_ATTENDUE_CONFIRMATION.zip"

    # 3️⃣  Vérifier que la version existe réellement :
    if ! curl -fsI "$ZIP_URL" >/dev/null 2>&1; then
        echo " ❌ La version MediaWiki $MW_VERSION_ATTENDUE_CONFIRMATION n'existe pas."
        continue
    fi

    # Sortir de la boucle.
    break
done

    # Temps d'attente de 20 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 20;

#############################################################
# Afficher la version de Mediawiki sélectionnée a installer #
#############################################################
# La version de Mediawiki a installer est dans $FLAG_MW_VERSION_CONFIRMEE et le lien correspondant a utiliser dans $ZIP_URL :
if [ -n "$FLAG_MW_VERSION_CONFIRMEE" ]; then
    echo " ✅ Continuer l'installation de MediaWiki $MW_VERSION_ATTENDUE_CONFIRMATION"
    echo " 📦 Lien pour télécharger la version de Mediawiki qui va être installée : $ZIP_URL"
# Afficher la version de Mediawiki renseignée au début du script et le lien a utiliser :
else
    echo " ✅ Utiliser la version de Mediawiki $MW_VERSION_ATTENDUE renseignée au début du script."
    VERSION_PRINCIPALE="${MW_VERSION_ATTENDUE%.*}"

    # Exemple :
    # ZIP_URL="https://releases.wikimedia.org/mediawiki/1.44/mediawiki-1.44.0.zip"

    ZIP_URL="$MW_URL_ALL_VERSIONS/$VERSION_PRINCIPALE/mediawiki-$MW_VERSION_ATTENDUE.zip"
    echo " 📦 Lien pour télécharger la version de Mediawiki qui va être installée : $ZIP_URL"
    # Version reconfirmée :
    FLAG_MW_VERSION_CONFIRMEE="$MW_VERSION_ATTENDUE"
fi

    # Temps d'attente de 20 secondes.
    # Appuyer une touche pour continuer l'installation ...
    sleep_key 20;
#############################################################


# Vérifier les services disponibles sur le serveur.
##########################################
# Afficher le titre vide l'écran :
afficher_titre "Installation de Mediawiki"
afficher_introduction "Vérifier les services disponibles sur le serveur pour installer Mediawiki.";
##########################################

echo " Vérifier la version de Apache2 :";
if command -v apache2 > /dev/null 2>&1; then
echo "\033[32m ✅ Apache2 est installé.\n $(apache2 -v | head -n 1)\033[0m";
else
    echo "\033[31m ❌ Apache2 n'est pas installé.\033[0m";
fi
echo "";

# echo " Liste des répertoires PHP présents sur le serveur :";
# ls /etc/php/;
# echo "";

echo " Vérifier la version de PHP CLI :";
if which php > /dev/null; then
    echo " ✅ Version installée par défaut pour PHP CLI :";
    php_cli_defaut=$(php -v);

    # Ajouter un espace devant Copyright et devant Zend :
    php_cli_defaut=$(php -v | sed 's/^\(Copyright\|Zend\)/ \1/')

    echo "\033[32m $php_cli_defaut \033[0m";
    echo "";
    echo " Chemin vers l'executable de PHP CLI :";
    php_cli=$(command -v php);
    echo "\033[32m $php_cli \033[0m";
else
    echo "\033[31m ❌ Aucune version de PHP CLI n'est installée par défaut.\033[0m";
fi
echo "";

# Vérifier les versions installées de PHP CLI et PHP FPM :
echo " Vérifier les versions installées de PHP CLI et PHP FPM :";
php_found=false

# Chercher toutes les versions CLI dans le répertoire PHP :
for php_cli_path in /etc/php/*/cli; do
    if [ -d "$php_cli_path" ]; then
        php_version=$(basename $(dirname "$php_cli_path"))
        php_found=true
        echo "\033[32m Version PHP CLI trouvée : $php_version\033[0m";
    fi
done
# Si aucune version CLI de PHP n'a été trouvée :
if ! $php_found; then
    echo "\033[31m ❌ Aucune version PHP CLI trouvée.\033[0m";
fi
echo "";

# Chercher toutes les versions FPM dans le répertoire PHP :
for php_fpm_path in /etc/php/*/fpm; do
    if [ -d "$php_fpm_path" ]; then
        php_version=$(basename $(dirname "$php_fpm_path"))
        php_found=true
        echo "\033[32m ✅ Version PHP FPM trouvée : $php_version\033[0m";
    fi
done
# Si aucune version FPM de PHP n'a été trouvée :
if ! $php_found; then
    echo "\033[31m ❌ Aucune version PHP FPM trouvée.\033[0m";
fi
echo "";

# Vérifier MySQL et version compatible avec MediaWiki :
echo " Vérifier si MySQL est installé :";
if command -v mysql > /dev/null 2>&1; then
    mysql_version=$(mysql --version);
    echo "\033[32m ✅ MySQL est installé :\n $mysql_version\033[0m";
else
    echo "\033[31m ❌ MySQL n'est pas installé.\033[0m";
fi
echo "";

# Vérifier MariaDB et version compatible avec MediaWiki :
echo " Vérifier si MariaDB est installé :";
if command -v mariadb > /dev/null 2>&1; then
    mariadb_version=$(mariadb --version)
    echo "\033[32m ✅ MariaDB est installé :\n $mariadb_version\033[0m";
else
    echo "\033[31m ❌ MariaDB n'est pas installé.\033[0m";
fi
echo "";

# Vérifier si d'autres bases de données sont disponibles (PostgreSQL) :
echo " Vérifier si PostgreSQL est installé :";
if command -v psql > /dev/null 2>&1; then
    echo " ✅ PostgreSQL est installé :";
    psql_version=$(psql --version)
    echo "\033[32m ✅ PostgreSQL est installé :\n $psql_version\033[0m";
else
    echo "\033[31m ❌ PostgreSQL n'est pas installé.\033[0m";
fi
echo "";

# Vérifier si d'autres bases de données compatibles MediaWiki sont disponibles (SQLite3) :
echo " Vérifier si SQLite3 est installé :";
if command -v sqlite3 > /dev/null 2>&1; then
    sql_version=$(sqlite3 --version)
    echo "\033[32m ✅ SQLite3 est installé :\n $sql_version\033[0m";
else
    echo "\033[31m ❌ SQLite n'est pas installé.\033[0m";
fi

    # Temps d'attente de 30 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 30;


# Vérifier si une base de données existe.
##########################################
# Afficher le titre vide l'écran :
afficher_titre "Installation de Mediawiki"
afficher_introduction "Vérifier si la base de données existe à partir du fichier LocalSettings.php / ou utiliser les accès renseignés au début du script / afficher le nom de la base de données existante et vérifier la connexion.";
##########################################

##############################
# ==> Donner le choix, utiliser le fichier LocalSettings.php OU utiliser les accès renseignés dans les variables pour se connecter à la base de données existante ...
##############################

# Ne pas afficher le C^ du CTRL-C :
stty -echoctl < /dev/tty

while :; do
    echo " Définir une méthode de connexion vers la base de données :"
    echo " 1. Utiliser les informations du fichier LocalSettings.php pour se connecter à la base de données si Mediawiki est déjà installé."
    echo " 2. Utiliser les accès qui ont été renseignés dans ce script pour se connecter si une base de données existe déjà."
    echo " 3. Mediawiki n'est pas encore installé et une nouvelle base de données doit être créée."
    echo " 4|Q|q : Quitter l'installation."

    printf " Votre choix : "
    read choix

    # Si entrée vide → recommencer
    if [ -z "$choix" ]; then
        clear;
# Erreur vs invalide ?
        afficher_titre "Installation de Mediawiki"
        echo "\033[31m ❌ Erreur, il faut utiliser 1, 2, 3 ou 4.\033[0m"
echo "";
        continue
    fi

    # Vérifier que le choix est valide avec case (plus sûr que -eq)
    case "$choix" in
        1)
            echo " Vous avez choisi 1"
            break
            ;;
        2)
            echo " Vous avez choisi 2"
            break
            ;;
        3)
            echo " Vous avez choisi 3"
            break
            ;;
        4|Q|q)
            echo " Fin de l'installation."
            exit 0
            ;;
        *)
# Invalide vs erreur ?
            clear
            afficher_titre "Installation de Mediawiki"
            echo "\033[31m ❌ Choix invalide, il faut utiliser 1, 2, 3 ou 4.\033[0m"
echo "";
            ;;
    esac
done


###########
# Choix 1 #
###########
if [ "$choix" -eq 1 ]; then

    # Chemin vers le fichier LocalSettings.php :
    LOCALSETTINGS="$MW_Chemin_Complet_Du_Site/LocalSettings.php"

    echo "\n Chemin du fichier LocalSettings.php : $LOCALSETTINGS";

    # Extraire les informations de connexion à la base de données depuis LocalSettings.php avec awk :
    BDD_localsettings_SERVER=$(awk -F= '/\$wgDBserver/ {gsub(/[ ;'\''"]/,"",$2); print $2}' "$LOCALSETTINGS")
    BDD_localsettings_NAME=$(awk -F= '/\$wgDBname/ {gsub(/[ ;'\''"]/,"",$2); print $2}' "$LOCALSETTINGS")
    BDD_localsettings_USER=$(awk -F= '/\$wgDBuser/ {gsub(/[ ;'\''"]/,"",$2); print $2}' "$LOCALSETTINGS")
    BDD_localsettings_PASSWORD=$(awk -F= '/\$wgDBpassword/ {gsub(/[ ;'\''"]/,"",$2); print $2}' "$LOCALSETTINGS")

    # Vérifier l'existence de la base de données :
    RESULT=$(mysql -h "$BDD_localsettings_SERVER" -u "$BDD_localsettings_USER" -p"$BDD_localsettings_PASSWORD" -e "SHOW DATABASES LIKE '$BDD_localsettings_NAME';" | grep -v "Database\|+--" | awk '{print $1}')

    echo ""

    # Si le résultat n'est pas vide :
    if [ "$RESULT" ]; then
        echo " 1. Si Mediawiki est déjà installé, vérifier les informations de connexion à la base de données dans le fichier LocalSettings.php."
        echo "\033[32m ✅ Les informations de connexion à la base de données '$BDD_localsettings_NAME' renseignées dans le fichier LocalSettings.php fonctionnent.\n\033[0m"

        # Vérifier les valeurs du fichier LocalSettings.php :
        echo " 2. Les informations de connexion à la base de données renseignées dans le fichier LocalSettings.php :"
        echo " Serveur: $BDD_localsettings_SERVER"
        echo " Base de données: $BDD_localsettings_NAME"
        echo " Utilisateur: $BDD_localsettings_USER"
        # echo " Mot de passe: [PROTÉGÉ] [DEBUG] --> $BDD_localsettings_PASSWORD"
        echo " Mot de passe: [PROTÉGÉ]"

        # Temps d'attente de 15 secondes.
        # Appuyer une touche pour continuer l'installation...
        sleep_key 15;
    else
        echo "\033[31m ❌ Les informations de connexion à la Base de données '$BDD_localsettings_NAME' renseignées dans le fichier LocalSettings.php ne fonctionnent pas.\033[0m"
        echo "\033[32m Continuer l'installation... Il est possible de créer une nouvelle base de données plus loin dans cette installation.\033[0m"
        BDD_existe="non"
    fi
fi


###########
# Choix 2 #
###########
if [ "$choix" -eq 2 ]; then
    # Vérifier les informations de connexion pour la base de données renseignées au début du script :
    echo " Utiliser les informations de connexion pour la base de données renseignées au début du script :"
    echo " Serveur: ${BDD_existe_SERVEUR}"
    echo " Nom de la base de données: ${BDD_existe_NAME}"
    echo " Utilisateur: ${BDD_existe_USER}"
    echo " Mot de passe: [PROTÉGÉ]"

    # Vérifier l'existence de la base de données :
    RESULT=$(mysql -h "${BDD_existe_SERVEUR}" -u "${BDD_existe_USER}" -p"${BDD_existe_PASSWORD}" -e "SHOW DATABASES LIKE '${BDD_existe_NAME}';" | grep -v "Database\|+--" | awk '{print $1}')

    echo "";

    # Vérifier si le résultat est vide :
    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Nom de la base de données ??? !!!
    if [ "$RESULT" ]; then
        echo " 2. Utiliser la connexion vers la base de données renseignée au début du script."
        echo "\033[32m La base de données '${BDD_existe_NAME}' existe.\033[0m"
        echo "\033[32m ✅ Les informations de connexion à la base de données '$BDD_existe_SERVEUR' renseignées au début du script fonctionnent.\n\033[0m"

        # Temps d'attente de 20 secondes.
        # Appuyer une touche pour continuer l'installation...
        sleep_key 20;
    else
        echo "\033[31m ❌ La base de données '${BDD_existe_NAME}' n'existe pas.\033[0m"
        echo "\033[32m Continuer l'installation...\033[0m"
        BDD_existe="non";
    fi
fi


###########
# Choix 3 #
###########
if [ "$choix" -eq 3 ]; then
    echo " 3. Mediawiki n'est pas installé et la base de données doit être créée."

    # Temps d'attente de 20 secondes.
    # Appuyer une touche pour continuer l'installation...
    sleep_key 20;
fi


###########
# Choix 4 #
###########
# Quitter l'installation :
if [ "$choix" -eq 4 ]; then
    exit;
fi



# SUITE DU SCRIPT A INTEGRER ...



sleep 2;
# echo "";
# echo " ############";
# echo " Vérification : Afficher la structure de la table 'user' si elle existe.";
# echo " ############";
# echo "";

# Afficher la table user si elle existe :
# echo " Afficher la structure de la table 'user' si elle existe :";
# echo "";

# Remplacer par le nom de la table Mediawiki a tester :
# TABLE_NAME="${BDD_TABLE_PREFIXE}user"

# Requête pour récupérer la structure de la table :
# RESULT=$(mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "DESCRIBE $TABLE_NAME;" | grep -v "Field\|Type\|Null\|Key\|Default\|Extra" | awk '{$1=$1};1')

# Vérifier si le résultat est vide :
# if [ "$RESULT" ]; then
#  echo "\033[32m ✅ $RESULT\nContinuer l'installation...\033[0m"
# else
#  echo "\033[31m ❌ La table '$TABLE_NAME' n'existe pas ou n'a pas de structure définie.\nFin de l'installation !\033[0m"
# exit;
# fi



sleep 2
echo ""
echo " ############"
echo " Vérification : Afficher le contenu de la table 'user' si elle existe.";
echo " ############"
echo "";

# echo " Afficher le contenu de la table 'user' si elle existe :"
echo " Afficher le contenu user_name et user_email de la table 'user' si elle existe :"
echo ""

# Tester la table 'user' de Mediawiki avec le préfixe de la base de données renseigné dans les variables :
TABLE_NAME="${BDD_TABLE_PREFIXE}user"

# Affiche le nom de la table 'user' avec le préfixe :
echo " Nom de la table à tester : $TABLE_NAME\n"

# Vérifier si la table 'user' existe :
if [ "$choix" -eq 1 ]; then

    # Données de connexion LocalSettings.php :
    TABLE_EXISTS=$(mysql -h "$BDD_localsettings_SERVER" -u "$BDD_localsettings_USER" -p"$BDD_localsettings_PASSWORD" -D "$BDD_localsettings_NAME" -e "SHOW TABLES LIKE '$TABLE_NAME';")

    if [ -z "$TABLE_EXISTS" ]; then
        # Si la table n'existe pas :
        echo "\033[31m ❌ La table '$TABLE_NAME' n'existe pas.\n\033[0m\033[32m$RESULT\nContinuer l'installation...\033[0m"

        # La table user n'existe pas :
        BDD_existe="non-user";

    else

        # DEBUG :
        # Vérifier les valeurs du fichier LocalSettings.php :
        echo " Informations de connexion vers la Base de données renseignée dans le fichier LocalSettings.php :"
        echo " Serveur: $BDD_localsettings_SERVER"
        echo " Base de données: $BDD_localsettings_NAME"
        echo " Utilisateur: $BDD_localsettings_USER"
        echo " Mot de passe: [PROTÉGÉ]"

        # Exécute la commande pour lister toutes les données de la table user :
        # Exemple :
        # RESULT=$(mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM $TABLE_NAME LIMIT 10;" 2>/dev/null)
        # Si la table 'user' existe, on vérifie si elle est vide :
        RESULT=$(mysql -h "$BDD_localsettings_SERVER" -u "$BDD_localsettings_USER" -p"$BDD_localsettings_PASSWORD" -D "$BDD_localsettings_NAME" -e "SELECT user_name, user_email FROM $TABLE_NAME LIMIT 10;" 2>/dev/null)

        # Vérifier si le résultat contient des données :
        if echo "$RESULT" | grep -q "Empty set"; then
            echo "\033[31mLa table '$TABLE_NAME' est vide.\nIl faut créer un utilisateur administrateur.\033[0m"
            # La table user existe mais est vide ! Il faut créer un utilisateur administrateur !
            BDD_existe="non-user-vide";
        else
            # Affiche le contenu de la table 'user' si un contenu existe :
            echo "\033[32m"
            echo "$RESULT" | column -t | sed 's/^/        /'
            echo "\n ✅ Continuer l'installation...\033[0m"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        fi
    fi
fi

# Vérifier si la table 'user' existe :
if [ "$choix" -eq 2 ]; then

    # Données de connexion manuelle :
    TABLE_EXISTS=$(mysql -h "$BDD_existe_SERVER" -u "$BDD_existe_USER" -p"$BDD_existe_PASSWORD" -D "$BDD_existe_NAME" -e "SHOW TABLES LIKE '$TABLE_NAME';")

    if [ -z "$TABLE_EXISTS" ]; then
        # Si la table n'existe pas :
        echo "\033[31m ❌ La table '$TABLE_NAME' n'existe pas.\033[0m"

        # La table user n'existe pas :
        BDD_existe="non-user";

        echo "\033[32m$RESULT\n ✅ Continuer l'installation...\033[0m"

    else
        # DEBUG :
        # Vérifier les valeurs du fichier LocalSettings.php :
        echo " Informations de connexion vers la Base de données renseignées manuellement :"
        echo " Serveur: $BDD_existe_SERVER"
        echo " Base de données: $BDD_existe_NAME"
        echo " Utilisateur: $BDD_existe_USER"
        echo " Mot de passe: [PROTÉGÉ]\n"

        # Exécute la commande pour lister toutes les données de la table user :
        # Exemple :
        # RESULT=$(mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SELECT * FROM $TABLE_NAME LIMIT 10;" 2>/dev/null)
        # Si la table 'user' existe, on vérifie si elle est vide :
        RESULT=$(mysql -h "$BDD_existe_SERVER" -u "$BDD_existe_USER" -p"$BDD_existe_PASSWORD" -D "$BDD_existe_NAME" -e "SELECT user_name, user_email FROM $TABLE_NAME LIMIT 10;" 2>/dev/null)

        # Vérifier si le résultat contient des données :
        if echo "$RESULT" | grep -q "Empty set"; then
            echo "\033[31m ❌ La table '$TABLE_NAME' est vide.\nIl faut créer un utilisateur administrateur.\033[0m"
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        # La table user existe mais est vide ! Il faut créer un utilisateur administrateur !
        BDD_existe="non-user-vide";

        else
            # Affiche le contenu de la table 'user' si un contenu existe :
            echo "\033[32m ✅ $RESULT\nContinuer l'installation...\033[0m" | column -t
        fi
    fi
fi

# Vérifier si la table 'user' existe :
if [ "$choix" -eq 3 ]; then
    echo "\033[32m ❌ Aucune Base de données n'est renseignée pour Mediawiki. Ne pas vérifier l'existance de la table '$TABLE_NAME'.\033[0m";
    # Choix 3 : Aucune base de données n'existe :
    BDD_existe="non";
    echo "\033[32m ✅ Il est nécessaire de créer une base de données pour installer Mediawiki.\033[0m"
    echo "\033[32m Continuer l'installation...\033[0m"
fi



sleep 2;
# echo "";
# echo " ############";
# echo " Vérification : Affiche la structure de toutes les tables.";
# echo " ############";
# echo "";

# Connexion à la base de données pour afficher la structure de toutes les tables :
# TABLES=$(mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "SHOW TABLES;" | awk 'NR>1')

# Afficher la structure pour toutes les tables :
# for TABLE in $TABLES; do
#    echo "Structure de la table '$TABLE' :"
#    mysql -h "$DB_SERVER" -u "$DB_USER" -p"$DB_PASSWORD" -D "$DB_NAME" -e "DESCRIBE $TABLE;"
# done



sleep 2;
echo "";
echo " ############";
echo " Vérification : Créer une nouvelle base de donnéees et afficher les informations pour accéder à la nouvelle base de données.";
echo " ############";
echo "";

# Vérification si la BDD existe ;
if [ "$BDD_existe" = "non" ] || [ "$BDD_existe" = "non-user" ] || [ "$BDD_existe" = "non-user-vide" ]; then
    echo " Création d'une nouvelle Base de données MySQL..."
    echo " Attention ! Si la nouvelle Base de données MySQL a déjà été créée, elle sera supprimée avant d'être recréée !\n"

    # Demande de confirmation pour créer une nouvelle BDD :
    read -p " Voulez-vous créer une nouvelle Base de données ? (o/n) : " reponse

    if [ "$reponse" = "o" ] || [ "$reponse" = "O" ] || [ "$reponse" = "oui" ]; then
        echo "\n Création de la nouvelle Base de données MySQL."

        # Vérification si la base de données existe déjà :
        BDD_EXIST=$(mysql -u root -e "SHOW DATABASES LIKE '${BDD_creer_NAME}';")

    # Si la nouvelle base de données existe déjà, on la supprime avant de la recréer.
    if [ -n "$BDD_EXIST" ]; then
        echo "\033[33m La base de données '${BDD_creer_NAME}' existe déjà. Suppression de la base de données...\033[0m"
        mysql -u root -e "DROP DATABASE IF EXISTS ${BDD_creer_NAME};"
        echo "\033[32m ✅ La Base de données '${BDD_creer_NAME}' est maintenant supprimée.\033[0m"
    fi

        # Si la base de données n'existe pas, créer la base de données :
        if [ -z "$BDD_EXIST" ]; then
            # Créer la BDD et l'utilisateur
            su -c "mysql -u root <<EOF
CREATE DATABASE ${BDD_creer_NAME};
CREATE USER '${BDD_creer_USER}'@'localhost' IDENTIFIED BY '${BDD_creer_PASSWORD}';
GRANT ALL PRIVILEGES ON ${BDD_creer_NAME}.* TO '${BDD_creer_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${BDD_creer_NAME}.* TO '${BDD_creer_USER}'@'${BDD_creer_SERVEUR}' IDENTIFIED BY '${BDD_creer_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Erreur de caractère ? -->            "

            echo "\033[32m ✅ Base de données '${BDD_creer_NAME}' et utilisateur '${BDD_creer_USER}' créés avec succès.\nContinuer l'installation...\033[0m"
        else
            echo "\033[32m Une base de données '${BDD_creer_NAME}' existe déjà.\033[0m"
            echo "\033[32m Continuer l'installation...\033[0m"
        fi
    else
        echo " ❌ Création de la base de données : \033[31mLa base de données n'a pas été créée.\033[0m"
########## ########################### ###################### #
########## Afficher si la BDD existe ? ...................... ?
########## ########################### ###################### #
        echo "\033[32m Continuer l'installation...\033[0m"
    fi
else
    echo "\033[32m Une base de données existe déjà pour Mediawiki :\033[0m"

# Ne pas afficher de variable vide ? Ne pas afficher les 2 en même temps ? ??? ?
    echo " Nom de la base de données renseignée dans le fichier LocalSettings.php : $BDD_localsettings_NAME";
    echo " Nom de la base de données renseignée manuellement : $BDD_existe_NAME";
    echo "\033[32m Continuer l'installation...\033[0m"
fi


##############################################################################################
### Attention à ne pas changer le password de l'utilisateur de la base de données par erreur.#
##############################################################################################


# Arrêter Apache 2.
# Redémarrer Apache 2.


####################
# EXEMPLES DE CODE #
####################
# Vérifier si une version de Mediawiki a été trouvée sur le site et l'afficher :
# if [ -n "$MW_DERNIERE_VERSION" ]; then
#    echo "\033[32m Mediawiki $MW_DERNIERE_VERSION est la dernière version stable renseignée sur le site officiel \"mediawiki.org\".\033[0m";
# else
#    echo "\033[31m ❌ Impossible de récupérer la dernière version stable de MediaWiki sur le site officiel.\033[0m";
# fi


# Activer le debug avant cette partie :
# set +x
# set -x
