-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Create Main ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomInfoGui"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Create Main Frame (Cartoony & Dark Style)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 210)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- UI Corner for Main Frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = mainFrame

-- UI Stroke for border effect
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(80, 80, 110)
uiStroke.Thickness = 2
uiStroke.Parent = mainFrame

-- UI Layout
local layout = Instance.new("UIListLayout")
layout.Parent = mainFrame
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI Padding
local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 12)
padding.PaddingBottom = UDim.new(0, 12)
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 12)
padding.Parent = mainFrame

-- Title Header
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, 0, 0, 26)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 230, 109)
titleLabel.Font = Enum.Font.FredokaOne
titleLabel.TextSize = 16
titleLabel.Text = "PLAYER STATS"
titleLabel.LayoutOrder = 1
titleLabel.Parent = mainFrame

-- Utility function to create cartoony labels without icons
local function createLabel(name, order)
	local label = Instance.new("TextLabel")
	label.Name = name
	label.Size = UDim2.new(1, 0, 0, 28)
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Font = Enum.Font.FredokaOne
	label.TextSize = 14
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.LayoutOrder = order
	label.Parent = mainFrame
	return label
end

-- 1. Name Display
local nameLabel = createLabel("NameLabel", 2)
nameLabel.Text = "Name: " .. LocalPlayer.Name
nameLabel.TextColor3 = Color3.fromRGB(255, 209, 102)

-- 2. FPS Display
local fpsLabel = createLabel("FPSLabel", 3)
fpsLabel.Text = "FPS: Measuring..."
fpsLabel.TextColor3 = Color3.fromRGB(6, 214, 160)

-- 3. Players Count Display
local playersLabel = createLabel("PlayersLabel", 4)
playersLabel.Text = "Players: 0"
playersLabel.TextColor3 = Color3.fromRGB(17, 138, 178)

-- 4. Reset Button
local resetButton = Instance.new("TextButton")
resetButton.Name = "ResetButton"
resetButton.Size = UDim2.new(1, 0, 0, 38)
resetButton.BackgroundColor3 = Color3.fromRGB(239, 71, 111)
resetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
resetButton.Font = Enum.Font.FredokaOne
resetButton.TextSize = 15
resetButton.Text = "Reset Character"
resetButton.AutoButtonColor = true
resetButton.LayoutOrder = 5
resetButton.Parent = mainFrame

-- Button Corner
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 10)
btnCorner.Parent = resetButton

-- Button Stroke
local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 255, 255)
btnStroke.Transparency = 0.5
btnStroke.Thickness = 1.5
btnStroke.Parent = resetButton

-----------------------------------

-- Note Storage
local noteFile="Notes/"..LocalPlayer.UserId..".txt"
if makefolder and not isfolder("Notes") then pcall(makefolder,"Notes") end
local noteBox=Instance.new("TextBox")
noteBox.Size=UDim2.new(1,0,0,60)
noteBox.BackgroundColor3=Color3.fromRGB(40,40,55)
noteBox.TextColor3=Color3.new(1,1,1)
noteBox.Font=Enum.Font.FredokaOne
noteBox.TextWrapped=true
noteBox.ClearTextOnFocus=false
noteBox.PlaceholderText="Note for this account..."
noteBox.LayoutOrder=6
noteBox.Parent=mainFrame
local nc=Instance.new("UICorner",noteBox)
if isfile and isfile(noteFile) then
 pcall(function() noteBox.Text=readfile(noteFile) end)
end
noteBox.FocusLost:Connect(function()
 if writefile then pcall(function() writefile(noteFile,noteBox.Text) end) end
end)

-- LOGIC & FUNCTIONS
-----------------------------------

-- Update Players Count
local function updatePlayersCount()
	playersLabel.Text = "Players: " .. #Players:GetPlayers()
end

Players.PlayerAdded:Connect(updatePlayersCount)
Players.PlayerRemoving:Connect(updatePlayersCount)
updatePlayersCount()

-- Update FPS (Frames Per Second)
local lastTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
	frameCount = frameCount + 1
	local currentTime = tick()
	
	if currentTime - lastTime >= 1 then
		fpsLabel.Text = "FPS: " .. frameCount
		frameCount = 0
		lastTime = currentTime
	end
end)

-- Reset Character Button Action
resetButton.MouseButton1Click:Connect(function()
	local character = LocalPlayer.Character
	if character then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Health = 0
		end
	end
end)
