io = require 'socket.io-client'

socket = io()
socket.on 'init', (data) ->
  new Game(socket, data.side)

class Game
  constructor: (@socket, @side) ->
    @selectedField = null
    # Dict from target field to move struct
    @possibleMoves = {}
    @logic = require('./logic')(@side)
    @view = require('./view')(@side)
    @input = require('./input')(@onFieldClick)
    @socket.on 'move', @onServerMove

  onFieldClick: (f) =>
    @view.removeHighlights()
    if @selectedField? and f of @possibleMoves
      move = @possibleMoves[f]
      @socket.emit 'move', move
      @logic.executePlayerMove move
      @view.executeMove move
      @selectedField = null
      @possibleMoves = {}
    else
      @selectedField = null
      if @logic.hasPiece f
        @selectedField = f
        @view.highlightSelectedPiece f
        for move in @logic.getPossibleMoves f
          @possibleMoves[move.to] = move
          @view.highlightPossibleMove move.to

  onServerMove: (move) =>
    if move.from is @selectedField or move.captured is @selectedField
      @view.removeHighlights()
    @logic.executeEnemyMove move
    @view.executeMove move
