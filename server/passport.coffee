User = require './models/user'
LocalStrategy  = require('passport-local').Strategy

module.exports = (passport) ->
  # We dont use the (de)serialize methods of passport-local-mongoose,
  # because we want to allow users to sign in via other methods
  passport.serializeUser (user, done) -> done(null, user.id)
  passport.deserializeUser (id, done) ->
    User.findById id, (err, user) -> done(err, user)

  # The strategy created by User.createStrategy() would expect 'auth.local.email'
  # as the name of the Html form field.
  passport.use new LocalStrategy({
      usernameField: 'email'
      passwordField: 'password'
    }, User.authenticate())
