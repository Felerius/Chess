express = require 'express'
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
    res.sendFile __dirname + '/views/game.html'

io.on 'connection', (socket) ->
  socket.emit 'init',
    side: 'light'

http.listen 8000
