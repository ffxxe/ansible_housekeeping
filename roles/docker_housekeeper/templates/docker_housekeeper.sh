#!/usr/bin/env bash

#Saves file descriptors so they can be restored to whatever they were before redirection.
exec 3>&1 4>&2
#Restore file descriptors for particular signals.
trap 'exec 2>&4 1>&3' 0 1 2 3
#Redirect stdout to file docker_housekeeper.log.
exec 1>>/var/log/docker_housekeeper.log
#Redirect stderr to file docker_housekeeper.err.
exec 2>>/var/log/docker_housekeeper.err

{% raw %}
docker ps -a --format 'table {{.ID}}\t{{.Status}}' |grep Exited |grep months |awk '{print $1}' |xargs --no-run-if-empty docker rm
echo "$(date) : Remove all stopped containers older than a few months" >&1
echo "---" >&1
{% endraw %}

docker image prune -a --force --filter "until={{ item.value.housekeeper_hours }}h"
echo "$(date) : Remove all unused images older than {{ item.value.housekeeper_hours }} hours" >&1
echo "---" >&1

docker network prune --force --filter "until={{ item.value.housekeeper_hours }}h"
echo "$(date) : Remove all unused networks older than {{ item.value.housekeeper_hours }} hours" >&1
echo "---" >&1

docker builder prune --force --filter "until={{ item.value.housekeeper_hours }}h"
echo "$(date) : Remove build cache older than {{ item.value.housekeeper_hours }} hours" >&1
echo "---" >&1

#docker volume prune --force
#echo "$(date) : Remove all unused local volumes (not supported "until")" >&1
#echo "---" >&1
