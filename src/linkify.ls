# Linkify module
# ==============
# This module reproduces GitHub-specific linkification for things like issues,
# commits and @mentions. To read more about these, check out the following:
# 
# * https://help.github.com/articles/github-flavored-markdown#references
# * https://github.com/blog/821-mention-somebody-they-re-notified
# 
# The `text` in the function arguments is the raw markdown text, and the
# `context` is a string in the form of Username/Repository - this is used
# to determine where exactly the links should take and how they should be
# formatted.
#
# To see examples of how this module works, take a look at its unit tests.

Linkify = let

  # If in node.js, get the iterator function with require.
  # Otherwise, grab it from the Iterator variable. 
  
  iterator = if module? then require './iterator' else Iterator

  linkify =

    # A convenient shortcut function that processes the text with all three
    # linkification functions defined below.

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

  # if this file is required as a module in node.js, the iterator function
  # is exported as the module contents. Beyond that, we return the iterator
  # function so that it will be available in the top-level Iterator variable

  module?exports = linkify
  linkify

