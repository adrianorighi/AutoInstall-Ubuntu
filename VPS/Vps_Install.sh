#!/bin/bash

#---------------------------------------------------#
#Shell Script to automate installation of nginx+php7#
#        Run on Ubuntu 14.04 LTS or Later           #
#           Created by Adriano Righi                #
#               adrianorighi.com                    #
#---------------------------------------------------#

clear

    sudo add-apt-repository -y ppa:ondrej/php &
    wait

    apt-get update &
    wait

    apt-get upgrade -y &
    wait

    sudo apt-get install nginx -y &
    wait

    sudo apt-get install php7.0 -y &
    wait

    sudo apt-get install php7.0-fpm -y &
    wait

    sudo apt-get install php7.0-cli php7.0-mysql php7.0-curl php-memcached php7.0-dev php7.0-mcrypt -y &
    wait

    sudo apt-get install mysql-server -y &
    wait


    sudo adduser adriano

    sudo gpasswd -a adriano sudo

    sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default_config
    sudo cp default /etc/nginx/sites-available/default

    sudo phpenmod mcrypt

    sudo service php7.0-fpm restart && service nginx restart

    echo "<?php phpinfo();" >> /usr/share/nginx/html/index.php

exit 0