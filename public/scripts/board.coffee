class Board
  constructor: ->
    @pieces =
      c8: { piece: 'bishop', color: 'dark' }
      f8: { piece: 'bishop', color: 'dark' }
      c1: { piece: 'bishop', color: 'light' }
      f1: { piece: 'bishop', color: 'light' }
      e8: { piece: 'king', color: 'dark' }
      e1: { piece: 'king', color: 'light' }
      b8: { piece: 'knight', color: 'dark' }
      g8: { piece: 'knight', color: 'dark' }
      b1: { piece: 'knight', color: 'light' }
      g1: { piece: 'knight', color: 'light' }
      a7: { piece: 'pawn', color: 'dark' }
      b7: { piece: 'pawn', color: 'dark' }
      c7: { piece: 'pawn', color: 'dark' }
      d7: { piece: 'pawn', color: 'dark' }
      e7: { piece: 'pawn', color: 'dark' }
      f7: { piece: 'pawn', color: 'dark' }
      g7: { piece: 'pawn', color: 'dark' }
      h7: { piece: 'pawn', color: 'dark' }
      a2: { piece: 'pawn', color: 'light' }
      b2: { piece: 'pawn', color: 'light' }
      c2: { piece: 'pawn', color: 'light' }
      d2: { piece: 'pawn', color: 'light' }
      e2: { piece: 'pawn', color: 'light' }
      f2: { piece: 'pawn', color: 'light' }
      g2: { piece: 'pawn', color: 'light' }
      h2: { piece: 'pawn', color: 'light' }
      d8: { piece: 'queen', color: 'dark' }
      d1: { piece: 'queen', color: 'light' }
      a8: { piece: 'rook', color: 'dark' }
      h8: { piece: 'rook', color: 'dark' }
      a1: { piece: 'rook', color: 'light' }
      h1: { piece: 'rook', color: 'light' }
    @king =
      dark: 'e8'
      light: 'e1'

  get: (f) -> @pieces[f]

  all: -> @pieces

  kingPosition: (color) -> @king[color]

  executeMove: (move) ->
    {piece, color} = @pieces[move.from]
    if piece is 'king'
      @king[color] = move.to
    # We cannot rely on the move overriding the capture. See en passant
    if move.capture?
      @pieces[move.capture] = undefined
    @_executePieceMove move.from, move.to
    if move.secondaryMove?
      @_executePieceMove move.secondaryMove.from, move.secondaryMove.to

  _executePieceMove: (from, to) ->
    @pieces[to] = @pieces[from]
    @pieces[from] = undefined

module.exports = Board
