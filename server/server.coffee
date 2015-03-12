serverConfig = require './config/server'
dbConfig = require './config/db'

express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
flash = require 'connect-flash'
http = require 'http'
mongoose = require 'mongoose'
passport = require 'passport'

mongoose.connect dbConfig.url

# For some reason socket.io requires a server to be created it's constructor
# method. Probably because socket.io also requires http.
app = express()
server = http.Server(app)
io = require('socket.io')(server)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')
app.use session({ secret: serverConfig.sessionSecret })
app.use bodyParser()
app.use cookieParser()
app.use passport.initialize()
app.use passport.session()
app.use flash()

if serverConfig.forceHttps
  app.use (req, res, next) ->
    if not req.secure
      res.redirect "https://#{req.get 'host'}#{req.url}"
    else
      next()

require('./passport')(passport)
require('./routes')(app, passport)
require('./socket')(io)

server.listen serverConfig.port, serverConfig.ip
