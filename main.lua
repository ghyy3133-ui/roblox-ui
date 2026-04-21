local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

-- Xóa GUI cũ nếu đã tồn tại
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

-- TẠO GUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui

-- Bảng chính (Thu gọn lại: 300x360)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 360)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180) -- Viền hồng
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Nút Bật/Tắt UI
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 90, 0, 25)
ToggleUIBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ToggleUIBtn.Text = "Toggle Menu"
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.TextSize = 12
ToggleUIBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleUIBtn)

ToggleUIBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- HÀM TẠO LABEL
local function createLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 13
    label.Text = text
    label.Parent = MainFrame
    return label
end

-- THÔNG TIN (Khoảng cách được ép nhỏ lại)
local NameLabel = createLabel("Name: " .. player.Name, 10)
local FPSLabel = createLabel("FPS: Calculating...", 35)
local PingLabel = createLabel("Ping: Calculating...", 60)
local PlaceLabel = createLabel("Place ID: " .. game.PlaceId, 85)

local JobIdLabel = createLabel("Job ID: " .. game.JobId, 110)
JobIdLabel.TextScaled = true 

-- COPY JOB ID BUTTON
local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(0, 90, 0, 25)
CopyJobBtn.Position = UDim2.new(0, 10, 0, 140)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Text = "Copy Job ID"
CopyJobBtn.Font = Enum.Font.Gotham
CopyJobBtn.TextSize = 12
CopyJobBtn.Parent = MainFrame
Instance.new("UICorner", CopyJobBtn)

CopyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(game.JobId)
        CopyJobBtn.Text = "Copied!"
        task.wait(1)
        CopyJobBtn.Text = "Copy Job ID"
    end
end)

-- Ô NHẬP JOB ID ĐỂ JOIN
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 30)
JobInput.Position = UDim2.new(0, 10, 0, 175)
JobInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Paste Target Job ID here..."
JobInput.Text = ""
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 12
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

-- NÚT JOIN SERVER
local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0, 90, 0, 30)
JoinBtn.Position = UDim2.new(0, 10, 0, 215)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 13
JoinBtn.Parent = MainFrame
Instance.new("UICorner", JoinBtn)

JoinBtn.MouseButton1Click:Connect(function()
    local targetJobId = JobInput.Text
    if targetJobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, player)
    end
end)

-- NO RENDER TOGGLE (Mặc định ON)
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 35)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 310)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20) -- Màu xanh lá đậm vì mặc định đang ON
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.TextSize = 14
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

local noRenderEnabled = true
local noRenderConnection = nil

local function enableNoRender()
    for i,v in next, workspace:GetDescendants() do
        pcall(function() v.Transparency = 1 end)
    end
    if getnilinstances then
        for i,v in next, getnilinstances() do
            pcall(function()
                v.Transparency = 1
                for i1,v1 in next, v:GetDescendants() do
                    v1.Transparency = 1
                end
            end)
        end
    end
    if not noRenderConnection then
        noRenderConnection = workspace.DescendantAdded:Connect(function(v)
            pcall(function() v.Transparency = 1 end)
        end)
    end
end

local function disableNoRender()
    if noRenderConnection then
        noRenderConnection:Disconnect()
        noRenderConnection = nil
    end
    for i,v in next, workspace:GetDescendants() do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = 0
            end
        end)
    end
end

-- KÍCH HOẠT NO RENDER NGAY KHI CHẠY SCRIPT
enableNoRender()

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    if noRenderEnabled then
        NoRenderBtn.Text = "No Render: ON"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        enableNoRender()
    else
        NoRenderBtn.Text = "No Render: OFF"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        disableNoRender()
    end
end)

-- LOOP CẬP NHẬT FPS & PING
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start = TimeFunction(), TimeFunction()
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function()
    LastIteration = TimeFunction()
    for Index = #FrameUpdateTable, 1, -1 do
        FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
    end
    FrameUpdateTable[1] = LastIteration
    local fps = tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start)))
    FPSLabel.Text = "FPS: " .. fps

    local ping = "N/A"
    pcall(function()
        ping = tostring(math.round(player:GetNetworkPing() * 1000))
    end)
    PingLabel.Text = "Ping: " .. ping .. " ms"
end)
