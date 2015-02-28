# Chess
Browser-based, player vs. player chess game.

## Browser compatibility
This game relies on multiple features/libraries that are not supported in all browsers. These are:
- [pointer-events](http://caniuse.com/#feat=pointer-events):
  Not supported in: Opera Mini, Opera Classic, IE10 and lower
  Used to make pieces unclickable.
  Clickable pieces caused problems in mobile browsers, because the browser zoomed in to let the user decide whether he wanted to click the piece or the underlying field.
  This is obviously unwanted in this case.
  **Possible solution:** Create a nearly transparent overlay which catches clicks.
  Would need to research click support for transparent svg elements in browsers.
  Would also make hover harder to implement.
- [classList](http://caniuse.com/#feat=classlist):
  Not supported in: Opera Mini, IE9 and lower
  Used for class adding/removal for svg elements.
  Could be replaced class string editing (hacky) or a [jquery svg plugin](http://keith-wood.name/svg.html).
  Using the jquery plugin (and jquery) in browserify would in turn require jquery 2.1.0+, which requires IE9+.
