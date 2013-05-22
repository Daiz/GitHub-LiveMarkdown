Linkify =
  sha1: (text, context) ->
    regex = /([A-Za-z0-9-]+)?\/?([A-Za-z0-9_-]+)?@?([a-f0-9]{40})/
    match = text.match regex
    user = match.1
    repo = match.2
    hash = match.3
    short = hash.substr 0 8
    ctx = context.split '/'
    if user == ctx.1 and not repo?
      "[#user@`#short`](https://github.com/#context/commit/#hash)"
    else if user and repo
      "[#user/#repo@`#short`](https://github.com/#user/#repo/commit/#hash)"
    else if user == repo == void
      "[`#short`](https://github.com/#context/commit/#hash)"
    else
      text