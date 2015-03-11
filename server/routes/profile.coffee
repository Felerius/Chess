module.exports = (app, ensureLoggedIn) ->
  app.get '/profile', ensureLoggedIn, (req, res) ->
    res.render 'profile',
      user: req.user

  app.get '/profile/edit', ensureLoggedIn, (req, res) ->
    res.render 'profile/edit',
      user: req.user

  app.post '/profile/edit', ensureLoggedIn, (req, res, next) ->
    req.user.displayName = req.body.displayName
    req.user.save (err) ->
      return next(err) if err
      res.redirect '/profile'
