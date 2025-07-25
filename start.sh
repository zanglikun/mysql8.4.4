#!/bin/bash

COMPOSE_FILE="docker-compose-mysql8.4.4.yml"
CONTAINER_NAME="mysql8-dev"

function status() {
    running=$(docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format '{{.Names}}')
    if [ "$running" == "$CONTAINER_NAME" ]; then
        echo "MySQL 服务正在运行。"
    else
        echo "MySQL 服务未运行。"
    fi
}

function start() {
    running=$(docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format '{{.Names}}')
    if [ "$running" == "$CONTAINER_NAME" ]; then
        echo "MySQL 服务已在运行，无需重复启动。"
    else
        echo "正在启动 MySQL 服务..."
        docker-compose -f "$COMPOSE_FILE" up -d --build
        sleep 2
        status
    fi
}

function stop() {
    running=$(docker ps --filter "name=$CONTAINER_NAME" --filter "status=running" --format '{{.Names}}')
    if [ "$running" == "$CONTAINER_NAME" ]; then
        echo "正在关闭 MySQL 服务..."
        docker-compose -f "$COMPOSE_FILE" down
        sleep 1
        status
    else
        echo "MySQL 服务未运行，无需关闭。"
    fi
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    status)
        status
        ;;
    *)
        echo "用法: $0 {start|stop|status}"
        ;;
esac