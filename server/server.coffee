loadConfig = () ->
  try
    return require './config'
  catch e
    if e instanceof Error and e.code is 'MODULE_NOT_FOUND'
      console.log 'Using default config'
      return require './config.default'
    else
      throw e

config = loadConfig()
express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
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

http.listen config.port, config.ip
