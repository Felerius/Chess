io = require 'socket.io-client'

socket = io()
socket.on 'init', (data) ->
  new Game(socket, data.side)

class Game
  constructor: (socket, @side) ->
    @selectedField = null
    @logic = require('./logic')(@side)
    @view = require('./view')(@side)
    @input = require('./input')(@onFieldClick)
    socket.on 'move', @onServerMove

  onFieldClick: (f) =>
    @view.removeHighlights()
    if @logic.hasPiece f
      @selectedField = f
      @view.highlightSelectedPiece f
      for targetField in @logic.getPossibleMoves f
        @view.highlightPossibleMove targetField
    else
      @selectedField = null

  onServerMove: (move) =>
    if move.from is @selectedField or move.captured is @selectedField
      @view.removeHighlights()
    @logic.executeEnemyMove move
    @view.executeMove move
