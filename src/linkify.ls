Linkify = let

  linkify =
    all: (text, context) ->
      text = @sha text, context
      text = @issue text, context
      # text = @mention text
  
    sha: (text, context, ret = '') ->
      start = end = 0
      regex = /(?:([A-Za-z0-9-]+)(?:\/([A-Za-z0-9_-]+))?@)?([a-f0-9]{40})/g
      while regex.exec text
        [matched, user, repo, hash] = that
        start = end
        end = that.index - start + matched.length
        current = text.substr start, end
        rest = text.substr end
        short = hash.substr 0 8
        ctx-user = context.split '/' .0
        ret += current.replace matched, if user == ctx-user and not repo
          "[#user@`#short`](/#context/commit/#hash)"
        else if user and repo
          "[#user/#repo@`#short`](/#user/#repo/commit/#hash)"
        else if user == repo == void
          "[`#short`](/#context/commit/#hash)"
        else
          matched
      if not ret then text
      else ret + rest
  
    issue: (text, context, ret = '') ->
      start = end = 0
      regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?#([0-9]+)/g
      while regex.exec text
        [matched, user, repo, num] = that
        start = end
        end = that.index - start + matched.length
        current = text.substr start, end
        rest = text.substr end
        ctx-user = context.split '/' .0
        ret += current.replace matched, if user == ctx-user and not repo
          "[#user##num](/#context/issues/#num"
        else if user and repo
          "[#user/#repo##num](/#user/#repo/issues/#num"
        else if user == repo == void
          "[##num](/#context/issues/#num)"
        else
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

  if typeof module != \undefined
    module.exports = linkify

  return linkify

