local currentBrowser = "Safari"
local browsers = {
  Safari = "com.apple.Safari",
  Chrome = "com.google.Chrome"
}

spoon.SpoonInstall:andUse("URLDispatcher",
  {
    config = {
      default_handler = browsers.Safari,
      url_patterns = {
        { "https?://www%.google%.com",                             "com.apple.Safari" },
        { "https?://%w+%.google%.com",                             "com.google.Chrome" },
        { "https?://%w*%.?merc%.li",                               "com.google.Chrome" },
        { "https?://.*%.mercari%.in",                              "com.google.Chrome" },
        { "https?://unipos.me/*",                                  "com.google.Chrome" },
        { "https?://github.com/kouzoh/*",                          "com.google.Chrome" },
        { "https?://.*myworkday.*",                                "com.google.Chrome" },
        { "https?://.*retrium.*",                                  "com.google.Chrome" },
        { "https?://mercari%.service%-now%.com",                   "com.google.Chrome" },
        { "https?://mercari%.atlassian%.net",                      "com.google.Chrome" },
        { "https?://.*figma%.com",                                 "com.google.Chrome" },
        { "https?://.*okta%.com",                                  "com.google.Chrome" },
        { "https?://mercari%.looker%.com",                         "com.google.Chrome" },
        { "https?://mercari%.testrail%.",                          "com.google.Chrome" },
        { "https?://forms%.gle/*",                                 "com.google.Chrome" },
        { "https?://storage.cloud.google.com/kouzoh%-.*%.apk",     "com.google.Chrome" },
        { "https?://mercari%.workable%.com",                       "com.google.Chrome" },
        { "https?://mercari%.slack%.com",                          "com.google.Chrome" },
        { "https?://mercari%.enterprise%.slack%.com",              "com.google.Chrome" },
        { "https?://mercari%.blameless%.io",                       "com.google.Chrome" },
        { "https?://workcloud%.jp",                                "com.google.Chrome" },
        { "https?://mercari%.docebosaas%.com",                     "com.google.Chrome" },
        { "https?://.*zapier%.com",                                "com.google.Chrome" },
        { "https?://merpay%-corp%-question%-jp%.firebaseapp%.com", "com.google.Chrome" },
        { "https?://app%.datadoghq%.com",                          "com.google.Chrome" },
        { "https?://app%.firehydrant%.io",                         "com.google.Chrome" },
        { "https?://mercari%.pagerduty%.com",                      "com.google.Chrome" },
        { "https?://.*citadelapps%.com",                           "com.google.Chrome" },
        { "https?://.*pigeonhole%.at",                             "com.google.Chrome" },
        { "https?://.*notion%.so",                                 "com.google.Chrome" },
        { "https?://.*notion%.so",                                 "com.google.Chrome" },
        { "https?://.*getdx%.com",                                 "com.google.Chrome" },
        { "https?://.*kolide%.com",                                "com.google.Chrome" },
        { "https?://.*openai%.com",                                "com.google.Chrome" },
        { "https?://login%.tailscale%.com",                        "com.google.Chrome" },
      },
    },
    start = true
  }
)

local function toggleBrowser()
  if currentBrowser == "Safari" then
    currentBrowser = "Chrome"
  else
    currentBrowser = "Safari"
  end

  spoon.URLDispatcher.default_handler = browsers[currentBrowser]

  hs.alert.show("Default browser: " .. currentBrowser)
end

hs.hotkey.bind({"cmd", "shift"}, "b", toggleBrowser)
