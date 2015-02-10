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

  hasPiece: (f) -> f of @pieces

  executeMove: (move) ->
    @_updateCanCastle move.from, move.to
    @_checkEnPassantPossibility move.from, move.to
    @_executeMove move

  getPossibleMoves: (f) ->
    moves = getPieceMoves f, @_getPiece, @epStatus
    legalMoves = []
    for move in moves
      simulatedGetPiece = @_simulateMove(move)
      [king, enemyPieces] = findKingAndEnemies @pieces[f].color, simulatedGetPiece
      unless enemyPieces.some((f) => canCapture(f, king, simulatedGetPiece, @epStatus))
        legalMoves.push move
    return legalMoves

  _movePiece:  (from, to) ->
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

  # To be used as an arguments for move functions
  _getPiece: (f) => @pieces[f]

  _simulateMove: (move) ->
    # Creates a "getPiece" function, that acts as if the given move had been performed
    return (f) =>
      return switch f
        when move.from, move.secondaryMove?.from then undefined
        when move.to then @pieces[move.from]
        # Only needed for en passant (only then is to != captured)
        when move.captured then undefined
        when move.secondaryMove?.to then @pieces[move.secondaryMove.from]
        else @pieces[f]
    return false

findKingAndEnemies = (kingColor, getPiece) ->
  king = null
  enemies = []
  for f in field.all()
    p = getPiece f
    continue unless p?
    if p.color isnt kingColor
      enemies.push f
    else if p.piece is 'king'
      king = f
  return [king, enemies]

getPieceMoves = (f, getPiece, epStatus) ->
  return switch getPiece(f).piece
    when 'pawn'
      getPawnMoves f, getPiece, epStatus
    when 'king'
      getDirectionalMovesSingle f, getPiece, consts.directions.all
    when 'knight'
      getDirectionalMovesSingle f, getPiece, consts.directions.knightJumps
    when 'rook'
      getDirectionalMovesMultiple f, getPiece, consts.directions.straights
    when 'bishop'
      getDirectionalMovesMultiple f, getPiece, consts.directions.diagonals
    when 'queen'
      getDirectionalMovesMultiple f, getPiece, consts.directions.all

getDirectionalMovesMultiple = (f, getPiece, directions) ->
  moves = []
  color = getPiece(f).color
  for dir in directions
    i = 1
    loop
      target = field.offsetBy f, dir, i
      break unless field.inRange target
      piece = getPiece target
      if piece?
        if piece.color isnt color
          moves.push {from: f, to: target, captured: target}
        break
      else
        moves.push {from: f, to: target}
      i++
  return moves

getDirectionalMovesSingle = (f, getPiece, directions) ->
  moves = []
  color = getPiece(f).color
  for dir in directions
    target = field.offsetBy f, dir
    continue unless field.inRange target
    piece = getPiece target
    if piece?
      if piece.color isnt color
        moves.push {from: f, to: target, captured: target}
    else
      moves.push {from: f, to: target}
  return moves

getPawnMoves = (f, getPiece, epStatus) ->
  moves = []
  color = getPiece(f).color
  dir = consts.directions.forward[color]
  maxStep = if field.row(f) is consts.pawnStartRow[color] then 2 else 1
  for i in [1..maxStep]
    target = field.offsetBy f, dir, i
    break if not field.inRange(target) or getPiece(target)?
    moves.push {from: f, to: target}
  for dir in consts.directions.forwardDiagonals[color]
    target = field.offsetBy f, dir
    piece = getPiece target
    if piece? and piece.color isnt color
      moves.push {from: f, to: target, captured: target}
    else if target is epStatus[color]?.move
      moves.push {from: f, to: target, captured: epStatus[color].capture}
  return moves

# Requires there to be a piece on the target field
canCapture = (from, target, getPiece, epStatus) ->
  # Very much brute force, but performance impact seems to be negligible
  # Can be otherwise replaced by a more math heavy solution
  return getPieceMoves(from, getPiece, epStatus).some (move) ->
    move.captured is target

module.exports = (playerColor) -> new GameLogic(playerColor)
