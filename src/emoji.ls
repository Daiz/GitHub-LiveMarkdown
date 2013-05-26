# Emoji module
# ============
# This module provides the "emoji" function. It takes raw markdown text and
# replaces any valid emoji codes (defined by the emoji-list below) with their
# respective images.

Emoji = let
  
  # If in node.js, get the dependencies with require.
  # Otherwise, grab them from appropriate variables.

  if module?
    require! <[ ./iterator ./emoji-list ]>
  else
    iterator   = Iterator
    emoji-list = EmojiList

  emoji = (text) ->
    regex = /:([a-z0-9_+-]+):/g
    iterator text, regex, ->
      [matched, name] = it
      if name in emoji-list
        """
        <img class='emoji' title='#str' alt='#str' src=
        'https://a248.e.akamai.net/assets.github.com/images/icons/emoji/#name.png'
        width='20' height='20' align='absmiddle'>
        """
      else matched

  # if this file is required as a module in node.js, the iterator function
  # is exported as the module contents. Beyond that, we return the iterator
  # function so that it will be available in the top-level Emoji variable.

  module?exports = emoji
  emoji