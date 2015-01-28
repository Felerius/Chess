consts = require './consts'

class GameInput
  constructor: (onFieldClick) ->
    listener = () ->
      onFieldClick this.chessField
    for i in [0..63]
      svgField = document.getElementById "field_#{i}"
      svgField.addEventListener 'click', listener
    for i in [0...consts.numberBeginningPieces]
      svgPiece = document.getElementById "piece_#{i}"
      svgPiece.addEventListener 'click', listener

module.exports = (onFieldClick) -> new GameInput(onFieldClick)
