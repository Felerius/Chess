consts = require './consts'
field = require './field'

class GameLogic
  constructor: (@playerColor) ->
    @epStatus =
      dark: null
      light: null
    @castlingStatus =
      dark:
        queenSide: true
        kingSide: true
      light:
        queenSide: true
        kingSide: true
    @pieces = consts.beginningPieces

  executeMove: (move) ->
    @_updateCanCastle move.from, move.to
    @_checkEnPassantPossibility move.from, move.to
    @_executeMove move

  hasPiece: (f) -> f of @pieces

  # Dummy for testing highlighting
  getPossibleMoves: (f) ->
    switch @pieces[f].piece
      when 'pawn' then @_getPawnMoves f
      when 'bishop' then @_getBishopMoves f
      when 'rook' then @_getRookMoves f
      when 'queen' then @_getQueenMoves f
      when 'knight' then @_getKnightMoves f
      when 'king' then @_getKingMoves f

  _movePiece: (from, to) ->
    @pieces[to] = @pieces[from]
    delete @pieces[from]

  _updateCanCastle: (from ,to) ->
    {piece, color} = @pieces[from]
    if piece is 'king'
      @castlingStatus[color].queenSide = @castlingStatus[color].kingSide = false
    else if piece is 'rook'
      if from is consts.rookStarts[color].queenSide
        @castlingStatus[color].queenSide = false
      else if from is consts.rookStarts[color].kingSide
        @castlingStatus[color].kingSide = false

  _checkEnPassantPossibility: (from, to) ->
    oppositeColor = consts.oppositeColor[@pieces[from].color]
    @epStatus[oppositeColor] = null
    return if @pieces[from].piece isnt 'pawn'
    [fileFrom, rankFrom] = field.split from
    [fileTo, rankTo] = field.split to
    return if fileFrom isnt fileTo
    if Math.abs(rankFrom - rankTo) is 2
      @epStatus[oppositeColor] =
        move: fileFrom + ((rankFrom + rankTo) / 2)
        capture: to

  _executeMove: (move) ->
    # We can not rely on the move overriding the captured piece,
    # see en passant captures.
    if move.captured?
      delete @pieces[move.captured]
    @_movePiece move.from, move.to
    if move.secondaryMove?
      @_executeMove move.secondaryMove.from, move.secondaryMove.to

  _getBishopMoves: (f) ->
    @_getDirectionalMovesMultiple f, consts.directions.diagonals

  _getRookMoves: (f) ->
    @_getDirectionalMovesMultiple f, consts.directions.straights

  _getQueenMoves: (f) ->
    @_getDirectionalMovesMultiple f, consts.directions.all

  _getKnightMoves: (f) ->
    @_getDirectionalMovesSingle f, consts.directions.knightJumps

  _getKingMoves: (f) ->
    @_getDirectionalMovesSingle f, consts.directions.all

  _getDirectionalMovesMultiple: (f, directions) ->
    moves = []
    for dir in directions
      i = 1
      loop
        target = field.offset f, dir, i
        break unless field.inRange target
        if not @hasPiece target
          moves.push {from: f, to: target}
        else
          if @pieces[target].color isnt @pieces[f].color
            moves.push {from: f, to: target, captured: target}
          break
        i++
    return moves

  _getDirectionalMovesSingle: (f, directions) ->
    moves = []
    for dir in directions
      target = field.offset f, dir
      continue unless field.inRange target
      if not @hasPiece target
        moves.push {from: f, to: target}
      else
        if @pieces[target].color isnt @pieces[f].color
          moves.push {from: f, to: target, captured: target}
    return moves

  _getPawnMoves: (f) ->
    moves = []
    color = @pieces[f].color
    dir = consts.directions.forward[color]
    maxStep = if field.row(f) is consts.pawnStartRow[color] then 2 else 1
    for i in [1..maxStep]
      target = field.offset f, dir, i
      if not field.inRange(target) or @hasPiece(target)
        break
      moves.push {from: f, to: target}
    for dir in consts.directions.forwardDiagonals[color]
      target = field.offset f, dir
      if @hasPiece(target) and @pieces[target].color isnt color
        moves.push {from: f, to: target, captured: target}
      else if target is @epStatus[color]?.move
        moves.push {from: f, to: target, captured: @epStatus[color].capture}
    return moves

module.exports = (playerColor) -> new GameLogic(playerColor)
