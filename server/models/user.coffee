mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
messages = require '../config/messages'

schema = mongoose.Schema
  displayName: String
  auth:
    local:
      email: String
      salt: String
      hash: String

schema.plugin passportLocalMongoose,
  usernameField: 'auth.local.email'
  saltField: 'auth.local.salt'
  hashField: 'auth.local.hash'
  incorrectPasswordError: messages.invalidCredentials
  incorrectUsernameError: messages.invalidCredentials
  missingUsernameError: messages.emailMissing
  missingPasswordError: messages.passwordMissing
  userExistsError: messages.emailInUse

module.exports = mongoose.model 'User', schema
