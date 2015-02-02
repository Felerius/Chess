consts = require './consts'
field = require './field'

aCharCode = 'a'.charCodeAt(0)
pieceXOffset = 5
pieceYOffset = 5
svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'
selectionCssClass = 'selectionHighlight'
moveCssClass = 'moveHighlight'

class GameView
  constructor: (@playerSide) ->
    @pieces = {}
    @svgBoard = document.getElementById 'board'
    @selectedField = null
    @moveHighlightFields = []
    @_assignSvgFields()
    @_createInitialPieces()

  executeMove: (move) ->
    if move.captured?
      document.getElementById(@pieces[move.captured]).remove()
    @_movePiece move.from, move.to
    if move.secondaryMove?
      @_movePiece move.secondaryMove.from, move.secondaryMove.to

  highlightSelectedPiece: (f) ->
    svgField = document.getElementById f
    svgField.classList.add selectionCssClass
    @selectedField = f

  highlightPossibleMove: (f) ->
    svgField = document.getElementById f
    svgField.classList.add moveCssClass
    @moveHighlightFields.push f

  removeHighlights: ->
    if @selectedField?
      svgField = document.getElementById @selectedField
      svgField.classList.remove selectionCssClass
      @selectedField = null
    for f in @moveHighlightFields
      svgField = document.getElementById f
      svgField.classList.remove moveCssClass
    @moveHighlightFields = []

  _fieldToPos: (f) ->
    [file, rank] = field.toNumbers f
    x = if @playerSide is 'light' then file*100 else 700 - file*100
    y = if @playerSide is 'light' then 700 - rank*100 else rank*100
    return [x, y]

  _fieldToPiecePos: (f) ->
    [x, y] = @_fieldToPos f
    return [x + pieceXOffset, y + pieceYOffset]

  _assignSvgFields: ->
    # Assigns the svg field dom elements their respective chess fields as id
    for svgField in document.querySelectorAll '#board > .field'
      col = parseInt(svgField.getAttribute('x')) / 100
      row = parseInt(svgField.getAttribute('y')) / 100
      rankNum = if @playerSide is 'light' then 7 - row else row
      fileNum = if @playerSide is 'light' then col else 7 - col
      svgField.id = field.fromNumbers fileNum, rankNum

  _createSvgUse: (id, href, f, isPiece) ->
    [x, y] = if isPiece then @_fieldToPiecePos f else @_fieldToPos f
    svgUse = document.createElementNS svgNs, 'use'
    svgUse.setAttribute 'id', id
    svgUse.setAttributeNS xlinkNs, 'href', href
    svgUse.setAttribute 'x', x
    svgUse.setAttribute 'y', y
    return svgUse

  _createInitialPieces: ->
    pieceNum = 0
    for f, piece of consts.beginningPieces
      id = "piece_#{pieceNum}"
      pieceNum++
      @pieces[f] = id
      imageHref = "##{piece.piece}_#{piece.color}"
      svgPiece = @_createSvgUse id, imageHref, f, true
      svgPiece.chessField = f
      @svgBoard.appendChild svgPiece

  _movePiece: (from, to) ->
    id = @pieces[from]
    delete @pieces[from]
    svgPiece = document.getElementById id
    [x, y] = @_fieldToPiecePos to
    svgPiece.setAttribute 'x', x
    svgPiece.setAttribute 'y', y
    svgPiece.chessField = to
    @pieces[to] = id

module.exports = (playerSide) -> new GameView(playerSide)
