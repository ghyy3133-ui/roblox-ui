-- ===== AUTO LOCK 10 FPS =====
local FPS_LOCK = 10
if setfpscap then
	setfpscap(FPS_LOCK)
end

-- ===== SAVE NOTE BETWEEN SERVERS =====
getgenv().SavedNote = getgenv().SavedNote or ""

-- ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

-- ===== MAIN FRAME =====
local frame = Instance.new("Frame")
frame.Parent = screenGui
frame.Size = UDim2.new(0,360,0,300)
frame.AnchorPoint = Vector2.new(0.5,0)
frame.Position = UDim2.new(0.5,0,0,10)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0

Instance.new("UICorner",frame).CornerRadius = UDim.new(0,16)

local stroke = Instance.new("UIStroke",frame)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(0,180,255)

local layout = Instance.new("UIListLayout",frame)
layout.Padding = UDim.new(0,6)

local padding = Instance.new("UIPadding",frame)
padding.PaddingTop = UDim.new(0,8)
padding.PaddingBottom = UDim.new(0,8)
padding.PaddingLeft = UDim.new(0,8)
padding.PaddingRight = UDim.new(0,8)

-- ===== PLAYER INFO =====
local infoBar = Instance.new("Frame",frame)
infoBar.Size = UDim2.new(1,0,0,40)
infoBar.BackgroundTransparency = 1

local infoLayout = Instance.new("UIListLayout",infoBar)
infoLayout.FillDirection = Enum.FillDirection.Horizontal
infoLayout.Padding = UDim.new(0,8)

local avatar = Instance.new("ImageLabel",infoBar)
avatar.Size = UDim2.new(0,32,0,32)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"

local nameLabel = Instance.new("TextLabel",infoBar)
nameLabel.Size = UDim2.new(1,-40,0,20)
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 14
nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
nameLabel.Text = player.Name

-- ===== STATS =====
local statsLabel = Instance.new("TextLabel",frame)
statsLabel.Size = UDim2.new(1,0,0,26)
statsLabel.BackgroundTransparency = 1
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextSize = 16
statsLabel.TextColor3 = Color3.fromRGB(255,255,255)
statsLabel.Text = "FPS: ... | Ping: ... ms"

-- ===== PLAYER COUNT =====
local playerCountLabel = Instance.new("TextLabel",frame)
playerCountLabel.Size = UDim2.new(1,0,0,22)
playerCountLabel.BackgroundTransparency = 1
playerCountLabel.TextColor3 = Color3.fromRGB(180,255,180)
playerCountLabel.Font = Enum.Font.Gotham
playerCountLabel.TextSize = 13

-- ===== JOBID =====
local currentJob = Instance.new("TextLabel",frame)
currentJob.Size = UDim2.new(1,0,0,22)
currentJob.BackgroundTransparency = 1
currentJob.TextColor3 = Color3.fromRGB(200,200,200)
currentJob.Font = Enum.Font.Gotham
currentJob.TextSize = 13
currentJob.Text = "Current JobId: "..game.JobId

-- ===== PLACEID =====
local placeBox = Instance.new("TextBox",frame)
placeBox.Size = UDim2.new(1,0,0,26)
placeBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
placeBox.BackgroundTransparency = 0.4
placeBox.TextColor3 = Color3.fromRGB(200,200,255)
placeBox.Font = Enum.Font.Gotham
placeBox.TextSize = 13
placeBox.TextEditable = false
placeBox.Text = "PlaceId: "..game.PlaceId
placeBox.BorderSizePixel = 0
Instance.new("UICorner",placeBox).CornerRadius = UDim.new(0,10)

-- ===== JOBID INPUT =====
local jobBox = Instance.new("TextBox",frame)
jobBox.Size = UDim2.new(1,0,0,28)
jobBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
jobBox.BackgroundTransparency = 0.4
jobBox.TextColor3 = Color3.fromRGB(255,255,255)
jobBox.Font = Enum.Font.Gotham
jobBox.TextSize = 13
jobBox.PlaceholderText = "Nhập JobId..."
jobBox.BorderSizePixel = 0
Instance.new("UICorner",jobBox).CornerRadius = UDim.new(0,10)

-- ===== NOTE TEXTBOX =====
local noteBox = Instance.new("TextBox",frame)
noteBox.Size = UDim2.new(1,0,0,28)
noteBox.BackgroundColor3 = Color3.fromRGB(0,0,0)
noteBox.BackgroundTransparency = 0.4
noteBox.TextColor3 = Color3.fromRGB(255,255,255)
noteBox.Font = Enum.Font.Gotham
noteBox.TextSize = 13
noteBox.PlaceholderText = "Ghi chú acc (acc phụ / acc chính)"
noteBox.BorderSizePixel = 0
Instance.new("UICorner",noteBox).CornerRadius = UDim.new(0,10)

noteBox.Text = getgenv().SavedNote
noteBox.FocusLost:Connect(function()
	getgenv().SavedNote = noteBox.Text
end)

-- ===== BUTTON BAR =====
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
	b.BackgroundTransparency = 0.15
	b.TextColor3 = Color3.fromRGB(255,255,255)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 13
	b.Text = text
	b.BorderSizePixel = 0
	Instance.new("UICorner",b).CornerRadius = UDim.new(0,10)
	return b
end

local joinBtn = makeBtn("Join",Color3.fromRGB(0,200,100))
joinBtn.Parent = btnBar

local spamBtn = makeBtn("Spam Join",Color3.fromRGB(200,80,80))
spamBtn.Parent = btnBar

local copyBtn = makeBtn("Copy JobId",Color3.fromRGB(80,140,255))
copyBtn.Parent = btnBar

local noRenderBtn = makeBtn("No Render",Color3.fromRGB(120,120,120))
noRenderBtn.Parent = btnBar

-- ===== TOGGLE BUTTON =====
local toggleBtn = Instance.new("TextButton",screenGui)
toggleBtn.Size = UDim2.new(0,45,0,45)
toggleBtn.AnchorPoint = Vector2.new(1,0)
toggleBtn.Position = UDim2.new(1,-10,0,10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggleBtn.BackgroundTransparency = 0.4
toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.Text = "≡"
toggleBtn.BorderSizePixel = 0
Instance.new("UICorner",toggleBtn).CornerRadius = UDim.new(0,12)

-- ===== PLAYER COUNT =====
local function updatePlayerCount()
	playerCountLabel.Text = "Players: "..#Players:GetPlayers().."/"..Players.MaxPlayers
end
updatePlayerCount()
Players.PlayerAdded:Connect(updatePlayerCount)
Players.PlayerRemoving:Connect(updatePlayerCount)

-- ===== FPS =====
local frames,last=0,tick()
RunService.RenderStepped:Connect(function()
	frames+=1
	if tick()-last>=0.5 then
		local fps=math.floor(frames/(tick()-last))
		statsLabel.Text="FPS: "..fps.." | Ping: ..."
		frames=0
		last=tick()
	end
end)

-- ===== PING =====
task.spawn(function()
	while true do
		local ping=Stats.Network.ServerStatsItem:FindFirstChild("Data Ping")
		if ping then
			statsLabel.Text="FPS: "..FPS_LOCK.." | Ping: "..math.floor(ping:GetValue()).." ms"
		end
		task.wait(0.5)
	end
end)

-- ===== JOIN =====
joinBtn.MouseButton1Click:Connect(function()
	if jobBox.Text~="" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId,jobBox.Text,player)
	end
end)

-- ===== SPAM JOIN =====
local spamming=false
spamBtn.MouseButton1Click:Connect(function()
	spamming=not spamming
	spamBtn.Text=spamming and "Stop" or "Spam Join"
	while spamming do
		if jobBox.Text~="" then
			TeleportService:TeleportToPlaceInstance(game.PlaceId,jobBox.Text,player)
		end
		task.wait(1)
	end
end)

-- ===== COPY JOBID =====
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

-- ===== TOGGLE UI =====
local visible=true
toggleBtn.MouseButton1Click:Connect(function()
	visible=not visible
	frame.Visible=visible
end)

-- ===== NO RENDER =====
local noRender=false
local saved={}

local function hide(obj)
	if obj:IsA("BasePart") or obj:IsA("Decal") or obj:IsA("Texture") then
		saved[obj]=obj.Transparency
		obj.Transparency=1
	end
end

local function restore()
	for obj,val in pairs(saved) do
		pcall(function()
			obj.Transparency=val
		end)
	end
	saved={}
end

noRenderBtn.MouseButton1Click:Connect(function()
	noRender=not noRender
	noRenderBtn.Text=noRender and "No Render ON" or "No Render"
	if noRender then
		for _,v in ipairs(Workspace:GetDescendants()) do
			hide(v)
		end
	else
		restore()
	end
end)

Workspace.DescendantAdded:Connect(function(v)
	if noRender then
		hide(v)
	end
end)
