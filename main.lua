--// UI Info Script
--// Executor: Synapse / Fluxus / Delta / Codex hỗ trợ setfpscap

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

pcall(function()
    setfpscap(15)
end)

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "InfoPanel"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = ScreenGui
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -25)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
ToggleBtn.Text = "☰"
ToggleBtn.TextScaled = true
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.BorderSizePixel = 0

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1,0)

-- Main Frame
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 650, 0, 180)
Main.Position = UDim2.new(0.5, -325, 0.1, 0)
Main.BackgroundTransparency = 0.25
Main.BackgroundColor3 = Color3.fromRGB(20,20,20)
Main.BorderSizePixel = 2
Main.BorderColor3 = Color3.fromRGB(0,170,255)
Main.Active = true
Main.Draggable = true

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

-- Avatar
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = Main
Avatar.Size = UDim2.new(0,120,0,120)
Avatar.Position = UDim2.new(0,15,0.5,-60)
Avatar.BackgroundTransparency = 1
Avatar.Image = Players:GetUserThumbnailAsync(
    LocalPlayer.UserId,
    Enum.ThumbnailType.HeadShot,
    Enum.ThumbnailSize.Size420x420
)

-- Info Text
local Info = Instance.new("TextLabel")
Info.Parent = Main
Info.Size = UDim2.new(0, 320, 0, 140)
Info.Position = UDim2.new(0,150,0,20)
Info.BackgroundTransparency = 1
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.SourceSansBold
Info.TextSize = 20
Info.TextColor3 = Color3.new(1,1,1)
Info.RichText = true

-- Copy Job ID Button
local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = Main
CopyBtn.Size = UDim2.new(0,140,0,35)
CopyBtn.Position = UDim2.new(1,-160,0,20)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
CopyBtn.Text = "Copy Job ID"
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.TextScaled = true
CopyBtn.BorderSizePixel = 0

Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,8)

-- Join Box
local JoinBox = Instance.new("TextBox")
JoinBox.Parent = Main
JoinBox.Size = UDim2.new(0,140,0,35)
JoinBox.Position = UDim2.new(1,-160,0,70)
JoinBox.PlaceholderText = "Nhập Job ID"
JoinBox.Text = ""
JoinBox.TextScaled = true
JoinBox.BackgroundColor3 = Color3.fromRGB(35,35,35)
JoinBox.TextColor3 = Color3.new(1,1,1)
JoinBox.BorderColor3 = Color3.fromRGB(0,170,255)

Instance.new("UICorner", JoinBox).CornerRadius = UDim.new(0,8)

-- Join Button
local JoinBtn = Instance.new("TextButton")
JoinBtn.Parent = Main
JoinBtn.Size = UDim2.new(0,140,0,35)
JoinBtn.Position = UDim2.new(1,-160,0,115)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
JoinBtn.Text = "Join Job ID"
JoinBtn.TextColor3 = Color3.new(1,1,1)
JoinBtn.TextScaled = true
JoinBtn.BorderSizePixel = 0

Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0,8)

-- White Screen
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Parent = ScreenGui
WhiteScreen.Size = UDim2.new(1,0,1,0)
WhiteScreen.BackgroundColor3 = Color3.new(1,1,1)
WhiteScreen.BackgroundTransparency = 0
WhiteScreen.Visible = true
WhiteScreen.ZIndex = 999

-- White Toggle
local WhiteToggle = Instance.new("TextButton")
WhiteToggle.Parent = Main
WhiteToggle.Size = UDim2.new(0,140,0,35)
WhiteToggle.Position = UDim2.new(1,-160,1,-45)
WhiteToggle.BackgroundColor3 = Color3.fromRGB(0,170,255)
WhiteToggle.Text = "White Screen: ON"
WhiteToggle.TextColor3 = Color3.new(1,1,1)
WhiteToggle.TextScaled = true
WhiteToggle.BorderSizePixel = 0

Instance.new("UICorner", WhiteToggle).CornerRadius = UDim.new(0,8)

-- Toggle Main
ToggleBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

-- Copy Job ID
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyBtn.Text = "Copied!"
        task.wait(1)
        CopyBtn.Text = "Copy Job ID"
    end
end)

-- Join Job ID
JoinBtn.MouseButton1Click:Connect(function()
    if JoinBox.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, JoinBox.Text, LocalPlayer)
    end
end)

-- White Screen Toggle
WhiteToggle.MouseButton1Click:Connect(function()
    WhiteScreen.Visible = not WhiteScreen.Visible
    
    if WhiteScreen.Visible then
        WhiteToggle.Text = "White Screen: ON"
    else
        WhiteToggle.Text = "White Screen: OFF"
    end
end)

-- FPS Counter
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
    
    local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
    
    Info.Text =
        "👤 Name: "..LocalPlayer.Name..
        "\n🎮 FPS: "..fps..
        "\n📶 Ping: "..ping.." ms"..
        "\n👥 Players: "..#Players:GetPlayers()..
        "\n🆔 Place ID: "..game.PlaceId..
        "\n📌 Job ID:\n"..game.JobId
end)
