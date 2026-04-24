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
ScreenGui.Name = "HubScript"
ScreenGui.ResetOnSpawn = false

-- Bypass cho các executor khác nhau
local success, _ = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not success then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- White Screen (Màn hình trắng, chạy ngay lập tức)
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Name = "WhiteScreen"
WhiteScreen.Size = UDim2.new(10, 0, 10, 0)
WhiteScreen.Position = UDim2.new(-5, 0, -5, 0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreen.ZIndex = 9999
WhiteScreen.Visible = true
WhiteScreen.Parent = ScreenGui

-- Nút Toggle (Bật/Tắt bảng điều khiển - Có thể kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 60, 0, 60)
ToggleBtn.Position = UDim2.new(0, 20, 0.5, -30)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleBtn.BackgroundTransparency = 0.5
ToggleBtn.Text = "Menu"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.ZIndex = 10000
ToggleBtn.Parent = ScreenGui

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(0, 170, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = ToggleBtn

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

-- Bảng điều khiển chính (Nền trong suốt, viền xanh - Có thể kéo thả)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 420)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.3
MainFrame.ZIndex = 10000
MainFrame.Visible = false -- Ẩn lúc đầu để không bị đè lên White Screen
MainFrame.Parent = ScreenGui

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 170, 255)
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Cấu trúc tự động sắp xếp layout trong MainFrame
local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = MainFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 15)
UIPadding.PaddingBottom = UDim.new(0, 15)
UIPadding.Parent = MainFrame

-- Hàm tạo các dòng Text (Label)
local function createLabel(text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 25)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 14
    lbl.Text = text
    lbl.ZIndex = 10001
    lbl.Parent = MainFrame
    return lbl
end

-- Hiển thị Avatar
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 80, 0, 80)
AvatarImg.BackgroundTransparency = 1
AvatarImg.ZIndex = 10001
AvatarImg.Parent = MainFrame
local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0) -- Làm tròn ảnh
avatarCorner.Parent = AvatarImg
pcall(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
end)

-- Tạo các nhãn thông số
local NameLbl = createLabel("Name: " .. player.Name)
local FpsLbl = createLabel("FPS: ...")
local PingLbl = createLabel("Ping: ...")
local PlayersLbl = createLabel("Players: " .. #Players:GetPlayers())
local PlaceIdLbl = createLabel("Place ID: " .. game.PlaceId)

-- Nút Copy Job ID
local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(1, -30, 0, 30)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Font = Enum.Font.GothamMedium
CopyJobBtn.TextSize = 14
CopyJobBtn.Text = "Copy Job ID"
CopyJobBtn.ZIndex = 10001
CopyJobBtn.Parent = MainFrame
Instance.new("UICorner", CopyJobBtn).CornerRadius = UDim.new(0, 5)

-- Ô Nhập Job ID & Nút Join
local JoinFrame = Instance.new("Frame")
JoinFrame.Size = UDim2.new(1, -30, 0, 30)
JoinFrame.BackgroundTransparency = 1
JoinFrame.ZIndex = 10001
JoinFrame.Parent = MainFrame

local JobIdInput = Instance.new("TextBox")
JobIdInput.Size = UDim2.new(0.65, -5, 1, 0)
JobIdInput.Position = UDim2.new(0, 0, 0, 0)
JobIdInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
JobIdInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobIdInput.Font = Enum.Font.Gotham
JobIdInput.TextSize = 12
JobIdInput.PlaceholderText = "Nhập Job ID vào đây..."
JobIdInput.Text = ""
JobIdInput.ClearTextOnFocus = false
JobIdInput.ZIndex = 10001
JobIdInput.Parent = JoinFrame
Instance.new("UICorner", JobIdInput).CornerRadius = UDim.new(0, 5)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.35, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.65, 5, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 14
JoinBtn.Text = "Join"
JoinBtn.ZIndex = 10001
JoinBtn.Parent = JoinFrame
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 5)

-- Nút Bật/Tắt White Screen
local WhiteScreenBtn = Instance.new("TextButton")
WhiteScreenBtn.Size = UDim2.new(1, -30, 0, 30)
WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
WhiteScreenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreenBtn.Font = Enum.Font.GothamBold
WhiteScreenBtn.TextSize = 14
WhiteScreenBtn.Text = "Tắt White Screen"
WhiteScreenBtn.ZIndex = 10001
WhiteScreenBtn.Parent = MainFrame
Instance.new("UICorner", WhiteScreenBtn).CornerRadius = UDim.new(0, 5)

-- 3. Logic Vận Hành (FPS, Ping)
local frames = 0
RunService.RenderStepped:Connect(function()
    frames = frames + 1
end)

task.spawn(function()
    while task.wait(1) do
        -- Tính FPS
        FpsLbl.Text = "FPS: " .. frames
        frames = 0
        
        -- Tính Ping (sẽ phụ thuộc vào Network Stats)
        local ping = 0
        pcall(function()
            ping = string.split(Stats.Network.ServerStatsItem["Data Ping"]:GetValueString(), " ")[1]
        end)
        PingLbl.Text = "Ping: " .. tostring(ping) .. " ms"
        
        -- Đếm Players
        PlayersLbl.Text = "Players: " .. #Players:GetPlayers() .. "/" .. Players.MaxPlayers
    end
end)

-- 4. Chức năng các nút bấm
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

CopyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyJobBtn.Text = "Đã Copy!"
        task.wait(1.5)
        CopyJobBtn.Text = "Copy Job ID"
    else
        CopyJobBtn.Text = "Lỗi: Executor không hỗ trợ"
        task.wait(1.5)
        CopyJobBtn.Text = "Copy Job ID"
    end
end)

JoinBtn.MouseButton1Click:Connect(function()
    local jobId = JobIdInput.Text
    if jobId and jobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId, player)
    end
end)

WhiteScreenBtn.MouseButton1Click:Connect(function()
    WhiteScreen.Visible = not WhiteScreen.Visible
    if WhiteScreen.Visible then
        WhiteScreenBtn.Text = "Tắt White Screen"
        WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    else
        WhiteScreenBtn.Text = "Bật White Screen"
        WhiteScreenBtn.BackgroundColor3 = Color3.fromRGB(70, 200, 70)
    end
end)

-- 5. Logic Kéo Thả (Draggable) cho Frame và Nút
local function MakeDraggable(uiElement)
    local dragging, dragInput, dragStart, startPos
    
    uiElement.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = uiElement.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    uiElement.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            uiElement.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

MakeDraggable(ToggleBtn)
MakeDraggable(MainFrame)
