local function arrangeDisplays()
  local screens = hs.screen.allScreens()

  if #screens < 2 then
    return
  end

  local primaryScreen = hs.screen.primaryScreen()
  local secondaryScreen = nil

  for _, screen in ipairs(screens) do
    if screen ~= primaryScreen then
      secondaryScreen = screen
      break
    end
  end

  if secondaryScreen then
    local primaryFrame = primaryScreen:frame()
    local secondaryFrame = secondaryScreen:frame()

    local newX = primaryFrame.x
    local newY = primaryFrame.y - secondaryFrame.h

    secondaryScreen:setOrigin(newX, newY)
  end
end

local displayWatcher = hs.screen.watcher.new(function()
  hs.timer.doAfter(2, arrangeDisplays)
end)

displayWatcher:start()

arrangeDisplays()
