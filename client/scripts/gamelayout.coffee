# Switches the game page layout dynamically between horizontal and vertical

isVertical = ($win) -> $win.height() > $win.width()

$ () ->
  $win = $ window
  $panels = $ '.board-panel, .side-panel'
  vertical = isVertical $win
  if vertical
    $panels.addClass 'vertical'
  $win.resize () ->
    oldVertical = vertical
    vertical = isVertical $win
    if vertical isnt oldVertical
      $panels.toggleClass 'vertical'
