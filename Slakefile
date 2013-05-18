require 'shelljs/global'
require! {
  lsc: \LiveScript
  \clean-css
  \gaze
}

pkg = JSON.parse cat 'package.json'

compile = !->
  file = cat it
  file = lsc.compile file
  target = it.replace \src \lib .replace \.ls \.js
  file .to target

task \compile 'Compile src/*.ls to src/*.js.' !->
  [compile .. for ls 'src/*.ls']

task \build 'Build the userscript.' !->
  cd \src # move to source directory
  head = cat 'header.js'
  body = lsc.compile cat 'index.ls'
  css = clean-css.process (cat 'icon.css'), do
    keep-special-comments: 0
    remove-empty: true

  css .= replace '\\', '\\\\'
  body .= replace 'INLINE-CSS' css
  head .= replace 'VERSION' pkg.version

  cd \.. # come back to main directory
  if not test \-e \build then mkdir \build
  (head + body) .to 'script.user.js'
  console.log 'Build successful!'

task \watch 'Watch files for change and compile.' !->
  do action = !->
    invoke \build

  <-! gaze 'src/*'
  
  # throw errors
  throw it if it?
  
  @on \all action
