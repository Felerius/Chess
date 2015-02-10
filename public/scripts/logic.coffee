consts = require './consts'
field = require './field'

class GameLogic
  constructor: (@playerColor) ->
    @status =
      light:
        enPassant: null
        castling:
          queenSide: true
          kingSide: true
      dark:
        enPassant: null
        castling:
          queenSide: true
          kingSide: true
    @pieces = consts.beginningPieces

  hasPiece: (f) -> f of @pieces

  executeMove: (move) ->
    @_updateCanCastle move.from, move.to
    @_checkEnPassantPossibility move.from, move.to
    @_executeMove move

  getPossibleMoves: (f) ->
    color = @pieces[f].color
    moves = @_getPieceMoves f, @_getPiece
    legalMoves = []
    for move in moves
      simulatedGetPiece = @_simulateMove move, @_getPiece
      unless @_inCheck color, simulatedGetPiece
        legalMoves.push move
    return legalMoves

  _movePiece:  (from, to) ->
    @pieces[to] = @pieces[from]
    delete @pieces[from]

  _updateCanCastle: (from ,to) ->
    {piece, color} = @pieces[from]
    if piece is 'king'
      @status[color].castling.queenSide = @status[color].castling.kingSide = false
    else if piece is 'rook'
      for side in ['kingSide', 'queenSide']
        if from is consts.castling[color][side].rookStart
          @status[color].castling[side] = false

  _checkEnPassantPossibility: (from, to) ->
    oppositeColor = consts.oppositeColor[@pieces[from].color]
    @status[oppositeColor].enPassant = null
    return if @pieces[from].piece isnt 'pawn'
    [fileFrom, rankFrom] = field.split from
    [fileTo, rankTo] = field.split to
    return if fileFrom isnt fileTo
    if Math.abs(rankFrom - rankTo) is 2
      @status[oppositeColor].enPassant =
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

  _simulateMove: (move, getPiece) ->
    return (f) =>
      return switch f
        when move.from, move.secondaryMove?.from then undefined
        when move.to then getPiece(move.from)
        # Only needed for en passant (only then is to != captured)
        when move.captured then undefined
        when move.secondaryMove?.to then getPiece(move.secondaryMove.from)
        else getPiece(f)

  _inCheck: (color, getPiece) ->
    king = null
    enemies = []
    for f in field.all()
      p = getPiece f
      continue unless p?
      if p.color isnt color
        enemies.push f
      else if p.piece is 'king'
        king = f
    return enemies.some (f) => @_canCapture(f, king, getPiece)

  _getPieceMoves: (f, getPiece) ->
    return switch getPiece(f).piece
      when 'pawn'
        @_getPawnMoves f, getPiece
      when 'king'
        @_getKingMoves f, getPiece
      when 'knight'
        @_getDirectionalMovesSingle f, getPiece, consts.directions.knightJumps
      when 'rook'
        @_getDirectionalMovesMultiple f, getPiece, consts.directions.straights
      when 'bishop'
        @_getDirectionalMovesMultiple f, getPiece, consts.directions.diagonals
      when 'queen'
        @_getDirectionalMovesMultiple f, getPiece, consts.directions.all

  _getDirectionalMovesMultiple: (f, getPiece, directions) ->
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

  _getDirectionalMovesSingle: (f, getPiece, directions) ->
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

  _getKingMoves: (f, getPiece) ->
    color = getPiece(f).color
    moves = @_getDirectionalMovesSingle f, getPiece, consts.directions.all
    for side in ['kingSide', 'queenSide']
      continue unless @status[color].castling[side]
      data = consts.castling[color][side]
      continue if data.allBetween.some (f2) -> getPiece(f2)?
      continue if @_inCheck color, getPiece
      # Simulate move of king to skipped field to test for check
      # Skipped field is always the same as rook target field
      getPieceSimulated = @_simulateMove {from: f, to: data.rookTarget}, getPiece
      continue if @_inCheck color, getPieceSimulated
      # Check for check after the move is done by an outer method
      rookMove = {from: data.rookStart, to: data.rookTarget}
      moves.push {from: f, to: data.kingTarget, secondaryMove: rookMove}
    return moves

  _getPawnMoves: (f, getPiece) ->
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
      else if target is @status[color].enPassant?.move
        moves.push {from: f, to: target, captured: @status[color].enPassant.capture}
    return moves

  # Requires there to be a piece on the target field
  _canCapture: (from, target, getPiece) ->
    # Very much brute force, but performance impact seems to be negligible
    # Can be otherwise replaced by a more math heavy solution
    return @_getPieceMoves(from, getPiece).some (move) ->
      move.captured is target

module.exports = (playerColor) -> new GameLogic(playerColor)
