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
  light: [[-1, 1], [1, 1]]
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
castling =
  dark:
    queenSide:
      inBetween: ['b8', 'c8', 'd8']
      kingTarget: 'c8'
      rookTarget: 'd8'
    kingSide:
      inBetween: ['f8', 'g8']
      kingTarget: 'g8'
      rookTarget: 'f8'
  light:
    queenSide:
      inBetween: ['b1', 'c1', 'd1']
      kingTarget: 'c1'
      rookTarget: 'd1'
    kingSide:
      inBetween: ['f1', 'g1']
      kingTarget: 'g1'
      rookTarget: 'f1'

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
    color = @status.board.get(f).color
    return getMoves f, @status.board, @enPassantStatus[color], @castlingStatus[color]

getMoves = (f, board, enPassantStatus, castlingStatus) ->
  {color, piece} = board.get(f)
  moves = switch piece
    when 'pawn' then getPawnMoves f, board, enPassantStatus
    when 'knight' then getKnightMoves f, board
    when 'king' then getKingMoves f, board, castlingStatus
    when 'rook' then getRookMoves f, board
    when 'bishop' then getBishopMoves f, board
    when 'queen' then getQueenMoves f, board
  legalMoves = []
  for move in moves
    simulatedBoard = board.simulateMove move
    if not isInCheck color, simulatedBoard
      legalMoves.push move
  return legalMoves

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

getKingMoves = (f, board, castlingStatus) ->
  color = board.get(f).color
  moves = getDirectionalMovesSingle f, board, allDirections
  for side in ['queenSide', 'kingSide']
    data = castling[color][side]
    # Check if king or rook have moved
    continue if not castlingStatus[side]
    # Check if field in between are free
    continue if data.inBetween.some((f2) -> board.get(f2)?)
    # Check if king is currently in check
    continue if isInCheck color, board
    # Check if the king would be in check on the square he jumps over
    # That field is always the same as the rook target field
    simulatedBoard = board.simulateMove {from: f, to: data.rookTarget}
    continue if isInCheck color, simulatedBoard
    # Check if the king would be in check after castle
    simulatedBoard = board.simulateMove {from: f, to: data.kingTarget}
    continue if isInCheck color, simulatedBoard
    secondaryMove = {from: rookStarts[color][side], to: data.rookTarget}
    moves.push {from: f, to: data.kingTarget, secondaryMove: secondaryMove}
  return moves

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
