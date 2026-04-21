local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer

-- Xóa GUI cũ nếu đã tồn tại để tránh trùng lặp khi chạy lại script
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

-- TẠO GUI CHÍNH
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui

-- Bảng chính (Giữa màn hình, trong suốt, viền hồng)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BackgroundTransparency = 0.4 -- Bảng trong suốt
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Viền màu hồng
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180) -- Màu hồng (Hot Pink)
UIStroke.Thickness = 2
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- Nút Bật/Tắt UI (Góc trái màn hình)
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 100, 0, 30)
ToggleUIBtn.Position = UDim2.new(0, 20, 0, 20)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ToggleUIBtn.Text = "Toggle Menu"
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.TextSize = 14
ToggleUIBtn.Parent = ScreenGui
local ToggleUICorner = Instance.new("UICorner")
ToggleUICorner.Parent = ToggleUIBtn

ToggleUIBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- HÀM TẠO LABEL
local function createLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 30)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.Text = text
    label.Parent = MainFrame
    return label
end

-- THÔNG TIN CHI TIẾT
local NameLabel = createLabel("Name: " .. player.Name, 20)
local FPSLabel = createLabel("FPS: Calculating...", 60)
local PingLabel = createLabel("Ping: Calculating...", 100)
local PlaceLabel = createLabel("Place ID: " .. game.PlaceId, 140)

local JobIdLabel = createLabel("Job ID: " .. game.JobId, 180)
JobIdLabel.TextScaled = true -- Thu nhỏ text nếu JobID quá dài

-- COPY JOB ID BUTTON
local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(0, 100, 0, 30)
CopyJobBtn.Position = UDim2.new(0, 10, 0, 220)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Text = "Copy Job ID"
CopyJobBtn.Font = Enum.Font.Gotham
CopyJobBtn.TextSize = 14
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
JobInput.Position = UDim2.new(0, 10, 0, 270)
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
JoinBtn.Size = UDim2.new(0, 100, 0, 30)
JoinBtn.Position = UDim2.new(0, 10, 0, 310)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180) -- Màu hồng
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 14
JoinBtn.Parent = MainFrame
Instance.new("UICorner", JoinBtn)

JoinBtn.MouseButton1Click:Connect(function()
    local targetJobId = JobInput.Text
    if targetJobId ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetJobId, player)
    end
end)

-- NO RENDER TOGGLE
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 40)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 370)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: OFF"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.TextSize = 16
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

local noRenderEnabled = false
local noRenderConnection = nil

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    
    if noRenderEnabled then
        NoRenderBtn.Text = "No Render: ON"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        
        -- Code No Render của bạn
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
        
        noRenderConnection = workspace.DescendantAdded:Connect(function(v)
            pcall(function() v.Transparency = 1 end)
        end)
        
    else
        NoRenderBtn.Text = "No Render: OFF"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        
        -- Tắt No Render
        if noRenderConnection then
            noRenderConnection:Disconnect()
            noRenderConnection = nil
        end
        
        -- Khôi phục (Lưu ý: Chỉ khôi phục BasePart và Decal về 0)
        for i,v in next, workspace:GetDescendants() do
            pcall(function()
                if v:IsA("BasePart") or v:IsA("Decal") then
                    v.Transparency = 0
                end
            end)
        end
    end
end)

-- LOOP CẬP NHẬT FPS & PING
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start = TimeFunction(), TimeFunction()
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function()
    -- Tính FPS
    LastIteration = TimeFunction()
    for Index = #FrameUpdateTable, 1, -1 do
        FrameUpdateTable[Index + 1] = FrameUpdateTable[Index] >= LastIteration - 1 and FrameUpdateTable[Index] or nil
    end
    FrameUpdateTable[1] = LastIteration
    local fps = tostring(math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start)))
    FPSLabel.Text = "FPS: " .. fps

    -- Tính Ping
    local ping = "N/A"
    pcall(function()
        ping = tostring(math.round(player:GetNetworkPing() * 1000))
    end)
    PingLabel.Text = "Ping: " .. ping .. " ms"
end)
