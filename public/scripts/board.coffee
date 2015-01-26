A_CHAR_CODE = "a".charCodeAt(0)

SVGNS = 'http://www.w3.org/2000/svg'
XLINKNS = 'http://www.w3.org/1999/xlink'

PIECE_X_OFFSET = 5
PIECE_Y_OFFSET = 5

BEGINNING_PIECES = 
  bishop_dark: ['c8', 'f8']
  bishop_light: ['c1', 'f1']
  king_dark: ['e8']
  king_light: ['e1']
  knight_dark: ['b8', 'g8']
  knight_light: ['b1', 'g1']
  pawn_dark: ['a7', 'b7', 'c7', 'd7', 'e7', 'f7', 'g7', 'h7']
  pawn_light: ['a2', 'b2', 'c2', 'd2', 'e2', 'f2', 'g2', 'h2']
  queen_dark: ['d8']
  queen_light: ['d1']
  rook_dark: ['a8', 'h8']
  rook_light: ['a1', 'h1']

class Board
  constructor: (@darkSide) ->
    @pieces = {}
    @_placeInitialPieces()
      
  _fieldToPiecePos: (field) ->
    file = field.charCodeAt(0) - A_CHAR_CODE
    rank = parseInt(field[1]) - 1
    x = if @darkSide then 700 - file*100 else file*100
    y = if @darkSide then rank*100 else 700 - rank*100
    return [x + PIECE_X_OFFSET, y + PIECE_Y_OFFSET]

  _numToField: (num) ->
    num = 63 - num if @darkSide
    return String.fromCharCode(A_CHAR_CODE + Math.floor(num/8)) + (num % 8 + 1)

  _placeInitialPieces: () ->
    svgBoard = document.getElementById 'board'
    for piece, fields of BEGINNING_PIECES
      for field, i in fields
        svgPiece = document.createElementNS SVGNS, 'use'
        id = "#{piece}_#{i}"
        svgPiece.setAttribute 'id', id
        svgPiece.setAttributeNS XLINKNS, 'href', '#' + piece
        svgBoard.appendChild svgPiece
        @_placePiece id, field

  _placePiece: (pieceId, field) ->
    svgPiece = document.getElementById pieceId
    [x, y] = @_fieldToPiecePos field
    svgPiece.setAttribute 'x', x
    svgPiece.setAttribute 'y', y
    @pieces[field] = pieceId


module.exports = (darkSide) -> new Board(darkSide) 
