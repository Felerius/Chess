consts = require './consts'
field = require './field'

class GameInput
  constructor: (@onFieldClick) ->
    for f in field.all()
      svgField = document.getElementById f
      svgField.addEventListener 'click', @_onFieldClick
    for i in [0...consts.numberBeginningPieces]
      svgPiece = document.getElementById "piece_#{i}"
      svgPiece.addEventListener 'click', @_onPieceClick

  _onFieldClick: (event) =>
    @onFieldClick event.target.id

  _onPieceClick: (event) =>
    @onFieldClick event.target.chessField

module.exports = (onFieldClick) -> new GameInput(onFieldClick)
