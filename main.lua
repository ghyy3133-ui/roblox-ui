local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "V4StatusGUI"
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 260, 0, 260)
Frame.Position = UDim2.new(0.03, 0, 0.18, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
Frame.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.Parent = Frame

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Blox Fruits Race Panel"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Font = Enum.Font.Cartoon
Title.TextSize = 18

local Info = Instance.new("TextLabel")
Info.Parent = Frame
Info.Position = UDim2.new(0,10,0,40)
Info.Size = UDim2.new(1,-20,1,-50)
Info.BackgroundTransparency = 1
Info.TextXAlignment = Enum.TextXAlignment.Left
Info.TextYAlignment = Enum.TextYAlignment.Top
Info.Font = Enum.Font.Cartoon
Info.TextSize = 16
Info.TextColor3 = Color3.fromRGB(255,255,255)
Info.TextWrapped = true
Info.Text = "Loading..."

-- Race V4 Tier
local function getV4Tier()
    -- Có thể chỉnh theo dữ liệu thật
    -- Ví dụ demo:
    -- Chưa V4 = Tier 0
    -- 1 Gear = Tier 1
    -- 2 Gear = Tier 2
    -- 3 Gear = Tier 3

    local gears = 0

    -- chỉnh logic detect gear ở đây

    return "Tier "..tostring(gears)
end

-- Race
local function getRace()
    local data = plr:FindFirstChild("Data")

    if data and data:FindFirstChild("Race") then
        return data.Race.Value
    end

    return "Unknown"
end

-- Full Moon Status
local function getMoonStatus()
    local clock = Lighting.ClockTime

    -- demo check
    if clock >= 0 and clock <= 1 then
        return "Full Moon gần xuất hiện"
    elseif clock >= 12 then
        return "Ban ngày"
    else
        return "Ban đêm"
    end
end

-- Trial Status
local function getTrialStatus()
    -- chỉnh logic thật nếu có

    local level = plr.Data.Level.Value

    if level >= 2400 then
        return "Sẵn sàng Trial"
    else
        return "Cần train thêm"
    end
end

-- Update GUI
while true do
    local playerName = plr.Name
    local race = getRace()
    local tier = getV4Tier()
    local moon = getMoonStatus()
    local trial = getTrialStatus()

    Info.Text =
        "Name : "..playerName..
        "
────────────"
        .."
Race : "..race..
        "
Tier : "..tier..
        "
Moon : "..moon..
        "
Status : "..trial

    task.wait(1)
end
