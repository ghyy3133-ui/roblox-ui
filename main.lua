--// INFO PANEL + WHITE SCREEN
--// Hỗ trợ executor có setfpscap()

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,720,0,170)
Main.Position = UDim2.new(0.5,-360,0.08,0)
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BackgroundTransparency = 0.3
Main.BorderSizePixel = 0
Main.Active = true
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

-- TOGGLE BUTTON
local Toggle = Instance.new("TextButton")
Toggle.Size = UDim2.new(0,65,0,65)
Toggle.Position = UDim2.new(0,20,0.75,0)
Toggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
Toggle.Text = "ON"
Toggle.TextColor3 = Color3.fromRGB(255,255,255)
Toggle.Font = Enum.Font.Cartoon
Toggle.TextSize = 20
Toggle.BorderSizePixel = 0
Toggle.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner", Toggle)
ToggleCorner.CornerRadius = UDim.new(1,0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Parent = Toggle
ToggleStroke.Color = Color3.fromRGB(100,220,255)
ToggleStroke.Thickness = 3

-- DRAG TOGGLE
local dragging2 = false
local dragStart2
local startPos2

Toggle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = true
        dragStart2 = input.Position
        startPos2 = Toggle.Position
    end
end)

Toggle.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging2 = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging2 and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart2
        Toggle.Position = UDim2.new(
            startPos2.X.Scale,
            startPos2.X.Offset + delta.X,
            startPos2.Y.Scale,
            startPos2.Y.Offset + delta.Y
        )
    end
end)

-- TOGGLE WHITE SCREEN
local Enabled = true

Toggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled

    WhiteScreen.Visible = Enabled

    if Enabled then
        Toggle.Text = "ON"
    else
        Toggle.Text = "OFF"
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
