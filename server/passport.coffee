messages = require './config/messages'
User = require './models/user'
LocalStrategy  = require('passport-local').Strategy

module.exports = (passport) ->
  passport.serializeUser (user, next) ->
    next(null, user.id)

  passport.deserializeUser (id, next) ->
    User.findById id, (err, user) ->
      next(err, user)

  # Inspired by https://scotch.io/tutorials/easy-node-authentication-setup-and-local
  passport.use 'local-register', new LocalStrategy({
      usernameField: 'email'
      passwordField: 'password'
    }, (email, password, next) ->
      process.nextTick () ->
        User.findOne { 'auth.local.email': email }, (err, user) ->
          return next(err) if err
          if user
            return next(null, false, messages.emailInUse)
          user = new User()
          user.auth.local.email = email
          user.setPassword password, (err) ->
            return next(err) if err
            user.save (err) ->
              return next(err) if err
              return next(null, user)
    )

  # Inspired by https://scotch.io/tutorials/easy-node-authentication-setup-and-local
  passport.use 'local-login', new LocalStrategy({
      usernameField: 'email'
      passwordField: 'password'
    }, (email, password, next) ->
      User.findOne { 'auth.local.email': email }, (err, user) ->
        return next(err) if err
        if not user
          return next(null, false, messages.invalidCredentials)
        user.checkPassword password, (err, valid) ->
          if not valid
            return next(null, false, messages.invalidCredentials)
          return next(null, user)
    )
