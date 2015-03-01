module.exports = (io) ->
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
