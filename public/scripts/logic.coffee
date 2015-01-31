consts = require './consts'
field = require './field'

class GameLogic
  constructor: (@playerSide) ->
    @epField = null
    @canCastle =
      queenSide: true
      kingSide: true
    @pieces = consts.beginningPieces

  _movePiece: (from, to) ->
    @pieces[to] = @pieces[from]
    delete @pieces[from]

  _updateCanCastle: (from ,to) ->
    piece = @pieces[from].piece
    if piece is 'king'
      @canCastle.queenSide = @canCastle.kingSide = false
    else if piece is 'rook'
      rookStarts = consts.rookStarts[@playerSide]
      if from is rookStarts.queenSide
        @canCastle.queenSide = false
      else if from is rookStarts.kingSide
        @canCastle.kingSide = false

  _checkEnPassantPossibility: (from, to) ->
    @epField = null
    return if @pieces[from].piece isnt 'pawn'
    [fileFrom, rankFrom] = field.split from
    [fileTo, rankTo] = field.split to
    return if fileFrom isnt fileTo
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

  hasPiece: (f) -> f of @pieces

module.exports = (playerSide) -> new GameLogic(playerSide)
