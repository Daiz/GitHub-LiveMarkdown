# Live Markdown Preview for GitHub

This is a userscript that does exactly what it says on the tin: It adds a live preview underneath the markdown input in comments, issues, etc.

![Demonstration](https://f.cloud.github.com/assets/3596343/523374/4fe1218a-c0b0-11e2-8b0a-82f0072ef3de.gif)

The Live Preview is enabled by default, updates in realtime and can be toggled on and off with the button in the text area.

## Installation

1. Install a userscript implementation.
  * **Chrome:** [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo)
  * **Firefox:** [Greasemonkey](https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/)
  * **Opera:** See [documentation.](http://www.opera.com/docs/userjs/) *(Untested)*
  * **Safari:** [NinjaKit](https://github.com/os0x/NinjaKit) *(Untested)*
2. Download the userscript [**here.**](https://raw.github.com/Daiz-/GitHub-LiveMarkdown/master/script.min.user.js)

You can also install the script to Chrome directly by saving the `.user.js` file to your hard drive and dragging & dropping it to your Extensions page.

## Upcoming Features

Right now Live Preview doesn't work in commit line notes nor in Zen Mode. It also lacks support for some GitHub-specific things like @mentions, #XXX issue links and checkboxes. These are all planned features and should be implemented eventually.