field = require '../field'

class InputComponent
  constructor: (@msgSystem, @data) ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @onFieldClick
      svgField.addEventListener 'mouseover', @onFieldMouseOver
      svgField.addEventListener 'mouseout', @onFieldMouseOut

  onFieldClick: (event) =>
    return if not @data.playerActive
    f = event.target.id
    if @selectedPiece?
      move = @_tryFindMove f
      if move?
        @msgSystem.send 'move', move
      else
        @selectedPiece = if @data.board.get(f)? then f else null
        @msgSystem.send 'pieceSelected', @selectedPiece
    else
      if @data.board.get(f)?
        @selectedPiece = f
        @msgSystem.send 'pieceSelected', f

  onFieldMouseOver: (event) =>

  onFieldMouseOut: (event) =>

  _tryFindMove: (f) ->
    moves = @data.possibleMoves[@selectedPiece]
    return for m in moves when m.to is f if moves?
    return null


module.exports = InputComponent
