express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.set 'views', './views'
app.set 'view engine', 'jade'
app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
    res.render 'game'

io.on 'connection', (socket) ->
  socket.emit 'init',
    side: 'light'
  fileNum = 0
  onMove = (move) ->
    file = String.fromCharCode('a'.charCodeAt(0) + fileNum)
    fileNum++
    socket.emit 'move', {from: file + '7', to: file + '5'}
  socket.on 'move', onMove

http.listen 8000
