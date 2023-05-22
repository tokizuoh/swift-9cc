#!/bin/bash

source ./.env

rsync \
-avz ./ $HOST:$DIST \
--exclude '.env' \
--exclude '.git' \
--exclude '.ssh' \
--rsh "ssh -F ./.ssh/config"

ssh -F ./.ssh/config $HOST
