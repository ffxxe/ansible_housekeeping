#!/usr/bin/env bash

# Remove all stopped containers older than 1 month
docker container prune --force --filter "until=720h"

# Remove all unused images older than 1 month
docker image prune -a --force --filter "until=720h"

# Remove all unused networks older than 1 month
docker network prune --force --filter "until=720h"

# Remove build cache older than 1 month
docker builder prune --force --filter "until=720h"

# Remove all unused local volumes (not supported "until")
docker volume prune --force