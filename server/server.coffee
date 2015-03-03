serverConfig = require './config/server'

express = require 'express'
cookieParser = require 'cookie-parser'
bodyParser = require 'body-parser'
session = require 'express-session'
http = require('http')

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

require('./routes')(app)
require('./socket')(io)

server.listen serverConfig.port, serverConfig.ip
