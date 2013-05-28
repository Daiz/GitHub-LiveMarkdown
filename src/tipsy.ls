# Tipsy module
# ============
# This module is a very lightweight and stripped-down version of tipsy[1].
# It provides a tooltip for the Live Preview button in the edit box in the
# style of GitHub's other tooltips. Functionality can be extended in the
# future if necessary.
#
# [1] https://github.com/jaz303/tipsy

Tipsy = let
  
  d = document
  de = d.document-element

  add-tip = !->
    it.add-event-listener \mouseover show-tip
    it.add-event-listener \mouseout  destroy-tip

  show-tip = !->
    el = it.target.parent-node
    tipsy el

  destroy-tip = !->
    tip = d.body.query-selector \.tipsy
    d.body.remove-child tip

  default-opts =
    gravity: \e
    text: 'Live&nbsp;Preview'
    offset: 0

  tipsy = !(el, opts = ^^default-opts) ->

    # https://github.com/jaz303/tipsy/blob/master/src/javascripts/jquery.tipsy.js#L36-L58
    
    tip = d.create-element \div
      ..class-name = "tipsy tipsy-#{opts.gravity}"
      ..append-child d.create-element \div
        ..class-name = "tipsy-arrow tipsy-arrow-#{opts.gravity}"
      ..append-child d.create-element \div
        ..class-name = 'tipsy-inner'
        ..innerHTML = opts.text
      ..style
        ..opacity = 0.8
        ..top = 0
        ..left = 0
        ..display = \block

    d.body.insert-before tip, d.body.first-child 

    el-rect = el.get-bounding-client-rect!
    el-top  = el-rect.top + 1 + window.page-y-offset - de.client-top
    el-left = el-rect.left + window.page-x-offset - de.client-left

    el-width  = el.offset-width
    el-height = el.offset-height

    tip-width  = tip.offset-width
    tip-height = tip.offset-height

    pos = switch opts.gravity
    | \n => top: el-top + el-height + opts.offset, left: el-left + el-width / 2 - tip-width / 2
    | \s => top: el-top - tip-height - opts.offset, left: el-left + el-width / 2 - tip-width / 2
    | \e => top: el-top + el-height / 2 - tip-height / 2, left: el-left - tip-width - opts.offset
    | \w => top: el-top + el-height / 2 - tip-height / 2, left: el-left + el-width + opts.offset

    tip.style
      ..top = pos.top + \px
      ..left = pos.left + \px

  module?exports = add-tip
  add-tip