User = require '../models/user'

module.exports = (app, passport) ->
  app.get '/auth/login', (req, res) ->
    res.render 'auth/login'

  app.get '/auth/register', (req, res) ->
    res.render 'auth/register',
      message: req.flash 'error'
      email: req.flash 'email'

  app.post '/auth/register', (req, res, next) ->
    user = new User
      'auth.local.email': req.body.email
    User.register user, req.body.password, (err, user) ->
      if err
        if err.name is 'BadRequestError'
          req.flash 'error', err.message
          req.flash 'email', req.body.email
          res.redirect '/auth/register'
        else
          return next(err)
      else
        passport.authenticate('local')(req, res, () ->
          res.redirect '/play')
