# Iterator module
# ===============
# This module provides the "iterator" function. The input `text` should be
# raw markdown. The `regex` should be a global regular expression (with or
# without capture groups). The iterator will find all the regex matches
# in the text and transform them with the given function `fn` - unless the
# match is inside a code block (marked with backticks or indents).
# The transform function is passed the regex match result object, which has
# the form [match, capture groups, index: n, input: text]. `ret` is the
# transformed text that will be returned at the end, and the user should
# not provide any value for this argument (unless they want the whole text
# to be prepended with it). 

Iterator = let

  reverse = ->
    it.split '' .reverse!join ''
    
  iterator = (text, regex, fn, ret = '') ->
    start = len = 0
    skip = false
    while test = regex.exec text

      start += len

      # If the previous match was inside a code span/block, the "text block"
      # of the match was extended to the end of said block. If the start
      # index is greater than the current match index, it means there were
      # multiple matches inside a single code block and thus any matches
      # should be skipped until we're out of the code block.

      if start > test.index
        len = 0
        skip = true
        current = ''
        rest = text.substr start
      else

        # `current` is a string extending from the end of the last match
        # to the end of the current match. `rest` is simply the rest of the
        # text after the end of the current match. It is used to return any
        # text left over after the final match.

        len = test.index - start + test.0.length
        current = text.substr start, len
        rest = text.substr start + len

        # The following code figures out if the current match is inside a
        # code block or not. In case of backticks, we're counting the amount
        # of backticks and seeing if it's odd or not - if it is, then it
        # means a code block is 'open' and we're inside it. The match
        # transformation is skipped and we figure out where the code block
        # ends and only transform matches after that.
        #
        # If you want to know why bitwise AND 1 is used instead of modulo 2,
        # it's because the former is consistently faster:
        # http://jsperf.com/modulo-vs-bitwise-and-for-odd-checking
        #
        # The indent check is much simpler in comparison - it simply figures
        # out if the line of the match is indented with at least 4 spaces
        # or a single tab. If it is, the match transformation is skipped once
        # again and we find the first line with no 'code indentation' and
        # only transform matches after that. 
        
        backtick-skip = current.match /`/g
        if backtick-skip and backtick-skip.length .&. 1
          if stop = (/`|```/ == rest)
            skip = true
            len += stop.index + stop.0.length
            current = text.substr start, len
            rest = text.substr start + len
        else skip = false

        indent-skip = current.split '\n'
        if /^ {4}|^\t/ == indent-skip[*-1]
          skip = true
          if stop = (/\n[^ \t]{1,4}/ == rest)
            len += stop.index
          else
            len += rest.length
          current = text.substr start, len
          rest = text.substr start + len


      # Here we append the return string. If `skip` is true, we simply add
      # the current text block as-is, but if it's not, we transform the match
      # in the text block using the user-provided function. 
      
      ret += skip and current or current.replace test.0, fn test

    # if there were no matches to the given regex, ret will be empty.
    # In this case, we simply return the original text.
    # Otherwise, we return the transformed text.

    if not ret then text
    else ret + rest

  # if this file is required as a module in node.js, the iterator function
  # is exported as the module contents. Beyond that, we return the iterator
  # function so that it will be available in the top-level Iterator variable.

  module?exports = iterator
  iterator