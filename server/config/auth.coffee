module.exports =
  local:
    iterations: 25000
    keylen: 512
    saltlen: 32
    encoding: 'hex'
  google:
    clientID: process.env.GOOGLE_CLIENT_ID
    clientSecret: process.env.GOOGLE_CLIENT_SECRET
    callbackURL: process.env.GOOGLE_CALLBACK_URL
