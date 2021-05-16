# :diamond_shape_with_a_dot_inside: VRChat Friends Mover :diamond_shape_with_a_dot_inside:

This is a way to send friends requests to all friends of an another VRChat account's friends :tada:

```shell-session
$ source_user=$(echo -n source-VRChat-username:password | base64)
$ curl 'https://api.vrchat.cloud/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26' -H "Authorization: Basic $source_user" > auth.json

$ sender_user=$(echo -n your-VRChat-username:password | base64)
# Run below **ONLY** if you are using 2FA
$ sender_user_auth=$(curl -X POST -d 'code=<2fa-code>' 'https://api.vrchat.cloud/api/1/auth/twofactorauth/totp/verify' -H "Authorization: Basic $sender_user" -i | grep 'set-cookie: auth=' | cut -d= -f2 | cut -d';' -f1)
# Or if you are not using 2FA
$ sender_user_auth=$(curl 'https://api.vrchat.cloud/api/1/auth/user?apiKey=JlE5Jldo5Jibnk5O5hTx6XVqsJu4WJ26' -H "Authorization: Basic $sender_user" -i | grep 'set-cookie: auth=' | cut -d= -f2 | cut -d';' -f1)

$ ./send.sh "$sender_user_auth"
```
