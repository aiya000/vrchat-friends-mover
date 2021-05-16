#!/bin/bash

for friend_id in $(jq -r '.friends[]' < auth.json) ; do
  echo "Go: $friend_id"
  curl -X POST \
    -b 'auth=authcookie_b8405e4f-94b2-4dc1-95c1-e39a302decb3' \
    "https://api.vrchat.cloud/api/1/user/$friend_id/friendRequest?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26"
  sleep 60
done
