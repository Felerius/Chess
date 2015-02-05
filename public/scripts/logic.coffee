consts = require './consts'
field = require './field'

class GameLogic
  constructor: (@playerSide) ->
    @epField = null
    @canCastle =
      queenSide: true
      kingSide: true
    @pieces = consts.beginningPieces

  executePlayerMove: (move) ->
    @_updateCanCastle move.from, move.to
    @_executeMove move

  executeEnemyMove: (move) ->
    @_checkEnPassantPossibility move.from, move.to
    @_executeMove move

  hasPiece: (f) -> f of @pieces

  # Dummy for testing highlighting
  getPossibleMoves: (f) ->
    return switch @pieces[f].piece
      when 'pawn' then @_getPawnMoves f
      else []

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

  _getPawnMoves: (f) ->
    color = @pieces[f].color
    moves = []
    dir = consts.directions.forward[color]
    maxStep = if field.row(f) is consts.pawnStartRow[color] then 2 else 1
    for i in [1..maxStep]
      target = field.offset f, dir, i
      if not field.inRange(target) or @hasPiece(target)
        break
      moves.push({from: f, to: target})
    for dir in consts.directions.forwardDiagonals[color]
      target = field.offset f, dir
      if @hasPiece(target) and @pieces[target].color isnt color
        moves.push {from: f, to: target, captured: target}
    return moves

module.exports = (playerSide) -> new GameLogic(playerSide)
