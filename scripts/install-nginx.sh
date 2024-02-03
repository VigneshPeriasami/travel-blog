#!/bin/bash

function install_nginx() {
    sudo yum install nginx
}

function main() {
    install_nginx
}

main