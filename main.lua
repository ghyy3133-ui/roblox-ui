local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local userId = player.UserId
local fileName = "Note_" .. userId .. ".txt"

-- Lock FPS xuống 10 để treo máy nhẹ hơn
if setfpscap then setfpscap(10) end

-- Xóa GUI cũ
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- WHITE SCREEN FRAME (Phủ toàn màn hình)
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Size = UDim2.new(1, 0, 1, 0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreen.Visible = false
WhiteScreen.ZIndex = 10 -- Đảm bảo đè lên game
WhiteScreen.Parent = ScreenGui

-- BẢNG CHÍNH
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 310) -- Thu nhỏ lại cho gọn
MainFrame.Position = UDim2.new(0.5, -125, 0, 5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Parent = ScreenGui
MainFrame.ZIndex = 11 -- Hiện trên White Screen

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- HỆ THỐNG DRAG (Giữ nguyên)
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true; dragStart = input.Position; startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragToggle = false end end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- AVATAR & NAME
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 40, 0, 40)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
AvatarImage.Parent = MainFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 170, 0, 20)
NameLabel.Position = UDim2.new(0, 60, 0, 10)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
NameLabel.Text = player.DisplayName
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = MainFrame

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLabel.Position = UDim2.new(0, 60, 0, 25)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatsLabel.Text = "Loading..."
StatsLabel.Font = Enum.Font.GothamSemibold
StatsLabel.TextSize = 10
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.Parent = MainFrame

-- RÚT GỌN NOTE BOX (Bằng kích thước ô Job ID)
local NoteBox = Instance.new("TextBox")
NoteBox.Size = UDim2.new(1, -20, 0, 25)
NoteBox.Position = UDim2.new(0, 10, 0, 60)
NoteBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
NoteBox.PlaceholderText = "📝 Ghi chú nhanh..."
NoteBox.Font = Enum.Font.Gotham
NoteBox.TextSize = 11
NoteBox.Parent = MainFrame
Instance.new("UICorner", NoteBox)

-- LƯU/LOAD NOTE
local function saveNote() if writefile then writefile(fileName, NoteBox.Text) end end
if isfile and isfile(fileName) then NoteBox.Text = readfile(fileName) end
NoteBox.FocusLost:Connect(saveNote)

-- JOB ID & BUTTONS
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 25)
JobInput.Position = UDim2.new(0, 10, 0, 95)
JobInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Dán Job ID..."
JobInput.TextSize = 11
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, 0, 0, 25)
CopyBtn.Position = UDim2.new(0, 10, 0, 130)
CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Text = "Copy JobID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.TextSize = 11
CopyBtn.Parent = MainFrame
Instance.new("UICorner", CopyBtn)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.48, 0, 0, 25)
JoinBtn.Position = UDim2.new(0.52, 0, 0, 130)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 11
JoinBtn.Parent = MainFrame
Instance.new("UICorner", JoinBtn)

-- NÚT CHỨC NĂNG PHỤ
local function createToggleBtn(text, posY, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, posY)
    btn.BackgroundColor3 = color
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.Parent = MainFrame
    Instance.new("UICorner", btn)
    return btn
end

local NoRenderBtn = createToggleBtn("No Render: ON", 170, Color3.fromRGB(20, 60, 20))
local WhiteScreenBtn = createToggleBtn("White Screen: OFF", 215, Color3.fromRGB(60, 20, 20))

-- LOGIC TỐI ƯU VÒNG LẶP (Chạy mỗi 1 giây cho Ping/Player)
local lastUpdate = 0
local frameCount = 0
local fps = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if os.clock() - lastUpdate >= 1 then
        fps = frameCount
        frameCount = 0
        local ping = "N/A"
        pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
        StatsLabel.Text = string.format("FPS: %d | Ping: %s ms | PLR: %d/%d", fps, tostring(ping), #Players:GetPlayers(), Players.MaxPlayers)
        lastUpdate = os.clock()
    end
end)

-- LOGIC CHỨC NĂNG
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId); CopyBtn.Text = "Đã Copy!"; task.wait(1); CopyBtn.Text = "Copy JobID" end
end)

JoinBtn.MouseButton1Click:Connect(function()
    if JobInput.Text ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, JobInput.Text, player) end
end)

local renderOn = true
NoRenderBtn.MouseButton1Click:Connect(function()
    renderOn = not renderOn
    NoRenderBtn.Text = renderOn and "No Render: ON" or "No Render: OFF"
    NoRenderBtn.BackgroundColor3 = renderOn and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    RunService:Set3dRenderingEnabled(not renderOn) -- Cách tối ưu nhất để tắt render 3D
end)

WhiteScreenBtn.MouseButton1Click:Connect(function()
    WhiteScreen.Visible = not WhiteScreen.Visible
    WhiteScreenBtn.Text = WhiteScreen.Visible and "White Screen: ON" or "White Screen: OFF"
    WhiteScreenBtn.BackgroundColor3 = WhiteScreen.Visible and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
end)

-- NÚT MENU ẨN/HIỆN
local ShowHideBtn = Instance.new("TextButton")
ShowHideBtn.Size = UDim2.new(0, 60, 0, 22)
ShowHideBtn.Position = UDim2.new(0, 10, 0, 5)
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShowHideBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ShowHideBtn.Text = "Menu"
ShowHideBtn.Parent = ScreenGui
Instance.new("UICorner", ShowHideBtn)
ShowHideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

-- Mặc định chạy tối ưu
RunService:Set3dRenderingEnabled(false) 
