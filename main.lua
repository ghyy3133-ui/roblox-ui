local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Xóa GUI cũ
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- Bảng chính (Đặt ở trên cùng chính giữa)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 280)
MainFrame.Position = UDim2.new(0.5, -150, 0, 20) -- Trên cùng chính giữa
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Chức năng kéo (cơ bản)
MainFrame.Parent = ScreenGui

-- Chức năng kéo mượt mà hơn (Smooth Drag)
local function makeDraggable(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(MainFrame)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180) -- Viền hồng
UIStroke.Thickness = 1.8
UIStroke.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = MainFrame

-- Nút Toggle Show/Hide
local ToggleUIBtn = Instance.new("TextButton")
ToggleUIBtn.Size = UDim2.new(0, 80, 0, 25)
ToggleUIBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleUIBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleUIBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ToggleUIBtn.Text = "Show/Hide"
ToggleUIBtn.Font = Enum.Font.GothamBold
ToggleUIBtn.TextSize = 11
ToggleUIBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleUIBtn)

ToggleUIBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local function createLabel(text, posY)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 18)
    label.Position = UDim2.new(0, 10, 0, posY)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(230, 230, 230)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 12
    label.Text = text
    label.Parent = MainFrame
    return label
end

-- Thông tin
local NameLabel = createLabel("User: " .. player.Name, 15)
local FPSLabel = createLabel("FPS: ...", 35)
local PingLabel = createLabel("Ping: ...", 55)
local PlaceLabel = createLabel("Place ID: " .. game.PlaceId, 75)
local JobIdLabel = createLabel("Job ID: " .. game.JobId, 95)
JobIdLabel.TextScaled = true

-- Input Job ID
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 28)
JobInput.Position = UDim2.new(0, 10, 0, 125)
JobInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Enter Job ID to join..."
JobInput.Text = ""
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 12
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

-- Hàng nút Copy & Join
local ButtonFrame = Instance.new("Frame")
ButtonFrame.Size = UDim2.new(1, -20, 0, 30)
ButtonFrame.Position = UDim2.new(0, 10, 0, 165)
ButtonFrame.BackgroundTransparency = 1
ButtonFrame.Parent = MainFrame

local CopyJobBtn = Instance.new("TextButton")
CopyJobBtn.Size = UDim2.new(0.48, 0, 1, 0)
CopyJobBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyJobBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyJobBtn.Text = "Copy JobID"
CopyJobBtn.Font = Enum.Font.GothamBold
CopyJobBtn.TextSize = 12
CopyJobBtn.Parent = ButtonFrame
Instance.new("UICorner", CopyJobBtn)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.48, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.52, 0, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.TextSize = 12
JoinBtn.Parent = ButtonFrame
Instance.new("UICorner", JoinBtn)

-- Hàng No Render (Mặc định ON)
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 35)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 210)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.TextSize = 13
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

-- LOGIC
CopyJobBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
    CopyJobBtn.Text = "Copied!"
    task.wait(1)
    CopyJobBtn.Text = "Copy JobID"
end)

JoinBtn.MouseButton1Click:Connect(function()
    if JobInput.Text ~= "" then
        TeleportService:TeleportToPlaceInstance(game.PlaceId, JobInput.Text, player)
    end
end)

-- No Render Logic
local noRenderEnabled = true
local noRenderConn = nil

local function toggleRender(state)
    if state then
        for _, v in next, workspace:GetDescendants() do pcall(function() v.Transparency = 1 end) end
        if getnilinstances then
            for _, v in next, getnilinstances() do
                pcall(function() 
                    v.Transparency = 1 
                    for _, d in next, v:GetDescendants() do d.Transparency = 1 end
                end)
            end
        end
        noRenderConn = workspace.DescendantAdded:Connect(function(v) pcall(function() v.Transparency = 1 end) end)
    else
        if noRenderConn then noRenderConn:Disconnect() noRenderConn = nil end
        for _, v in next, workspace:GetDescendants() do
            pcall(function() if v:IsA("BasePart") or v:IsA("Decal") then v.Transparency = 0 end end)
        end
    end
end

toggleRender(true) -- Chạy ngay khi execute

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    if noRenderEnabled then
        NoRenderBtn.Text = "No Render: ON"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
        toggleRender(true)
    else
        NoRenderBtn.Text = "No Render: OFF"
        NoRenderBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        toggleRender(false)
    end
end)

-- FPS & Ping Loop
local TimeFunction = RunService:IsRunning() and time or os.clock
local LastIteration, Start = TimeFunction(), TimeFunction()
local FrameUpdateTable = {}

RunService.RenderStepped:Connect(function()
    LastIteration = TimeFunction()
    for i = #FrameUpdateTable, 1, -1 do FrameUpdateTable[i + 1] = FrameUpdateTable[i] >= LastIteration - 1 and FrameUpdateTable[i] or nil end
    FrameUpdateTable[1] = LastIteration
    local fps = math.floor(TimeFunction() - Start >= 1 and #FrameUpdateTable or #FrameUpdateTable / (TimeFunction() - Start))
    FPSLabel.Text = "FPS: " .. tostring(fps)
    
    local ping = "N/A"
    pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
    PingLabel.Text = "Ping: " .. tostring(ping) .. " ms"
end)
