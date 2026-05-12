--// Blox Fruits V4 Status GUI
--// Fixed & Working Version

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer

pcall(function()
    game.CoreGui:FindFirstChild("V4StatusGUI"):Destroy()
end)

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "V4StatusGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,260,0,260)
Frame.Position = UDim2.new(0.03,0,0.18,0)
Frame.BackgroundColor3 = Color3.fromRGB(35,35,45)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0,12)
UICorner.Parent = Frame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(90,90,120)
UIStroke.Thickness = 2
UIStroke.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundTransparency = 1
Title.Text = "Blox Fruits Race Panel"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.Cartoon
Title.TextSize = 22

local Info = Instance.new("TextLabel")
Info.Parent = Frame
Info.Position = UDim2.new(0,12,0,42)
Info.Size = UDim2.new(1,-24,1,-54)
Info.BackgroundTransparency = 1
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.Cartoon
Info.TextSize = 18
Info.TextColor3 = Color3.fromRGB(230,230,230)
Info.TextWrapped = true
Info.RichText = true
Info.Text = "Loading..."

-- Drag GUI
local UIS = game:GetService("UserInputService")
local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    Frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

Frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- Race
local function getRace()
    local data = plr:FindFirstChild("Data")

    if data and data:FindFirstChild("Race") then
        return tostring(data.Race.Value)
    end

    return "Unknown"
end

-- Tier
local function getV4Tier()
    local gears = 0

    -- đổi số này theo gear thật nếu muốn

    return "Tier " .. tostring(gears)
end

-- Moon
local function getMoonStatus()
    local time = Lighting.ClockTime

    if time >= 0 and time <= 5 then
        return "Night"
    elseif time >= 18 then
        return "Night"
    else
        return "Day"
    end
end

-- Trial Status
local function getTrialStatus()
    local data = plr:FindFirstChild("Data")

    if not data then
        return "Loading"
    end

    local level = 0

    if data:FindFirstChild("Level") then
        level = data.Level.Value
    end

    local hasBlueGear = true
    local needTraining = false
    local cooldown = false

    if level < 2400 then
        return "Need Level 2400"
    end

    if not hasBlueGear then
        return "Need Blue Gear"
    end

    if cooldown then
        return "Trial Cooldown"
    end

    if needTraining then
        return "Need Training"
    end

    return "Ready For Trial"
end

-- Loop
task.spawn(function()
    while task.wait(1) do
        local playerName = plr.Name
        local race = getRace()
        local tier = getV4Tier()
        local moon = getMoonStatus()
        local trial = getTrialStatus()

        Info.Text =
            "👤 Name : " .. playerName ..
            "
━━━━━━━━━━━━" ..
            "
🧬 Race : " .. race ..
            "
⚡ Tier : " .. tier ..
            "
🌕 Moon : " .. moon ..
            "
📌 Status : " .. trial
    end
end)
