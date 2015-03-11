module.exports = (app, ensureLoggedIn) ->
  app.get '/profile', ensureLoggedIn, (req, res) ->
    res.render 'profile',
      user: req.user

  app.get '/profile/common', ensureLoggedIn, (req, res) ->
    res.render 'profile/common',
      user: req.user

  app.post '/profile/common', ensureLoggedIn, (req, res, next) ->
    req.user.displayName = req.body.displayName
    req.user.save (err) ->
      return next(err) if err
      res.redirect '/profile'

  app.get '/profile/email', ensureLoggedIn, (req, res) ->
    res.render 'profile/email',
      user: req.user

  app.post '/profile/email', ensureLoggedIn, (req, res, next) ->
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
