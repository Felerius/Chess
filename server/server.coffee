serverConfig = require './config/server'

express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')

require('./routes')(app)
require('./socket')(io)

http.listen serverConfig.port, serverConfig.ip
