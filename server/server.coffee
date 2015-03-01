serverConfig = require './config/server'
express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')

app.get '/play', (req, res) ->
    res.render 'game'

waitingConnection = null

io.on 'connection', (socket) ->
  if not waitingConnection?
    waitingConnection = socket
    return
  waitingConnection.enemy = socket
  socket.enemy = waitingConnection
  side = if Math.random() > 0.5 then 'light' else 'dark'
  socket.emit 'init', {side: side}
  socket.enemy.emit 'init', {side: if side is 'light' then 'dark' else 'light'}
  for s in [socket, socket.enemy]
    s.on 'move', (move) -> @enemy.emit 'move', move
  waitingConnection = null

http.listen serverConfig.port, serverConfig.ip
