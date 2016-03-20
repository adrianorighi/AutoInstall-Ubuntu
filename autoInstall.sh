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
INPUT=/$TMP/menu.sh.$$

# Storage file for displaying cal and date command output
OUTPUT=/$TMP/output.sh.$$

# Storage file for displaying log
LOG=$TMP/installer.log.$$

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
    local t=${4-percent}
    dialog --title "Aguarde..." --gauge "${q}" 10 75 "${t}"
}



function VLC {
    #echo Installing VLC, please wait" > $OUTPUT
    #display_output 6 40 VLC"
    display_progress 6 40 "Adicionando Repositorio" 0
    apt-add-repository ppa:videolan/stable-daily -y &> $LOG
    display_progress 6 40 "Atualizando Pacotes" 10
    apt-get update &> $LOG
    display_progress 6 40 "Instalando VLC" 40
    apt-get install vlc -y &> $LOG
    display_progress 6 40 "Instalando VLC" 100
    sleep 1
    echo "Install VLC completed" > $OUTPUT
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

function showLog() {
    cat $LOG > $OUTPUT
    display_output 30 80 "LOG"
}

function autoClean() {
   display_progress 6 40 "Executando Limpeza automática" 0
   sleep 1
   apt-get clean -y &> $LOG
   display_progress 6 40 "Executando Limpeza automática" 30
   apt-get autoremove -y &> $LOG
   display_progress 6 40 "Executando Limpeza automática" 50
   sudo apt-get autoclean -y &> $LOG
   display_progress 6 40 "Executando Limpeza automática" 80
   sudo dpkg --configure -a &> $LOG
   display_progress 6 40 "Executando Limpeza automática" 100
   sleep 1
   echo "Limpeza concluída" > $OUTPUT
   display_output 10 40 "Limpeza"

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
--menu "Selecione uma opção\n
\n
adrianorighi.com" 15 50 4 \
Installers "Installers" \
AutoClean "Clean de system" \
ShowLog "Show the log" \
Exit "Exit to the shell" 2>"${INPUT}"

menuitem=$(<"${INPUT}")


# Make decision
case $menuitem in
    AutoClean) autoClean;;
    Installers) installProgramms;;
    ShowLog) showLog;;
    Exit) break;;
esac

done

#
# Delete if temp files on exit
#
trap "rm -rf $TMP" EXIT SIGHUP SIGINT SIGTERM
