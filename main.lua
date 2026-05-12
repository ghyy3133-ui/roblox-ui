local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local UIStroke = Instance.new("UIStroke")
local Title = Instance.new("TextLabel")
local InfoLabel = Instance.new("TextLabel")
local AvatarImg = Instance.new("ImageLabel")
local JobIdBox = Instance.new("TextBox")
local JoinBtn = Instance.new("TextButton")
local CopyBtn = Instance.new("TextButton")
local WhiteScreenBtn = Instance.new("TextButton")
local ToggleBtn = Instance.new("TextButton")
local WhiteFrame = Instance.new("Frame")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

ScreenGui.Name = "ToolByNamThanK11"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

WhiteFrame.Name = "WhiteFrame"
WhiteFrame.Parent = ScreenGui
WhiteFrame.BackgroundColor3 = Color3.new(1, 1, 1)
WhiteFrame.Size = UDim2.new(1, 0, 1, 0)
WhiteFrame.ZIndex = 10
WhiteFrame.Visible = true

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BackgroundTransparency = 1
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -150)
MainFrame.Size = UDim2.new(0, 220, 0, 320)
MainFrame.Active = true

UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "ToolByNamThanK11"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.TextSize = 18

AvatarImg.Parent = MainFrame
AvatarImg.Position = UDim2.new(0.5, -35, 0, 35)
AvatarImg.Size = UDim2.new(0, 70, 0, 70)
AvatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)

InfoLabel.Parent = MainFrame
InfoLabel.Position = UDim2.new(0, 10, 0, 110)
InfoLabel.Size = UDim2.new(1, -20, 0, 100)
InfoLabel.BackgroundTransparency = 1
InfoLabel.TextColor3 = Color3.new(1, 1, 1)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left
InfoLabel.TextYAlignment = Enum.TextYAlignment.Top

JobIdBox.Parent = MainFrame
JobIdBox.Position = UDim2.new(0, 10, 0, 215)
JobIdBox.Size = UDim2.new(1, -20, 0, 25)
JobIdBox.PlaceholderText = "Enter Job ID..."
JobIdBox.Text = ""

JoinBtn.Parent = MainFrame
JoinBtn.Position = UDim2.new(0, 10, 0, 245)
JoinBtn.Size = UDim2.new(0, 95, 0, 25)
JoinBtn.Text = "Join Job"
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

CopyBtn.Parent = MainFrame
CopyBtn.Position = UDim2.new(0, 115, 0, 245)
CopyBtn.Size = UDim2.new(0, 95, 0, 25)
CopyBtn.Text = "Copy JobID"
CopyBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

WhiteScreenBtn.Parent = MainFrame
WhiteScreenBtn.Position = UDim2.new(0, 10, 0, 275)
WhiteScreenBtn.Size = UDim2.new(1, -20, 0, 25)
WhiteScreenBtn.Text = "Toggle White Screen (ON)"
WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)

ToggleBtn.Parent = ScreenGui
ToggleBtn.Position = UDim2.new(0, 50, 0, 50)
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Text = "MENU"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)

if setfpscap then setfpscap(15) end

local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	ToggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
ToggleBtn.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = ToggleBtn.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
ToggleBtn.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

ToggleBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

WhiteScreenBtn.MouseButton1Click:Connect(function()
	WhiteFrame.Visible = not WhiteFrame.Visible
	WhiteScreenBtn.Text = "Toggle White Screen (" .. (WhiteFrame.Visible and "ON" or "OFF") .. ")"
end)

CopyBtn.MouseButton1Click:Connect(function()
	setclipboard(game.JobId)
end)

JoinBtn.MouseButton1Click:Connect(function()
	if JobIdBox.Text ~= "" then
		TeleportService:TeleportToPlaceInstance(game.PlaceId, JobIdBox.Text, player)
	end
end)

RunService.RenderStepped:Connect(function()
	local fps = math.floor(1 / RunService.RenderStepped:Wait())
	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	local pCount = #Players:GetPlayers()
	InfoLabel.Text = string.format(
		"Name: %s\nFPS: %d\nPing: %d ms\nPlayers: %d\nPlace ID: %d\nJob ID: %s",
		player.Name, fps, ping, pCount, game.PlaceId, game.JobId
	)
end)
