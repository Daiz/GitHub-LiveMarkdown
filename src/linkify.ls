Linkify = let
  
  iterator = if module? then require './iterator' else Iterator

  linkify =
    all: (text, context) ->
      text = @sha text, context
      text = @issue text, context
      text = @mention text
  
    sha: (text, context, ret = '') ->
      regex = /(?:([A-Za-z0-9-]*)(?:\/([A-Za-z0-9_-]*))?@)?([a-f0-9]{40})/g
      iterator text, regex, ->
        [matched, user, repo, hash] = it
        short = hash.substr 0 8
        [ctx-user, ctx-repo] = context.split '/'
        if (it.index > 0) and (text.char-at it.index - 1) is '/'
          matched
        else switch
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
  
    issue: (text, context, ret = '') ->
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
      iterator text, regex, ->
        if (it.0.substr 0 5) == \https
          [matched, user, repo, number] = it
          url = true
        else
          [matched, _, _, _, user, repo, number] = it
          url = false
        [ctx-user, ctx-repo] = context.split '/'
        switch
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
  
    mention: (text, ret = '') ->
      regex = /([^A-Za-z0-9])@([A-Za-z0-9-]+)|^@([A-Za-z0-9-]+)/g
      iterator text, regex, ->
        [matched, pre, n1, n2] = it
        name = n1 or n2
        pre ?= ''
        if /[a-f0-9]{40}/ == name then skip = true
        switch
          case name == \mention
            "#pre<a class='user-mention' href='/blog/821'>@mention</a>"
          default
            "#pre<a class='user-mention' href='/#name'>@#name</a>"

  module?exports = linkify
  linkify

