-- AUTO LOCK 10 FPS (DELTA MOBILE)
local FPS_LOCK = 10
if setfpscap then
	setfpscap(FPS_LOCK)
end

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- MAIN FRAME (trên cùng - giữa)
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 260, 0, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.35 -- trong suốt
frame.BorderSizePixel = 0
frame.AutomaticSize = Enum.AutomaticSize.Y

-- BO GÓC
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 10)

-- VIỀN XANH
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(0, 200, 255)
stroke.Transparency = 0

-- PADDING
local framePad = Instance.new("UIPadding", frame)
framePad.PaddingTop = UDim.new(0, 6)
framePad.PaddingBottom = UDim.new(0, 6)

-- LAYOUT
local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0, 5)

-- TOGGLE BUTTON (bên trái bảng)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.AnchorPoint = Vector2.new(1, 0)
toggleBtn.Position = UDim2.new(0.5, -140, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.BackgroundTransparency = 0.35
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "≡"
toggleBtn.BorderSizePixel = 0

local tCorner = Instance.new("UICorner", toggleBtn)
tCorner.CornerRadius = UDim.new(0, 8)

local tStroke = Instance.new("UIStroke", toggleBtn)
tStroke.Thickness = 1.5
tStroke.Color = Color3.fromRGB(0, 200, 255)

-- LABEL
local function newLabel(text, color)
	local lbl = Instance.new("TextLabel")
	lbl.Parent = frame
	lbl.Size = UDim2.new(1, -10, 0, 20)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 15
	lbl.TextColor3 = color
	lbl.Text = text

	local pad = Instance.new("UIPadding", lbl)
	pad.PaddingLeft = UDim.new(0, 6)

	return lbl
end

-- COPY BOX
local function newCopyBox(text, color)
	local box = Instance.new("TextBox")
	box.Parent = frame
	box.Size = UDim2.new(1, -10, 0, 22)
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

-- INPUT BOX
local function newInputBox(placeholder)
	local box = Instance.new("TextBox")
	box.Parent = frame
	box.Size = UDim2.new(1, -10, 0, 24)
	box.BackgroundTransparency = 1
	box.TextXAlignment = Enum.TextXAlignment.Left
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.PlaceholderText = placeholder
	box.ClearTextOnFocus = false

	local pad = Instance.new("UIPadding", box)
	pad.PaddingLeft = UDim.new(0, 6)

	return box
end

-- BUTTON
local function newButton(text)
	local btn = Instance.new("TextButton")
	btn.Parent = frame
	btn.Size = UDim2.new(1, -10, 0, 24)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.BackgroundTransparency = 0.35
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Text = text
	btn.BorderSizePixel = 0

	local c = Instance.new("UICorner", btn)
	c.CornerRadius = UDim.new(0, 8)

	local s = Instance.new("UIStroke", btn)
	s.Thickness = 1.5
	s.Color = Color3.fromRGB(0, 200, 255)

	return btn
end

-- INFO
newLabel("ScriptByGiaHuy", Color3.fromRGB(255,255,255))
local nameLabel = newLabel("Name: " .. player.Name, Color3.fromRGB(255,105,180))
local fpsLabel = newLabel("FPS: ...", Color3.fromRGB(0,150,255))
local pingLabel = newLabel("Ping: ... ms", Color3.fromRGB(255,0,0))
local playerCountLabel = newLabel("Players: .../12", Color3.fromRGB(180,255,180))

-- HIỂN THỊ FPS LOCK (CHỈ HIỂN THỊ)
local fpsLockLabel = newLabel("FPS Lock: " .. FPS_LOCK, Color3.fromRGB(0,255,150))

-- COPY INFO
newCopyBox("PlaceId: " .. game.PlaceId, Color3.fromRGB(255,255,150))
newCopyBox("JobId: " .. game.JobId, Color3.fromRGB(200,200,255))

-- JOIN JOBID
local jobBox = newInputBox("Nhập JobId để join...")
local joinBtn = newButton("JOIN JOBID")

joinBtn.MouseButton1Click:Connect(function()
	local jobId = jobBox.Text
	if jobId and jobId ~= "" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
	end
end)

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
