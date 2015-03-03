module.exports = (app, passport) ->
  require('./main')(app)
  require('./play')(app)
  require('./auth')(app, passport)
