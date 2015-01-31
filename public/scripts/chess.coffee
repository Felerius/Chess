io = require 'socket.io-client'
socket = io()
socket.on 'init', (data) ->
  logic = require('./logic')(data.side)
  view = require('./view')(data.side)
  onFieldClick = (f) ->
    view.removeHighlights()
    if logic.hasPiece f
      view.highlightSelectedPiece f
      for move in logic.getMoves f
        view.highlightPossibleMove move

  input = require('./input')(onFieldClick)
  socket.on 'move', (move) ->
    logic.executeEnemyMove move
    view.executeMove move
