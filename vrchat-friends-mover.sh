#!/bin/bash

function show_help () {
  echo  '--- Usage ---'
  echo  '  vrchat-friends-mover.sh <your-VRChat-username> <your-VRChat-password> <another-VRChat-account> <another-VRChat-password> [options]'
  echo $'  # Sending friend requests for <another-VRChat-account>\'s friends on a second.'
  echo  '  # This takes sleeping with a second for each friends'
  echo
  echo  '   <your-VRChat-password>:'
  echo  '     Below expressions are available.'
  echo
  echo  '     password=<actual-plain-password>:'
  echo  '       Using your usual VRChat password to login.'
  echo
  echo  '     auth-cookie=<auth-cookie>:'
  echo $'       Using the auth cookie instead of \'password\' to login.'
  echo $'       This can be taken from VRChat API endpoint \'auth/user\'.'
  echo
  echo  '   [options]:'
  echo  '     Optional fields.'
  echo  '     Below options are available.'
  echo
  echo  '     --2fa-code=<actual-2fa-code>:'
  echo  '       Using this if you asked 2fa code from VRChat API.'
  echo $'       If you set 2fa configuration for VRChat Account, and you didn\'t set this,'
  echo $'       I\'ll ask 2fa code when this app is progressing.'
  echo
  echo  '     --unsafe-fast:'
  echo  '       Omits sleeping'
  echo  '       (This advocates your VRChat account to ban. Please see README.md.)'
}

if [[ $# -lt 4 ]] || [[ $1 = 'help' ]] || [[ $1 = '--help' ]]; then
  show_help
  exit 1
fi

username=$1

if echo "$2" | grep '^password' ; then
  : TODO
fi

password=$2
target_username=$3
target_password=$4
twofa_code=''
unsafe_fast=false

for (( i=5; i <= $#; ++i )) ; do
  if [[ "${!i}" = '--unsafe-fast' ]] ; then
    echo 'Using: --unsafe-fast'
    unsafe_fast=true
  elif echo "${!i}" | grep '^--2fa-code=' > /dev/null 2>&1 ; then
    actual=$(echo "${!i}" | sed -r 's/^--2fa-code=(.*)/\1/')

    if [[ $actual = '' ]] ; then
      echo "Invalid --2fa-code expression: $actual" > /dev/stderr
      exit 1
    fi

    echo "Using: ${!i}"
    twofa_code=$actual
  fi
done

function take_2fa_code () {
  if [[ $twofa_code = '' ]] ; then
    read -rp '2fa code: ' asked
    echo "$asked"
    return
  fi

  echo "$twofa_code"
}

auth=$(echo -n "$username:$password" | base64)

auth_result=$( \
  curl --silent \
    --header "Authorization: Basic $auth" \
    'https://api.vrchat.cloud/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26' \
)

if echo "$auth_result" | jq .requiresTwoFactorAuth > /dev/null 2>&1 ; then
  twofa_result_all=$( \
    curl -X POST --verbose \
      --header "Authorization: Basic $auth" \
      --data "code=$(take_2fa_code)" \
      'https://api.vrchat.cloud/api/1/auth/twofactorauth/totp/verify' \
  )

  if ! twofa_result=$(echo "$twofa_result_all" | grep '^{"verified":') ; then
    echo 'Invalid 2fa response:'
    echo "$twofa_result_all"
    exit 1
  fi

  if [[ $(echo "$twofa_result" | jq -r .verified) != true ]] ; then
    echo 'That 2fa code is not valid!' > /dev/stderr
    exit 1
  fi
  echo '2fa verified.'

  auth_cookie=$(echo "$twofa_result_all" | grep 'set-cookie: auth=' | cut -d= -f2 | cut -d';' -f1)
fi
