messages = require './config/messages'
authConfig = require './config/auth'
User = require './models/user'
LocalStrategy  = require('passport-local').Strategy
GoogleStrategy = require('passport-google-oauth').OAuth2Strategy

module.exports = (passport) ->
  passport.serializeUser (user, next) ->
    next(null, user.id)

  passport.deserializeUser (id, next) ->
    User.findById id, (err, user) ->
      next(err, user)

  # Inspired by https://scotch.io/tutorials/easy-node-authentication-setup-and-local
  passport.use 'local-enable-or-register', new LocalStrategy({
      usernameField: 'email'
      passwordField: 'password'
      passReqToCallback: true
    }, (req, email, password, next) ->
      process.nextTick () ->
        User.findOne { 'auth.local.email': email }, (err, user) ->
          return next(err) if err
          if user
            return next(null, false, messages.emailInUse)
          if req.user
            # Enabling email login on existing account
            user = req.user
          else
            user = new User
              displayName: req.body.name
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

  # Inspired by https://scotch.io/tutorials/easy-node-authentication-google
  passport.use new GoogleStrategy({
      clientID: authConfig.google.clientID
      clientSecret: authConfig.google.clientSecret
      callbackURL: authConfig.google.callbackURL
    }, (token, refreshToken, profile, next) ->
      process.nextTick () ->
          User.findOne { 'auth.google.id': profile.id }, (err, user) ->
            return next(err) if err
            return next(null, user) if user
            user = new User
              'auth.google.id': profile.id
              'auth.google.accountName': profile.displayName
              displayName: profile.displayName
            user.save (err) ->
              return next(err) if err
              return next(null, user)
    )
