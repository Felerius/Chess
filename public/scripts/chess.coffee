io = require 'socket.io-client'
socket = io()
socket.on 'init', (data) ->
  view = require('./view')(data.side)
