io = require 'socket.io-client'
field = require './field'
Board = require './board'
MessageSystem = require './messages'
NetworkComponent = require './components/network'
InputComponent = require './components/input'

assignFields = (side) ->
  for svgField in document.querySelectorAll '#board > .field'
    col = parseInt(svgField.getAttribute('x')) / 100
    row = parseInt(svgField.getAttribute('y')) / 100
    rankNum = if side is 'light' then 7 - row else row
    fileNum = if side is 'light' then col else 7 - col
    svgField.id = field.fromNumbers fileNum, rankNum

socket = io()
socket.on 'init', (msgData) ->
  assignFields msgData.side
  data =
    playerActive: msgData.side is 'light'
    board: new Board()
    possibleMoves: {}
  msgSystem = new MessageSystem()
  network = new NetworkComponent(msgSystem, data, socket)
  input = new InputComponent(msgSystem, data)
  msgSystem.on 'move', (o) -> console.log(o)
  msgSystem.on 'pieceSelected', (o) -> console.log(o)
