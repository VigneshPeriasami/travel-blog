#!/bin/bash

# Requirements
# AMI Linux instance that works with yum repositories

MYSQL_GPG_KEY=https://repo.mysql.com/RPM-GPG-KEY-mysql-2023

MYSQL_RPM_VERSION=mysql80-community-release-el9-5.noarch.rpm
# https://dev.mysql.com/get/mysql80-community-release-el9-5.noarch.rpm
MYSQL_COMMUNITY_RPM_URI="https://dev.mysql.com/get/${MYSQL_RPM_VERSION}"

function install_mysql() {
    sudo rpm --import ${MYSQL_GPG_KEY}
    wget ${MYSQL_COMMUNITY_RPM_URI}
    sudo yum localinstall -y ${MYSQL_RPM_VERSION}
    sudo yum install -y mysql-community-server

    sudo systemctl start mysqld 
    sudo systemctl enable mysqld 
}

function default_root_password() {
    local password=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
    echo $password
}

function setup_root_user() {
    local temp_password=$(default_root_password)

    echo "Temporary password: ${temp_password}"
    mysql_secure_installation
}

function mysql_add_user() {
    read -p "Mysql Root password:" my_root_password

    read -p "Mysql New username:" my_new_user
    read -p "Mysql New user password:" my_new_user_password
    
    # todo: Should probably restrict access privileges to database
    mysql_user_command="
    CREATE USER '${my_new_user}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${my_new_user_password}';
    GRANT ALL PRIVILEGES ON *.* TO '${my_new_user}'@'%';
    "

    echo "Executing Command: \n ${mysql_user_command}"

    mysql \
    --user="root" \
    --password="${my_root_password}" \
    --execute="${mysql_user_command}"
}

function main() {
    local task=$1
    local choices=(install-mysql setup_root_password mysql-add-user)

    case $task in
        "${choices[0]}")
            install_mysql
            setup_root_user
            ;;
        "${choices[1]}")
            setup_root_user
            ;;
        "${choices[2]}")
            mysql_add_user
            ;;
        *)
            echo "No Task found: ${task}"
            echo "Available tasks: ${choices[@]}"
            ;;
    esac
}

main "$@"