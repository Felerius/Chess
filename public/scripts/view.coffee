consts = require './consts'
field = require './field'

aCharCode = "a".charCodeAt(0)
pieceXOffset = 5
pieceYOffset = 5
svgNs = 'http://www.w3.org/2000/svg'
xlinkNs = 'http://www.w3.org/1999/xlink'

class GameView
  constructor: (@playerSide) ->
    @pieces = {}
    @_assignSvgFields()
    @_createInitialPieces()

  _fieldToPos: (f) ->
    [file, rank] = field.toNumbers f
    x = if @playerSide is 'light' then file*100 else 700 - file*100
    y = if @playerSide is 'light' then 700 - rank*100 else rank*100
    return [x, y]

  _fieldToPiecePos: (f) ->
    [x, y] = @_fieldToPos f
    return [x + pieceXOffset, y + pieceYOffset]

  _assignSvgFields: ->
    # Assigns the svg field dom elements their respective chess fields
    # The fields in the html file are generated from bottom-left and row first
    for col in [0..7]
      for row in [0..7]
        svgField = document.getElementById 'field_' + (col*8 + row)
        rank = if @playerSide is 'light' then row + 1 else 8 - row
        fileNum = if @playerSide is 'light' then col else 7 - col
        file = String.fromCharCode(aCharCode + fileNum)
        svgField.chessField = file + rank

  _createInitialPieces: ->
    pieceNum = 0
    svgBoard = document.getElementById 'board'
    for f, piece of consts.beginningPieces
      svgPiece = document.createElementNS svgNs, 'use'
      id = "piece_#{pieceNum}"
      pieceNum++
      @pieces[f] = id
      imageHref = "##{piece.piece}_#{piece.color}"
      svgPiece.setAttribute 'id', id
      svgPiece.setAttributeNS xlinkNs, 'href', imageHref
      [x, y] = @_fieldToPiecePos f
      svgPiece.setAttribute 'x', x
      svgPiece.setAttribute 'y', y
      svgPiece.chessField = f
      svgBoard.appendChild svgPiece

  _movePiece: (from, to) ->
    id = @pieces[from]
    delete @pieces[from]
    svgPiece = document.getElementById id
    [x, y] = @_fieldToPiecePos to
    svgPiece.setAttribute 'x', x
    svgPiece.setAttribute 'y', y
    svgPiece.chessField = to
    @pieces[to] = id

  executeMove: (move) ->
    if move.captured?
      document.getElementById(@pieces[move.captured]).remove()
    @_movePiece move.from, move.to
    if move.secondaryMove?
      @_movePiece move.secondaryMove.from, move.secondaryMove.to

  highlightField: (f) ->
    svgHighlight = document.getElementById 'selected_field'
    svgHighlight.setAttribute 'visibility', 'show'
    [x, y] = @_fieldToPos f
    svgHighlight.setAttribute 'x', x
    svgHighlight.setAttribute 'y', y


module.exports = (playerSide) -> new GameView(playerSide)
