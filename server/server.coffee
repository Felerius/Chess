serverConfig = require './config/server'
dbConfig = require './config/db'

express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
http = require 'http'
socketIO = require 'socket.io'
mongoose = require 'mongoose'
passport = require 'passport'

mongoose.connect dbConfig.url

app = express()
server = http.Server(app)
io = socketIO(http)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')
app.use session({ secret: serverConfig.sessionSecret })
app.use bodyParser()
app.use cookieParser()
app.use passport.initialize()
app.use passport.session()

require('./routes')(app)
require('./socket')(io)

server.listen serverConfig.port, serverConfig.ip
