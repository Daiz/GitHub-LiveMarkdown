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