class NetworkComponent
  constructor: (@msgSystem, @data, @socket) ->
    @socket.on 'move', @onEnemyMove
    @msgSystem.on 'move', @onMoveMsg

  onEnemyMove: (move) ->
    @disableHandler = true
    @msgSystem.send 'move', move
    @disableHandler = false

  onMoveMsg: (move) ->
    return if @disableHandler
    @socket.emit 'move', move

module.exports = NetworkComponent
