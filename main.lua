-- LocalScript đặt trong StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0, 10, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 0

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "≡"
toggleBtn.BorderSizePixel = 0

-- LAYOUT
local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0, 5)

-- LABEL
local function newLabel(text, color)
	local lbl = Instance.new("TextLabel")
	lbl.Parent = frame
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 16
	lbl.TextColor3 = color
	lbl.Text = text

	local pad = Instance.new("UIPadding", lbl)
	pad.PaddingLeft = UDim.new(0, 6)

	return lbl
end

-- COPY TEXTBOX (bôi đen Ctrl+C)
local function newCopyBox(text, color)
	local box = Instance.new("TextBox")
	box.Parent = frame
	box.Size = UDim2.new(1, -10, 0, 20)
	box.BackgroundTransparency = 1
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Font = Enum.Font.GothamBold
	box.TextSize = 14
	box.TextColor3 = color
	box.TextEditable = false
	box.ClearTextOnFocus = false
	box.Text = text

	local pad = Instance.new("UIPadding", box)
	pad.PaddingLeft = UDim.new(0, 6)

	return box
end

-- INFO
newLabel("ScriptByGiaHuy", Color3.fromRGB(255,255,255))
local nameLabel = newLabel("Name: " .. player.Name, Color3.fromRGB(255,105,180))
local fpsLabel = newLabel("FPS: ...", Color3.fromRGB(0,150,255))
local pingLabel = newLabel("Ping: ... ms", Color3.fromRGB(255,0,0))
local playerCountLabel = newLabel("Players: .../12", Color3.fromRGB(180,255,180))

newCopyBox("PlaceId: " .. game.PlaceId, Color3.fromRGB(255,255,150))
newCopyBox("JobId: " .. game.JobId, Color3.fromRGB(200,200,255))

-- UPDATE NAME
player:GetPropertyChangedSignal("Name"):Connect(function()
	nameLabel.Text = "Name: " .. player.Name
end)

-- FPS
local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	local now = tick()
	if now - last >= 0.5 then
		fpsLabel.Text = "FPS: " .. math.floor(frames / (now - last))
		frames = 0
		last = now
	end
end)

-- PING
task.spawn(function()
	while true do
		local pingStat = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if pingStat then
			pingLabel.Text = "Ping: " .. math.floor(pingStat:GetValue()) .. " ms"
		else
			pingLabel.Text = "Ping: N/A"
		end
		task.wait(0.5)
	end
end)

-- PLAYER COUNT
local MAX_PLAYERS = 12
local function updatePlayerCount()
	playerCountLabel.Text = "Players: " .. #Players:GetPlayers() .. "/" .. MAX_PLAYERS
end
updatePlayerCount()
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)

-- TOGGLE LOGIC
local visible = true
local function toggleUI()
	visible = not visible
	frame.Visible = visible
end

toggleBtn.MouseButton1Click:Connect(toggleUI)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		toggleUI()
	end
end)
