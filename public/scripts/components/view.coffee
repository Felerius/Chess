svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'
selectedClass = 'selected'

class ViewComponent
  constructor: (@msgSystem, @data) ->
    @svgBoard = document.getElementById 'board'
    @fieldToPieceId = {}
    @highlights = {}
    @_createPieces()
    @msgSystem.on 'pieceSelected', @_onPieceSelected

  _clearHighlights: ->
    for cssClass, fields of @highlights
      for svgField in fields
        svgField.classList.remove cssClass

  _addHighlight: (f, cssClass) ->
    svgField = document.getElementById f
    svgField.classList.add cssClass
    @highlights[cssClass] ?= []
    @highlights[cssClass].push svgField

  _onPieceSelected: (selected) =>
    @_clearHighlights()
    if selected?
      @_addHighlight selected, selectedClass

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
