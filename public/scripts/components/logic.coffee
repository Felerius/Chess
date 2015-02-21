Board = require '../board'

class LogicComponent
  constructor: (@msgSystem, playerColor) ->
    @status =
      playerColor: playerColor
      playerActive: playerColor is 'light'
      board: new Board()
      getPossibleMoves: @_getPossibleMoves
    @moveCache = {}
    @msgSystem.on 'init', @_onInit
    @msgSystem.on 'move', @_onMove

  _onInit: () =>
    @msgSystem.send 'statusUpdated', @status, true

  _onMove: (move) =>
    @status.board.executeMove move
    @status.playerActive = not @status.playerActive
    @moveCache = {}
    @msgSystem.send 'statusUpdated', @status, false

  _getPossibleMoves: (f) =>
    if f not of @moveCache
      @moveCache[f] = @_calculatePossibleMoves f
    return @moveCache[f]

  _calculatePossibleMoves: (f) ->
    # Dummy
    return [{from: f, to: 'e4'}]

module.exports = LogicComponent
