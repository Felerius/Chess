crypto = require 'crypto'

module.exports = (io) ->
  waitingConnection = null

  io.on 'connection', (socket) ->
    if not waitingConnection?
      waitingConnection = socket
      return
    # We could directly assign the two sockets to each other,
    # but that would result in circular references which
    # could keep the socket objects alive longer then wanted.
    # To avoid this we use a room for each game instance.
    # This could also be used for spectating.

    # To be replaced with a database id later
    gameId = crypto.randomBytes(20).toString('hex')
    socket.join gameId
    waitingConnection.join gameId
    side = if Math.random() > 0.5 then 'light' else 'dark'
    otherSide = if side is 'light' then 'dark' else 'light'
    socket.emit 'init', { side: side }
    waitingConnection.emit 'init', { side: otherSide }
    for s in [socket, waitingConnection]
      s.on 'move', (move) -> @broadcast.to(gameId).emit('move', move)
    waitingConnection = null
