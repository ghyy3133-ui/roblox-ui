-- Services
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- 1. Lock FPS 15
if setfpscap then
    setfpscap(15)
end

-- 2. Khởi tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HorizontalHub"
ScreenGui.ResetOnSpawn = false

local success, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- White Screen (Chạy ngay lập tức)
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Name = "WhiteScreen"
WhiteScreen.Size = UDim2.new(10, 0, 10, 0)
WhiteScreen.Position = UDim2.new(-5, 0, -5, 0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreen.ZIndex = 9999
WhiteScreen.Visible = true
WhiteScreen.Parent = ScreenGui

-- Nút Toggle Menu (Có thể kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 50, 0, 30)
ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Text = "Menu"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ZIndex = 10000
ToggleBtn.Parent = ScreenGui
Instance.new("UIStroke", ToggleBtn).Color = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 5)

-- Bảng điều khiển CHÍNH (DẠNG NGANG)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 100) -- Chiều ngang rộng, chiều dọc thấp
MainFrame.Position = UDim2.new(0.5, -325, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.ZIndex = 10000
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Tự động sắp xếp các Section nằm ngang
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.FillDirection = Enum.FillDirection.Horizontal
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingLeft = UDim.new(0, 10)
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = MainFrame

-- Section 1: Avatar & Tên
local Section1 = Instance.new("Frame")
Section1.Size = UDim2.new(0, 150, 1, -10)
Section1.BackgroundTransparency = 1
Section1.Parent = MainFrame

local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 60, 0, 60)
AvatarImg.Position = UDim2.new(0, 0, 0.5, -30)
AvatarImg.BackgroundTransparency = 1
AvatarImg.Parent = Section1
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

local NameLbl = Instance.new("TextLabel")
NameLbl.Size = UDim2.new(1, -70, 1, 0)
NameLbl.Position = UDim2.new(0, 70, 0, 0)
NameLbl.BackgroundTransparency = 1
NameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
NameLbl.Font = Enum.Font.GothamBold
NameLbl.TextSize = 12
NameLbl.Text = player.DisplayName
NameLbl.TextWrapped = true
NameLbl.Parent = Section1

-- Section 2: Thông số (FPS, Ping, Player, IDs)
local Section2 = Instance.new("Frame")
Section2.Size = UDim2.new(0, 220, 1, -10)
Section2.BackgroundTransparency = 1
Section2.Parent = MainFrame

local Section2Layout = Instance.new("UIListLayout")
Section2Layout.Parent = Section2
Section2Layout.SortOrder = Enum.SortOrder.LayoutOrder
Section2Layout.Padding = UDim.new(0, 2)

local function createSmallLabel(text, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.Parent = parent
    return lbl
end

local FpsLbl = createSmallLabel("FPS: ...", Section2)
local PingLbl = createSmallLabel("Ping: ...", Section2)
local PlayersLbl = createSmallLabel("Players: ...", Section2)
local PlaceIdLbl = createSmallLabel("Place ID: " .. game.PlaceId, Section2)
local CurrentJobIdLbl = createSmallLabel("Job ID: " .. game.JobId, Section2)
CurrentJobIdLbl.TextSize = 8 -- Nhỏ hơn vì ID rất dài

-- Section 3: Nút & Điều khiển
local Section3 = Instance.new("Frame")
Section3.Size = UDim2.new(0, 240, 1, -10)
Section3.BackgroundTransparency = 1
Section3.Parent = MainFrame

local Section3Layout = Instance.new("UIListLayout")
Section3Layout.Parent = Section3
Section3Layout.Padding = UDim.new(0, 5)

-- Nút Copy & White Screen (Nằm trên cùng dòng)
local BtnRow = Instance.new("Frame")
BtnRow.Size = UDim2.new(1, 0, 0, 25)
BtnRow.BackgroundTransparency = 1
BtnRow.Parent = Section3

local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(0.48, 0, 1, 0)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Text = "Copy JobID"
CopyJobBtn.TextSize = 10
CopyJobBtn.Parent = BtnRow
Instance.new("UICorner", CopyJobBtn)

local WhiteScreenBtn = Instance.new("TextButton")
WhiteScreenBtn.Size = UDim2.new(0.48, 0, 1, 0)
WhiteScreenBtn.Position = UDim2.new(0.52, 0, 0, 0)
WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
WhiteScreenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreenBtn.Text = "Tắt White"
WhiteScreenBtn.TextSize = 10
WhiteScreenBtn.Parent = BtnRow
Instance.new("UICorner", WhiteScreenBtn)

-- Ô nhập Job ID & Nút Join
local JoinRow = Instance.new("Frame")
JoinRow.Size = UDim2.new(1, 0, 0, 25)
JoinRow.BackgroundTransparency = 1
JoinRow.Parent = Section3

local JobIdInput = Instance.new("TextBox")
JobIdInput.Size = UDim2.new(0.7, 0, 1, 0)
JobIdInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JobIdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobIdInput.PlaceholderText = "Nhập Job ID..."
JobIdInput.Text = ""
JobIdInput.TextSize = 10
JobIdInput.Parent = JoinRow
Instance.new("UICorner", JobIdInput)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.25, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.75, 0, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join"
JoinBtn.TextSize = 10
JoinBtn.Parent = JoinRow
Instance.new("UICorner", JoinBtn)

-- 3. Logic Vận Hành
local frames = 0
RunService.RenderStepped:Connect(function() frames = frames + 1 end)

task.spawn(function()
    while task.wait(1) do
        FpsLbl.Text = "FPS: " .. frames
        frames = 0
        local ping = 0
        pcall(function() ping = string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1] end)
        PingLbl.Text = "Ping: " .. tostring(ping) .. " ms"
        PlayersLbl.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    end
end)

ToggleBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

CopyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
end)

JoinBtn.MouseButton1Click:Connect(function()
    if JobIdInput.Text ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, JobIdInput.Text, player) end
end)

WhiteScreenBtn.MouseButton1Click:Connect(function()
    WhiteScreen.Visible = not WhiteScreen.Visible
    WhiteScreenBtn.Text = WhiteScreen.Visible and "Tắt White" or "Bật White"
    WhiteScreenBtn.BackgroundColor3 = WhiteScreen.Visible and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(50, 200, 50)
end)

-- Kéo thả
local function MakeDraggable(ui)
    local dragging, dragInput, dragStart, startPos
    ui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true dragStart = input.Position startPos = ui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    ui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            ui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

MakeDraggable(ToggleBtn)
MakeDraggable(MainFrame)
