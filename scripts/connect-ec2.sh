#!/bin/bash

# Helper that connects to ec2 instances
# Requirements
# Execute ssh commands from local machine

function ssh_ec2() {
    echo "ssh ing into: ec2-user@$1"
    ssh -i $KEY_PAIR ec2-user@$1
}

function main() {
    local choices=(mysql ec2-01)
    echo "Available choices ${choices[@]}"
    read -p "Input:" instance
    
    case $instance in 
        "${choices[0]}")
            ssh_ec2 $MYSQL_HOST
            ;;
        "${choices[1]}")
            ssh_ec2 $EC2_INSTANCE_01
            ;;
        *)
            ssh_ec2 $1
            ;;
    esac
}

main