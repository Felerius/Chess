class MessageSystem
  constructor: (@logger) ->
    @handlers = {}

  on: (type, handler) ->
    if type not of @handlers
      @handlers[type] = []
    @handlers[type].push handler

  send: (type, args...) ->
    handlers = @handlers[type]
    if not handlers?
      @logger(type, args, 0) if @logger?
    else
      @logger(type, args, handlers.length) if @logger?
      for handler in @handlers[type]
        handler args...

module.exports = MessageSystem
