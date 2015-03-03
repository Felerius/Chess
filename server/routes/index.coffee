module.exports = (app) ->
  require('./main')(app)
  require('./play')(app)
  require('./auth')(app)
