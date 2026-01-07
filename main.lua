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

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0, 360, 0, 170)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0

-- BO GÓC
local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 16)

-- VIỀN
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(0, 180, 255)
stroke.Transparency = 0.1

-- LAYOUT
local layout = Instance.new("UIListLayout")
layout.Parent = frame
layout.Padding = UDim.new(0, 6)

local padding = Instance.new("UIPadding", frame)
padding.PaddingTop = UDim.new(0, 8)
padding.PaddingBottom = UDim.new(0, 8)
padding.PaddingLeft = UDim.new(0, 8)
padding.PaddingRight = UDim.new(0, 8)

-- ===== PLAYER INFO BAR =====
local infoBar = Instance.new("Frame")
infoBar.Parent = frame
infoBar.Size = UDim2.new(1, 0, 0, 40)
infoBar.BackgroundTransparency = 1

local infoLayout = Instance.new("UIListLayout", infoBar)
infoLayout.FillDirection = Enum.FillDirection.Horizontal
infoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
infoLayout.Padding = UDim.new(0, 8)

-- AVATAR
local avatar = Instance.new("ImageLabel")
avatar.Parent = infoBar
avatar.Size = UDim2.new(0, 32, 0, 32)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. player.UserId .. "&w=150&h=150"

-- NAME
local nameLabel = Instance.new("TextLabel")
nameLabel.Parent = infoBar
nameLabel.Size = UDim2.new(1, -40, 0, 20)
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
nameLabel.Text = player.Name

-- STATS LINE
local statsLabel = Instance.new("TextLabel")
statsLabel.Parent = frame
statsLabel.Size = UDim2.new(1, 0, 0, 20)
statsLabel.BackgroundTransparency = 1
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Font = Enum.Font.Gotham
statsLabel.TextSize = 13
statsLabel.TextColor3 = Color3.fromRGB(200,200,200)
statsLabel.Text = "FPS: ... | Ping: ... ms | FPS Lock: 10"

-- ===== PLACEID BOX =====
local placeBox = Instance.new("TextBox")
placeBox.Parent = frame
placeBox.Size = UDim2.new(1, 0, 0, 26)
placeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
placeBox.BackgroundTransparency = 0.4
placeBox.TextColor3 = Color3.fromRGB(200,200,255)
placeBox.Font = Enum.Font.Gotham
placeBox.TextSize = 13
placeBox.TextEditable = false
placeBox.ClearTextOnFocus = false
placeBox.TextXAlignment = Enum.TextXAlignment.Left
placeBox.BorderSizePixel = 0
placeBox.Text = "PlaceId: " .. game.PlaceId

local placeCorner = Instance.new("UICorner", placeBox)
placeCorner.CornerRadius = UDim.new(0, 10)

local placeStroke = Instance.new("UIStroke", placeBox)
placeStroke.Thickness = 1
placeStroke.Color = Color3.fromRGB(0,180,255)

-- ===== JOBID BOX =====
local jobBox = Instance.new("TextBox")
jobBox.Parent = frame
jobBox.Size = UDim2.new(1, 0, 0, 28)
jobBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
jobBox.BackgroundTransparency = 0.4
jobBox.TextColor3 = Color3.fromRGB(255,255,255)
jobBox.Font = Enum.Font.Gotham
jobBox.TextSize = 13
jobBox.PlaceholderText = "JobId..."
jobBox.ClearTextOnFocus = false
jobBox.TextXAlignment = Enum.TextXAlignment.Left
jobBox.BorderSizePixel = 0

local jobCorner = Instance.new("UICorner", jobBox)
jobCorner.CornerRadius = UDim.new(0, 10)

local jobStroke = Instance.new("UIStroke", jobBox)
jobStroke.Thickness = 1
jobStroke.Color = Color3.fromRGB(0,180,255)

-- ===== BUTTON BAR =====
local btnBar = Instance.new("Frame")
btnBar.Parent = frame
btnBar.Size = UDim2.new(1, 0, 0, 30)
btnBar.BackgroundTransparency = 1

local btnLayout = Instance.new("UIListLayout", btnBar)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0, 6)

local function makeBtn(text, color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1/3, -4, 1, 0)
	b.BackgroundColor3 = color
	b.BackgroundTransparency = 0.15
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = text
	b.BorderSizePixel = 0

	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0, 10)

	return b
end

local joinBtn = makeBtn("Join", Color3.fromRGB(0,200,100))
joinBtn.Parent = btnBar

local spamBtn = makeBtn("Spam Join", Color3.fromRGB(200,80,80))
spamBtn.Parent = btnBar

local copyBtn = makeBtn("Copy", Color3.fromRGB(80,140,255))
copyBtn.Parent = btnBar

-- ===== TOGGLE BUTTON =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0, 34, 0, 34)
toggleBtn.AnchorPoint = Vector2.new(1, 0)
toggleBtn.Position = UDim2.new(0.5, -190, 0, 10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 18
toggleBtn.Text = "≡"
toggleBtn.BorderSizePixel = 0

local tCorner = Instance.new("UICorner", toggleBtn)
tCorner.CornerRadius = UDim.new(0, 12)

local tStroke = Instance.new("UIStroke", toggleBtn)
tStroke.Thickness = 1.5
tStroke.Color = Color3.fromRGB(0,180,255)

-- ===== LOGIC =====

-- UPDATE NAME
player:GetPropertyChangedSignal("Name"):Connect(function()
	nameLabel.Text = player.Name
end)

-- FPS
local frames, last = 0, tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	local now = tick()
	if now - last >= 0.5 then
		local fps = math.floor(frames / (now - last))
		statsLabel.Text = "FPS: " .. fps .. " | Ping: ... ms | FPS Lock: " .. FPS_LOCK
		frames = 0
		last = now
	end
end)

-- PING
task.spawn(function()
	while true do
		local pingStat = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if pingStat then
			statsLabel.Text = "FPS: " .. tostring(FPS_LOCK) .. " | Ping: " .. math.floor(pingStat:GetValue()) .. " ms | FPS Lock: " .. FPS_LOCK
		end
		task.wait(0.5)
	end
end)

-- JOIN
joinBtn.MouseButton1Click:Connect(function()
	local jobId = jobBox.Text
	if jobId and jobId ~= "" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
	end
end)

-- SPAM JOIN
local spamming = false
spamBtn.MouseButton1Click:Connect(function()
	spamming = not spamming
	spamBtn.Text = spamming and "Stop" or "Spam Join"

	while spamming do
		local jobId = jobBox.Text
		if jobId and jobId ~= "" then
			TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
		end
		task.wait(1)
	end
end)

-- COPY JOBID
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(jobBox.Text)
	end
end)

-- TOGGLE
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		visible = not visible
		frame.Visible = visible
	end
end)
