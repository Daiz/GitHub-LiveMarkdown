Linkify =
  sha1: (text, context) ->
    regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?@?([a-f0-9]{40})/
    [, user, repo, hash] = text.match regex
    short = hash.substr 0 8
    ctx-user = context.split '/' .0
    if user == ctx-user and not repo
      "[#user@`#short`](https://github.com/#context/commit/#hash)"
    else if user and repo
      "[#user\/#repo@`#short`](https://github.com/#user/#repo/commit/#hash)"
    else if user == repo == void
      "[`#short`](https://github.com/#context/commit/#hash)"
    else
      text

  issue: (text, context) ->
    regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?#([0-9]+)/
    [, user, repo, num] = text.match regex
    ctx-user = context.split '/' .0
    if user == ctx-user and not repo
      "[#user##num](https://github.com/#context/issues/#num"
    else if user and repo
      "[#user\/#repo##num](https://github.com/#user/#repo/issues/#num"
    else
      "[#num](https://github.com/#context/issues/#num)"

  mention: (text) ->
    name = text.match /@([A-Za-z0-9-]+)/ .1
    if name == \mention
      "<a class='user-mention' href='https://github.com/blog/821'>@#name</a>"
    else
      "<a class='user-mention' href='https://github.com/#name'>@#name</a>"