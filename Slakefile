require 'shelljs/global'
require! {
  lsc: \LiveScript
  \clean-css
  \gaze
  uglify: \uglify-js
  \browserify
}

pkg = JSON.parse cat 'package.json'

sources =
  \head.ls
  \emoji.ls
  \linkify.ls
  \index.ls


task \bundle 'Bundle dependencies.' !->

  b = browserify!
  b.require \marked
  b.require \highlight.js
  (err, deps) <-! b.bundle {}
  deps.to 'vendor.js'
  console.log 'Dependencies built successfully!'



task \build 'Build the userscript.' !->

  if not test \-e 'vendor.js'
    console.log 'vendor.js not compiled. Run slake build again.'
    invoke \bundle
    return
  else libs = cat 'vendor.js'
  
  cd \src # move to source directory
  head = cat 'HEADER'
  body = lsc.compile (cat sources), {+bare}

  css-opts =
    keep-special-comments: 0
    remove-empty: true

  css = clean-css.process (cat 'style.css'), css-opts
  pre = clean-css.process (cat 'github.css'), css-opts
  emoji-list = lsc.compile (cat 'emoji.ls'), {+bare}

  embed = 'https://gist.github.com/Daiz-/0146e783887fea4c462d/raw/fea70365ef1281e09959914a8c765efb2d5a1db8/embed.js'

  head  .= replace 'VERSION' pkg.version
  body = body
    .replace 'INLINE_CSS' css
    .replace 'INLINE_PRE_CSS' pre
    .replace 'INLINE_JS' embed
    .replace 'EMOJI_LIST' emoji-list

  body = """
    (function(){
      #libs
      #body
    })();
  """

  cd \.. # come back to main directory
  (head + body).to 'script.user.js'
  console.log 'Build successful!'




task \minify 'Build a minified version of the script.' !->
  head = cat 'src/HEADER' .replace \VERSION pkg.version
  body = uglify.minify 'script.user.js'
  (head + body.code).to 'script.min.user.js'
  console.log 'Minification successful!'




task \dist 'Build and minify.' !->
  invoke \build
  invoke \minify




task \watch 'Watch files for change and compile.' !->

  do action = !->
    invoke \build

  <-! gaze 'src/*'
  
  # throw errors
  throw it if it?
  
  @on \all action
