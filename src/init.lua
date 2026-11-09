if not game:IsLoaded() then game.Loaded:Wait() end
local env = getgenv()
local http = game:GetService("HttpService")
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")

local GITHUB_USER = "whyvariant"
local GITHUB_REPO = "fortnite-battlepass"
local BASE_URL = "https://raw.githubusercontent.com/" .. GITHUB_USER .. "/" .. GITHUB_REPO .. "/main/"

local function getGitPath(folder)
    if folder == "src" then return BASE_URL .. "src/" 
    elseif folder == "games" then return BASE_URL .. "src/games/" end
end

local CoreGui = game:GetService("CoreGui")
local hui = gethui and gethui() or CoreGui
local oldUI = hui:FindFirstChild("Celest")
if oldUI then oldUI:Destroy() end

local MainUI = Instance.new("ScreenGui")
MainUI.Name = "Celest"
MainUI.ResetOnSpawn = false
MainUI.Parent = hui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(620, 420)
MainFrame.Position = UDim2.new(0.5, -310, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BackgroundTransparency = 0.6
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.8
Stroke.Thickness = 1.5

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.BackgroundTransparency = 0.5
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 15)
TopBarFix.Position = UDim2.new(0, 0, 1, -15)
TopBarFix.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBarFix.BackgroundTransparency = 0.5
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.fromOffset(15, 0)
Title.BackgroundTransparency = 1
Title.Text = "Celest"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(24, 24)
MinimizeBtn.Position = UDim2.new(1, -70, 0, 8)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
MinimizeBtn.BackgroundTransparency = 0.5
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.fromOffset(24, 24)
KillBtn.Position = UDim2.new(1, -38, 0, 8)
KillBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
KillBtn.BackgroundTransparency = 0.2
KillBtn.Text = "X"
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Parent = TopBar
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 6)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(150, 380)
Sidebar.Position = UDim2.fromOffset(0, 40)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -40)
ContentArea.Position = UDim2.fromOffset(150, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local GameContainer = Instance.new("ScrollingFrame")
GameContainer.Size = UDim2.new(1, -20, 1, -20)
GameContainer.Position = UDim2.fromOffset(10, 10)
GameContainer.BackgroundTransparency = 1
GameContainer.ScrollBarThickness = 2
GameContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
GameContainer.CanvasSize = UDim2.new()
GameContainer.Visible = false
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

local SettingsContainer = Instance.new("ScrollingFrame")
SettingsContainer.Size = UDim2.new(1, -20, 1, -20)
SettingsContainer.Position = UDim2.fromOffset(10, 10)
SettingsContainer.BackgroundTransparency = 1
SettingsContainer.ScrollBarThickness = 2
SettingsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
SettingsContainer.CanvasSize = UDim2.new()
SettingsContainer.Visible = false
SettingsContainer.Parent = ContentArea
Instance.new("UIListLayout", SettingsContainer).Padding = UDim.new(0, 8)

local HomeContainer = Instance.new("Frame")
HomeContainer.Size = UDim2.new(1, -20, 1, -20)
HomeContainer.Position = UDim2.fromOffset(10, 10)
HomeContainer.BackgroundTransparency = 1
HomeContainer.Visible = false
HomeContainer.Parent = ContentArea

local HomeText = Instance.new("TextLabel")
HomeText.Size = UDim2.fromScale(1, 1)
HomeText.BackgroundTransparency = 1
HomeText.Text = "Welcome to Celest."
HomeText.TextColor3 = Color3.fromRGB(200, 200, 200)
HomeText.Font = Enum.Font.GothamMedium
HomeText.TextSize = 18
HomeText.Parent = HomeContainer

local function makeTab(name, yPos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -20, 0, 35)
    b.Position = UDim2.fromOffset(10, yPos)
    b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 1
    b.Text = "  " .. name
    b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = Sidebar
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local HomeTab = makeTab("Home", 10)
local GameTab = makeTab("Game", 50)
local ListTab = makeTab("Games List", 90)
local SettingsTab = makeTab("Settings", 130)

local function switchTab(activeTab)
    for _, container in ipairs({GameContainer, ListContainer, SettingsContainer, HomeContainer}) do
        container.Visible = false
    end
    
    for _, tab in ipairs({HomeTab, GameTab, ListTab, SettingsTab}) do
        tab.BackgroundTransparency = 1
        tab.TextColor3 = Color3.fromRGB(180, 180, 180)
    end
    
    activeTab.Tab.BackgroundTransparency = 0.85
    activeTab.Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    activeTab.Container.Visible = true
end

HomeTab.MouseButton1Click:Connect(function() switchTab({Tab = HomeTab, Container = HomeContainer}) end)
GameTab.MouseButton1Click:Connect(function() switchTab({Tab = GameTab, Container = GameContainer}) end)
ListTab.MouseButton1Click:Connect(function() switchTab({Tab = ListTab, Container = ListContainer}) end)
SettingsTab.MouseButton1Click:Connect(function() switchTab({Tab = SettingsTab, Container = SettingsContainer}) end)

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
    b.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    b.BackgroundTransparency = 0.9
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
    h.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    h.BackgroundTransparency = 0.9
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

KillBtn.MouseButton1Click:Connect(function()
    for k, v in pairs(getgenv()) do
        if type(v) == "boolean" then getgenv()[k] = false end
    end
    MainUI:Destroy()
end)

local minimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetSize = minimized and UDim2.fromOffset(620, 40) or UDim2.fromOffset(620, 420)
    tween:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
    Sidebar.Visible = not minimized
    ContentArea.Visible = not minimized
end)

local currentPlaceId = tostring(game.PlaceId)
local fetchUrl = getGitPath("games") .. currentPlaceId .. ".lua"

local ok = pcall(function()
    local code = game:HttpGet(fetchUrl)
    if code and code ~= "404: Not Found" and #code > 0 then
        loadstring(code)()(Elements)
        return
    end
    error()
end)

if not ok then
    Elements:Label("Game not supported")
    Elements:Label("PlaceId: " .. currentPlaceId)
    Elements:Button("Copy Game ID", function() setclipboard(currentPlaceId) end)
end

local listOk, gameList = pcall(function()
    return http:JSONDecode(game:HttpGet(BASE_URL .. "src/gameslist.json"))
end)

if listOk and gameList then
    for _, g in ipairs(gameList) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundTransparency = 0.9
        btn.Text = "  " .. g.game
        btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 13
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = ListContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseButton1Click:Connect(function()
            if queue_on_teleport then
                queue_on_teleport('loadstring(game:HttpGet("' .. BASE_URL .. 'src/init.lua"))()')
            end
            game:GetService("TeleportService"):Teleport(tonumber(g.id))
        end)
    end
else
    local err = Instance.new("TextLabel")
    err.Size = UDim2.new(1, 0, 0, 24)
    err.BackgroundTransparency = 1
    err.Text = "Failed to load gameslist.json"
    err.TextColor3 = Color3.fromRGB(255, 100, 100)
    err.Font = Enum.Font.Gotham
    err.Parent = ListContainer
end

MainFrame.Size = UDim2.fromOffset(0, 0)
tween:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {
    Size = UDim2.fromOffset(620, 420)
}):Play()

switchTab({Tab = HomeTab, Container = HomeContainer})
