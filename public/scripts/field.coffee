aCharCode = 'a'.charCodeAt 0

module.exports =
  row: (f) -> @split(f)[1]

  split: (f) -> [f[0], parseInt f[1]]

  toNumbers: (f) -> [f.charCodeAt(0) - aCharCode, parseInt f[1] - 1]

  fromNumbers: (fileNum, rowNum) ->
    String.fromCharCode(aCharCode + fileNum) + (rowNum + 1)

  offsetBy: (f, o, times = 1) ->
    [fileNum, rowNum] = @toNumbers f
    return @fromNumbers fileNum + o[0] * times, rowNum + o[1] * times

  getOffset: (from, to) ->
    [fileFrom, rowFrom] = @toNumbers from
    [fileTo, rowTo] = @toNumbers to
    return [fileTo - fileFrom, rowTo - rowFrom]

  inRange: (f) -> f.length is 2 and 'a' <= f[0] <= 'h' and '1' <= f[1] <= '8'

  all:  ->
    l = []
    for fileNum in [0..7]
      for rowNum in [0..7]
        l.push @fromNumbers fileNum, rowNum
    return l
