local M = {}

local CHROME_BUNDLE = "com.google.Chrome"
local INTERVAL = 30

-- Reads the Inbox nav link ("Inbox 2 unread"), which is present in every view.
-- Needs Chrome > View > Developer > Allow JavaScript from Apple Events.
local script = [[
tell application "Google Chrome"
  set out to ""
  repeat with w in windows
    repeat with t in tabs of w
      if URL of t contains "mail.google.com" then
        try
          set js to execute t javascript "(function(){var a=document.querySelector('a[aria-label^=\"Inbox\"]');if(!a)return '';var m=a.getAttribute('aria-label').match(/\\d+/);return m?m[0]:'0'})()"
        on error
          set js to ""
        end try
        set out to out & js & (ASCII character 9) & (title of t) & linefeed
      end if
    end repeat
  end repeat
  return out
end tell
]]

M.menu = hs.menubar.new()

local function render(count)
  if count == nil then
    M.menu:setTitle("G(-)")
  else
    M.menu:setTitle("G(" .. count .. ")")
  end
end

-- Each line is "<js count>\t<title>". Fall back to the title, where Gmail only
-- shows the unread count on the Inbox view; other views (All Mail, Sent, ...)
-- have no count, so they say nothing about unread.
local function parseUnread(output)
  local best
  for js, title in output:gmatch("([^\t\n]*)\t([^\n]*)") do
    local n = js:match("^%d+$") or title:match("%((%d+)%)")
    if n then
      n = tonumber(n)
      if not best or n > best then best = n end
    elseif not best and title:match("^Inbox") then
      best = 0
    end
  end
  return best
end

function M.refresh()
  if not hs.application.get(CHROME_BUNDLE) then
    render(nil)
    return
  end
  if M.task and M.task:isRunning() then return end
  M.task = hs.task.new("/usr/bin/osascript", function(code, stdout)
    if code ~= 0 then
      render(nil)
      return
    end
    render(parseUnread(stdout))
  end, { "-e", script })
  M.task:start()
end

local focusScript = [[
tell application "Google Chrome"
  repeat with w in windows
    set i to 0
    repeat with t in tabs of w
      set i to i + 1
      if URL of t contains "mail.google.com" then
        set active tab index of w to i
        set index of w to 1
        activate
        return "ok"
      end if
    end repeat
  end repeat
  return "none"
end tell
]]

function M.openGmail()
  hs.task.new("/usr/bin/osascript", function(code, stdout)
    if code ~= 0 or not stdout:match("ok") then
      hs.urlevent.openURLWithBundle("https://mail.google.com", CHROME_BUNDLE)
    end
  end, { "-e", focusScript }):start()
end

M.menu:setMenu({
  { title = "Refresh",    fn = M.refresh },
  { title = "Open Gmail", fn = M.openGmail },
})

render(nil)
M.refresh()
M.timer = hs.timer.doEvery(INTERVAL, M.refresh)

return M
