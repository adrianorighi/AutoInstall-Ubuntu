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

# Storage file for install sequence
INSTALL=/$TMP/install.sh.$$

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
    # echo "Installing VLC, please wait" > $OUTPUT
    # display_output 6 40 "VLC"
    display_progress 6 40 "Adicionando Repositorio VLC" 0
    sudo apt-add-repository ppa:videolan/stable-daily -y &> $LOG
    display_progress 6 40 "Atualizando Pacotes" 10
    sudo apt-get update &> $LOG
    display_progress 6 40 "Instalando VLC" 40
    sudo apt-get install vlc -y &> $LOG
    display_progress 6 40 "Instalando VLC" 100
    sleep 1
    echo "Install VLC completed" > $OUTPUT
    display_output 6 40 "VLC"
}

function Sublime {
    sudo add-apt-repository ppa:webupd8team/sublime-text-3 -y
    sudo apt-get update
    sudo apt-get install sublime-text-installer
}

function Atom {
    sudo add-apt-repository ppa:webupd8team/atom -y
    sudo apt-get update
    sudo apt-get install atom -y
}

function Chrome {
    echo "Installing Chrome" > $OUTPUT
    display_output 6 40 "Chrome"
    cd $TMP
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get -f install
}

function Chromium {
    sudo apt-get install chromium-browser -y
}

function FileZilla {
    sudo add-apt-repository ppa:n-muench/programs-ppa -y
    sudo apt-get update
    sudo apt-get install filezilla -y
}

function WorkBench {
    cd $TMP
    wget https://dev.mysql.com/get/Downloads/MySQLGUITools/mysql-workbench-community-6.3.6-1ubu1510-amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt-get -f install
}

function Tomahawk {
    echo "Installing Tomahawk" > $OUTPUT
    display_output 6 40 "Tomahawk"
	# sudo add-apt-repository ppa:tomahawk/ppa
	# sudo apt-get update
	# sudo apt-get install tomahawk
}

function Php7 {
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt-get update
    sudo apt-get install php7.0 php7.0-fpm -y
    sudo apt-get install php7.0-cli php7.0-mysql php7.0-curl php-memcached php7.0-dev php7.0-mcrypt -y
    sudo phpenmod mcrypt
    sudo service php7.0-fpm restart
}

function qBitTorrent {
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable -y
    sudo apt-get update
    sudo apt-get install qbittorrent
}

function VirtualBox {
    sudo apt-get install dkms -y
    cd $TEMP
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install virtualbox-5.0
}

function Kodi {
    sudo add-apt-repository ppa:team-xbmc/ppa -y
    sudo apt-get update
    sudo apt-get install kodi -y
    sudo apt-get install --install-suggests kodi
}

function Flash {
    sudo add-apt-repository -r ppa:mqchael/pipelight -y
    sudo add-apt-repository -r ppa:ehoover/compholio -y
    sudo apt-get update
    sudo apt-get install --install-recommends pipelight-multi
    sudo pipelight-plugin --update
    sudo pipelight-plugin --enable flash
    sudo pipelight-plugin --enable widevine
    sudo pipelight-plugin --enable silverlight
    sudo pipelight-plugin --update
    sudo pipelight-plugin --create-mozilla-plugins
}

function Skype {
    sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner" -y
    sudo apt-get update
    sudo apt-get install skype
    sudo apt-get -f install
}

function AfterInstall {
    sudo add-apt-repository ppa:thefanclub/ubuntu-after-install -y
    sudo apt-get update
    sudo apt-get install ubuntu-after-install
}

function restrictedExtras {
    sudo apt install ubuntu-restricted-extras -y
}

function unityTweakTool {
    sudo apt install unity-tweak-tool -y
}

function installProgramms() {
    whiptail --title "Install your programs" --checklist --separate-output "Choose programs to install:" 20 78 15 \
    "1" "VLC" off \
    "2" "Sublime Text 3" off \
    "3" "Atom" off \
    "4" "Google Chrome" off \
    "5" "Tomahawk Player" off 2> $INSTALL

    while read choice
    do
    case $choice in
        1) VLC
        ;;
        2) Sublime
        ;;
        3) Chrome
        ;;
        4) Tomahawk
        ;;
        *)
        ;;
    esac
    done < $INSTALL
}

function showLog() {
    cat $LOG > $OUTPUT
    display_output 30 80 "LOG"
}

function autoClean() {
   display_progress 6 40 "Executando Limpeza automática" 0
   sleep 1
   sudo apt-get clean -y &> $LOG
   display_progress 6 40 "Executando Limpeza automática" 30
   sudo apt-get autoremove -y &> $LOG
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
Sua distribuição: $(lsb_release -sc)
\n
adrianorighi.com" 15 50 4 \
Installers "Instalar Aplicações" \
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
