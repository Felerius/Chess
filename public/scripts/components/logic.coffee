Board = require '../board'
field = require '../field'

pawnStartRow =
  dark: 7
  light: 2
pawnMove =
  dark: [0, -1]
  light: [0, 1]
pawnCapture =
  dark: [[-1, -1], [1, -1]]
  light: [[-1, 1], [-1, 1]]
rookStarts =
  dark:
    queenSide: 'a8'
    kingSide: 'h8'
  light:
    queenSide: 'a1'
    kingSide: 'h1'
knightJumps = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
straights = [[1, 0], [-1, 0], [0, 1], [0, -1]]
diagonals = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
allDirections = straights.concat diagonals

class LogicComponent
  constructor: (@msgSystem, playerColor) ->
    startingCastlingStatus =
      queenSide: true
      kingSide: true
    @castlingStatus =
      dark: startingCastlingStatus
      light: startingCastlingStatus
    @enPassantStatus =
      dark: null
      light: null
    @status =
      playerColor: playerColor
      playerActive: playerColor is 'light'
      board: new Board()
      getPossibleMoves: @_getPossibleMoves
    @moveCache = {}
    @msgSystem.on 'init', @_onInit
    @msgSystem.on 'move', @_onMove

  _onInit: () =>
    @msgSystem.send 'statusUpdated', @status, true

  _onMove: (move) =>
    @_updateCastlingStatus move
    @_updateEnPassantStatus move
    @status.board.executeMove move
    @status.playerActive = not @status.playerActive
    @moveCache = {}
    @msgSystem.send 'statusUpdated', @status, false

  _updateCastlingStatus: (move) ->
    # Only testing primary move, only secondary move is castling
    {piece, color} = @status.board.get move.from
    if piece is 'king'
      @castlingStatus[color].queenSide = @castlingStatus[color].kingSide = false
    else if piece is 'rook'
      for side in ['queenSide', 'kingSide']
        if move.from is rookStarts[color][side]
          @castlingStatus[color][side] = false

  _updateEnPassantStatus: (move) ->
    {piece, color} = @status.board.get move.from
    enemyColor = getOppositeColor color
    @enPassantStatus[enemyColor] = null
    return if piece isnt 'pawn'
    [fileFrom, rowFrom] = field.split move.from
    [fileTo, rowTo] = field.split move.to
    if fileFrom is fileTo and Math.abs(rowFrom - rowTo) is 2
      @enPassantStatus[enemyColor] =
        move: fileFrom + ((rowFrom + rowTo) / 2)
        capture: move.to

  _getPossibleMoves: (f) =>
    if f not of @moveCache
      @moveCache[f] = @_calculatePossibleMoves f
    return @moveCache[f]

  _calculatePossibleMoves: (f) ->
    {piece, color} = @status.board.get(f)
    return switch piece
      when 'pawn' then getPawnMoves f, @status.board, @enPassantStatus[color]
      when 'knight' then getKnightMoves f, @status.board
      when 'king' then getKingMoves f, @status.board
      when 'rook' then getRookMoves f, @status.board
      when 'bishop' then getBishopMoves f, @status.board
      when 'queen' then getQueenMoves f, @status.board

getPawnMoves = (f, board, enPassantStatus) ->
  color = board.get(f).color
  moves = []
  maxStep = if field.split(f)[1] is pawnStartRow[color] then 2 else 1
  for step in [1..maxStep]
    to = field.offsetBy f, pawnMove[color], step
    break if not field.inRange(to) or board.get(to)?
    moves.push {from: f, to: to}
  for offset in pawnCapture[color]
    to = field.offsetBy f, offset
    # Implicit in range check
    piece = board.get to
    if piece? and piece.color isnt color
      moves.push {from: f, to: to, capture: to}
    else if to is enPassantStatus?.move
      moves.push {from: f, to: to, capture: enPassantStatus.capture}
  return moves

getKnightMoves = (f, board) ->
  return getDirectionalMovesSingle f, board, knightJumps

getKingMoves = (f, board) ->
  return getDirectionalMovesSingle f, board, allDirections

getRookMoves = (f, board) ->
  return getDirectionalMovesMultiple f, board, straights

getBishopMoves = (f, board) ->
  return getDirectionalMovesMultiple f, board, diagonals

getQueenMoves = (f, board) ->
  return getDirectionalMovesMultiple f, board, allDirections

getDirectionalMovesSingle = (f, board, directions) ->
  color = board.get(f).color
  moves = []
  for dir in directions
    to = field.offsetBy f, dir
    piece = board.get to
    continue if not field.inRange(to) or piece?.color is color
    if piece?
      moves.push {from: f, to: to, capture: to}
    else
      moves.push {from: f, to: to}
  return moves

getDirectionalMovesMultiple = (f, board, directions) ->
  color = board.get(f).color
  moves = []
  for dir in directions
    step = 0
    while true
      step++
      to = field.offsetBy f, dir, step
      piece = board.get(to)
      break if not field.inRange(to)
      if not piece?
        moves.push {from: f, to: to}
      else
        if piece.color isnt color
          moves.push {from: f, to: to, capture: to}
        break
  return moves

# Only requires the "kingPosition" and "get" methods on the board
isInCheck = (color, board) ->
  king = board.kingPosition color
  enemyColor = getOppositeColor color
  isSpecificEnemy = (f, types) ->
    piece = board.get f
    return piece? and piece.color is enemyColor and piece.piece in types
  # Test pawn
  # The offset for a color are the reversed ones of the other color
  for offset in pawnCapture[color]
    return true if isSpecificEnemy field.offsetBy(king, offset), ['pawn']
  # Test knight
  for offset in knightJumps
    return true if isSpecificEnemy field.offsetBy(king, offset), ['knight']
  # Test king
  # Needed for testing possible moves
  offset = field.getOffset king, board.kingPosition(enemyColor)
  if Math.abs(offset[0]) is 1 and Math.abs(offset[1]) is 1
    return true
  # Test queen, rook and bishop
  tests = [
    [diagonals, ['queen', 'bishop']]
    [straights, ['queen', 'rook']]
  ]
  for [directions, types] in tests
    for dir in directions
      step = 0
      while true
        step++
        f = field.offsetBy king, dir, step
        break if not field.inRange f
        piece = board.get f
        if piece?
          return true if isSpecificEnemy f, types
          break
  return false


getOppositeColor = (color) -> if color is 'light' then 'dark' else 'light'

module.exports = LogicComponent
