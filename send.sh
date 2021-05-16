#!/bin/bash

auth_cookie=$1

send_friend_request () {
  local friend_id=$1 result

  result=$( \
    curl -X POST --silent \
      -b "auth=$auth_cookie" \
      "https://api.vrchat.cloud/api/1/user/$friend_id/friendRequest?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26" \
  )

  if echo "$result" | grep 'You are making too many friend requests' > /dev/null 2>&1 ; then
    echo "Error! $result"
    echo $'OK!! I\'ll sleep 30min!'
    sleep $((60 * 30))
    send_friend_request "$friend_id"
    return
  fi
  echo "$result"
}

for friend_id in $(jq -r '.friends[]' < auth.json) ; do
  echo "Go: $friend_id"
  send_friend_request "$friend_id"
  sleep 60
done
