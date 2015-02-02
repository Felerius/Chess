aCharCode = 'a'.charCodeAt 0

module.exports =
  split: (f) -> [f[0], parseInt f[1]]

  toNumbers: (f) -> [f.charCodeAt(0) - aCharCode, parseInt f[1] - 1]

  fromNumbers: (fileNum, rowNum) ->
    String.fromCharCode(aCharCode + fileNum) + (rowNum + 1)

  all:  ->
    l = []
    for fileNum in [0...7]
      for rowNum in [0...7]
        l.push @fromNumbers fileNum, rowNum
    return l
