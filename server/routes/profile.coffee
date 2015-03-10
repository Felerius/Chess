module.exports = (app, ensureLoggedIn) ->
  app.get '/profile', ensureLoggedIn, (req, res) ->
    res.render 'profile',
      user: req.user
