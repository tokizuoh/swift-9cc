#!/bin/bash

source ./.env

rsync \
-avz ./ $HOST:$DIST \
--exclude '.env' \
--exclude '.git' \
--exclude '.ssh' \
--exclude '.build' \
--exclude '.swiftpm' \
--rsh "ssh -F ./.ssh/config"

ssh -F ./.ssh/config $HOST
