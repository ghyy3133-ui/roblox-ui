local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")

-- THIẾT LẬP AUTO LOCK FPS 15 NGAY KHI CHẠY
if setfpscap then
    setfpscap(15)
end

local player = Players.LocalPlayer
local userId = player.UserId
local noteFile = "Note_" .. userId .. ".txt"
local webhookFile = "Webhook_" .. userId .. ".txt"

-- Xóa GUI cũ
if CoreGui:FindFirstChild("MyCustomHub") then
    CoreGui.MyCustomHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MyCustomHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

-- BẢNG CHÍNH (Đã thu gọn chiều cao vì bớt nút: 250x430)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 430)
MainFrame.Position = UDim2.new(0.5, -125, 0, 5)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- HỆ THỐNG KÉO THẢ (DRAG)
local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragToggle = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(MainFrame, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {Position = position}):Play()
    end
end)

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(255, 105, 180)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- AVATAR & NAME
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 45, 0, 45)
AvatarImage.Position = UDim2.new(0, 10, 0, 10)
AvatarImage.Image = "rbxthumb://type=AvatarHeadShot&id=" .. userId .. "&w=150&h=150"
AvatarImage.Parent = MainFrame
Instance.new("UICorner", AvatarImage).CornerRadius = UDim.new(1, 0)

local NameLabel = Instance.new("TextLabel")
NameLabel.Size = UDim2.new(0, 170, 0, 20)
NameLabel.Position = UDim2.new(0, 65, 0, 15)
NameLabel.BackgroundTransparency = 1
NameLabel.TextColor3 = Color3.fromRGB(255, 105, 180)
NameLabel.Text = player.DisplayName
NameLabel.Font = Enum.Font.GothamBold
NameLabel.TextSize = 14
NameLabel.TextXAlignment = Enum.TextXAlignment.Left
NameLabel.Parent = MainFrame

-- DÒNG STATS (FPS sẽ cố định quanh mức 15)
local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 20)
StatsLabel.Position = UDim2.new(0, 10, 0, 60)
StatsLabel.BackgroundTransparency = 1
StatsLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
StatsLabel.Text = "FPS: -- | Ping: -- | PLR: --"
StatsLabel.Font = Enum.Font.GothamSemibold
StatsLabel.TextSize = 10
StatsLabel.Parent = MainFrame

-- TRẠNG THÁI HỆ THỐNG
local AntiAfkLabel = Instance.new("TextLabel")
AntiAfkLabel.Size = UDim2.new(1, -20, 0, 22)
AntiAfkLabel.Position = UDim2.new(0, 10, 0, 85)
AntiAfkLabel.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
AntiAfkLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
AntiAfkLabel.Text = "⚡ ANTI-AFK & 15 FPS: ACTIVE"
AntiAfkLabel.Font = Enum.Font.GothamBold
AntiAfkLabel.TextSize = 10
AntiAfkLabel.Parent = MainFrame
Instance.new("UICorner", AntiAfkLabel)

-- WEBHOOK SECTION
local function createSmallTitle(text, posY)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 15)
    l.Position = UDim2.new(0, 10, 0, posY)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.Text = text
    l.Font = Enum.Font.GothamBold
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = MainFrame
    return l
end

createSmallTitle("🔗 Discord Webhook:", 115)
local WebhookBox = Instance.new("TextBox")
WebhookBox.Size = UDim2.new(1, -20, 0, 25)
WebhookBox.Position = UDim2.new(0, 10, 0, 135)
WebhookBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WebhookBox.TextColor3 = Color3.fromRGB(150, 150, 150)
WebhookBox.PlaceholderText = "Dán Webhook URL vào đây..."
WebhookBox.Text = ""
WebhookBox.Font = Enum.Font.Gotham
WebhookBox.TextSize = 9
WebhookBox.ClearTextOnFocus = false
WebhookBox.Parent = MainFrame
Instance.new("UICorner", WebhookBox)

-- NOTE SECTION
createSmallTitle("📝 Ghi chú cày acc:", 170)
local NoteBox = Instance.new("TextBox")
NoteBox.Size = UDim2.new(1, -20, 0, 45)
NoteBox.Position = UDim2.new(0, 10, 0, 190)
NoteBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
NoteBox.TextColor3 = Color3.fromRGB(200, 200, 200)
NoteBox.PlaceholderText = "Nội dung cày..."
NoteBox.Font = Enum.Font.Gotham
NoteBox.TextSize = 10
NoteBox.TextWrapped = true
NoteBox.TextYAlignment = Enum.TextYAlignment.Top
NoteBox.Parent = MainFrame
Instance.new("UICorner", NoteBox)

-- JOIN SERVER SECTION
local JobInput = Instance.new("TextBox")
JobInput.Size = UDim2.new(1, -20, 0, 25)
JobInput.Position = UDim2.new(0, 10, 0, 250)
JobInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
JobInput.TextColor3 = Color3.fromRGB(255, 255, 255)
JobInput.PlaceholderText = "Nhập Job ID..."
JobInput.Font = Enum.Font.Gotham
JobInput.TextSize = 10
JobInput.Parent = MainFrame
Instance.new("UICorner", JobInput)

local BtnFrame = Instance.new("Frame")
BtnFrame.Size = UDim2.new(1, -20, 0, 25)
BtnFrame.Position = UDim2.new(0, 10, 0, 285)
BtnFrame.BackgroundTransparency = 1
BtnFrame.Parent = MainFrame

local CopyBtn = Instance.new("TextButton")
CopyBtn.Size = UDim2.new(0.48, 0, 1, 0)
CopyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CopyBtn.Text = "Copy ID"
CopyBtn.Font = Enum.Font.GothamBold
CopyBtn.Parent = BtnFrame
Instance.new("UICorner", CopyBtn)

local JoinBtn = Instance.new("TextButton")
JoinBtn.Size = UDim2.new(0.48, 0, 1, 0)
JoinBtn.Position = UDim2.new(0.52, 0, 0, 0)
JoinBtn.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
JoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
JoinBtn.Text = "Join Server"
JoinBtn.Font = Enum.Font.GothamBold
JoinBtn.Parent = BtnFrame
Instance.new("UICorner", JoinBtn)

-- NO RENDER & TEST WEBHOOK
local NoRenderBtn = Instance.new("TextButton")
NoRenderBtn.Size = UDim2.new(1, -20, 0, 35)
NoRenderBtn.Position = UDim2.new(0, 10, 0, 325)
NoRenderBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
NoRenderBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
NoRenderBtn.Text = "No Render: ON"
NoRenderBtn.Font = Enum.Font.GothamBold
NoRenderBtn.Parent = MainFrame
Instance.new("UICorner", NoRenderBtn)

local TestWebBtn = Instance.new("TextButton")
TestWebBtn.Size = UDim2.new(1, -20, 0, 30)
TestWebBtn.Position = UDim2.new(0, 10, 0, 370)
TestWebBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
TestWebBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TestWebBtn.Text = "Gửi Test Webhook"
TestWebBtn.Font = Enum.Font.GothamBold
TestWebBtn.TextSize = 10
TestWebBtn.Parent = MainFrame
Instance.new("UICorner", TestWebBtn)

-----------------------------------------------------------
-- XỬ LÝ DỮ LIỆU & TÍNH NĂNG
-----------------------------------------------------------

-- 1. Tải/Lưu file
local function saveFile(name, content) if writefile then writefile(name, content) end end
local function readFile(name) if isfile and isfile(name) then return readfile(name) end return "" end

NoteBox.Text = readFile(noteFile)
WebhookBox.Text = readFile(webhookFile)

NoteBox.FocusLost:Connect(function() saveFile(noteFile, NoteBox.Text) end)
WebhookBox.FocusLost:Connect(function() saveFile(webhookFile, WebhookBox.Text) end)

-- 2. Discord Webhook
local function sendWebhook(msg)
    local url = WebhookBox.Text
    if url == "" or not url:find("discord.com/api/webhooks") then return end
    local data = {
        ["embeds"] = {{
            ["title"] = "⚠️ Hub Cày Cuốc - Cảnh Báo",
            ["description"] = msg,
            ["color"] = 16711850,
            ["fields"] = {
                {["name"] = "Acc", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "Game", ["value"] = "[Link Game](https://www.roblox.com/games/"..game.PlaceId..")", ["inline"] = true}
            },
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }
    if request then
        request({Url = url, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = HttpService:JSONEncode(data)})
    end
end

TestWebBtn.MouseButton1Click:Connect(function()
    sendWebhook("Đã kết nối thành công! ✅")
    TestWebBtn.Text = "Đã gửi!"; task.wait(1); TestWebBtn.Text = "Gửi Test Webhook"
end)

-- Báo văng/kick
GuiService.ErrorMessageChanged:Connect(function()
    sendWebhook("❌ **Acc đã bị ngắt kết nối (Disconnected/Kick)!**")
end)

-- 3. No Render
local noRenderEnabled = true
local function toggleRender(state)
    for _, v in next, workspace:GetDescendants() do
        pcall(function()
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = state and 1 or 0
            end
        end)
    end
end
toggleRender(true)

NoRenderBtn.MouseButton1Click:Connect(function()
    noRenderEnabled = not noRenderEnabled
    NoRenderBtn.Text = noRenderEnabled and "No Render: ON" or "No Render: OFF"
    NoRenderBtn.BackgroundColor3 = noRenderEnabled and Color3.fromRGB(20, 60, 20) or Color3.fromRGB(60, 20, 20)
    toggleRender(noRenderEnabled)
end)

-- 4. Anti-AFK (Chạy ngầm)
player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- 5. Copy & Join
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(game.JobId) end
    CopyBtn.Text = "Copied!"; task.wait(1); CopyBtn.Text = "Copy ID"
end)
JoinBtn.MouseButton1Click:Connect(function()
    if JobInput.Text ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, JobInput.Text, player) end
end)

-- 6. Stats Loop
local lastUpdate = os.clock()
local frameCount = 0
local currentFps = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if os.clock() - lastUpdate >= 1 then
        currentFps = frameCount
        frameCount = 0
        lastUpdate = os.clock()
    end
    local ping = "N/A"
    pcall(function() ping = math.round(player:GetNetworkPing() * 1000) end)
    StatsLabel.Text = string.format("FPS: %d | Ping: %s ms | PLR: %d/%d", currentFps, tostring(ping), #Players:GetPlayers(), Players.MaxPlayers)
end)

-- Nút Show/Hide
local ShowHideBtn = Instance.new("TextButton")
ShowHideBtn.Size = UDim2.new(0, 60, 0, 22)
ShowHideBtn.Position = UDim2.new(0, 10, 0, 5)
ShowHideBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ShowHideBtn.TextColor3 = Color3.fromRGB(255, 105, 180)
ShowHideBtn.Text = "Menu"
ShowHideBtn.Font = Enum.Font.GothamBold
ShowHideBtn.TextSize = 10
ShowHideBtn.Parent = ScreenGui
Instance.new("UICorner", ShowHideBtn)
ShowHideBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)
