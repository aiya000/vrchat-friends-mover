import * as T from 'io-ts'
import { ArgumentParser } from 'argparse'

export const cliOptions = T.intersection([
  T.type({
    yourVRChatUsername: T.string,
    yourVRChatPassword: T.string,
    sourceVRChatUsername: T.string,
    sourceVRChatPassword: T.string,
  }),
  T.partial({
    twoFACode: T.string,
  }),
])

export type CliOptions = T.TypeOf<typeof cliOptions>

export const parser = new ArgumentParser({
  description: `
    vrchat-friends-mover.sh <your-VRChat-username> <your-VRChat-password> <another-VRChat-account> <another-VRChat-password> [options]

    Sending friend requests for <another-VRChat-account>'s friends on a second.
    This takes sleeping with a second for each friends

     <your-VRChat-password>:
       Below expressions are available.

       password=<actual-plain-password>:
         Using your usual VRChat password to login.

       auth-cookie=<auth-cookie>:
         Using the auth cookie instead of 'password' to login.
         This can be taken from VRChat API endpoint 'auth/user'.
    `,
})
parser.add_argument('--2fa-code', {
  help: `
    Using this if you asked 2fa code from VRChat API.
    If you set 2fa configuration for VRChat Account, and you didn't set this,
    I'll ask 2fa code when this app is progressing.
    `,
})
parser.add_argument('--unsafe-fast', {
  help: `
    Omits sleeping.
    (This advocates your VRChat account to ban. Please see README.md.)
  `,
})

export function parseCliOptions(): CliOptions | null {
  const result = parser.parse_args()

  if (!cliOptions.is(result)) {
    console.log(result)
    return null
  }

  return result
}
