if not game:IsLoaded() then game.Loaded:Wait() end
local env = getgenv()
local http = game:GetService("HttpService")
local tween = game:GetService("TweenService")
local input = game:GetService("UserInputService")
local vu = game:GetService("VirtualUser")

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
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = MainUI
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(255, 255, 255)
Stroke.Transparency = 0.85
Stroke.Thickness = 1

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
TopBar.BackgroundTransparency = 0.1
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 15)
TopBarFix.Position = UDim2.new(0, 0, 1, -15)
TopBarFix.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
TopBarFix.BackgroundTransparency = 0.1
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
MinimizeBtn.Size = UDim2.fromOffset(30, 26)
MinimizeBtn.Position = UDim2.new(1, -85, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
MinimizeBtn.Text = "—"
MinimizeBtn.TextColor3 = Color3.new(1,1,1)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.fromOffset(30, 26)
KillBtn.Position = UDim2.new(1, -45, 0, 7)
KillBtn.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
KillBtn.Text = "X"
KillBtn.TextColor3 = Color3.new(1,1,1)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.TextSize = 14
KillBtn.Parent = TopBar
Instance.new("UICorner", KillBtn).CornerRadius = UDim.new(0, 6)

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromOffset(150, 380)
Sidebar.Position = UDim2.fromOffset(0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Sidebar.BackgroundTransparency = 0.3
Sidebar.Parent = MainFrame

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -150, 1, -40)
ContentArea.Position = UDim2.fromOffset(150, 40)
ContentArea.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
ContentArea.BackgroundTransparency = 0.3
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

local ScriptsContainer = Instance.new("ScrollingFrame")
ScriptsContainer.Size = UDim2.new(1, -20, 1, -20)
ScriptsContainer.Position = UDim2.fromOffset(10, 10)
ScriptsContainer.BackgroundTransparency = 1
ScriptsContainer.ScrollBarThickness = 2
ScriptsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScriptsContainer.CanvasSize = UDim2.new()
ScriptsContainer.Visible = false
ScriptsContainer.Parent = ContentArea
Instance.new("UIListLayout", ScriptsContainer).Padding = UDim.new(0, 8)

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
    b.TextColor3 = Color3.fromRGB(160, 160, 170)
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
local ScriptsTab = makeTab("Scripts", 130)
local SettingsTab = makeTab("Settings", 170)

local function switchTab(activeTab)
    for _, container in ipairs({GameContainer, ListContainer, SettingsContainer, HomeContainer, ScriptsContainer}) do
        container.Visible = false
    end
    
    for _, tab in ipairs({HomeTab, GameTab, ListTab, SettingsTab, ScriptsTab}) do
        tab.BackgroundTransparency = 1
        tab.TextColor3 = Color3.fromRGB(160, 160, 170)
    end
    
    activeTab.Tab.BackgroundTransparency = 0.85
    activeTab.Tab.TextColor3 = Color3.fromRGB(255, 255, 255)
    activeTab.Container.Visible = true
end

HomeTab.MouseButton1Click:Connect(function() switchTab({Tab = HomeTab, Container = HomeContainer}) end)
GameTab.MouseButton1Click:Connect(function() switchTab({Tab = GameTab, Container = GameContainer}) end)
ListTab.MouseButton1Click:Connect(function() switchTab({Tab = ListTab, Container = ListContainer}) end)
ScriptsTab.MouseButton1Click:Connect(function() switchTab({Tab = ScriptsTab, Container = ScriptsContainer}) end)
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
function Elements:Label(text, container)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 20)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container or GameContainer
end

function Elements:Button(text, cb, container)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.AutoButtonColor = false
    b.Parent = container or GameContainer
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    
    b.MouseEnter:Connect(function() tween:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play() end)
    b.MouseLeave:Connect(function() tween:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play() end)
    
    b.MouseButton1Click:Connect(cb)
end

function Elements:Toggle(text, default, cb, container)
    local h = Instance.new("TextButton")
    h.Size = UDim2.new(1, 0, 0, 36)
    h.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    h.Text = ""
    h.AutoButtonColor = false
    h.Parent = container or GameContainer
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

function Elements:Slider(text, min, max, default, cb, container)
    local h = Instance.new("TextButton")
    h.Size = UDim2.new(1, 0, 0, 50)
    h.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    h.Text = ""
    h.AutoButtonColor = false
    h.Parent = container or GameContainer
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 6)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 20)
    l.Position = UDim2.fromOffset(10, 5)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 220)
    l.Font = Enum.Font.GothamMedium
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local valLabel = Instance.new("TextLabel")
    valLabel.Size = UDim2.new(0, 50, 0, 20)
    valLabel.Position = UDim2.new(1, -60, 0, 5)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(default)
    valLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    valLabel.Font = Enum.Font.GothamBold
    valLabel.TextSize = 13
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.Parent = h

    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -20, 0, 6)
    track.Position = UDim2.new(0, 10, 1, -15)
    track.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    track.Parent = h
    Instance.new("UICorner", track).CornerRadius = UDim.new(0, 99)

    local fill = Instance.new("Frame")
    local percent = (default - min) / (max - min)
    fill.Size = UDim2.fromScale(percent, 1)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 99)

    local draggingSlider = false
    h.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    input.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    input.InputChanged:Connect(function(inp)
        if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local mouseX = inp.Position.X
            local trackX = track.AbsolutePosition.X
            local trackWidth = track.AbsoluteSize.X
            local p = math.clamp((mouseX - trackX) / trackWidth, 0, 1)
            
            local val = min + (max - min) * p
            if max <= 1 then
                val = math.floor(val * 100 + 0.5) / 100
            else
                val = math.floor(val + 0.5)
            end
            
            fill.Size = UDim2.fromScale(p, 1)
            valLabel.Text = tostring(val)
            cb(val)
        end
    end)
    task.defer(function() cb(default) end)
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

env.AutoRejoin = false
env.AutoExecute = true
env.AntiAfk = false

Elements:Label("Universal Settings", SettingsContainer)
Elements:Toggle("Auto Rejoin After Kick", false, function(state)
    env.AutoRejoin = state
    if state then
        task.spawn(function()
            while env.AutoRejoin do
                game:GetService("GuiService").ErrorMessageChanged:Wait()
                if env.AutoRejoin then game:GetService("TeleportService"):Teleport(game.PlaceId) end
            end
        end)
    end
end, SettingsContainer)

Elements:Toggle("Auto Execute When Joining", true, function(state) env.AutoExecute = state end, SettingsContainer)

Elements:Toggle("Anti-AFK", false, function(state)
    env.AntiAfk = state
    if state then
        task.spawn(function()
            while env.AntiAfk do
                task.wait(60)
                if env.AntiAfk then vu:CaptureController(); vu:ClickButton2(Vector2.new()) end
            end
        end)
    end
end, SettingsContainer)

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
    Elements:Label("Game not supported", GameContainer)
    Elements:Label("PlaceId: " .. currentPlaceId, GameContainer)
    Elements:Button("Copy Game ID", function() setclipboard(currentPlaceId) end, GameContainer)
end

local listOk, gameList = pcall(function() return http:JSONDecode(game:HttpGet(BASE_URL .. "src/gameslist.json")) end)
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
        btn.AutoButtonColor = false
        btn.Parent = ListContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        
        btn.MouseEnter:Connect(function() tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(45, 45, 55)}):Play() end)
        btn.MouseLeave:Connect(function() tween:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(30, 30, 35)}):Play() end)
        
        btn.MouseButton1Click:Connect(function()
            if env.AutoExecute and queue_on_teleport then
                queue_on_teleport('loadstring(game:HttpGet("' .. BASE_URL .. 'src/init.lua"))()')
            end
            game:GetService("TeleportService"):Teleport(tonumber(g.id))
        end)
    end
end

local scriptsOk, scriptList = pcall(function() return http:JSONDecode(game:HttpGet(BASE_URL .. "src/scripts.json")) end)
if scriptsOk and scriptList then
    for name, url in pairs(scriptList) do
        Elements:Button(name, function()
            if url:sub(1, 8) == "loadstr" then
                loadstring(url)()
            else
                loadstring(game:HttpGet(url))()
            end
        end, ScriptsContainer)
    end
else
    Elements:Label("Failed to load scripts.json", ScriptsContainer)
end

MainFrame.Size = UDim2.fromOffset(0, 0)
tween:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(620, 420)}):Play()

switchTab({Tab = HomeTab, Container = HomeContainer})
