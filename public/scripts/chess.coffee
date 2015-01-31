io = require 'socket.io-client'

socket = io()
socket.on 'init', (data) ->
  new Game(socket, data.side)

class Game
  constructor: (socket, @side) ->
    @logic = require('./logic')(@side)
    @view = require('./view')(@side)
    @input = require('./input')(@onFieldClick)
    socket.on 'move', @onServerMove

  onFieldClick: (f) =>
    @view.removeHighlights()
    if @logic.hasPiece f
      @view.highlightSelectedPiece f
      for targetField in @logic.getPossibleMoves f
        @view.highlightPossibleMove targetField

  onServerMove: (move) =>
    @logic.executeEnemyMove move
    @view.executeMove move
