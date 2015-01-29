io = require 'socket.io-client'
socket = io()
socket.on 'init', (data) ->
  logic = require('./logic')(data.side)
  view = require('./view')(data.side)
  onFieldClick = (field) ->
    view.highlightField field if logic.hasPiece field

  input = require('./input')(onFieldClick)
  socket.on 'move', (move) ->
    logic.executeEnemyMove move
    view.executeMove move
