require 'shelljs/global'
require! {
  \browserify
  ls: \LiveScript
  pkg: \package.json
}

compile = !->
  file = cat "src/#it"
  file = ls.compile file
  target = "lib/#it" .replace \.ls \.js
  file .to target

task \compile 'Compile src/*.ls to src/*.js.' !->
  [compile .. for ls 'src/*.ls']

task \build 'Build the userscript.' !->
  invoke \compile
  b = browserify 'lib/index.js'
  (err, src) <-! b.bundle {}
  head = cat 'header.js' .replace 'VERSION' pkg.version
  if not test \-e \build then mkdir \build
  (head + src) .to 'build/script.user.js'