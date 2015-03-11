mongoose = require 'mongoose'
crypto = require 'crypto'

authConfig = require '../config/auth'

schema = mongoose.Schema
  displayName: String
  auth:
    local:
      email: String
      salt: String
      hash: String
    google:
      id: String
      accountName: String

# These two methods are largely identical to the ones in passport-local-mongoose
# (https://github.com/saintedlama/passport-local-mongoose).
schema.methods.setPassword = (password, next) ->
  user = this
  crypto.randomBytes authConfig.local.saltlen, (err, buf) ->
    return next(err) if err
    salt = buf.toString authConfig.local.encoding
    crypto.pbkdf2 password, salt, authConfig.local.iterations, authConfig.local.keylen, (err, hashRaw) ->
      return next(err) if err
      user.auth.local.hash = new Buffer(hashRaw, 'binary').toString(authConfig.local.encoding)
      user.auth.local.salt = salt
      next(null)

schema.methods.checkPassword = (password, next) ->
  user = this
  crypto.pbkdf2 password, user.auth.local.salt, authConfig.local.iterations, authConfig.local.keylen, (err, hashRaw) ->
    return next(err) if err
    hash = new Buffer(hashRaw, 'binary').toString(authConfig.local.encoding)
    next(null, hash is user.auth.local.hash)

schema.methods.localEnabled = () -> this.auth.local.email?

schema.methods.googleEnabled = () -> this.auth.google.id?

module.exports = mongoose.model 'User', schema
