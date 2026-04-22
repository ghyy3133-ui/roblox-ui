local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local userId = player.UserId
local fileName = "Note_" .. userId .. ".txt"

-- Xóa GUI cũ
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- BẢNG CHÍNH (250x350)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0, 5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- HỆ THỐNG KÉO THẢ (DRAG)
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {Position = position}):Play()
    end
end)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- AVATAR & NAME
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 50, 0, 50)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
AvatarImage.Parent = MainFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 170, 0, 20)
NameLabel.Position = UDim2.new(0, 70, 0, 15)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
NameLabel.Text = player.DisplayName
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = MainFrame

-- DÒNG STATS TỔNG HỢP (ĐÃ GỘP)
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLabel.Position = UDim2.new(0, 10, 0, 65)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatsLabel.Text = "FPS: -- | Ping: -- | PLR: --"
StatsLabel.Font = Enum.Font.GothamSemibold
StatsLabel.TextSize = 10.5
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

-- ID LABELS
local function createSmallLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 16)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 10
    label.Text = text
    label.Parent = MainFrame
    return label
end
createSmallLabel("Place ID: " .. game.PlaceId, 85)
local JobIdLabel = createSmallLabel("Job ID: " .. game.JobId, 101)
JobIdLabel.TextScaled = true

-- NOTE SECTION
createSmallLabel("📝 Ghi chú cày acc:", 125).TextColor3 = Color3.fromRGB(255, 255, 255)
local NoteBox = Instance.new("TextBox")
NoteBox.Size = UDim2.new(1, -20, 0, 50)
NoteBox.Position = UDim2.new(0, 10, 0, 145)
NoteBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
NoteBox.PlaceholderText = "Ghi chú tại đây..."
NoteBox.Font = Enum.Font.Gotham
NoteBox.TextSize = 11
NoteBox.TextWrapped = true
NoteBox.TextYAlignment = Enum.TextYAlignment.Top
NoteBox.Parent = MainFrame
Instance.new("UICorner", NoteBox)

local function saveNote() if writefile then writefile(fileName, NoteBox.Text) end end
if isfile and isfile(fileName) then NoteBox.Text = readfile(fileName) else NoteBox.Text = "" end
NoteBox.FocusLost:Connect(saveNote)

-- JOIN SECTION
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 25)
JobInput.Position = UDim2.new(0, 10, 0, 210)
JobInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Dán Job ID..."
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 11
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 25)
BtnFrame.Position = UDim2.new(0, 10, 0, 245)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, 0, 1, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Text = "Copy ID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 11
CopyBtn.Parent = BtnFrame
Instance.new("UICorner", CopyBtn)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.48, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.52, 0, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 11
JoinBtn.Parent = BtnFrame
Instance.new("UICorner", JoinBtn)

-- NO RENDER
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 35)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 295)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

-- LOGIC CHỨC NĂNG
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
    CopyBtn.Text = "Xong!"; task.wait(1); CopyBtn.Text = "Copy ID"
end)

JoinBtn.MouseButton1Click:Connect(function()
    if JobInput.Text ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, JobInput.Text, player) end
end)

local noRenderEnabled = true
local noRenderConn = nil
local function toggleRender(state)
    if state then
        for _, v in next, workspace:GetDescendants() do pcall(function() v.Transparency = 1 end) end
        noRenderConn = workspace.DescendantAdded:Connect(function(v) pcall(function() v.Transparency = 1 end) end)
    else
        if noRenderConn then noRenderConn:Disconnect() noRenderConn = nil end
        for _, v in next, workspace:GetDescendants() do
            pcall(function() if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end end)
        end
    end
end
toggleRender(true)

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    NoRenderBtn.Text = noRenderEnabled and "No Render: ON" or "No Render: OFF"
    NoRenderBtn.BackgroundColor3 = noRenderEnabled and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    toggleRender(noRenderEnabled)
end)

-- NÚT MENU (HIỆN/ẨN)
local ShowHideBtn = Instance.new("TextButton")
ShowHideBtn.Size = UDim2.new(0, 60, 0, 22)
ShowHideBtn.Position = UDim2.new(0, 10, 0, 5)
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShowHideBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ShowHideBtn.Text = "Menu"
ShowHideBtn.Font = Enum.Font.GothamBold
ShowHideBtn.TextSize = 10
ShowHideBtn.Parent = ScreenGui
Instance.new("UICorner", ShowHideBtn)
ShowHideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- LOOP UPDATE STATS (FIXED FPS)
local lastUpdate = os.clock()
local frameCount = 0
local currentFps = 0

RunService.RenderStepped:Connect(function(dt)
    frameCount = frameCount + 1
    if os.clock() - lastUpdate >= 1 then
        currentFps = frameCount
        frameCount = 0
        lastUpdate = os.clock()
    end
    
    local ping = "N/A"
    pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
    local playerCount = #Players:GetPlayers()
    local maxPlayers = Players.MaxPlayers
    
    StatsLabel.Text = string.format("FPS: %d | Ping: %s ms | PLR: %d/%d", currentFps, tostring(ping), playerCount, maxPlayers)
end)
