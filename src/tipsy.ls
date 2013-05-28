Tipsy = let
  
  d = document

  default-opts =
    gravity: \e
    text: 'Live Preview'
    offset: 0

  tipsy = (el, opts = ^^default-opts) ->
    
    tip = d.create-element \div
      ..class-name = "tipsy tipsy-#{opts.gravity}"
      ..append-child d.create-element \div
        ..class-name = "tipsy-arrow tipsy-arrow-#{opts.gravity}"
      ..append-child d.create-element \div
        ..class-name = 'tipsy-inner'
        ..text-content = opts.text
      ..style
        ..opacity = 0.8
        ..top = 0
        ..left = 0
        ..display = \none

    d.body.append-child tip

    el-top  = el.offset-top
    el-left = el-offset-left

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
      {..top, ..left} = pos



  module?exports = tipsy
  tipsy