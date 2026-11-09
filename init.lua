if not game:IsLoaded() then game.Loaded:Wait() end
local env = getgenv()
local http = game:GetService("HttpService")
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- =========================================================
-- SETUP & CONFIG
-- =========================================================
if not isfolder("BrainrotPolice") then makefolder("BrainrotPolice") end
if not isfolder("BrainrotPolice/Games") then makefolder("BrainrotPolice/Games") end
if not isfile("BrainrotPolice/Config.json") then
    writefile("BrainrotPolice/Config.json", http:JSONEncode({
        settings = { auto_rejoin_on_kick = false, disable_3d_rendering = false }
    }))
end

function env.getgitpath(where)
    local mainBuild = "https://raw.githubusercontent.com/IcantAffordSynapse/BrainrotPolice/refs/heads/main/"
    if where == "src" then return mainBuild .. "src/" 
    elseif where == "games" then return mainBuild .. "src/games/" end
end

function env.setconfig(key, value)
    local dec = http:JSONDecode(readfile("BrainrotPolice/Config.json"))
    dec[tostring(game.PlaceId)] = dec[tostring(game.PlaceId)] or {}
    dec[tostring(game.PlaceId)][key] = value
    writefile("BrainrotPolice/Config.json", http:JSONEncode(dec))
end

-- =========================================================
-- UI CREATION
-- =========================================================
local CoreGui = game:GetService("CoreGui")
local hui = gethui and gethui() or CoreGui
local oldUI = hui:FindFirstChild("BrainrotUI")
if oldUI then oldUI:Destroy() end

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "BrainrotUI"
MainUI.ResetOnSpawn = false
MainUI.Parent = hui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(600, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(140, 400)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -140, 1, 0)
ContentArea.Position = UDim2.fromOffset(140, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- Topbar / Kill Switch
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
TopBar.Parent = ContentArea

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.fromOffset(70, 24)
KillBtn.Position = UDim2.new(1, -80, 0, 3)
KillBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
KillBtn.Text = "Kill Script"
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 12
KillBtn.Parent = TopBar
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 4)

-- Tab Containers
local GameContainer = Instance.new("ScrollingFrame")
GameContainer.Size = UDim2.new(1, -20, 1, -40)
GameContainer.Position = UDim2.fromOffset(10, 35)
GameContainer.BackgroundTransparency = 1
GameContainer.ScrollBarThickness = 2
GameContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
GameContainer.CanvasSize = UDim2.new()
GameContainer.Parent = ContentArea
Instance.new("UIListLayout", GameContainer).Padding = UDim.new(0, 8)

local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Size = UDim2.new(1, -20, 1, -40)
ListContainer.Position = UDim2.fromOffset(10, 35)
ListContainer.BackgroundTransparency = 1
ListContainer.ScrollBarThickness = 2
ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListContainer.CanvasSize = UDim2.new()
ListContainer.Visible = false
ListContainer.Parent = ContentArea
Instance.new("UIListLayout", ListContainer).Padding = UDim.new(0, 8)

-- Sidebar Buttons
local function createTabBtn(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.fromOffset(10, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = Sidebar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local GameTab = createTabBtn("Game", 20)
local ListTab = createTabBtn("Games List", 60)

local function switchTab(tab)
    if tab == "Game" then
        GameTab.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        ListTab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        GameContainer.Visible = true
        ListContainer.Visible = false
    else
        GameTab.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        ListTab.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        GameContainer.Visible = false
        ListContainer.Visible = true
    end
end

GameTab.MouseButton1Click:Connect(function() switchTab("Game") end)
ListTab.MouseButton1Click:Connect(function() switchTab("List") end)

-- Draggable logic
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = MainFrame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inp end
end)
input.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local delta = inp.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- =========================================================
-- ELEMENTS API (For game scripts)
-- =========================================================
local Elements = {}

function Elements:Label(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = GameContainer
    return lbl
end

function Elements:Button(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 13
    btn.Parent = GameContainer
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

function Elements:Toggle(text, default, callback)
    local holder = Instance.new("TextButton")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    holder.Text = ""
    holder.Parent = GameContainer
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -60, 1, 0)
    lbl.Position = UDim2.fromOffset(10, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 220)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.fromOffset(36, 20)
    toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
    toggleBg.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
    toggleBg.Parent = holder
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(0, 99)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.new(1,1,1)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 99)

    local isToggled = default
    holder.MouseButton1Click:Connect(function()
        isToggled = not isToggled
        toggleBg.BackgroundColor3 = isToggled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
        tween:Create(knob, TweenInfo.new(0.15), { Position = isToggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play()
        callback(isToggled)
    end)
    task.defer(function() callback(isToggled) end)
    return holder
end

env.CelestElements = Elements

-- =========================================================
-- KILL SWITCH
-- =========================================================
KillBtn.MouseButton1Click:Connect(function()
    for k, v in pairs(getgenv()) do
        if type(v) == "boolean" then getgenv()[k] = false end
    end
    MainUI:Destroy()
    loadstring(game:HttpGet(env.getgitpath("src").."init.lua"))() 
end)

-- =========================================================
-- LOAD GAME SCRIPT
-- =========================================================
local currentPlaceId = tostring(game.PlaceId)
local fetchUrl = env.getgitpath("games") .. currentPlaceId .. ".lua"

local success = pcall(function()
    local code = game:HttpGet(fetchUrl)
    if code and code ~= "404: Not Found" and #code > 0 then
        loadstring(code)()(Elements)
        return
    end
    error()
end)

if not success then
    local localPath = "BrainrotPolice/Games/" .. currentPlaceId .. ".lua"
    if isfile(localPath) then
        loadstring(readfile(localPath))()(Elements)
    else
        Elements:Label("❌ Game not supported")
        Elements:Label("PlaceId: " .. currentPlaceId)
        Elements:Button("Copy Game ID", function() setclipboard(currentPlaceId) end)
    end
end

-- =========================================================
-- LOAD GAMES LIST & AUTO-EXECUTE ON TELEPORT
-- =========================================================
local gameListSuccess, gameList = pcall(function()
    return http:JSONDecode(game:HttpGet(env.getgitpath("src") .. "gameslist.json"))
end)

if gameListSuccess and gameList then
    for _, g in ipairs(gameList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        btn.Text = "  " .. g.game
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = ListContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            -- Queues the script to auto-execute when you load into the new game
            if queue_on_teleport then
                queue_on_teleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/IcantAffordSynapse/BrainrotPolice/refs/heads/main/src/init.lua"))()')
            end
            -- Teleports you to the game
            game:GetService("TeleportService"):Teleport(tonumber(g.id))
        end)
    end
else
    local errLbl = Instance.new("TextLabel")
    errLbl.Size = UDim2.new(1, 0, 0, 24)
    errLbl.BackgroundTransparency = 1
    errLbl.Text = "Failed to load gameslist.json"
    errLbl.TextColor3 = Color3.fromRGB(255, 100, 100)
    errLbl.Font = Enum.Font.Gotham
    errLbl.Parent = ListContainer
end

switchTab("Game") 