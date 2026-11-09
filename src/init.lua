if not game:IsLoaded() then game.Loaded:Wait() end
local env = getgenv()
local http = game:GetService("HttpService")
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")

-- =========================================================
-- YOUR NEW GITHUB URL
-- =========================================================
local GITHUB_USER = "whyvariant"
local GITHUB_REPO = "fortnite-battlepass"
local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/main/"

function env.getgitpath(where)
    if where == "src" then return BASE_URL .. "src/" 
    elseif where == "games" then return BASE_URL .. "src/games/" end
end

-- =========================================================
-- CLEAN UP OLD UI
-- =========================================================
local CoreGui = game:GetService("CoreGui")
local hui = gethui and gethui() or CoreGui
local oldUI = hui:FindFirstChild("NewBrainrotUI")
if oldUI then oldUI:Destroy() end

-- =========================================================
-- BUILD CLEAN UI
-- =========================================================
local MainUI = Instance.new("ScreenGui")
MainUI.Name = "NewBrainrotUI"
MainUI.ResetOnSpawn = false
MainUI.Parent = hui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(600, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(50, 50, 60)
MainStroke.Thickness = 1

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

-- Hide bottom corners of top bar
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 10)
TopBarFix.Position = UDim2.new(0, 0, 1, -10)
TopBarFix.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "whyvariant UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(25, 25)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 5)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 4)

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.fromOffset(25, 25)
KillBtn.Position = UDim2.new(1, -35, 0, 5)
KillBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
KillBtn.Text = "X"
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Parent = TopBar
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 4)

-- Sidebar Background
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(140, 365)
Sidebar.Position = UDim2.fromOffset(0, 35)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
Sidebar.Parent = MainFrame

-- Smooth Tab Indicator
local Indicator = Instance.new("Frame")
Indicator.Size = UDim2.fromOffset(3, 30)
Indicator.Position = UDim2.fromOffset(0, 15)
Indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Indicator.BorderSizePixel = 0
Indicator.Parent = Sidebar
Instance.new("UICorner", Indicator).CornerRadius = UDim.new(0, 4)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -140, 1, -35)
ContentArea.Position = UDim2.fromOffset(140, 35)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ContentArea.Parent = MainFrame

-- Scroll Containers
local GameContainer = Instance.new("ScrollingFrame")
GameContainer.Size = UDim2.new(1, -20, 1, -20)
GameContainer.Position = UDim2.fromOffset(10, 10)
GameContainer.BackgroundTransparency = 1
GameContainer.ScrollBarThickness = 2
GameContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
GameContainer.CanvasSize = UDim2.new()
GameContainer.Parent = ContentArea
Instance.new("UIListLayout", GameContainer).Padding = UDim.new(0, 8)

local ListContainer = Instance.new("ScrollingFrame")
ListContainer.Size = UDim2.new(1, -20, 1, -20)
ListContainer.Position = UDim2.fromOffset(10, 10)
ListContainer.BackgroundTransparency = 1
ListContainer.ScrollBarThickness = 2
ListContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ListContainer.CanvasSize = UDim2.new()
ListContainer.Visible = false
ListContainer.Parent = ContentArea
Instance.new("UIListLayout", ListContainer).Padding = UDim.new(0, 8)

-- Sidebar Buttons
local function makeTab(name, yPos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 30)
    b.Position = UDim2.fromOffset(10, yPos)
    b.BackgroundTransparency = 1
    b.Text = "  " .. name
    b.TextColor3 = Color3.fromRGB(160, 160, 170)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Sidebar
    return b
end

local GameTab = makeTab("Game", 15)
local ListTab = makeTab("Games List", 50)

-- Tab Logic
local function switchTab(t)
    GameContainer.Visible = (t == "Game")
    ListContainer.Visible = (t == "List")
    
    if t == "Game" then
        GameTab.TextColor3 = Color3.new(1,1,1)
        ListTab.TextColor3 = Color3.fromRGB(160, 160, 170)
        tween:Create(Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 15)}):Play()
    else
        GameTab.TextColor3 = Color3.fromRGB(160, 160, 170)
        ListTab.TextColor3 = Color3.new(1,1,1)
        tween:Create(Indicator, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 50)}):Play()
    end
end

GameTab.MouseButton1Click:Connect(function() switchTab("Game") end)
ListTab.MouseButton1Click:Connect(function() switchTab("List") end)

-- Dragging
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = MainFrame.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement then dragInput = inp end
end)
input.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local delta = inp.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Elements API
local Elements = {}
function Elements:Label(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = GameContainer
end

function Elements:Button(text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.Parent = GameContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(cb)
end

function Elements:Toggle(text, default, cb)
    local h = Instance.new("TextButton")
    h.Size = UDim2.new(1, 0, 0, 36)
    h.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    h.Text = ""
    h.Parent = GameContainer
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -60, 1, 0)
    l.Position = UDim2.fromOffset(10, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromOffset(36, 20)
    bg.Position = UDim2.new(1, -46, 0.5, -10)
    bg.BackgroundColor3 = default and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
    bg.Parent = h
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 99)

    local k = Instance.new("Frame")
    k.Size = UDim2.fromOffset(16, 16)
    k.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    k.BackgroundColor3 = Color3.new(1,1,1)
    k.Parent = bg
    Instance.new("UICorner", k).CornerRadius = UDim.new(0, 99)

    local state = default
    h.MouseButton1Click:Connect(function()
        state = not state
        bg.BackgroundColor3 = state and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 65)
        tween:Create(k, TweenInfo.new(0.15), { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play()
        cb(state)
    end)
    task.defer(function() cb(state) end)
end

env.CelestElements = Elements

-- Kill Switch
KillBtn.MouseButton1Click:Connect(function()
    for k, v in pairs(getgenv()) do
        if type(v) == "boolean" then getgenv()[k] = false end
    end
    MainUI:Destroy()
end)

-- Minimize Switch
local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame.Size = minimized and UDim2.fromOffset(600, 35) or UDim2.fromOffset(600, 400)
    Sidebar.Visible = not minimized
    ContentArea.Visible = not minimized
end)

-- =========================================================
-- LOAD GAME SCRIPT
-- =========================================================
local currentPlaceId = tostring(game.PlaceId)
local fetchUrl = env.getgitpath("games") .. currentPlaceId .. ".lua"

local ok = pcall(function()
    local code = game:HttpGet(fetchUrl)
    if code and code ~= "404: Not Found" and #code > 0 then
        loadstring(code)()(Elements)
        return
    end
    error()
end)

if not ok then
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
-- LOAD YOUR GAME LIST & AUTO EXECUTE ON TELEPORT
-- =========================================================
-- THIS WAS THE FIX: It now pulls from YOUR json file.
local listOk, gameList = pcall(function()
    return http:JSONDecode(game:HttpGet(BASE_URL .. "src/gameslist.json"))
end)

if listOk and gameList then
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
            if queue_on_teleport then
                -- Queues using YOUR github link so it auto-executes the UI on join
                queue_on_teleport('loadstring(game:HttpGet("' .. BASE_URL .. 'src/init.lua"))()')
            end
            game:GetService("TeleportService"):Teleport(tonumber(g.id))
        end)
    end
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 24)
    err.BackgroundTransparency = 1
    err.Text = "❌ Failed to load gameslist.json"
    err.TextColor3 = Color3.fromRGB(255, 100, 100)
    err.Font = Enum.Font.Gotham
    err.Parent = ListContainer
end

switchTab("Game")
