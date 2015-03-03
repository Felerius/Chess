module.exports = (app) ->
    app.get '/play', (req, res) ->
      res.render 'play'
