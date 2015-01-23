svgns = 'http://www.w3.org/2000/svg'
xlinkns = 'http://www.w3.org/1999/xlink'
files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

fieldToPos = (file, rank, darkSide) ->
  return [700 - 100*file, 100*rank] if darkSide
  return [100*file, 700 - 100*rank]

createFields = (darkSide) ->
  boardSvg = document.getElementById 'board'
  outlineRect = document.getElementById 'outline'
  for file in [0..7]
    for rank in [0..7]
      field = document.createElementNS svgns, 'use'
      [x, y] = fieldToPos(file, rank, darkSide)
      field.setAttribute 'x', x
      field.setAttribute 'y', y
      field.setAttribute 'id', files[file] + (rank + 1)
      href =  if (file + rank) % 2 is 0 then '#dark_field' else '#light_field'
      field.setAttributeNS xlinkns, 'href', href
      boardSvg.insertBefore field, outlineRect

createFields(false)