--===== SETTINGS =====
local FPS_LOCK = 10

--===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--===== FPS LOCK =====
if setfpscap then
	setfpscap(FPS_LOCK)
end

--===== ANTI AFK =====
player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

--===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0,360,0,260)
frame.AnchorPoint = Vector2.new(0.5,0)
frame.Position = UDim2.new(0.5,0,0,10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,16)

local layout = Instance.new("UIListLayout",frame)
layout.Padding = UDim.new(0,6)

--===== STATS =====
local statsLabel = Instance.new("TextLabel",frame)
statsLabel.Size = UDim2.new(1,0,0,26)
statsLabel.BackgroundTransparency = 1
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextSize = 16
statsLabel.TextColor3 = Color3.fromRGB(255,255,255)
statsLabel.Text = "FPS: ... | Ping: ..."

--===== PLAYER COUNT =====
local playerCountLabel = Instance.new("TextLabel",frame)
playerCountLabel.Size = UDim2.new(1,0,0,22)
playerCountLabel.BackgroundTransparency = 1
playerCountLabel.Font = Enum.Font.Gotham
playerCountLabel.TextSize = 13
playerCountLabel.TextColor3 = Color3.fromRGB(180,255,180)

--===== JOBID =====
local currentJob = Instance.new("TextLabel",frame)
currentJob.Size = UDim2.new(1,0,0,22)
currentJob.BackgroundTransparency = 1
currentJob.Font = Enum.Font.Gotham
currentJob.TextSize = 13
currentJob.TextColor3 = Color3.fromRGB(200,200,200)
currentJob.Text = "Current JobId: "..game.JobId

--===== JOB INPUT =====
local jobBox = Instance.new("TextBox",frame)
jobBox.Size = UDim2.new(1,0,0,28)
jobBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
jobBox.BackgroundTransparency = 0.4
jobBox.TextColor3 = Color3.fromRGB(255,255,255)
jobBox.PlaceholderText = "Nhập JobId..."
jobBox.Font = Enum.Font.Gotham
jobBox.TextSize = 13
jobBox.ClearTextOnFocus = false
jobBox.BorderSizePixel = 0
Instance.new("UICorner",jobBox)

--===== BUTTON BAR =====
local btnBar = Instance.new("Frame",frame)
btnBar.Size = UDim2.new(1,0,0,32)
btnBar.BackgroundTransparency = 1

local btnLayout = Instance.new("UIListLayout",btnBar)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.Padding = UDim.new(0,6)

local function makeBtn(text,color)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1/4,-4,1,0)
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = text
	b.BorderSizePixel = 0
	Instance.new("UICorner",b)
	return b
end

local joinBtn = makeBtn("Join",Color3.fromRGB(0,200,100))
joinBtn.Parent = btnBar

local spamBtn = makeBtn("Spam",Color3.fromRGB(200,80,80))
spamBtn.Parent = btnBar

local copyBtn = makeBtn("Copy",Color3.fromRGB(80,140,255))
copyBtn.Parent = btnBar

local noRenderBtn = makeBtn("NoRender",Color3.fromRGB(120,120,120))
noRenderBtn.Parent = btnBar

--===== TOGGLE BUTTON RIGHT =====
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = screenGui
toggleBtn.Size = UDim2.new(0,50,0,50)
toggleBtn.AnchorPoint = Vector2.new(1,0)
toggleBtn.Position = UDim2.new(1,-10,0,10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.Text = "≡"
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
Instance.new("UICorner",toggleBtn)

--===== PLAYER COUNT UPDATE =====
local function updatePlayers()
	playerCountLabel.Text = "Players: "..#Players:GetPlayers().."/"..Players.MaxPlayers
end
updatePlayers()
Players.PlayerAdded:Connect(updatePlayers)
Players.PlayerRemoving:Connect(updatePlayers)

--===== FPS =====
local frames,last = 0,tick()
RunService.RenderStepped:Connect(function()
	frames += 1
	if tick()-last >= 1 then
		statsLabel.Text = "FPS: "..frames.." | Ping: ..."
		frames = 0
		last = tick()
	end
end)

--===== JOIN =====
joinBtn.MouseButton1Click:Connect(function()
	if jobBox.Text ~= "" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId,jobBox.Text,player)
	end
end)

--===== SPAM JOIN =====
local spamming = false
spamBtn.MouseButton1Click:Connect(function()
	spamming = not spamming
	while spamming do
		if jobBox.Text ~= "" then
			TeleportService:TeleportToPlaceInstance(game.PlaceId,jobBox.Text,player)
		end
		task.wait(1)
	end
end)

--===== COPY JOBID =====
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

--===== NO RENDER =====
local noRender = false
local saved = {}

local function hide(v)
	if v:IsA("BasePart") or v:IsA("Decal") then
		if not saved[v] then
			saved[v] = v.Transparency
		end
		v.Transparency = 1
	end
end

local function enableNoRender()
	noRender = true
	for _,v in pairs(Workspace:GetDescendants()) do
		pcall(function() hide(v) end)
	end
end

Workspace.DescendantAdded:Connect(function(v)
	if noRender then hide(v) end
end)

noRenderBtn.MouseButton1Click:Connect(enableNoRender)

task.wait(5)
enableNoRender()

--===== INSTANT AUTO RECONNECT =====
local reconnecting = false

local function reconnect()
	if reconnecting then return end
	reconnecting = true

	for i=1,10 do
		pcall(function()
			TeleportService:TeleportToPlaceInstance(game.PlaceId,game.JobId,player)
		end)
		task.wait(0.2)
	end

	reconnecting = false
end

game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
	if child.Name == "ErrorPrompt" then
		task.wait(0.2)
		reconnect()
	end
end)

player.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.Failed then
		reconnect()
	end
end)

--===== AUTO SERVER HOP WHEN PING HIGH =====
task.spawn(function()
	while true do
		local pingStat = Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if pingStat then
			local ping = pingStat:GetValue()
			if ping > 500 then
				TeleportService:Teleport(game.PlaceId,player)
			end
		end
		task.wait(5)
	end
end)

--===== TOGGLE UI =====
local visible = true
toggleBtn.MouseButton1Click:Connect(function()
	visible = not visible
	frame.Visible = visible
end)
