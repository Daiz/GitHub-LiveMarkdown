Iterator = let
    
  iterator = (text, regex, fn, ret = '') ->
    start = len = 0
    while regex.exec text
      start += len
      if start > test.index
        len = 0
        skip = true
        current = ''
        rest = text.substr start
      else
        len = test.index - start + matched.length
        current = text.substr start, len
        rest = text.substr start + len
        skip = current.match /`/g
        if skip and skip.length .&. 1
          skip = true
          stop = (/`|```/ == rest)
          len += (stop?index + stop?0.length) or rest.length
          current = text.substr start, len
          rest = text.substr start + len
        else skip = false
      
      ret += fn current, that unless skip

    if not ret then text
    else ret + rest

  module?exports = linkify
  linkify