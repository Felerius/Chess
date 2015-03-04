messages = require '../config/messages'
User = require '../models/user'

# Returns a middleware that tries to authenticate but saves all form fields
# via req.flash on failure so that they can be kept.
# All form fields are saved in req.flash by the same name.
# See http://passportjs.org/guide/authenticate/ section Custom callback
authenticateKeepFormFields = (passport, strategy, fields, redirectSuccess, redirectFailure) ->
  opts = { badRequestMessage: messages.missingCredentials }
  return (req, res, next) ->
    passport.authenticate(strategy, opts, (err, user, info) ->
      return next(err) if err
      if user
        req.logIn user, (err) ->
          return next(err) if err
          return res.redirect redirectSuccess
      else
        # Same error message handling as in passport itself
        req.flash 'error', info.message || info
        for f in fields
          console.log [f, req.body[f]]
          req.flash f, req.body[f]
        return res.redirect redirectFailure
    )(req, res, next)

module.exports = (app, passport, ensureLoggedOut) ->
  app.get '/auth/login', ensureLoggedOut, (req, res) ->
    res.render 'auth/login',
      message: req.flash 'error'
      email: req.flash 'email'

  app.post '/auth/login',
    authenticateKeepFormFields passport, 'local-login', ['email'], '/play', '/auth/login'

  app.get '/auth/register', ensureLoggedOut, (req, res) ->
    res.render 'auth/register',
      message: req.flash 'error'
      email: req.flash 'email'
      name: req.flash 'name'

  app.post '/auth/register',
    authenticateKeepFormFields passport, 'local-register', ['email', 'name'], '/play', '/auth/register'

  app.get '/auth/google', passport.authenticate('google', { scope: ['profile'] })

  app.get '/auth/google/callback', passport.authenticate('google',
    successRedirect: '/play'
    failureRedirect: '/'
  )

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
