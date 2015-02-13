field = require '../field'

class InputComponent
  construct: (@msgSystem, @data) ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'onclick', @onFieldClick
      svgField.addEventListener 'onmouseover', @onFieldMouseOver
      svgField.addEventListener 'onmouseout', @onFieldMouseOut

  onFieldClick: (event) =>
    return if not @data.playerActive
    f = event.target.id
    if @selectedPiece?
      move = m for m in @data.possibleMoves[@selectedPiece] when m.to is f
      if move?
        @msgSystem.send 'move', move
      else
        @msgSystem.send 'pieceSelected', null
      @selectedPiece = null
    else
      @selectedPiece = @data.board.get f
      @msgSystem.send 'pieceSelected', @selectedPiece

  onFieldMouseOver: (event) =>

  onFieldMouseOut: (event) =>

module.exports = InputComponent
