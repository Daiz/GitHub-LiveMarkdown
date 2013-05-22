require! {
  \marked
  hljs: \highlight.js
}

# shortcuts
d = document
context = do ->
  regex = /https:\/\/github.com\/([A-Za-z0-9-]+\/[A-Za-z0-9_-]+)\//
  (document.location.href.match regex)1