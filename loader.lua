--[[
 █████ █████ ██████████ ███████████     █████████      █████   █████ █████  █████ ███████████ 
░░███ ░░███ ░░███░░░░░█░░███░░░░░███   ███░░░░░███    ░░███   ░░███ ░░███  ░░███ ░░███░░░░░███
 ░░███ ███   ░███  █ ░  ░███    ░███  ░███    ░███     ░███    ░███  ░███   ░███  ░███    ░███
  ░░█████    ░██████    ░██████████   ░███████████     ░███████████  ░███   ░███  ░██████████ 
   ███░███   ░███░░█    ░███░░░░░███  ░███░░░░░███     ░███░░░░░███  ░███   ░███  ░███░░░░░███
  ███ ░░███  ░███ ░   █ ░███    ░███  ░███    ░███     ░███    ░███  ░███   ░███  ░███    ░███
 █████ █████ ██████████ █████   █████ █████   █████    █████   █████ ░░████████   ███████████ 
░░░░░ ░░░░░ ░░░░░░░░░░ ░░░░░   ░░░░░ ░░░░░   ░░░░░    ░░░░░   ░░░░░   ░░░░░░░░   ░░░░░░░░░░░                                                                                            
]]

--// Obsidian UI
local Obsidian_repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

local Obsidian = loadstring(game:HttpGet(Obsidian_repo .. "Library.lua"))()
local Obsidian_SaveManager = loadstring(game:HttpGet(Obsidian_repo .. "addons/SaveManager.lua"))()

--// Constants
local PLACE_ID = game.PlaceId
local SUPPORTED_GAMES = {
    [12208518151] = "https://raw.githubusercontent.com/NobodyOrIdk/XeraHub/refs/heads/main/v1.lua"
}

--// Helpers
local function sendWebhook()
    local plr = Players.LocalPlayer
    local executor = identifyexecutor() or "Unknown"

    local data = {
        ["username"] = "XeraHub Logs",
        ["avatar_url"] = "",
        ["embeds"] = {{
            ["title"] = "New XeraHub Execution",
            ["description"] = "**User:** " .. plr.Name ..
                              "\n**UserId:** " .. plr.UserId ..
                              "\n**Executor:** " .. executor ..
                              "\n**Time:** <t:" .. os.time() .. ":F>",
            ["color"] = 14177041
        }}
    }

    local json = HttpService:JSONEncode(data)

    request = request or http_request or (http and http.request) or syn.request

    if request then
        request({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end
end

--// Loading
local Loading = Obsidian:CreateLoading({
    Title = "Xera Hub Loader",
    Icon = "eye",
    TotalSteps = 2
})

Loading:SetCurrentStep(1)
Loading:SetMessage("Verifying game...")
Loading:SetDescription("Checking game place ID...")

task.wait(1)

if not SUPPORTED_GAMES[PLACE_ID] then
    Loading:ShowErrorPage(true)
    Loading:SetErrorMessage("This game is not supported")

    Loading:SetErrorButtons({
    Close = {
        Title = "Close",
        Variant = "Primary",
        Callback = function()
            Loading:Continue()
        end
    }
    })
    
    return
end

Loading:SetCurrentStep(2)
Loading:SetMessage("Loading script...")
Loading:SetDescription("Loading script...")
Loading:ShowSidebarPage(true)
Loading.Sidebar:AddLabel("User: " .. game.Players.LocalPlayer.DisplayName)
Loading.Sidebar:AddLabel("Version: v1.0.0")
task.wait(1)

--// Variables
local Script = SUPPORTED_GAMES[PLACE_ID]

local success,result = pcall(function()
    return loadstring(game:HttpGet(Script))
end)

if not success or not result then
    Loading:ShowErrorPage(true)
    Loading:SetErrorMessage("Failed to load script.If this keeps happening, report it on our Discord.,error: "..result)
    Loading:SetErrorButtons({
    Close = {
        Title = "Close",
        Variant = "Primary",
        Callback = function()
            Loading:Continue()
        end
    }
    })

    return
end

--// Initialization
Loading:Continue()
result()
sendWebhook()
