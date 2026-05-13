local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

-- Khóa FPS 15
pcall(function()
    if setfpscap then setfpscap(15) end
end)

-- Xóa GUI cũ
local guiName = "CustomHorizontalGUI_Fixed"
local targetParent = pcall(function() return gethui() end) and gethui() or CoreGui
if targetParent:FindFirstChild(guiName) then targetParent[guiName]:Destroy() end
if LocalPlayer.PlayerGui:FindFirstChild(guiName) then LocalPlayer.PlayerGui[guiName]:Destroy() end

local GuiParent = pcall(function() return targetParent.Name end) and targetParent or LocalPlayer.PlayerGui

-- Khởi tạo ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- [FIX LỖI 1]: Giúp màn hình trắng full 100% màn hình, không bị hở dải trên
ScreenGui.DisplayOrder = 9999 -- Đẩy GUI lên lớp cao nhất
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = GuiParent

-- Màn hình trắng (Lớp dưới cùng của GUI)
local WhiteScreen = Instance.new("Frame")
WhiteScreen.Name = "WhiteScreen"
WhiteScreen.Size = UDim2.new(1, 0, 1, 0)
WhiteScreen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
WhiteScreen.ZIndex = 1 -- [FIX LỖI 2]: Đặt ZIndex thấp để nằm dưới MainFrame
WhiteScreen.Visible = true
WhiteScreen.Parent = ScreenGui

-- Nút Toggle màu hồng (Lớp trên cùng)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(0, 100, 0, 40)
ToggleBtn.Position = UDim2.new(0.5, -50, 0, 20)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 14
ToggleBtn.Text = "MENU (ON)"
ToggleBtn.ZIndex = 100 -- Luôn hiển thị trên cùng
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Kéo thả nút Toggle
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

-- Khung Main (Lớp giữa: Nằm trên WhiteScreen, Nằm dưới ToggleBtn)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 160)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4
MainFrame.ZIndex = 10 -- [FIX LỖI 2]: Cao hơn WhiteScreen để không bị che
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(0, 150, 255)
MainStroke.Thickness = 2

-- Chức năng Ẩn/Hiện MainFrame
ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    ToggleBtn.Text = MainFrame.Visible and "MENU (ON)" or "MENU (OFF)"
end)

-- Hàm tạo Label (Tự động set ZIndex = 15 để hiển thị rõ trên MainFrame)
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
    lbl.ZIndex = 15
    lbl.Parent = parent
    return lbl
end

-- [AVATAR]
local AvatarImg = Instance.new("ImageLabel")
AvatarImg.Size = UDim2.new(0, 120, 0, 120)
AvatarImg.Position = UDim2.new(0, 20, 0, 20)
AvatarImg.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AvatarImg.BackgroundTransparency = 0.5
AvatarImg.ZIndex = 15
AvatarImg.Parent = MainFrame
Instance.new("UICorner", AvatarImg).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", AvatarImg).Color = Color3.fromRGB(0, 150, 255)

task.spawn(function()
    AvatarImg.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
e
