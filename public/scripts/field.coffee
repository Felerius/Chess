aCharCode = 'a'.charCodeAt 0

module.exports =
  split: (f) -> [f[0], parseInt f[1]]

  toNumbers: (f) -> [f.charCodeAt(0) - aCharCode, parseInt f[1] - 1]
