Iterator = let
    
  iterator = (text, regex, fn, ret = '') ->
    start = len = 0
    skip = false
    while test = regex.exec text
      start += len
      if start > test.index
        len = 0
        skip = true
        current = ''
        rest = text.substr start
      else
        len = test.index - start + test.0.length
        current = text.substr start, len
        rest = text.substr start + len
        
        backtick-skip = current.match /`/g
        if backtick-skip and backtick-skip.length .&. 1
          if stop = (/`|```/ == rest)
            skip = true
            len += stop.index + stop.0.length
            current = text.substr start, len
            rest = text.substr start + len
        else skip = false

        indent-skip = current.match /\n {4}|\n\t/g
        if indent-skip
          if stop = (/\n[^ \t]{1,4}/ == rest)
            skip = true
            len += stop.index
            current = text.substr start, len
            rest = text.substr start + len

      
      ret += skip and current or current.replace test.0, fn test

    if not ret then text
    else ret + rest

  module?exports = iterator
  iterator