hs.window.animationDuration = 0
hs.loadSpoon("SpoonInstall")

require "vi-keys"
require "yen-key"
require "url-dispatch"
require "caffeinate"
require "display-layout"
require "reload"
require "spotify"
require "gmail-unread"

spoon.SpoonInstall:andUse("MouseCircle", {
  hotkeys = {
    show = { { "cmd", "shift" }, "m" }
  }
})
