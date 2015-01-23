svgns = 'http://www.w3.org/2000/svg'
xlinkns = 'http://www.w3.org/1999/xlink'
files = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h']

createFields = () ->
  boardSvg = document.getElementById 'board'
  outlineRect = document.getElementById 'outline'
  for file in [0..7]
    for rank in [0..7]
      field = document.createElementNS svgns, 'use'
      field.setAttribute 'x', 100*file
      field.setAttribute 'y', 700 - 100*rank
      field.setAttribute 'id', files[file] + (rank + 1)
      href =  if (file + rank) % 2 is 0 then '#dark_field' else '#light_field'
      field.setAttributeNS xlinkns, 'href', href
      boardSvg.insertBefore field, outlineRect

createFields()