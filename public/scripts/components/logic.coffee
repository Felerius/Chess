class LogicComponent
  constructor: (@msgSystem, @data) ->
    @msgSystem.on 'init', () =>
      @msgSystem.send 'movesCalculated', @_calculatePossibleMoves()

  _calculatePossibleMoves: () ->
    # Dummy
    moves = {}
    for f, piece of @data.board.all()
      moves[f] = [{from: f, to: 'e4'}]
    return moves

module.exports = LogicComponent
