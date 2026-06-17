--// INFO PANEL + WHITE SCREEN
--// Hỗ trợ executor có setfpscap()

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

pcall(function()
    setfpscap(15)
end)

-- Xóa GUI cũ
pcall(function()
    game.CoreGui.InfoPanelGUI:Destroy()
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfoPanelGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

-- WHITE SCREEN
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Name = "WhiteScreen"
WhiteScreen.Size = UDim2.new(1,0,1,0)
WhiteScreen.Position = UDim2.new(0,0,0,0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255,255,255)
WhiteScreen.BorderSizePixel = 0
WhiteScreen.ZIndex = 0
WhiteScreen.Parent = ScreenGui

-- MAIN PANEL
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,720,0,170)
Main.Position = UDim2.new(0.5,-360,0.08,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.3
Main.BorderSizePixel = 0
Main.Active = true
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0,22)

-- VIỀN XANH
local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 3

-- DRAG
local dragging = false
local dragStart
local startPos

Main.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)

Main.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- AVATAR
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0,120,0,120)
Avatar.Position = UDim2.new(0,15,0.5,-60)
Avatar.BackgroundTransparency = 1
Avatar.Parent = Main

local thumb = Players:GetUserThumbnailAsync(
    LocalPlayer.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

Avatar.Image = thumb

local AvatarCorner = Instance.new("UICorner", Avatar)
AvatarCorner.CornerRadius = UDim.new(1,0)

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Parent = Avatar
AvatarStroke.Color = Color3.fromRGB(0,170,255)
AvatarStroke.Thickness = 3

-- INFO
local Info = Instance.new("TextLabel")
Info.Size = UDim2.new(0,330,0,130)
Info.Position = UDim2.new(0,150,0,20)
Info.BackgroundTransparency = 1
Info.TextColor3 = Color3.fromRGB(255,255,255)
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.Cartoon
Info.TextSize = 20
Info.RichText = true
Info.Parent = Main

-- COPY JOB ID
local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0,150,0,35)
CopyBtn.Position = UDim2.new(1,-170,0,20)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
CopyBtn.Text = "Copy Job ID"
CopyBtn.TextColor3 = Color3.fromRGB(255,255,255)
CopyBtn.Font = Enum.Font.Cartoon
CopyBtn.TextSize = 18
CopyBtn.BorderSizePixel = 0
CopyBtn.Parent = Main

local CopyCorner = Instance.new("UICorner", CopyBtn)
CopyCorner.CornerRadius = UDim.new(0,12)

local CopyStroke = Instance.new("UIStroke")
CopyStroke.Parent = CopyBtn
CopyStroke.Color = Color3.fromRGB(100,220,255)
CopyStroke.Thickness = 2

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyBtn.Text = "Copied!"
        task.wait(1)
        CopyBtn.Text = "Copy Job ID"
    end
end)

-- JOIN BOX
local JoinBox = Instance.new("TextBox")
JoinBox.Size = UDim2.new(0,150,0,35)
JoinBox.Position = UDim2.new(1,-170,0,70)
JoinBox.PlaceholderText = "Enter Job ID"
JoinBox.Text = ""
JoinBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
JoinBox.TextColor3 = Color3.fromRGB(255,255,255)
JoinBox.PlaceholderColor3 = Color3.fromRGB(180,180,180)
JoinBox.Font = Enum.Font.Cartoon
JoinBox.TextSize = 17
JoinBox.BorderSizePixel = 0
JoinBox.Parent = Main

local JoinCorner = Instance.new("UICorner", JoinBox)
JoinCorner.CornerRadius = UDim.new(0,12)

local JoinStroke = Instance.new("UIStroke")
JoinStroke.Parent = JoinBox
JoinStroke.Color = Color3.fromRGB(0,170,255)
JoinStroke.Thickness = 2

-- JOIN BUTTON
local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0,150,0,35)
JoinBtn.Position = UDim2.new(1,-170,0,115)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
JoinBtn.Text = "Join Job ID"
JoinBtn.TextColor3 = Color3.fromRGB(255,255,255)
JoinBtn.Font = Enum.Font.Cartoon
JoinBtn.TextSize = 18
JoinBtn.BorderSizePixel = 0
JoinBtn.Parent = Main

local JoinBtnCorner = Instance.new("UICorner", JoinBtn)
JoinBtnCorner.CornerRadius = UDim.new(0,12)

local JoinBtnStroke = Instance.new("UIStroke")
JoinBtnStroke.Parent = JoinBtn
JoinBtnStroke.Color = Color3.fromRGB(100,220,255)
JoinBtnStroke.Thickness = 2

JoinBtn.MouseButton1Click:Connect(function()
    local id = JoinBox.Text
    if id ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer)
    end
end)

-- TOGGLE WHITE SCREEN BUTTON
local ToggleWhite = Instance.new("TextButton")
ToggleWhite.Size = UDim2.new(0,65,0,65)
ToggleWhite.Position = UDim2.new(0,20,0.75,0)
ToggleWhite.BackgroundColor3 = Color3.fromRGB(0,170,255)
ToggleWhite.Text = "ON"
ToggleWhite.TextColor3 = Color3.fromRGB(255,255,255)
ToggleWhite.Font = Enum.Font.Cartoon
ToggleWhite.TextSize = 20
ToggleWhite.BorderSizePixel = 0
ToggleWhite.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner", ToggleWhite)
ToggleCorner.CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = ToggleWhite
ToggleStroke.Color = Color3.fromRGB(100,220,255)
ToggleStroke.Thickness = 3

-- DRAG TOGGLE WHITE
local dragging2 = false
local dragStart2
local startPos2

ToggleWhite.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = ToggleWhite.Position
    end
end)

ToggleWhite.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart2
        ToggleWhite.Position = UDim2.new(
            startPos2.X.Scale,
            startPos2.X.Offset + delta.X,
            startPos2.Y.Scale,
            startPos2.Y.Offset + delta.Y
        )
    end
end)

-- TOGGLE WHITE SCREEN
local WhiteEnabled = true

ToggleWhite.MouseButton1Click:Connect(function()
    WhiteEnabled = not WhiteEnabled
    WhiteScreen.Visible = WhiteEnabled
    ToggleWhite.Text = WhiteEnabled and "ON" or "OFF"
end)

-- ====== NÚT THU GỌN/TẮT GUI MỚI ======
local ToggleGuiBtn = Instance.new("TextButton")
ToggleGuiBtn.Size = UDim2.new(0,40,0,40)
ToggleGuiBtn.Position = UDim2.new(1,-55,0.08,0)
ToggleGuiBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
ToggleGuiBtn.Text = "✕"
ToggleGuiBtn.TextColor3 = Color3.fromRGB(255,255,255)
ToggleGuiBtn.Font = Enum.Font.Cartoon
ToggleGuiBtn.TextSize = 22
ToggleGuiBtn.BorderSizePixel = 0
ToggleGuiBtn.Parent = ScreenGui

local ToggleGuiCorner = Instance.new("UICorner", ToggleGuiBtn)
ToggleGuiCorner.CornerRadius = UDim.new(1,0)

local ToggleGuiStroke = Instance.new("UIStroke")
ToggleGuiStroke.Parent = ToggleGuiBtn
ToggleGuiStroke.Color = Color3.fromRGB(100,220,255)
ToggleGuiStroke.Thickness = 2

-- DRAG TOGGLE GUI BUTTON
local dragging3 = false
local dragStart3
local startPos3

ToggleGuiBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging3 = true
        dragStart3 = input.Position
        startPos3 = ToggleGuiBtn.Position
    end
end)

ToggleGuiBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging3 = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging3 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart3
        ToggleGuiBtn.Position = UDim2.new(
            startPos3.X.Scale,
            startPos3.X.Offset + delta.X,
            startPos3.Y.Scale,
            startPos3.Y.Offset + delta.Y
        )
    end
end)

-- Biến trạng thái
local GuiVisible = true
local isMinimized = false

-- Hàm thu gọn/mở rộng
local function ToggleGui()
    isMinimized = not isMinimized
    
    if isMinimized then
        -- Thu gọn: ẩn hết, chỉ để lại nút toggle
        Main.Visible = false
        ToggleWhite.Visible = false
        ToggleGuiBtn.Text = "☰"
        ToggleGuiBtn.Size = UDim2.new(0,40,0,40)
    else
        -- Mở rộng: hiện tất cả
        Main.Visible = true
        ToggleWhite.Visible = true
        ToggleGuiBtn.Text = "✕"
        ToggleGuiBtn.Size = UDim2.new(0,40,0,40)
    end
end

-- Click để thu gọn/mở rộng
ToggleGuiBtn.MouseButton1Click:Connect(ToggleGui)

-- Phím tắt: Insert để thu gọn/mở rộng
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Insert then
        ToggleGui()
    end
end)

-- Phím tắt: End để bật/tắt WhiteScreen
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.End then
        WhiteEnabled = not WhiteEnabled
        WhiteScreen.Visible = WhiteEnabled
        ToggleWhite.Text = WhiteEnabled and "ON" or "OFF"
    end
end)

-- FPS
local fps = 0
local last = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
    frames += 1
    if tick() - last >= 1 then
        fps = frames
        frames = 0
        last = tick()
    end
end)

-- UPDATE INFO
task.spawn(function()
    while true do
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        
        Info.Text =
            "<font color='#00AAFF'>Name:</font> "..LocalPlayer.Name..
            "\n<font color='#00AAFF'>FPS:</font> "..fps..
            "\n<font color='#00AAFF'>Ping:</font> "..ping.." ms"..
            "\n<font color='#00AAFF'>Players:</font> "..#Players:GetPlayers()..
            "\n<font color='#00AAFF'>Place ID:</font> "..game.PlaceId..
            "\n<font color='#00AAFF'>Job ID:</font> "..game.JobId
        
        task.wait(1)
    end
end)

-- Thông báo phím tắt
task.wait(0.5)
print("=== INFO PANEL CONTROLS ===")
print("Insert: Toggle GUI (Hide/Show)")
print("End: Toggle White Screen")
