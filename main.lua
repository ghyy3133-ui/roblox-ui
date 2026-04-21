local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local userId = player.UserId
local fileName = "Note_" .. userId .. ".txt"

-- Xóa GUI cũ để tránh chồng chéo
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- BẢNG CHÍNH (Gọn: 250x370, vị trí trên cùng chính giữa)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 370)
MainFrame.Position = UDim2.new(0.5, -125, 0, 5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true -- Bắt buộc để nhận input
MainFrame.Parent = ScreenGui

-- HỆ THỐNG KÉO THẢ (DRAG) MỚI - ĐÃ FIX LỖI
local dragToggle = nil
local dragSpeed = 0.15
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    game:GetService("TweenService"):Create(MainFrame, TweenInfo.new(dragSpeed), {Position = position}):Play()
end

MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateInput(input)
    end
end)

-- Giao diện (Viền hồng, bo góc)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- AVATAR
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

-- THÔNG TIN SERVER
local function createLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 16)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(220, 220, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 11
    label.Text = text
    label.Parent = MainFrame
    return label
end

local FPSLabel = createLabel("FPS: ...", 70)
local PingLabel = createLabel("Ping: ...", 88)
local PlaceLabel = createLabel("Place ID: " .. game.PlaceId, 106)
local JobIdLabel = createLabel("Job ID: " .. game.JobId, 124)
JobIdLabel.TextScaled = true

-- Ô NOTE (Persistence - Ghi chú cày acc)
createLabel("📝 Ghi chú cày acc:", 150)
local NoteBox = Instance.new("TextBox")
NoteBox.Size = UDim2.new(1, -20, 0, 45)
NoteBox.Position = UDim2.new(0, 10, 0, 170)
NoteBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
NoteBox.PlaceholderText = "Đang tải dữ liệu..."
NoteBox.Font = Enum.Font.Gotham
NoteBox.TextSize = 11
NoteBox.TextWrapped = true
NoteBox.TextYAlignment = Enum.TextYAlignment.Top
NoteBox.Parent = MainFrame
Instance.new("UICorner", NoteBox)

local function saveNote() if writefile then writefile(fileName, NoteBox.Text) end end
local function loadNote()
    if isfile and isfile(fileName) then NoteBox.Text = readfile(fileName)
    else NoteBox.Text = "" end
end
loadNote()
NoteBox.FocusLost:Connect(saveNote)

-- JOIN SERVER SECTION
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 25)
JobInput.Position = UDim2.new(0, 10, 0, 230)
JobInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Nhập Job ID..."
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 11
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 25)
BtnFrame.Position = UDim2.new(0, 10, 0, 265)
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
JoinBtn.Text = "Join"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 11
JoinBtn.Parent = BtnFrame
Instance.new("UICorner", JoinBtn)

-- NO RENDER TOGGLE (Mặc định ON)
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 35)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 310)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.TextSize = 12
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

-- LOGIC CHỨC NĂNG
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
    CopyBtn.Text = "Xong!"
    task.wait(1)
    CopyBtn.Text = "Copy ID"
end)

JoinBtn.MouseButton1Click:Connect(function()
    if JobInput.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, JobInput.Text, player)
    end
end)

local noRenderEnabled = true
local noRenderConn = nil

local function toggleRender(state)
    if state then
        for _, v in next, workspace:GetDescendants() do pcall(function() v.Transparency = 1 end) end
        if getnilinstances then
            for _, v in next, getnilinstances() do
                pcall(function() 
                    v.Transparency = 1 
                    for _, d in next, v:GetDescendants() do d.Transparency = 1 end
                end)
            end
        end
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
    if noRenderEnabled then
        NoRenderBtn.Text = "No Render: ON"; NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        toggleRender(true)
    else
        NoRenderBtn.Text = "No Render: OFF"; NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        toggleRender(false)
    end
end)

-- Nút Show/Hide Menu (Góc trên trái)
local ShowHideBtn = Instance.new("TextButton")
ShowHideBtn.Size = UDim2.new(0, 60, 0, 25)
ShowHideBtn.Position = UDim2.new(0, 10, 0, 5)
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShowHideBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ShowHideBtn.Text = "Menu"
ShowHideBtn.Font = Enum.Font.GothamBold
ShowHideBtn.TextSize = 10
ShowHideBtn.Parent = ScreenGui
Instance.new("UICorner", ShowHideBtn)
ShowHideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- LOOP UPDATE FPS & PING
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start = TimeFunction(), TimeFunction()
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function()
    LastIteration = TimeFunction()
    for i = #FrameUpdateTable, 1, -1 do FrameUpdateTable[i+1] = FrameUpdateTable[i] >= LastIteration-1 and FrameUpdateTable[i] or nil end
    FrameUpdateTable[1] = LastIteration
    local fps = math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))
    FPSLabel.Text = "FPS: " .. tostring(fps)
    local ping = "N/A"
    pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
    PingLabel.Text = "Ping: " .. tostring(ping) .. " ms"
end)
