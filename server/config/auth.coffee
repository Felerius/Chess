module.exports =
  local:
    iterations: 25000
    keylen: 512
    saltlen: 32
    encoding: 'hex'
  google:
    clientID: process.env.GOOGLE_CLIENT_ID
    clientSecret: process.env.GOOGLE_CLIENT_SECRET
    callbackRegister: process.env.GOOGLE_CALLBACK_REGISTER
    callbackConnect: process.env.GOOGLE_CALLBACK_CONNECT
