Linkify = let

  linkify =
    all: (text, context) ->
      text = @sha text, context
      text = @issue text, context
      # text = @mention text
  
    sha: (text, context, ret = '') ->
      start = len = 0
      regex = /(?:([A-Za-z0-9-]*)(?:\/([A-Za-z0-9_-]*))?@)?([a-f0-9]{40})/g
      while regex.exec text
        [matched, user, repo, hash] = that
        start += len
        len = that.index - start + matched.length
        current = text.substr start, len
        rest = text.substr start + len
        skip = current.match /`/g
        if skip and skip.length .&. 1
          skip = true
          stop = (/`|```/ == rest)
          len += stop?index + stop?0.length
          current = text.substr start, len
          rest = text.substr start + len
        else skip = false
        short = hash.substr 0 8
        [ctx-user, ctx-repo] = context.split '/'
        if (that.index > 0) and (text.char-at that.index - 1) is '/'
          ret += current
        else
          ret += current.replace matched, switch
            case skip
              matched
            case user and not repo
              switch
              | /\/@/ == matched  => "[#user/@`#short`](/#user//commit/#hash)"
              | otherwise => "[#user@`#short`](/#user/#ctx-repo/commit/#hash)"
            case user and repo
              "[#user/#repo@`#short`](/#user/#repo/commit/#hash)"
            case not user and not repo
              switch (/^@|^\/@/ == matched)?0
              | '@'  => "[@`#short`](/#context/commit/#hash)"
              | '/@' => "/@[`#short`](/#context/commit/#hash)"
              | _    => "[`#short`](/#context/commit/#hash)"
            default
              matched
      if not ret then text
      else ret + rest
  
    issue: (text, context, ret = '') ->
      start = len = 0
      regex = //
      (?:
        https:\/\/github.com\/
        ([A-Za-z0-9-]+)\/
        ([A-Za-z0-9_-]*)\/
        issues\/([0-9]+)
      )|(?:
        (?:([A-Za-z0-9-]*)
        (?:\/([A-Za-z0-9_-]*))?)?
        \#([0-9]+)
      )//g
      while regex.exec text
        test = that
        if (test.0.substr 0 5) == "https"
          [matched, user, repo, number] = test
          url = true
        else
          [matched, _, _, _, user, repo, number] = test
          url = false
        start += len
        len = that.index - start + matched.length
        current = text.substr start, len
        rest = text.substr start + len
        skip = current.match /`/g
        if skip and skip.length .&. 1
          skip = true
          stop = (/`|```/ == rest)
          len += stop?index + stop?0.length
          current = text.substr start, len
          rest = text.substr start + len
        else skip = false
        [ctx-user, ctx-repo] = context.split '/'
        ret += current.replace matched, switch
          case skip
            matched
          case user and not repo
            "[#user##number](/#user/#ctx-repo/issues/#number)"
          case user and repo and url
            if user != ctx-user and repo == ctx-repo
              "[#user##number](/#user/#repo/issues/#number)"
            else
              "[##number](/#user/#repo/issues/#number)"
          case user and repo and not url
            "[#user/#repo##number](/#user/#repo/issues/#number)"
          case not user and not repo
            "[##number](/#context/issues/#number)"
          default
            matched
      if not ret then text
      else ret + rest
  
    mention: (text, ret = '') ->
      start = end = 0
      regex = /([^\w])@([\w-]+)|^@([\w-]+)/g
      while regex.exec text
        [matched, pre, n1, n2] = that
        name = n1 or n2
        pre ?= ''
        start = end
        end = that.index - start + matched.length
        current = text.substr start, end
        rest = text.substr end
        ret += current.replace matched, if name == \mention
          "#pre<a class='user-mention' href='/blog/821'>@#name</a>"
        else
          "#pre<a class='user-mention' href='/#name'>@#name</a>"
      if not ret then text
      else ret + rest

  module?exports = linkify
  linkify

