# configure marked
marked.set-options do
  gfm: true
  tables: true
  breaks: true
  highlight: ->
    hljs.highlight-auto it .value

d = document

# find the important elements
content = d.query-selector \.write-content
textarea = content.query-selector \textarea
head = d.head

# create the button link
button = d.create-element \a
  ..class-name = 'js-toggle-live-preview tooltipped leftwards'
  ..href = \#
  ..set-attribute \original-title 'Live Preview'

# create the button icon
icon = d.create-element \span
  ..class-name = 'octicon octicon-live-preview'

# create the style elements
css = d.create-element \style
  ..class-name = \live-preview-styling 
  ..text-content = \INLINE-CSS

css-pre = d.create-element \style
  ..class-name = \live-preview-code-styling
  ..text-content = \INLINE-PRE-CSS

# create the script element
js = d.create-element \script
  ..src = \INLINE-JS

# append initial elements to appropriate places
head
  ..append-child css
  ..append-child css-pre

button.append-child icon
content.insert-before button, content.first-child

d.body.append-child js

# create preview element
preview = d.create-element 'div'
  ..class-name = 'comment-body markdown-body'
preview-wrapper = d.create-element 'div'
  ..class-name = \comment-content
  ..append-child preview

content.append-child preview-wrapper

update-preview = !->
  text = it.target.value
  preview.innerHTML = marked text

# add event listener for keyup
textarea.add-event-listener 'keyup', update-preview, false
