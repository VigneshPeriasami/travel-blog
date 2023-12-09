#!/bin/bash

CURRENT_SCRIPT=${BASH_SOURCE[0]}

SERVICE_DIR=service
SERVICE_NAME=auth.service
ZIPPED_FILE=auth-server.zip

DEPLOY_INSTANCE=$MYSQL_EC2

DOCKER_FILES=(docker-compose.yml Dockerfile .env)

AUTH_SERVER_FILES=(auth-server/* aws-misc/auth.service)
AUTH_SERVER_FILES+=(${DOCKER_FILES[@]})

function stop_auth_service() {
    echo "Stopping service: "${SERVICE_NAME}""
    set +e
    
    sudo systemctl stop $SERVICE_NAME
    errorCode=$?
    if [ $errorCode -ne 0 ]; then
        echo "No service Exist "${SERVICE_NAME}""
    fi

    set -e
}

function start_auth_service() {
    echo "Starting service "${SERVICE_NAME}""
    sudo systemctl start $SERVICE_NAME
}

function unpack_auth_service() {
    echo "Starting unpacking"
    rm -rf $SERVICE_DIR
    unzip ${ZIPPED_FILE} -d $SERVICE_DIR
    sudo cp $SERVICE_DIR/aws-misc/${SERVICE_NAME} /etc/systemd/system/${SERVICE_NAME}
    echo "Done unpacking"
}

function zip_auth_server() {
    zip -r $ZIPPED_FILE ${AUTH_SERVER_FILES[@]}
}

function upload_auth_server() {
    zip_auth_server

    scp -i $KEY_PAIR $ZIPPED_FILE $DEPLOY_INSTANCE:~/.
    scp -i $KEY_PAIR $CURRENT_SCRIPT $DEPLOY_INSTANCE:~/

    rm $ZIPPED_FILE
}

function main() {
    local task=$1
    case $task in
        upload)
            upload_auth_server
            ;;
        unpack)
            stop_auth_service
            unpack_auth_service
            start_auth_service
            echo "Unpack completed"
            ;;
        *)
            echo "No Task named "${task}" found"
            ;;
    esac
}

main $1