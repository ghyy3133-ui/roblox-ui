-- LocalScript in StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========== GUI ==========
local gui = Instance.new("ScreenGui", playerGui)
gui.ResetOnSpawn = false
gui.Name = "PerfUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 520, 0, 270)
main.Position = UDim2.new(0.5, -260, 0, 30)
main.BackgroundColor3 = Color3.fromRGB(20, 90, 150)
main.BorderSizePixel = 0

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(0, 140, 255)

-- Avatar
local avatar = Instance.new("ImageLabel", main)
avatar.Size = UDim2.new(0, 50, 0, 50)
avatar.Position = UDim2.new(0, 10, 0, 10)
avatar.BackgroundTransparency = 1
avatar.Image = "rbxthumb://type=AvatarHeadShot&id="..player.UserId.."&w=150&h=150"

-- Name
local nameLabel = Instance.new("TextLabel", main)
nameLabel.Size = UDim2.new(1, -80, 0, 30)
nameLabel.Position = UDim2.new(0, 70, 0, 12)
nameLabel.BackgroundTransparency = 1
nameLabel.Text = player.Name.."  (@"..player.Name..")"
nameLabel.TextColor3 = Color3.new(1,1,1)
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextSize = 18
nameLabel.TextXAlignment = Left

-- FPS + Ping
local info = Instance.new("TextLabel", main)
info.Size = UDim2.new(1, -80, 0, 25)
info.Position = UDim2.new(0, 70, 0, 40)
info.BackgroundTransparency = 1
info.Text = "FPS: 0    Ping: 0 ms"
info.TextColor3 = Color3.new(1,1,1)
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextXAlignment = Left

-- ========== BUTTON MAKER ==========
local function makeBtn(text, x, y, w, h, color)
	local b = Instance.new("TextButton", main)
	b.Text = text
	b.Size = UDim2.new(0, w, 0, h)
	b.Position = UDim2.new(0, x, 0, y)
	b.BackgroundColor3 = color
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

-- Buttons giống ảnh
local lowSetBtn   = makeBtn("Low Set",      20, 80, 220, 45, Color3.fromRGB(90,170,90))
local hideMapBtn  = makeBtn("Hide Map: ON", 280, 80, 220, 45, Color3.fromRGB(170,100,100))
local fpsLockBtn  = makeBtn("10",           20, 140, 220, 45, Color3.fromRGB(40,40,40))
local noRenderBtn = makeBtn("No Render: OFF",280,140,220,45, Color3.fromRGB(120,120,120))

-- JobId
local jobText = Instance.new("TextLabel", main)
jobText.Size = UDim2.new(1, -40, 0, 25)
jobText.Position = UDim2.new(0, 20, 0, 195)
jobText.BackgroundTransparency = 1
jobText.TextColor3 = Color3.new(1,1,1)
jobText.Font = Enum.Font.Gotham
jobText.TextSize = 13
jobText.TextXAlignment = Left
jobText.Text = "JobId: "..game.JobId

local jobBox = makeBtn(game.JobId, 20, 220, 480, 35, Color3.fromRGB(30,30,30))
jobBox.TextXAlignment = Left
jobBox.TextWrapped = true
jobBox.TextSize = 12

local joinBtn = makeBtn("Join", 20, 260, 140, 35, Color3.fromRGB(80,180,80))
local spamBtn = makeBtn("Spam Join", 190, 260, 140, 35, Color3.fromRGB(180,100,100))
local copyBtn = makeBtn("Copy", 360, 260, 140, 35, Color3.fromRGB(90,120,180))

-- ========== FPS + PING ==========
local last = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		local fps = frames
		frames = 0
		last = tick()
		
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		info.Text = "FPS: "..fps.."    Ping: "..ping.." ms"
	end
end)

-- ========== FUNCTIONS ==========

-- Low Set
lowSetBtn.MouseButton1Click:Connect(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- Hide Map (KHÔNG LÀM XANH MÀN)
local hidden = false
hideMapBtn.MouseButton1Click:Connect(function()
	hidden = not hidden
	hideMapBtn.Text = "Hide Map: "..(hidden and "ON" or "OFF")

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and not v:IsDescendantOf(player.Character) then
			v.LocalTransparencyModifier = hidden and 1 or 0
		end
	end
end)

-- FPS Lock
local cap = 10
fpsLockBtn.MouseButton1Click:Connect(function()
	cap = (cap == 10 and 30 or 10)
	fpsLockBtn.Text = tostring(cap)
	if setfpscap then
		setfpscap(cap)
	end
end)

-- No Render
local noRender = false
noRenderBtn.MouseButton1Click:Connect(function()
	noRender = not noRender
	noRenderBtn.Text = "No Render: "..(noRender and "ON" or "OFF")
	RunService:Set3dRenderingEnabled(not noRender)
end)

-- Join
joinBtn.MouseButton1Click:Connect(function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

-- Spam Join
local spamming = false
spamBtn.MouseButton1Click:Connect(function()
	spamming = not spamming
	spamBtn.Text = spamming and "Spamming..." or "Spam Join"
	task.spawn(function()
		while spamming do
			TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
			task.wait(1)
		end
	end)
end)

-- Copy JobId
copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(game.JobId)
	end
end)

-- ========== DRAG ==========
local dragging, dragStart, startPos
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)
main.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
