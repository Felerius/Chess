module.exports = (app, ensureLoggedIn) ->
    app.get '/play', ensureLoggedIn, (req, res) ->
      res.render 'play',
        user: req.user
