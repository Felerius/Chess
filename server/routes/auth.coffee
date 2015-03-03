module.exports = (app) ->
  app.get '/auth/login', (req, res) ->
    res.render 'auth/login'

  app.get '/auth/register', (req, res) ->
    res.render 'auth/register'
