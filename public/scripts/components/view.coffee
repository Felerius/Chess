svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'
selectedClass = 'selected'

class ViewComponent
  constructor: (@msgSystem, @data) ->
    @svgBoard = document.getElementById 'board'
    @fieldToPieceId = {}
    @selectedField = null
    @_createPieces()
    @msgSystem.on 'pieceSelected', @_onPieceSelected

  _onPieceSelected: (f) =>
    if @selectedField?
      document.getElementById(@selectedField).classList.remove selectedClass
    if f?
      @selectedField = f
      document.getElementById(f).classList.add selectedClass

  _createPieces: ->
    pieceNum = 0
    for f, piece of @data.board.all()
      [x, y] = @_getFieldPos f
      svgPiece = document.createElementNS svgNs, 'use'
      id = "piece_#{pieceNum}"
      svgPiece.setAttribute 'id', id
      svgPiece.setAttributeNS xlinkNs, 'href', "##{piece.piece}_#{piece.color}"
      svgPiece.setAttribute 'x', x
      svgPiece.setAttribute 'y', y
      @svgBoard.appendChild svgPiece
      @fieldToPieceId[f] = id
      pieceNum++

  _getFieldPos: (f) ->
    svgField = document.getElementById f
    return (parseInt(svgField.getAttribute(coord)) for coord in ["x","y"])

module.exports = ViewComponent
