-- LocalScript đặt trong StarterGui

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

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 260, 0, 0)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 5)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 0.35
frame.BorderSizePixel = 0
frame.AutomaticSize = Enum.AutomaticSize.Y

-- BO TRÒN
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

-- VIỀN XANH
local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(0, 170, 255)
stroke.Thickness = 2

-- PADDING
local framePad = Instance.new("UIPadding", frame)
framePad.PaddingTop = UDim.new(0, 6)
framePad.PaddingBottom = UDim.new(0, 6)

-- LAYOUT
local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0, 5)

-- TOGGLE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 30, 0, 30)
toggleBtn.AnchorPoint = Vector2.new(1, 0)
toggleBtn.Position = UDim2.new(0.5, -frame.Size.X.Offset / 2 - 5, 0, 5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
toggleBtn.BackgroundTransparency = 0.3
toggleBtn.TextColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "≡"
toggleBtn.BorderSizePixel = 0

local toggleCorner = Instance.new("UICorner", toggleBtn)
toggleCorner.CornerRadius = UDim.new(0, 8)

local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.fromRGB(0, 170, 255)
toggleStroke.Thickness = 1.5

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

-- COPY BOX
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

-- JOIN JOBID BOX
local function newJoinBox()
	local holder = Instance.new("Frame")
	holder.Parent = frame
	holder.Size = UDim2.new(1, -10, 0, 28)
	holder.BackgroundTransparency = 1

	local layout2 = Instance.new("UIListLayout", holder)
	layout2.FillDirection = Enum.FillDirection.Horizontal
	layout2.Padding = UDim.new(0, 4)

	local box = Instance.new("TextBox")
	box.Parent = holder
	box.Size = UDim2.new(1, -60, 1, 0)
	box.PlaceholderText = "Nhập JobId..."
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.BackgroundColor3 = Color3.fromRGB(0,0,0)
	box.BackgroundTransparency = 0.4
	box.BorderSizePixel = 0

	local c1 = Instance.new("UICorner", box)
	c1.CornerRadius = UDim.new(0, 8)

	local s1 = Instance.new("UIStroke", box)
	s1.Color = Color3.fromRGB(0,170,255)
	s1.Thickness = 1

	local btn = Instance.new("TextButton")
	btn.Parent = holder
	btn.Size = UDim2.new(0, 56, 1, 0)
	btn.Text = "JOIN"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	btn.BorderSizePixel = 0

	local c2 = Instance.new("UICorner", btn)
	c2.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		if box.Text ~= "" then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, box.Text, player)
		end
	end)
end

-- FPS LOCK BOX (DÙNG setfpscap)
local function newFpsLockBox()
	local holder = Instance.new("Frame")
	holder.Parent = frame
	holder.Size = UDim2.new(1, -10, 0, 28)
	holder.BackgroundTransparency = 1

	local layout2 = Instance.new("UIListLayout", holder)
	layout2.FillDirection = Enum.FillDirection.Horizontal
	layout2.Padding = UDim.new(0, 4)

	local box = Instance.new("TextBox")
	box.Parent = holder
	box.Size = UDim2.new(1, -60, 1, 0)
	box.PlaceholderText = "FPS Lock (vd: 30, 60, 120)"
	box.Text = ""
	box.Font = Enum.Font.Gotham
	box.TextSize = 14
	box.TextColor3 = Color3.fromRGB(255,255,255)
	box.BackgroundColor3 = Color3.fromRGB(0,0,0)
	box.BackgroundTransparency = 0.4
	box.BorderSizePixel = 0

	local c1 = Instance.new("UICorner", box)
	c1.CornerRadius = UDim.new(0, 8)

	local s1 = Instance.new("UIStroke", box)
	s1.Color = Color3.fromRGB(0,170,255)
	s1.Thickness = 1

	local btn = Instance.new("TextButton")
	btn.Parent = holder
	btn.Size = UDim2.new(0, 56, 1, 0)
	btn.Text = "SET"
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
	btn.BorderSizePixel = 0

	local c2 = Instance.new("UICorner", btn)
	c2.CornerRadius = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		local value = tonumber(box.Text)
		if setfpscap then
			if value and value > 0 then
				setfpscap(value) -- LOCK FPS BẰNG EXPLOIT
			else
				setfpscap(0) -- 0 = UNLOCK
			end
		end
	end)
end

-- INFO
newLabel("ScriptByGiaHuy", Color3.fromRGB(255,255,255))
local nameLabel = newLabel("Name: " .. player.Name, Color3.fromRGB(255,105,180))
local fpsLabel = newLabel("FPS: ...", Color3.fromRGB(0,150,255))
local pingLabel = newLabel("Ping: ... ms", Color3.fromRGB(255,0,0))
local playerCountLabel = newLabel("Players: .../12", Color3.fromRGB(180,255,180))

newCopyBox("PlaceId: " .. game.PlaceId, Color3.fromRGB(255,255,150))
newCopyBox("JobId: " .. game.JobId, Color3.fromRGB(200,200,255))

-- JOIN + FPS LOCK
newJoinBox()
newFpsLockBox()

-- UPDATE NAME
player:GetPropertyChangedSignal("Name"):Connect(function()
	nameLabel.Text = "Name: " .. player.Name
end)

-- FPS COUNTER
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

-- TOGGLE
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
