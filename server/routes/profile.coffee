module.exports = (app, ensureLoggedIn) ->
  app.get '/profile', ensureLoggedIn, (req, res) ->
    res.render 'profile',
      user: req.user
      message: req.flash 'error'

  app.get '/profile/edit', ensureLoggedIn, (req, res) ->
    res.render 'profile/edit',
      user: req.user

  app.post '/profile/edit', ensureLoggedIn, (req, res, next) ->
    req.user.displayName = req.body.displayName
    req.user.save (err) ->
      return next(err) if err
      res.redirect '/profile'

  app.get '/profile/delete', ensureLoggedIn, (req, res) ->
    res.render 'profile/delete',
      user: req.user

  app.post '/profile/delete', ensureLoggedIn, (req, res) ->
    req.user.remove()
    res.redirect '/logout'
