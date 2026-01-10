local module = {}

-- State variables
local appWatcher = nil
local currentTrackMenubar = nil
local updateTimer = nil
local lastTrack = nil

-- Constants
local SPOTIFY_APP_NAME = "Spotify"

-- Helper function to check if Spotify is running
local function isSpotifyRunning()
  return hs.spotify.isRunning()
end

-- Helper function to get current track info
local function getCurrentTrack()
  if not isSpotifyRunning() then
    return nil
  end

  local track = hs.spotify.getCurrentTrack()
  local artist = hs.spotify.getCurrentArtist()

  if track and artist then
    return track .. " - " .. artist
  end
  return nil
end

-- Helper function to play next track
local function nextTrack()
  if not isSpotifyRunning() then
    return
  end

  hs.spotify.next()
  updateCurrentTrackDisplay()
end

-- Helper function to play previous track
local function previousTrack()
  if not isSpotifyRunning() then
    return
  end

  hs.spotify.previous()
  updateCurrentTrackDisplay()
end

-- Update current track display
function updateCurrentTrackDisplay()
  if currentTrackMenubar then
    local track = getCurrentTrack()
    if track and track ~= lastTrack then
      currentTrackMenubar:setTitle(track)
      lastTrack = track
    elseif not track then
      currentTrackMenubar:setTitle("No track")
      lastTrack = nil
    end

    -- Update menu with controls
    local menu = {
      { title = "⏮ Previous Track", fn = previousTrack },
      { title = "⏭ Next Track", fn = nextTrack }
    }
    currentTrackMenubar:setMenu(menu)
  end
end

-- Create menubar items
local function createMenubarItems()
  -- Current track display with submenu
  currentTrackMenubar = hs.menubar.new()
  if currentTrackMenubar then
    updateCurrentTrackDisplay()
    -- Update track info every 2 seconds
    updateTimer = hs.timer.doEvery(2, updateCurrentTrackDisplay)
  end
end

-- Remove menubar items
local function removeMenubarItems()
  if updateTimer then
    updateTimer:stop()
    updateTimer = nil
  end
  if currentTrackMenubar then
    currentTrackMenubar:delete()
    currentTrackMenubar = nil
  end
  lastTrack = nil
end

-- Application watcher callback
local function applicationWatcher(appName, eventType, appObject)
  if appName == SPOTIFY_APP_NAME then
    if eventType == hs.application.watcher.launched then
      -- Spotify launched, create menubar items
      createMenubarItems()
    elseif eventType == hs.application.watcher.terminated then
      -- Spotify quit, remove menubar items
      removeMenubarItems()
    end
  end
end

-- Initialize the module
function module.init()
  -- Create application watcher
  appWatcher = hs.application.watcher.new(applicationWatcher)
  appWatcher:start()

  -- If Spotify is already running, create menubar items
  if isSpotifyRunning() then
    createMenubarItems()
  end
end

-- Cleanup function
function module.stop()
  if appWatcher then
    appWatcher:stop()
    appWatcher = nil
  end
  removeMenubarItems()
end

-- Initialize on load
module.init()

return module
