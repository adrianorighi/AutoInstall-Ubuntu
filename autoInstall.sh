#!/bin/bash

#---------------------------------------------------#
# Shell Script to automate installation of programs #
#        Run on Ubuntu 14.04 LTS or Later           #
#           Created by Adriano Righi                #
#               adrianorighi.com                    #
#---------------------------------------------------#

# Create a temp dir
TMP=${TMPDIR-/tmp}
    TMP=$TMP/righi.$RANDOM.$RANDOM.$RANDOM.$$ # Using a random name
    (umask 077 & mkdir "$TMP") || {
        echo "Erro ao criar diretorio temporario" 1>&2
        exit 1
    }

# Store menu options selected by the user
INPUT=/tmp/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/tmp/output.sh.$$

# Trap and delete temp files
trap "rm $OUTPUT; rm $INPUT; exit" SIGHUP SIGINT SIGTERM

#
# Display message box
#  $1 -> set msgbox height
#  $2 -> set msgbox width
#  $3 -> set msgbox title
#
function display_output(){
    local h=${1-10}         # box height default 10
    local w=${2-41}         # box width default 41
    local t=${3-Output}     # box title
    dialog --backtitle "Adriano Righi Auto Installer Script" --title "${t}" --clear --msgbox "$(<$OUTPUT)" ${h} ${w}
}

#
# Display progress bar box
#
function display_progress(){
    local u=${1-10}
    local p=${2-41}
    local q=${3-Output}
    dialog --title "Aguarde..." --gauge "${q}" 10 75
}



function VLC {
    echo "Instaling VLC" > $OUTPUT
    display_output 6 40 "VLC"
    apt-add-repository ppa:videolan/stable-daily -y
    apt-get update
    apt-get install vlc -y
    echo "Install VLC completed"
    display_output 6 40 "VLC"
}

function Sublime {
    echo "Installing Sublime" > $OUTPUT
    display_output 6 40 "Sublime"
}

function Chrome {
    echo "Installing Chrome" > $OUTPUT
    display_progress 6 40 80
}


function installProgramms() {
    whiptail --title "Install your programs" --checklist --separate-output "Choose programs to install:" 20 78 15 \
    "1" "VLC" off \
    "2" "Sublime Text 3" off \
    "3" "Google Chrome" off 2> $OUTPUT

    while read choice
    do
    case $choice in
        1) VLC
        ;;
        2) Sublime
        ;;
        3) Chrome
        ;;
        *) break
        ;;
    esac
    done < $OUTPUT
}

#
# Set infinite loop
#
while true
do

#
# Display main menu
#
dialog --clear --backtitle "Adriano Righi Auto Installer Script" \
--title "[ M E N U ]" \
--menu "Selecione o que voce deseja instalar\n
\n
adrianorighi.com" 15 50 4 \
Installers "Installers" \
AutoClean "Clean de system" \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# Make decision
case $menuitem in
    AutoClean) autoClean;;
    Installers) installProgramms;;
    Exit) break;;
esac

done

#
# Delete if temp files found
#
[ -f $OUTPUT ] && rm $OUTPUT
[ -f $INPUT ] && rm $INPUT
