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

local Options = Obsidian.Options

--// Constants

local NOTIFY_SOUND = 83547933303850
local MAX_FPS_SAMPLES = 100
local DISCORD_INVITE = "2bZ6kKJ6wy"
local VERSION = "1.0.0"

--// Helpers
local function Notify(Description,Icon)
    Obsidian:Notify({
        Title = "Xera Hub",
        Description = Description or "",
        Icon = Icon,
        Time = 2,
        SoundId = NOTIFY_SOUND
    })
end

local function OpenDC(Invite)
    if request then
        pcall(function()
            request({
                Url = 'http://127.0.0.1:6463/rpc?v=1',
                Method = 'POST',
                Headers = {
                    ['Content-Type'] = 'application/json',
                    Origin = 'https://discord.com'
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = 'INVITE_BROWSER',
                    nonce = game:GetService("HttpService"):GenerateGUID(false),
                    args = {code = Invite}
                })
            })
        end)
    else
        setclipboard("https://discord.gg" .. Invite)
        Notify("Discord link copied into clipboard!","info")
    end
end

--// Services
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

--// Variables
local fpsTable = {}

local Window = Obsidian:CreateWindow({
    Title = "Xera Hub [Lobby]",
    Footer = "version: "..VERSION,
    Icon = "house",
    NotifySide = "Right",
})

--// UI
local Watermark = Obsidian:AddDraggableLabel("Xera Hub | Loading...")

local Tabs = {
    Main = Window:AddTab("Info", "user","Basic info about Xera Hub"),
    ESP = Window:AddTab("ESP","eye","ESP for things like Players/Entities/Furniture")
    Settings = Window:AddTab("Settings", "settings"),
}

--// Info Tab
local InfoLeftGroup = Tabs.Main:AddLeftGroupbox("General Information")
local InfoRightGroup = Tabs.Main:AddRightGroupbox("Build Details")

InfoLeftGroup:AddLabel({
    Text = "Xera Hub "..VERSION,
    DoesWrap = true,
})

InfoLeftGroup:AddLabel({
    Text = "An Hub for Rooms & Doors designed to make gameplay a lot more easier.",
     DoesWrap = true,
})

InfoLeftGroup:AddLabel({
    Text = "This project is fully open-source under the MIT License.",
     DoesWrap = true,
})

InfoLeftGroup:AddDivider()

InfoLeftGroup:AddButton({
    Text = "Join Discord Server",
    Func = function()
        OpenDC(DISCORD_INVITE)
    end,
    DoubleClick = false,
    Tooltip = "Click to join our community",
    Icon = "message-circle",
})

--// UI setup
Obsidian.ShowCustomCursor = false

--// Events
RunService.RenderStepped:Connect(function(dt)
    local currentFps = 1 / dt

    table.insert(fpsTable, currentFps)
    if #fpsTable > MAX_FPS_SAMPLES then
        table.remove(fpsTable, 1)
    end

    local sum = 0
    for i = 1, #fpsTable do
        sum = sum + fpsTable[i]
    end
    local averageFps = math.floor(sum / #fpsTable)

    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

    Watermark:SetText(string.format("Xera Hub | %d FPS | %d MS", averageFps, ping))
end)
