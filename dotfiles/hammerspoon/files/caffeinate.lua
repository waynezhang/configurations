local module = {}

-- State variables
local caffeinateWatcher = nil
local menubar = nil
local isActive = false
local onTimer = nil
local offTimer = nil
local updateMenu = nil
local sleepWatcher = nil

-- Constants
local ON_ICON = "●"
local OFF_ICON = "○"
local WORK_HOURS_START = { hour = 10, min = 0 } -- 10:00 AM
local WORK_HOURS_END = { hour = 19, min = 30 }  -- 19:30 PM
local MORSE_SOUND = "/System/Library/Sounds/Morse.aiff"

-- Helper function to check if current time is a weekday
local function isWeekday()
  local weekday = os.date("%w")
  return weekday ~= "0" and weekday ~= "6" -- 0 = Sunday, 6 = Saturday
end

-- Helper function to check if current time is within work hours
local function isWithinWorkHours()
  if not isWeekday() then
    return false
  end

  local now = os.date("*t")
  local currentMinutes = now.hour * 60 + now.min
  local startMinutes = WORK_HOURS_START.hour * 60 + WORK_HOURS_START.min
  local endMinutes = WORK_HOURS_END.hour * 60 + WORK_HOURS_END.min

  return currentMinutes >= startMinutes and currentMinutes <= endMinutes
end

-- Play beep sound when status changes
local function playBeep()
  hs.sound.getByFile(MORSE_SOUND):play()
end

-- Update menubar icon
local function updateMenubar()
  if menubar then
    menubar:setTitle(isActive and ON_ICON or OFF_ICON)
    menubar:setTooltip("Caffeinate: " .. (isActive and "ON" or "OFF"))

    -- Update menu if function exists
    if updateMenu then
      updateMenu()
    end
  end
end

-- Toggle caffeinate state
local function toggleCaffeinate()
  isActive = not isActive

  if isActive then
    caffeinateWatcher = hs.caffeinate.watcher.new(function(eventType)
      -- Handle caffeinate events, but don't change behavior on screen lock
    end)
    caffeinateWatcher:start()
    hs.caffeinate.set("displayIdle", true, true)
    hs.caffeinate.set("systemIdle", true, true)
    hs.caffeinate.set("system", true, true)
  else
    if caffeinateWatcher then
      caffeinateWatcher:stop()
      caffeinateWatcher = nil
    end
    hs.caffeinate.set("displayIdle", false, true)
    hs.caffeinate.set("systemIdle", false, true)
    hs.caffeinate.set("system", false, true)
  end

  updateMenubar()
  playBeep()
  scheduleTimers()
end

-- Calculate next work start time (10:00 AM on next weekday)
local function getNextWorkStart()
  local now = os.date("*t")
  local target = {
    year = now.year,
    month = now.month,
    day = now.day,
    hour = WORK_HOURS_START.hour,
    min = WORK_HOURS_START.min,
    sec = 0
  }

  local targetTime = os.time(target)
  local currentTime = os.time(now)

  -- If today is a weekday and we haven't reached 10:00 AM yet
  if isWeekday() and currentTime < targetTime then
    return targetTime
  end

  -- Find next weekday
  repeat
    target.day = target.day + 1
    targetTime = os.time(target)
    target = os.date("*t", targetTime)
  until target.wday ~= 1 and target.wday ~= 7 -- Not Sunday (1) or Saturday (7)

  return targetTime
end

-- Calculate next work end time (19:30 PM on current weekday if still within work hours)
local function getNextWorkEnd()
  if not isWeekday() then
    return nil
  end

  local now = os.date("*t")
  local target = {
    year = now.year,
    month = now.month,
    day = now.day,
    hour = WORK_HOURS_END.hour,
    min = WORK_HOURS_END.min,
    sec = 0
  }

  local targetTime = os.time(target)
  local currentTime = os.time(now)

  -- Only schedule for today if we haven't passed 19:30 PM yet
  if currentTime < targetTime then
    return targetTime
  end

  return nil
end

-- Get next timer information for display
local function getNextTimerInfo()
  local now = os.time()
  local nextOnTime = getNextWorkStart()
  local nextOffTime = nil

  -- Only consider off timer if currently active
  if isActive then
    nextOffTime = getNextWorkEnd()
  end


  local nextTimer = nil
  local timerType = nil

  -- Determine which timer is next based on current state
  if isActive then
    -- If currently active, next relevant timer is turn OFF (if available) or next turn ON
    if nextOffTime then
      nextTimer = nextOffTime
      timerType = "Turn OFF"
    elseif nextOnTime then
      nextTimer = nextOnTime
      timerType = "Turn ON"
    end
  else
    -- If currently inactive, next relevant timer is turn ON
    if nextOnTime then
      nextTimer = nextOnTime
      timerType = "Turn ON"
    end
  end

  if nextTimer then
    local timeLeft = nextTimer - now
    local hoursLeft = math.floor(timeLeft / 3600)
    local minutesLeft = math.floor((timeLeft % 3600) / 60)

    local timeFormat = ""
    if hoursLeft > 0 then
      timeFormat = string.format("%dh %dm", hoursLeft, minutesLeft)
    else
      timeFormat = string.format("%dm", minutesLeft)
    end

    local targetTime = os.date("%I:%M %p", nextTimer)
    return string.format("%s at %s (in %s)", timerType, targetTime, timeFormat)
  end
  return nil
end

-- Check and adjust state based on current time (useful after wake from sleep)
local function checkAndAdjustState()
  local shouldBeActive = isWithinWorkHours()
  
  if shouldBeActive and not isActive then
    -- Should be active but isn't - turn on
    isActive = true
    if caffeinateWatcher then
      caffeinateWatcher:stop()
    end
    caffeinateWatcher = hs.caffeinate.watcher.new(function(eventType)
      -- Handle caffeinate events, but don't change behavior on screen lock
    end)
    caffeinateWatcher:start()
    hs.caffeinate.set("displayIdle", true, true)
    hs.caffeinate.set("systemIdle", true, true)
    hs.caffeinate.set("system", true, true)
    updateMenubar()
    playBeep()
  elseif not shouldBeActive and isActive then
    -- Should be inactive but isn't - turn off
    isActive = false
    if caffeinateWatcher then
      caffeinateWatcher:stop()
      caffeinateWatcher = nil
    end
    hs.caffeinate.set("displayIdle", false, true)
    hs.caffeinate.set("systemIdle", false, true)
    hs.caffeinate.set("system", false, true)
    updateMenubar()
    playBeep()
  end
  
  -- Always reschedule timers after state check
  scheduleTimers()
end

-- Schedule automatic on/off timers
function scheduleTimers()
  -- Clear existing timers
  if onTimer then
    onTimer:stop()
    onTimer = nil
  end
  if offTimer then
    offTimer:stop()
    offTimer = nil
  end

  -- Schedule turn on timer
  local nextWorkStart = getNextWorkStart()
  if nextWorkStart then
    local delay = nextWorkStart - os.time()
    onTimer = hs.timer.doAfter(delay, function()
      if not isActive then
        toggleCaffeinate()
      end
      scheduleTimers() -- Reschedule for next day
    end)
  end

  -- Schedule turn off timer (only if currently active and within work hours)
  if isActive then
    local nextWorkEnd = getNextWorkEnd()
    if nextWorkEnd then
      local delay = nextWorkEnd - os.time()
      offTimer = hs.timer.doAfter(delay, function()
        if isActive then
          toggleCaffeinate()
        end
        scheduleTimers() -- Reschedule for next day
      end)
    end
  end
end

-- Initialize the module
function module.init()
  -- Create menubar
  menubar = hs.menubar.new()
  if menubar then
    -- Set click callback to toggle (left click)
    menubar:setClickCallback(function()
      toggleCaffeinate()
    end)

    -- Create menu update function
    updateMenu = function()
      local menu = {
        { title = "Toggle Caffeinate",                         fn = toggleCaffeinate },
        { title = "-" },
        { title = "Status: " .. (isActive and "ON" or "OFF"),  disabled = true },
        { title = "Work Hours: 10:00 AM - 7:30 PM (Weekdays)", disabled = true }
      }

      -- Add next timer info
      local nextTimerInfo = getNextTimerInfo()
      if nextTimerInfo then
        table.insert(menu, { title = "-" })
        table.insert(menu, { title = "Next: " .. nextTimerInfo, disabled = true })
      end

      menubar:setMenu(menu)
    end

    -- Initialize menu
    updateMenu()
  end

  -- Create sleep watcher to handle wake from sleep
  sleepWatcher = hs.caffeinate.watcher.new(function(eventType)
    if eventType == hs.caffeinate.watcher.systemDidWake then
      -- Check and adjust state after waking from sleep
      hs.timer.doAfter(1, checkAndAdjustState)  -- Small delay to ensure system is ready
    end
  end)
  sleepWatcher:start()

  -- Check if we should be active based on current time
  if isWithinWorkHours() then
    isActive = true
    if caffeinateWatcher then
      caffeinateWatcher:stop()
    end
    caffeinateWatcher = hs.caffeinate.watcher.new(function(eventType)
      -- Handle caffeinate events, but don't change behavior on screen lock
    end)
    caffeinateWatcher:start()
    hs.caffeinate.set("displayIdle", true, true)
    hs.caffeinate.set("systemIdle", true, true)
    hs.caffeinate.set("system", true, true)
  end

  updateMenubar()
  scheduleTimers()
end

-- Cleanup function
function module.stop()
  if caffeinateWatcher then
    caffeinateWatcher:stop()
    caffeinateWatcher = nil
  end
  if sleepWatcher then
    sleepWatcher:stop()
    sleepWatcher = nil
  end
  if menubar then
    menubar:delete()
    menubar = nil
  end
  if onTimer then
    onTimer:stop()
    onTimer = nil
  end
  if offTimer then
    offTimer:stop()
    offTimer = nil
  end

  -- Turn off caffeinate
  hs.caffeinate.set("displayIdle", false, true)
  hs.caffeinate.set("systemIdle", false, true)
  hs.caffeinate.set("system", false, true)
end

-- Initialize on load
module.init()

return module
