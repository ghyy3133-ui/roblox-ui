--// Roblox Info Panel Script
--// UI: Transparent + Blue Border
--// Features:
--// Name, FPS, Ping, Players, PlaceId, JobId
--// Copy JobId
--// Join JobId
--// Avatar Preview
--// White Screen Toggle
--// Draggable Toggle Button
--// FPS Lock 15

repeat task.wait() until game:IsLoaded()

-- FPS LOCK
pcall(function()
    setfpscap(15)
end)

local Players = game:GetService("Players")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- MAIN FRAME
local Main = Instance.new("Frame")
Main.Parent = ScreenGui
Main.Size = UDim2.new(0, 330, 0, 340)
Main.Position = UDim2.new(0.5, -165, 0.5, -170)
Main.BackgroundColor3 = Color3.fromRGB(0,0,0)
Main.BackgroundTransparency = 0.35
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Main
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2

local Corner = Instance.new("UICorner")
Corner.Parent = Main

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "SERVER INFO PANEL"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0,170,255)

-- AVATAR
local Avatar = Instance.new("ImageLabel")
Avatar.Parent = Main
Avatar.Size = UDim2.new(0,80,0,80)
Avatar.Position = UDim2.new(0,15,0,45)
Avatar.BackgroundTransparency = 1

local userId = LocalPlayer.UserId
local thumbType = Enum.ThumbnailType.HeadShot
local thumbSize = Enum.ThumbnailSize.Size420x420
local content, ready = Players:GetUserThumbnailAsync(userId, thumbType, thumbSize)
Avatar.Image = content

-- INFO LABELS
local Info = Instance.new("TextLabel")
Info.Parent = Main
Info.Position = UDim2.new(0,110,0,45)
Info.Size = UDim2.new(0,200,0,150)
Info.BackgroundTransparency = 1
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.Code
Info.TextSize = 14
Info.TextColor3 = Color3.fromRGB(255,255,255)
Info.Text = ""

-- JOB ID BOX
local JobBox = Instance.new("TextBox")
JobBox.Parent = Main
JobBox.Size = UDim2.new(0,220,0,35)
JobBox.Position = UDim2.new(0,15,0,210)
JobBox.Text = game.JobId
JobBox.PlaceholderText = "Enter Job ID"
JobBox.Font = Enum.Font.Code
JobBox.TextSize = 14
JobBox.TextColor3 = Color3.new(1,1,1)
JobBox.BackgroundColor3 = Color3.fromRGB(20,20,20)

local jbCorner = Instance.new("UICorner", JobBox)

local jbStroke = Instance.new("UIStroke", JobBox)
jbStroke.Color = Color3.fromRGB(0,170,255)

-- COPY BUTTON
local CopyBtn = Instance.new("TextButton")
CopyBtn.Parent = Main
CopyBtn.Size = UDim2.new(0,80,0,35)
CopyBtn.Position = UDim2.new(0,245,0,210)
CopyBtn.Text = "COPY"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 14
CopyBtn.TextColor3 = Color3.new(1,1,1)
CopyBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)

local cpCorner = Instance.new("UICorner", CopyBtn)

CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyBtn.Text = "COPIED"
        task.wait(1)
        CopyBtn.Text = "COPY"
    end
end)

-- JOIN BUTTON
local JoinBtn = Instance.new("TextButton")
JoinBtn.Parent = Main
JoinBtn.Size = UDim2.new(1,-30,0,35)
JoinBtn.Position = UDim2.new(0,15,0,255)
JoinBtn.Text = "JOIN JOB ID"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 14
JoinBtn.TextColor3 = Color3.new(1,1,1)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)

local joinCorner = Instance.new("UICorner", JoinBtn)

JoinBtn.MouseButton1Click:Connect(function()
    if JobBox.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, JobBox.Text, LocalPlayer)
    end
end)

-- WHITE SCREEN
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Parent = ScreenGui
WhiteScreen.Size = UDim2.new(1,0,1,0)
WhiteScreen.BackgroundColor3 = Color3.new(1,1,1)
WhiteScreen.Visible = false
WhiteScreen.ZIndex = 999

-- WHITE SCREEN TOGGLE
local WhiteBtn = Instance.new("TextButton")
WhiteBtn.Parent = Main
WhiteBtn.Size = UDim2.new(1,-30,0,35)
WhiteBtn.Position = UDim2.new(0,15,0,300)
WhiteBtn.Text = "WHITE SCREEN : OFF"
WhiteBtn.Font = Enum.Font.GothamBold
WhiteBtn.TextSize = 14
WhiteBtn.TextColor3 = Color3.new(1,1,1)
WhiteBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)

local wbCorner = Instance.new("UICorner", WhiteBtn)

local WhiteEnabled = false

WhiteBtn.MouseButton1Click:Connect(function()
    WhiteEnabled = not WhiteEnabled
    WhiteScreen.Visible = WhiteEnabled
    
    if WhiteEnabled then
        WhiteBtn.Text = "WHITE SCREEN : ON"
    else
        WhiteBtn.Text = "WHITE SCREEN : OFF"
    end
end)

-- TOGGLE BUTTON
local Toggle = Instance.new("TextButton")
Toggle.Parent = ScreenGui
Toggle.Size = UDim2.new(0,50,0,50)
Toggle.Position = UDim2.new(0,20,0.5,-25)
Toggle.Text = "UI"
Toggle.Font = Enum.Font.GothamBold
Toggle.TextSize = 18
Toggle.TextColor3 = Color3.new(1,1,1)
Toggle.BackgroundColor3 = Color3.fromRGB(0,120,255)
Toggle.Active = true
Toggle.Draggable = true

local tgCorner = Instance.new("UICorner", Toggle)
tgCorner.CornerRadius = UDim.new(1,0)

local Open = true

Toggle.MouseButton1Click:Connect(function()
    Open = not Open
    Main.Visible = Open
end)

-- FPS COUNTER
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
        "Name : "..LocalPlayer.Name..
        "\nFPS : "..fps..
        "\nPing : "..ping.." ms"..
        "\nPlayers : "..#Players:GetPlayers()..
        "\nPlace ID : "..game.PlaceId..
        "\nJob ID : "..game.JobId
end)
