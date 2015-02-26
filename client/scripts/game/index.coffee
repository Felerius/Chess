io = require 'socket.io-client'
field = require './field'
Board = require './board'
MessageSystem = require './messages'
NetworkComponent = require './components/network'
InputComponent = require './components/input'
ViewComponent = require './components/view'
LogicComponent = require './components/logic'

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
  msgSystem = new MessageSystem()
  network = new NetworkComponent(msgSystem, socket)
  input = new InputComponent(msgSystem)
  view = new ViewComponent(msgSystem)
  logic = new LogicComponent(msgSystem, msgData.side)
  # Gives components the chance to perform initialization that relies on
  # the other components existing
  msgSystem.send 'init'
