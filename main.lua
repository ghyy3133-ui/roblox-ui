--[=[
    ROBLOX HORIZONTAL MULTI-FUNCTION GUI
    Yêu cầu: Executor hỗ trợ setfpscap, setclipboard, gethui (tùy chọn)
]=]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- 1. Khóa FPS ở mức 15 ngay khi chạy script
pcall(function()
    if setfpscap then
        setfpscap(15)
    end
end)

-- Xóa GUI cũ nếu đã tồn tại để tránh trùng lặp
local guiName = "CustomHorizontalGUI_15FPS"
local targetParent = pcall(function() return gethui() end) and gethui() or CoreGui
if targetParent:FindFirstChild(guiName) then
    targetParent[guiName]:Destroy()
end
if LocalPlayer.PlayerGui:FindFirstChild(guiName) then
    LocalPlayer.PlayerGui[guiName]:Destroy()
end

-- Sử dụng PlayerGui nếu CoreGui bị chặn
local GuiParent = pcall(function() return targetParent.Name end) and targetParent or LocalPlayer.PlayerGui

-- 2. Khởi tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

-- 3. Màn hình trắng (White Screen) - Bật ngay khi chạy script
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Name = "WhiteScreen"
WhiteScreen.Size = UDim2.new(1, 0, 1, 0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreen.ZIndex = 999
WhiteScreen.Visible = true -- Bật ngay lập tức
WhiteScreen.Parent = ScreenGui

-- 4. Nút Toggle (Màu hồng, có thể kéo thả)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -50, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Text = "MENU (ON)"
ToggleBtn.ZIndex = 1000
ToggleBtn.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleBtn

-- Hàm kéo thả cho Nút Toggle
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            local delta = dragInput.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(ToggleBtn)

-- 5. Khung Main (Nằm ngang, nền trong suốt, viền xanh nước biển)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 160)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4 -- Nền bán trong suốt
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(0, 150, 255) -- Viền xanh nước biển
MainStroke.Thickness = 2
MainStroke.Parent = MainFrame

-- Chức năng Ẩn/Hiện MainFrame
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "MENU (ON)" or "MENU (OFF)"
end)

-- [PHẦN 1: AVATAR] (Bên trái)
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 120, 0, 120)
AvatarImg.Position = UDim2.new(0, 20, 0, 20)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.BackgroundTransparency = 0.5
AvatarImg.Parent = MainFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0) -- Bo tròn thành hình tròn
AvatarCorner.Parent = AvatarImg

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Color3.fromRGB(0, 150, 255)
AvatarStroke.Parent = AvatarImg

-- Load Avatar
task.spawn(function()
    local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    AvatarImg.Image = content
end)

-- Tạo template Label để tái sử dụng
local function createLabel(text, pos, size, parent)
    local lbl = Instance.new("TextLabel")
    lbl.Size = size
    lbl.Position = pos
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = text
    lbl.Parent = parent
    return lbl
end

-- [PHẦN 2: THÔNG TIN SERVER & PLAYER] (Ở giữa)
local NameLabel = createLabel("Name: " .. LocalPlayer.DisplayName .. " (@" .. LocalPlayer.Name .. ")", UDim2.new(0, 160, 0, 15), UDim2.new(0, 300, 0, 20), MainFrame)
local FpsLabel = createLabel("FPS: ...", UDim2.new(0, 160, 0, 40), UDim2.new(0, 140, 0, 20), MainFrame)
local PingLabel = createLabel("Ping: ...", UDim2.new(0, 310, 0, 40), UDim2.new(0, 140, 0, 20), MainFrame)
local PlayersLabel = createLabel("Players: ...", UDim2.new(0, 160, 0, 65), UDim2.new(0, 300, 0, 20), MainFrame)
local PlaceIdLabel = createLabel("Place ID: " .. game.PlaceId, UDim2.new(0, 160, 0, 90), UDim2.new(0, 300, 0, 20), MainFrame)

local JobIdLabel = createLabel("Job ID: " .. string.sub(game.JobId, 1, 28) .. "...", UDim2.new(0, 160, 0, 115), UDim2.new(0, 240, 0, 20), MainFrame)
JobIdLabel.TextSize = 11

-- Nút Copy Job ID
local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(0, 50, 0, 22)
CopyJobBtn.Position = UDim2.new(0, 410, 0, 114)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Font = Enum.Font.GothamBold
CopyJobBtn.TextSize = 11
CopyJobBtn.Text = "Copy"
CopyJobBtn.Parent = MainFrame
Instance.new("UICorner", CopyJobBtn).CornerRadius = UDim.new(0, 4)

CopyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyJobBtn.Text = "Copied!"
        task.wait(1.5)
        CopyJobBtn.Text = "Copy"
    else
        CopyJobBtn.Text = "Error"
    end
end)

-- [PHẦN 3: CÁC CHỨC NĂNG TƯƠNG TÁC] (Bên phải)
-- Ô nhập Job ID
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(0, 220, 0, 30)
JobInput.Position = UDim2.new(0, 480, 0, 20)
JobInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JobInput.BackgroundTransparency = 0.3
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 11
JobInput.PlaceholderText = "Paste Job ID here to join..."
JobInput.Text = ""
JobInput.ClearTextOnFocus = false
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", JobInput).Color = Color3.fromRGB(0, 150, 255)

-- Nút Join Job ID
local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0, 60, 0, 30)
JoinBtn.Position = UDim2.new(0, 710, 0, 20)
JoinBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 83) -- Màu xanh lá
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 12
JoinBtn.Text = "Join"
JoinBtn.Parent = MainFrame
Instance.new("UICorner", JoinBtn).CornerRadius = UDim.new(0, 6)

JoinBtn.MouseButton1Click:Connect(function()
    local targetJob = string.gsub(JobInput.Text, " ", "")
    if targetJob ~= "" then
        JoinBtn.Text = "Joining..."
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJob, LocalPlayer)
        end)
        task.wait(2)
        JoinBtn.Text = "Join"
    end
end)

-- Khung Bật/Tắt White Screen
local WsLabel = createLabel("White Screen (Tối ưu máy):", UDim2.new(0, 480, 0, 80), UDim2.new(0, 200, 0, 20), MainFrame)
local WsToggleBtn = Instance.new("TextButton")
WsToggleBtn.Size = UDim2.new(0, 80, 0, 30)
WsToggleBtn.Position = UDim2.new(0, 480, 0, 105)
WsToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255) -- Đang bật mặc định
WsToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WsToggleBtn.Font = Enum.Font.GothamBold
WsToggleBtn.TextSize = 12
WsToggleBtn.Text = "ON"
WsToggleBtn.Parent = MainFrame
Instance.new("UICorner", WsToggleBtn).CornerRadius = UDim.new(0, 6)

WsToggleBtn.MouseButton1Click:Connect(function()
    WhiteScreen.Visible = not WhiteScreen.Visible
    if WhiteScreen.Visible then
        WsToggleBtn.Text = "ON"
        WsToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    else
        WsToggleBtn.Text = "OFF"
        WsToggleBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    end
end)

-- 6. Vòng lặp cập nhật FPS, Ping và Số người chơi
local frameCount = 0
local startRealTime = os.clock()

RunService.RenderStepped:Connect(function()
    frameCount += 1
    local currentTime = os.clock()
    
    -- Cập nhật mỗi giây
    if currentTime - startRealTime >= 1 then
        -- Tính FPS
        local fps = math.floor(frameCount / (currentTime - startRealTime))
        FpsLabel.Text = "FPS: " .. fps
        
        -- Tính Ping
        local ping = 0
        pcall(function()
            ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        end)
        PingLabel.Text = "Ping: " .. ping .. " ms"
        
        -- Cập nhật số người chơi
        local currentPlayers = #Players:GetPlayers()
        local maxPlayers = Players.MaxPlayers
        PlayersLabel.Text = "Players: " .. currentPlayers .. " / " .. maxPlayers

        -- Reset biến đếm
        frameCount = 0
        startRealTime = currentTime
    end
end)
