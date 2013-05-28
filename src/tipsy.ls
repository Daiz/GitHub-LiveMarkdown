Tipsy = let
	
	d = document

	tipsy = (el, opts = gravity: \e, text: 'Live Preview') ->
		
		tip = d.create-element \div
			..class-name = "tipsy tipsy-#{opts.gravity}"
			..append-child d.create-element \div
				..class-name = "tipsy-arrow tipsy-arrow-#{opts.gravity}"
			..append-child d.create-element \div
				..class-name = 'tipsy-inner'
				..text-content = opts.text
			..style
				..opacity = 0.8
				..visibility = hidden





	module?exports = tipsy
	tipsy