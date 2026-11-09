local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Celest",
   LoadingTitle = "Celest",
   LoadingSubtitle = "by whyvariant",
   ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "CelestConfig" },
   KeySystem = false
})

local HTTP = game:GetService("HttpService")
local BASE_URL = "https://raw.githubusercontent.com/whyvariant/fortnite-battlepass/main/"

local GameTab = Window:CreateTab("Game", 4483362458)
local ListTab = Window:CreateTab("Games List", 4483362458)
local ScriptsTab = Window:CreateTab("Scripts", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

local isAutoExecute = true

local placeId = tostring(game.PlaceId)
local fetchUrl = BASE_URL .. "src/games/" .. placeId .. ".lua"

local ok, code = pcall(function()
    return game:HttpGet(fetchUrl)
end)

if ok and code and code ~= "404: Not Found" and #code > 0 then
    local func = loadstring(code)
    if func then
        func()(GameTab)
    end
else
    GameTab:CreateLabel("Game not supported")
    GameTab:CreateLabel("PlaceId: " .. placeId)
    GameTab:CreateButton({
        Name = "Copy Game ID",
        Callback = function() setclipboard(placeId) end,
    })
end

local listOk, gameList = pcall(function()
    return HTTP:JSONDecode(game:HttpGet(BASE_URL .. "src/gameslist.json"))
end)

if listOk and gameList then
    for _, g in ipairs(gameList) do
        ListTab:CreateButton({
            Name = g.game,
            Callback = function()
                if isAutoExecute and queue_on_teleport then
                    queue_on_teleport('loadstring(game:HttpGet("' .. BASE_URL .. 'src/init.lua"))()')
                end
                game:GetService("TeleportService"):Teleport(tonumber(g.id))
            end,
        })
    end
else
    ListTab:CreateLabel("Failed to load gameslist.json")
end

local scriptsOk, scriptList = pcall(function()
    return HTTP:JSONDecode(game:HttpGet(BASE_URL .. "src/scripts.json"))
end)

if scriptsOk and scriptList then
    for name, url in pairs(scriptList) do
        ScriptsTab:CreateButton({
            Name = name,
            Callback = function()
                if url:sub(1, 8) == "loadstr" then
                    loadstring(url)()
                else
                    loadstring(game:HttpGet(url))()
                end
            end,
        })
    end
else
    ScriptsTab:CreateLabel("Failed to load scripts.json")
end

SettingsTab:CreateSection("Universal")

SettingsTab:CreateToggle({
   Name = "Auto Rejoin After Kick",
   CurrentValue = false,
   Flag = "AutoRejoin",
   Callback = function(Value)
       _G.AutoRejoin = Value
       if Value then
           task.spawn(function()
               while _G.AutoRejoin do
                   game:GetService("GuiService").ErrorMessageChanged:Wait()
                   if _G.AutoRejoin then game:GetService("TeleportService"):Teleport(game.PlaceId) end
               end
           end)
       end
   end,
})

SettingsTab:CreateToggle({
   Name = "Auto Execute When Joining",
   CurrentValue = true,
   Flag = "AutoExecute",
   Callback = function(Value)
       isAutoExecute = Value
   end,
})

SettingsTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "AntiAfk",
   Callback = function(Value)
       _G.AntiAfk = Value
       if Value then
           task.spawn(function()
               while _G.AntiAfk do
                   task.wait(60)
                   if _G.AntiAfk then
                       game:GetService("VirtualUser"):CaptureController()
                       game:GetService("VirtualUser"):ClickButton2(Vector2.new())
                   end
               end
           end)
       end
   end,
})
