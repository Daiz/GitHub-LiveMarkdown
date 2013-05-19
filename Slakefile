require 'shelljs/global'
require! {
  lsc: \LiveScript
  \clean-css
  \gaze
}

libs =
  '../lib/marked.js'
  '../lib/highlight.js'

pkg = JSON.parse cat 'package.json'

task \build 'Build the userscript.' !->

  cd \src # move to source directory
  head = cat 'header.js'
  body = lsc.compile (cat 'index.ls'), {+bare}

  css-opts =
    keep-special-comments: 0
    remove-empty: true

  css = clean-css.process (cat 'icon.css'), css-opts
  pre = clean-css.process (cat 'github.css'), css-opts

  embed = lsc.compile cat 'embed.ls'
  libs = cat libs

  head  .= replace 'VERSION' pkg.version
  body = body
    .replace 'INLINE-CSS' css
    .replace 'INLINE-PRE-CSS' pre
    .replace 'INLINE-JS'  'https://gist.github.com/Daiz-/0146e783887fea4c462d/raw/fea70365ef1281e09959914a8c765efb2d5a1db8/embed.js'

  body = """
    (function(){
      #libs
      #body
    })();
  """

  cd \.. # come back to main directory
  (head + body) .to 'script.user.js'
  embed .to 'embed.js'
  console.log 'Build successful!'

task \watch 'Watch files for change and compile.' !->

  do action = !->
    invoke \build

  <-! gaze 'src/*'
  
  # throw errors
  throw it if it?
  
  @on \all action
