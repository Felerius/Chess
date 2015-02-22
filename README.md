# Chess
Browser-based, player vs. player chess game.

## Browser compatibility
This game relies on multiple features/libraries that are not supported in all browsers. These are:
- [pointer-events](http://caniuse.com/#feat=pointer-events):
  Not supported in Opera Mini and only in IE11+.
  Used to make pieces unclickable.
  Clickable pieces caused problems in mobile browsers, because the browser zoomed in to let the user decide whether he wanted to click the piece or the underlying field.
  This is obviously unwanted in this case.
  **Possible solution:** Create a nearly transparent overlay which catches clicks.
  Would need to research click support for transparent svg elements in browsers.
  Would also make hover harder to implement.
- [jquery 2.1.0](http://jquery.com/browser-support/):
  Needed for easy integration with browserify.
  Only supports IE9+.
  Could be replaced by a globally required jquery file.
- [classList](http://caniuse.com/#feat=classlist):
  Only supported in IE9+ and not in Opera Mini.
  Used for class adding/removal for svg elements.
  Could be replaced class string editing (hacky) or a [jquery svg plugin](http://keith-wood.name/svg.html).
