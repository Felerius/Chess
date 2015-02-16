svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'

class ViewComponent
  constructor: (@msgSystem, @data) ->
    @svgBoard = document.getElementById 'board'
    @_createPieces()

  _createPieces: ->
    pieceNum = 0
    for f, piece of @data.board.all()
      [x, y] = @_getFieldPos f
      svgPiece = document.createElementNS svgNs, 'use'
      svgPiece.setAttribute 'id', "piece_#{pieceNum}"
      svgPiece.setAttributeNS xlinkNs, 'href', "##{piece.piece}_#{piece.color}"
      svgPiece.setAttribute 'x', x
      svgPiece.setAttribute 'y', y
      @svgBoard.appendChild svgPiece
      pieceNum++

  _getFieldPos: (f) ->
    svgField = document.getElementById f
    return (parseInt(svgField.getAttribute(coord)) for coord in ["x","y"])

module.exports = ViewComponent
