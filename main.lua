-- LocalScript đặt trong StarterGui

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ================= GUI =================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPS_PING_UI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 500, 0, 230)
main.Position = UDim2.new(0.5, -250, 0, 20)
main.BackgroundColor3 = Color3.fromRGB(25, 70, 120)
main.BorderSizePixel = 0
main.Parent = screenGui

local corner = Instance.new("UICorner", main)
corner.CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 5)
title.BackgroundTransparency = 1
title.Text = player.Name.."  (@"..player.Name..")"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Left
title.Parent = main

-- FPS + Ping
local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 30)
info.Position = UDim2.new(0, 10, 0, 45)
info.BackgroundTransparency = 1
info.TextColor3 = Color3.new(1,1,1)
info.Font = Enum.Font.Gotham
info.TextSize = 14
info.TextXAlignment = Left
info.Text = "FPS: 0   Ping: 0 ms"
info.Parent = main

-- ================= BUTTON CREATOR =================
local function createButton(text, pos, size, color)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = color
	b.Text = text
	b.TextColor3 = Color3.new(1,1,1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.BorderSizePixel = 0
	b.Parent = main
	
	local c = Instance.new("UICorner", b)
	c.CornerRadius = UDim.new(0, 8)
	
	return b
end

-- Buttons
local fpsBtn = createButton("Low Set", UDim2.new(0, 10, 0, 90), UDim2.new(0, 220, 0, 40), Color3.fromRGB(90, 170, 90))
local hideMapBtn = createButton("Hide Map: OFF", UDim2.new(0, 260, 0, 90), UDim2.new(0, 220, 0, 40), Color3.fromRGB(170, 100, 100))
local fpsLockBtn = createButton("FPS Lock: 60", UDim2.new(0, 10, 0, 140), UDim2.new(0, 220, 0, 40), Color3.fromRGB(60, 60, 60))
local noRenderBtn = createButton("No Render: OFF", UDim2.new(0, 260, 0, 140), UDim2.new(0, 220, 0, 40), Color3.fromRGB(120, 120, 120))

-- ================= JOB ID =================
local jobLabel = Instance.new("TextLabel")
jobLabel.Size = UDim2.new(1, -20, 0, 30)
jobLabel.Position = UDim2.new(0, 10, 0, 190)
jobLabel.BackgroundTransparency = 1
jobLabel.TextColor3 = Color3.new(1,1,1)
jobLabel.Font = Enum.Font.Gotham
jobLabel.TextSize = 13
jobLabel.TextXAlignment = Left
jobLabel.Text = "JobId: "..game.JobId
jobLabel.Parent = main

local joinBtn = createButton("Join", UDim2.new(0, 10, 0, 220), UDim2.new(0, 140, 0, 35), Color3.fromRGB(90, 180, 90))
local spamJoinBtn = createButton("Spam Join", UDim2.new(0, 180, 0, 220), UDim2.new(0, 140, 0, 35), Color3.fromRGB(180, 100, 100))
local copyBtn = createButton("Copy", UDim2.new(0, 350, 0, 220), UDim2.new(0, 140, 0, 35), Color3.fromRGB(90, 120, 180))

-- ================= FPS + PING =================
local last = tick()
local frames = 0

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		local fps = frames
		frames = 0
		last = tick()
		
		local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		info.Text = "FPS: "..fps.."   Ping: "..ping.." ms"
	end
end)

-- ================= FEATURES =================

-- Low Graphics
fpsBtn.MouseButton1Click:Connect(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- Hide Map
local hideMap = false
hideMapBtn.MouseButton1Click:Connect(function()
	hideMap = not hideMap
	hideMapBtn.Text = "Hide Map: "..(hideMap and "ON" or "OFF")
	
	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			if hideMap then
				v.Transparency = 1
				v.CanCollide = false
			else
				v.Transparency = 0
				v.CanCollide = true
			end
		end
	end
end)

-- FPS Lock (chỉ hoạt động trên executor hỗ trợ setfpscap)
local fpsCap = 60
fpsLockBtn.MouseButton1Click:Connect(function()
	fpsCap = (fpsCap == 60 and 30 or 60)
	fpsLockBtn.Text = "FPS Lock: "..fpsCap
	
	if setfpscap then
		setfpscap(fpsCap)
	end
end)

-- No Render
local noRender = false
noRenderBtn.MouseButton1Click:Connect(function()
	noRender = not noRender
	noRenderBtn.Text = "No Render: "..(noRender and "ON" or "OFF")
	
	RunService:Set3dRenderingEnabled(not noRender)
end)

-- ================= JOB ID FUNCTIONS =================

-- Join server bằng JobId
joinBtn.MouseButton1Click:Connect(function()
	if game.JobId ~= "" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
	end
end)

-- Spam Join
local spamming = false
spamJoinBtn.MouseButton1Click:Connect(function()
	spamming = not spamming
	spamJoinBtn.Text = spamming and "Spamming..." or "Spam Join"
	
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

-- ================= DRAG UI =================
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
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
