local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local userId = player.UserId

-- Tên file lưu trữ theo UserId để không bị trùng giữa các tài khoản
local fileName = "Note_" .. userId .. ".txt"

-- Xóa GUI cũ
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- BẢNG CHÍNH (Kích thước lớn hơn một chút để chứa Avatar và Note)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Chức năng kéo (Smooth Drag)
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- HIỂN THỊ AVATAR
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 60, 0, 60)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
AvatarImage.Parent = MainFrame
local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0) -- Làm ảnh tròn
AvatarCorner.Parent = AvatarImage

-- Tên người dùng bên cạnh Avatar
local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 210, 0, 25)
NameLabel.Position = UDim2.new(0, 80, 0, 15)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
NameLabel.Text = player.DisplayName
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 16
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = MainFrame

-- THÔNG TIN SERVER (Dưới Avatar)
local function createLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.Text = text
    label.Parent = MainFrame
    return label
end

local FPSLabel = createLabel("FPS: ...", 80)
local PingLabel = createLabel("Ping: ...", 100)
local PlaceLabel = createLabel("Place ID: " .. game.PlaceId, 120)
local JobIdLabel = createLabel("Job ID: " .. game.JobId, 140)
JobIdLabel.TextScaled = true

-- Ô NHẬP NOTE (Ghi chú cày acc)
local NoteTitle = createLabel("📝 Ghi chú (Auto-save):", 170)
NoteTitle.TextColor3 = Color3.fromRGB(255, 255, 255)

local NoteBox = Instance.new("TextBox")
NoteBox.Size = UDim2.new(1, -20, 0, 60)
NoteBox.Position = UDim2.new(0, 10, 0, 195)
NoteBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
NoteBox.Text = "Đang tải ghi chú..."
NoteBox.PlaceholderText = "Nhập nội dung cày cuốc tại đây..."
NoteBox.Font = Enum.Font.Gotham
NoteBox.TextSize = 12
NoteBox.TextWrapped = true
NoteBox.TextYAlignment = Enum.TextYAlignment.Top
NoteBox.ClearTextOnFocus = false
NoteBox.Parent = MainFrame
Instance.new("UICorner", NoteBox)

-- Xử lý lưu/tải Note bằng file hệ thống của Executor
local function saveNote()
    if writefile then
        writefile(fileName, NoteBox.Text)
    end
end

local function loadNote()
    if isfile and isfile(fileName) then
        NoteBox.Text = readfile(fileName)
    else
        NoteBox.Text = ""
    end
end

loadNote() -- Tải note khi chạy script
NoteBox.FocusLost:Connect(saveNote) -- Lưu note khi nhấn enter hoặc bấm ra ngoài

-- INPUT JOB ID & NÚT CHỨC NĂNG
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 30)
JobInput.Position = UDim2.new(0, 10, 0, 265)
JobInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Nhập Job ID để Join..."
JobInput.Text = ""
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 12
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 30)
BtnFrame.Position = UDim2.new(0, 10, 0, 305)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, 0, 1, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Text = "Copy ID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Parent = BtnFrame
Instance.new("UICorner", CopyBtn)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.48, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.52, 0, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Parent = BtnFrame
Instance.new("UICorner", JoinBtn)

-- NO RENDER TOGGLE
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 40)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 350)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

-- LOGIC CHỨC NĂNG
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
    CopyBtn.Text = "Đã Copy!"
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

toggleRender(true) -- Mặc định bật khi chạy

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    if noRenderEnabled then
        NoRenderBtn.Text = "No Render: ON"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        toggleRender(true)
    else
        NoRenderBtn.Text = "No Render: OFF"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        toggleRender(false)
    end
end)

-- NÚT SHOW/HIDE
local ShowHideBtn = Instance.new("TextButton")
ShowHideBtn.Size = UDim2.new(0, 80, 0, 25)
ShowHideBtn.Position = UDim2.new(0, 10, 0, 10)
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShowHideBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ShowHideBtn.Text = "Hiện/Ẩn Menu"
ShowHideBtn.Font = Enum.Font.GothamBold
ShowHideBtn.TextSize = 10
ShowHideBtn.Parent = ScreenGui
Instance.new("UICorner", ShowHideBtn)

ShowHideBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- LOOP FPS & PING
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start = TimeFunction(), TimeFunction()
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function()
    LastIteration = TimeFunction()
    for i = #FrameUpdateTable, 1, -1 do FrameUpdateTable[i + 1] = FrameUpdateTable[i] >= LastIteration - 1 and FrameUpdateTable[i] or nil end
    FrameUpdateTable[1] = LastIteration
    local fps = math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))
    FPSLabel.Text = "FPS: " .. tostring(fps)
    
    local ping = "N/A"
    pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
    PingLabel.Text = "Ping: " .. tostring(ping) .. " ms"
end)
