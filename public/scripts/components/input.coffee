field = require '../field'

class InputComponent
  constructor: (@msgSystem, @data, @playerColor) ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @_onFieldClick
      svgField.addEventListener 'mouseover', @_onFieldMouseOver
      svgField.addEventListener 'mouseout', @_onFieldMouseOut
    @msgSystem.on 'movesCalculated', @_onMovesCalculated

  _onMovesCalculated: (possibleMoves) =>
    @possibleMoves = possibleMoves

  _onFieldClick: (event) =>
    return if not @data.playerActive
    f = event.target.id
    if @selectedPiece?
      move = @_tryFindMove f
      if move?
        @msgSystem.send 'move', move
        @msgSystem.send 'pieceSelected', null
        return
    piece = @data.board.get(f)
    if piece? and piece.color is @playerColor
      @selectedPiece = f
      @msgSystem.send 'pieceSelected', f, @possibleMoves[f]
    else
      @selectedPiece = null
      @msgSystem.send 'pieceSelected', null

  _onFieldMouseOver: (event) =>

  _onFieldMouseOut: (event) =>

  _tryFindMove: (f) ->
    moves = @possibleMoves[@selectedPiece]
    if moves?
      return (m for m in moves when m.to is f)[0]
    return null

module.exports = InputComponent
