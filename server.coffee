express = require 'express'
app = express()

app.get '/', (req, res) ->
    res.sendFile __dirname + '/public/game.html'

app.listen 8000