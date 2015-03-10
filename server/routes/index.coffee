ensureLoggedIn = (req, res, next) ->
  if req.isAuthenticated()
    return next()
  res.redirect '/'

ensureLoggedOut = (req, res, next) ->
  unless req.isAuthenticated()
    return next()
  res.redirect '/'

module.exports = (app, passport) ->
  require('./main')(app)
  require('./play')(app, ensureLoggedIn)
  require('./auth')(app, passport, ensureLoggedOut)
  require('./profile')(app, ensureLoggedIn)
