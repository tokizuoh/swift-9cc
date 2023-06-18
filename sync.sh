#!/bin/bash

source ./.env

fswatch ./ \
-v \
-e '.git/' \
-e '.gitignore' \
-e '.env' \
-e '.ssh' \
-e '.build/' \
-e '.swiftpm/' \
| \
xargs -I {} rsync \
-avz ./ $HOST:$DIST \
--exclude '.env' \
--exclude '.git' \
--exclude '.ssh' \
--exclude '.build' \
--exclude '.swiftpm' \
--rsh "ssh -F ./.ssh/config"
