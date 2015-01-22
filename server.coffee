express = require 'express'
app = express()

app.use express.static(__dirname + '/public')

app.get '/', (req, res) ->
    res.sendFile __dirname + '/views/game.html'

app.listen 8000