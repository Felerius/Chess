BEGINNING_PIECES = 
  'c8': { piece: 'bishop', color: 'dark' }
  'f8': { piece: 'bishop', color: 'dark' }
  'c1': { piece: 'bishop', color: 'light' }
  'f1': { piece: 'bishop', color: 'light' }
  'e8': { piece: 'king', color: 'dark' }
  'e1': { piece: 'king', color: 'light' }
  'b8': { piece: 'knight', color: 'dark' }
  'g8': { piece: 'knight', color: 'dark' }
  'b1': { piece: 'knight', color: 'light' }
  'g1': { piece: 'knight', color: 'light' }
  'a7': { piece: 'pawn', color: 'dark' }
  'b7': { piece: 'pawn', color: 'dark' }
  'c7': { piece: 'pawn', color: 'dark' }
  'd7': { piece: 'pawn', color: 'dark' }
  'e7': { piece: 'pawn', color: 'dark' }
  'f7': { piece: 'pawn', color: 'dark' }
  'g7': { piece: 'pawn', color: 'dark' }
  'h7': { piece: 'pawn', color: 'dark' }
  'a2': { piece: 'pawn', color: 'light' }
  'b2': { piece: 'pawn', color: 'light' }
  'c2': { piece: 'pawn', color: 'light' }
  'd2': { piece: 'pawn', color: 'light' }
  'e2': { piece: 'pawn', color: 'light' }
  'f2': { piece: 'pawn', color: 'light' }
  'g2': { piece: 'pawn', color: 'light' }
  'h2': { piece: 'pawn', color: 'light' }
  'd8': { piece: 'queen', color: 'dark' }
  'd1': { piece: 'queen', color: 'light' }
  'a8': { piece: 'rook', color: 'dark' }
  'h8': { piece: 'rook', color: 'dark' }
  'a1': { piece: 'rook', color: 'light' }
  'h1': { piece: 'rook', color: 'light' }

class GameLogic
  constructor: (@playerSide) ->
    @epField = null
    @canCastle =
      queenSide: true
      kingSide: true
    @pieces = BEGINNING_PIECES

  _movePiece: (from, to) ->
    @pieces[to] = @pieces[from]
    delete @pieces[from]
    
  _updateCanCastle: (from ,to) ->
    piece = @pieces[from].piece
    if piece is 'king'
      @canCastle.queenSide = @canCastle.kingSide = false
    else if piece is 'rook'
      rank = if @playerSide is 'light' then 1 else 8
      if from is 'a' + rank
        @canCastle.queenSide = false
      else if from is 'h' + rank
        @canCastle.kingSide = false

  _checkEnPassantPossibility: (from, to) ->
    @epField = null
    return if @pieces[from].piece isnt 'pawn'
    fileFrom = from[0]
    fileTo = to[0]
    return if fileFrom isnt fileTo
    rankFrom = parseInt from[1]
    rankTo = parseInt to[1]
    if Math.abs rankFrom - rankTo is 2
      @epField = fileFrom + ((rankFrom + rankTo) / 2)

  _executeMove: (move) ->
    # We can not rely on the move overriding the captured piece,
    # see en passant captures.
    if move.captured?
      delete @pieces[move.captured]
    @_movePiece move.from, move.to
    if move.secondaryMove?
      @_executeMove move.secondaryMove.from, move.secondaryMove.to

  executePlayerMove: (move) ->
    @_updateCanCastle move.from, move.to
    @_executeMove move 

  executeEnemyMove: (move) ->
    @_checkEnPassantPossibility move.from, move.to
    @_executeMove move 
    
module.exports = (playerSide) -> new GameLogic(playerSide)
