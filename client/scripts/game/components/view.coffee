svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'

class ViewComponent
  constructor: (@msgSystem) ->
    @svgBoard = document.getElementById 'board'
    @fieldToPieceId = {}
    @highlights = {}
    @_createPieces()
    @msgSystem.on 'pieceSelected', @_onPieceSelected
    @msgSystem.on 'move', @_onMove
    @msgSystem.on 'statusUpdated', @_onStatusUpdated

  _onStatusUpdated: (status, init) =>
    @_createPieces(status.board.all()) if init

  _clearHighlights: ->
    for cssClass, fields of @highlights
      for svgField in fields
        svgField.classList.remove cssClass

  _addClasses: (f, cssClasses...) =>
    svgField = document.getElementById f
    for cls in cssClasses
      svgField.classList.add cls
      @highlights[cls] ?= []
      @highlights[cls].push svgField

  _onPieceSelected: (selected, moves, active) =>
    @_clearHighlights()
    return if not selected?
    setClass = if active then @_addClasses else (f, cls) => @_addClasses(f, cls, 'inactive')
    setClass selected, 'selected'
    for move in moves
      cls = if move.capture? then 'capture' else 'move'
      setClass move.to, cls

  _onMove: (move) =>
    if move.capture?
      document.getElementById(@fieldToPieceId[move.capture]).remove()
      @fieldToPieceId[move.capture] = undefined
    @_executeMove move.from, move.to
    if move.secondaryMove?
      @_executeMove move.secondaryMove.from, move.secondaryMove.to

  _executeMove: (from, to) ->
    svgPiece = document.getElementById(@fieldToPieceId[from])
    [x, y] = @_getFieldPos to
    svgPiece.setAttribute 'x', x
    svgPiece.setAttribute 'y', y
    @fieldToPieceId[to] = @fieldToPieceId[from]
    @fieldToPieceId[from] = undefined

  _createPieces: (pieces) ->
    pieceNum = 0
    for f, piece of pieces
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
