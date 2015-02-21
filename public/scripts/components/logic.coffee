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
knightJumps = [[1, 2], [2, 1], [2, -1], [1, -2], [-1, -2], [-2, -1], [-2, 1], [-1, 2]]
straights = [[1, 0], [-1, 0], [0, 1], [0, -1]]
diagonals = [[1, 1], [1, -1], [-1, 1], [-1, -1]]
allDirections = straights.concat diagonals

class LogicComponent
  constructor: (@msgSystem, playerColor) ->
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
    @status.board.executeMove move
    @status.playerActive = not @status.playerActive
    @moveCache = {}
    @msgSystem.send 'statusUpdated', @status, false

  _getPossibleMoves: (f) =>
    if f not of @moveCache
      @moveCache[f] = @_calculatePossibleMoves f
    return @moveCache[f]

  _calculatePossibleMoves: (f) ->
    # Dummy
    return switch @status.board.get(f).piece
      when 'pawn' then getPawnMoves f, @status.board
      when 'knight' then getKnightMoves f, @status.board
      when 'king' then getKingMoves f, @status.board
      when 'rook' then getRookMoves f, @status.board
      when 'bishop' then getBishopMoves f, @status.board
      when 'queen' then getQueenMoves f, @status.board

getPawnMoves = (f, board) ->
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
    capture = board.get to
    if capture? and capture.color isnt color
      moves.push {from: f, to: to, capture: to}
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

module.exports = LogicComponent
