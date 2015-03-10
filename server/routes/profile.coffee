module.exports = (app, ensureLoggedIn) ->
  app.get '/profile', ensureLoggedIn, (req, res) ->
    res.render 'profile',
      user: req.user

  app.get '/profile/common', ensureLoggedIn, (req, res) ->
    res.render 'profile/common',
      user: req.user

  app.post '/profile/common', (req, res, next) ->
    req.user.displayName = req.body.displayName
    req.user.save (err) ->
      return next(err) if err
      res.redirect '/profile'
