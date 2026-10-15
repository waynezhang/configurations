local currentBrowser = "Safari"
local browsers = {
  Chrome = "com.google.Chrome",
  Hammerspoon = "org.hammerspoon.Hammerspoon",
}

spoon.SpoonInstall:andUse("URLDispatcher",
  {
    config = {
      default_handler = browsers.Safari,
      url_patterns = dofile(hs.configdir .. "/url-patterns.lua"),
    },
    start = true
  }
)

local function toggleBrowser()
  if currentBrowser == "Hammerspoon" then
    currentBrowser = "Chrome"
  else
    currentBrowser = "Hammerspoon"
  end

  hs.urlevent.setDefaultHandler("http", browsers[currentBrowser])
  -- spoon.URLDispatcher.default_handler = browsers[currentBrowser]

  hs.alert.show("Default browser: " .. currentBrowser)
end

hs.hotkey.bind({ "cmd", "shift" }, "b", toggleBrowser)
