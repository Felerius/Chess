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
          req.flash f, req.body[f]
        return res.redirect redirectFailure
    )(req, res, next)

module.exports = (app, passport, ensureLoggedIn, ensureLoggedOut) ->
  app.get '/auth/email/login', ensureLoggedOut, (req, res) ->
    res.render 'auth/email/login',
      message: req.flash 'error'
      email: req.flash 'email'

  app.post '/auth/email/login',
    authenticateKeepFormFields passport, 'local-login', ['email'], '/play', '/auth/email/login'

  app.get '/auth/email/register', ensureLoggedOut, (req, res) ->
    res.render 'auth/email/register',
      message: req.flash 'error'
      email: req.flash 'email'
      name: req.flash 'name'

  app.post '/auth/email/register',
    authenticateKeepFormFields passport, 'local-enable-or-register', ['email', 'name'], '/play', '/auth/email/register'

  app.get '/auth/email/enable', ensureLoggedIn, (req, res) ->
    res.render 'auth/email/enable',
      user: req.user
      message: req.flash 'error'
      email: req.flash 'email'

  app.post '/auth/email/enable',
    ensureLoggedIn,
    authenticateKeepFormFields passport, 'local-enable-or-register', ['email', 'name'], '/profile', '/auth/email/enable'

  app.get '/auth/email/edit', ensureLoggedIn, (req, res) ->
    res.render 'auth/email/edit',
      user: req.user

  app.post '/auth/email/edit', ensureLoggedIn, (req, res, next) ->
    req.user.auth.local.email = req.body.email
    save = () ->
      req.user.save (err) ->
        return next(err) if err
        res.redirect '/profile'
    if req.body.password
      req.user.setPassword req.body.password, (err) ->
        return next(err) if err
        save()
    else
      save()

  app.get '/auth/google', passport.authenticate('google', { scope: ['profile'] })

  app.get '/auth/google/callback', passport.authenticate('google',
    successRedirect: '/play'
    failureRedirect: '/'
  )

  app.get '/logout', (req, res) ->
    req.logout()
    res.redirect '/'
