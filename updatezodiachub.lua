-- [[ ZODIAC HUB - V4 FULL ESP + MODERN KEY SYSTEM ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ZodiacHubUI") then
    CoreGui.ZodiacHubUI:Destroy()
end

local ZodiacGui = Instance.new("ScreenGui")
ZodiacGui.Name = "ZodiacHubUI"
ZodiacGui.ResetOnSpawn = false
ZodiacGui.Parent = (gethui and gethui()) or CoreGui

local Theme = {
    Bg = Color3.fromRGB(15, 17, 26),
    CardBg = Color3.fromRGB(21, 25, 38),
    SidebarBg = Color3.fromRGB(11, 13, 20),
    Accent = Color3.fromRGB(88, 101, 242), -- Fotoğraftaki Mavi Tonu
    TextPrimary = Color3.fromRGB(240, 242, 250),
    TextSecondary = Color3.fromRGB(130, 135, 155),
    InputBg = Color3.fromRGB(24, 27, 38),
    ToggleOff = Color3.fromRGB(38, 43, 62)
}

local function corner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 8); c.Parent = p end

-- =======================================================
-- 1) LOADING EKRANI
-- =======================================================
local LoadFrame = Instance.new("Frame")
LoadFrame.Size = UDim2.new(0, 300, 0, 120)
LoadFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
LoadFrame.BackgroundColor3 = Theme.Bg
LoadFrame.Parent = ZodiacGui
corner(LoadFrame, 12)

local LoadTitle = Instance.new("TextLabel")
LoadTitle.Size = UDim2.new(1, 0, 0, 40)
LoadTitle.Position = UDim2.new(0, 0, 0, 20)
LoadTitle.BackgroundTransparency = 1
LoadTitle.Text = "Z O D I A C"
LoadTitle.TextColor3 = Theme.TextPrimary
LoadTitle.TextSize = 24
LoadTitle.Font = Enum.Font.GothamBold
LoadTitle.Parent = LoadFrame

local LoadBarBg = Instance.new("Frame")
LoadBarBg.Size = UDim2.new(0, 240, 0, 6)
LoadBarBg.Position = UDim2.new(0.5, -120, 0, 80)
LoadBarBg.BackgroundColor3 = Theme.CardBg
LoadBarBg.Parent = LoadFrame
corner(LoadBarBg, 3)

local LoadBarFill = Instance.new("Frame")
LoadBarFill.Size = UDim2.new(0, 0, 1, 0)
LoadBarFill.BackgroundColor3 = Theme.Accent
LoadBarFill.Parent = LoadBarBg
corner(LoadBarFill, 3)

-- =======================================================
-- 2) YENİ MODERN KEY SİSTEMİ EKRANI (FOTO 1 İLE AYNI)
-- =======================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 420, 0, 220)
KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
KeyFrame.BackgroundColor3 = Theme.Bg
KeyFrame.Visible = false
KeyFrame.Parent = ZodiacGui
corner(KeyFrame, 12)

local kPad = Instance.new("UIPadding")
kPad.PaddingTop = UDim.new(0, 24); kPad.PaddingBottom = UDim.new(0, 24)
kPad.PaddingLeft = UDim.new(0, 24); kPad.PaddingRight = UDim.new(0, 24)
kPad.Parent = KeyFrame

local AccessLbl = Instance.new("TextLabel")
AccessLbl.Size = UDim2.new(1, 0, 0, 14)
AccessLbl.BackgroundTransparency = 1
AccessLbl.Text = "ZODIAC ACCESS"
AccessLbl.TextColor3 = Theme.TextSecondary
AccessLbl.TextSize = 10
AccessLbl.Font = Enum.Font.GothamBold
AccessLbl.TextXAlignment = Enum.TextXAlignment.Left
AccessLbl.Parent = KeyFrame

local TitleLbl = Instance.new("TextLabel")
TitleLbl.Size = UDim2.new(1, 0, 0, 28)
TitleLbl.Position = UDim2.new(0, 0, 0, 18)
TitleLbl.BackgroundTransparency = 1
TitleLbl.Text = "Enter key to unlock menu"
TitleLbl.TextColor3 = Theme.TextPrimary
TitleLbl.TextSize = 22
TitleLbl.Font = Enum.Font.GothamBold
TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
TitleLbl.Parent = KeyFrame

local DescLbl = Instance.new("TextLabel")
DescLbl.Size = UDim2.new(1, 0, 0, 16)
DescLbl.Position = UDim2.new(0, 0, 0, 50)
DescLbl.BackgroundTransparency = 1
DescLbl.Text = "Main panel appears after successful key check."
DescLbl.TextColor3 = Theme.TextSecondary
DescLbl.TextSize = 13
DescLbl.Font = Enum.Font.Gotham
DescLbl.TextXAlignment = Enum.TextXAlignment.Left
DescLbl.Parent = KeyFrame

local InputBg = Instance.new("Frame")
InputBg.Size = UDim2.new(1, 0, 0, 44)
InputBg.Position = UDim2.new(0, 0, 0, 85)
InputBg.BackgroundColor3 = Theme.InputBg
InputBg.Parent = KeyFrame
corner(InputBg, 8)

-- Gerçek InputBox (Noktasız, net gözüken metin)
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -30, 1, 0)
KeyInput.Position = UDim2.new(0, 15, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter access key (e.g. ZodiacHub)"
KeyInput.PlaceholderColor3 = Theme.TextSecondary
KeyInput.TextColor3 = Theme.TextPrimary
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.TextXAlignment = Enum.TextXAlignment.Left
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputBg

local VerifyBtn = Instance.new("TextButton")
VerifyBtn.Size = UDim2.new(0, 120, 0, 38)
VerifyBtn.AnchorPoint = Vector2.new(1, 1)
VerifyBtn.Position = UDim2.new(1, 0, 1, 0)
VerifyBtn.BackgroundColor3 = Theme.Accent
VerifyBtn.Text = "Unlock"
VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyBtn.TextSize = 14
VerifyBtn.Font = Enum.Font.GothamBold
VerifyBtn.Parent = KeyFrame
corner(VerifyBtn, 8)

-- =======================================================
-- 3) ANA MENÜ
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 840, 0, 520)
MainFrame.Position = UDim2.new(0.5, -420, 0.5, -260)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Visible = false
MainFrame.Parent = ZodiacGui
corner(MainFrame, 12)

-- Sürükleme Sistemi
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
        if input == dragInput and dragging then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
end
makeDraggable(MainFrame)
makeDraggable(KeyFrame)

-- Geçiş Animasyonu
task.spawn(function()
    local tween = TweenService:Create(LoadBarFill, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)})
    tween:Play()
    tween.Completed:Wait()
    task.wait(0.3)
    LoadFrame.Visible = false
    KeyFrame.Visible = true
end)

VerifyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "ZodiacHub" then
        VerifyBtn.Text = "Success!"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        task.wait(0.5)
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        local oldText = VerifyBtn.Text
        local oldColor = VerifyBtn.BackgroundColor3
        VerifyBtn.Text = "Invalid"
        VerifyBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        task.wait(1)
        VerifyBtn.Text = oldText
        VerifyBtn.BackgroundColor3 = oldColor
        KeyInput.Text = ""
    end
end)

-- =======================================================
-- KART BOZUKLUKLARINI ÇÖZEN (AUTOMATIC SIZE) SİSTEMİ
-- =======================================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.Parent = MainFrame
corner(Sidebar, 12)

local HeaderBox = Instance.new("Frame")
HeaderBox.Size = UDim2.new(1, -20, 0, 45)
HeaderBox.Position = UDim2.new(0, 10, 0, 10)
HeaderBox.BackgroundColor3 = Theme.CardBg
HeaderBox.Parent = Sidebar
corner(HeaderBox, 8)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -10, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Zodiac Menu"
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBox

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -190, 1, -20)
ContentScroll.Position = UDim2.new(0, 190, 0, 10)
ContentScroll.BackgroundTransparency = 1
ContentScroll.ScrollBarThickness = 2
ContentScroll.Parent = MainFrame

local LeftCol = Instance.new("Frame")
LeftCol.Size = UDim2.new(0.49, 0, 0, 0)
LeftCol.AutomaticSize = Enum.AutomaticSize.Y
LeftCol.BackgroundTransparency = 1
LeftCol.Parent = ContentScroll
local LeftLayout = Instance.new("UIListLayout")
LeftLayout.Padding = UDim.new(0, 10)
LeftLayout.Parent = LeftCol

local RightCol = Instance.new("Frame")
RightCol.Size = UDim2.new(0.49, 0, 0, 0)
RightCol.Position = UDim2.new(0.51, 0, 0, 0)
RightCol.AutomaticSize = Enum.AutomaticSize.Y
RightCol.BackgroundTransparency = 1
RightCol.Parent = ContentScroll
local RightLayout = Instance.new("UIListLayout")
RightLayout.Padding = UDim.new(0, 10)
RightLayout.Parent = RightCol

local function updateScroll()
    ContentScroll.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftLayout.AbsoluteContentSize.Y, RightLayout.AbsoluteContentSize.Y) + 20)
end
LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScroll)
RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScroll)

local function createCard(parentCol, category, titleText)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 0)
    card.AutomaticSize = Enum.AutomaticSize.Y -- Bozulmaları önleyen asıl ayar
    card.BackgroundColor3 = Theme.CardBg
    card.Parent = parentCol
    corner(card, 8)
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0,12); pad.PaddingBottom = UDim.new(0,12)
    pad.PaddingLeft = UDim.new(0,14); pad.PaddingRight = UDim.new(0,14)
    pad.Parent = card

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 10)
    listLayout.Parent = card

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 30)
    header.BackgroundTransparency = 1
    header.LayoutOrder = 1
    header.Parent = card

    local catLbl = Instance.new("TextLabel")
    catLbl.Size = UDim2.new(1, 0, 0, 12)
    catLbl.BackgroundTransparency = 1
    catLbl.Text = category
    catLbl.TextColor3 = Theme.TextSecondary
    catLbl.TextSize = 9
    catLbl.Font = Enum.Font.GothamBold
    catLbl.TextXAlignment = Enum.TextXAlignment.Left
    catLbl.Parent = header

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 18)
    titleLbl.Position = UDim2.new(0, 0, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
    titleLbl.TextColor3 = Theme.TextPrimary
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = header

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 0)
    container.AutomaticSize = Enum.AutomaticSize.Y
    container.BackgroundTransparency = 1
    container.LayoutOrder = 2
    container.Parent = card

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Padding = UDim.new(0, 12)
    containerLayout.Parent = container

    return container
end

local function addToggle(parent, text, default, callback)
    local state = default
    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Text = ""
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.new(0, 34, 0, 18)
    toggleBg.Position = UDim2.new(1, -34, 0.5, -9)
    toggleBg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
    toggleBg.Parent = frame
    corner(toggleBg, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    corner(knob, 10)

    frame.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff}):Play()
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        callback(state)
    end)
    callback(state)
end

local function addDropdown(parent, text, options, defaultIndex, callback)
    local currentIndex = defaultIndex
    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(1, 0, 0, 22)
    frame.BackgroundTransparency = 1
    frame.Text = ""
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 12
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local ddBox = Instance.new("Frame")
    ddBox.Size = UDim2.new(0, 90, 0, 22)
    ddBox.Position = UDim2.new(1, -90, 0.5, -11)
    ddBox.BackgroundColor3 = Theme.InputBg
    ddBox.Parent = frame
    corner(ddBox, 4)

    local ddVal = Instance.new("TextLabel")
    ddVal.Size = UDim2.new(1, 0, 1, 0)
    ddVal.BackgroundTransparency = 1
    ddVal.Text = options[currentIndex]
    ddVal.TextColor3 = Theme.TextPrimary
    ddVal.TextSize = 11
    ddVal.Font = Enum.Font.Gotham
    ddVal.Parent = ddBox

    frame.MouseButton1Click:Connect(function()
        currentIndex = currentIndex + 1
        if currentIndex > #options then currentIndex = 1 end
        ddVal.Text = options[currentIndex]
        callback(options[currentIndex])
    end)
    callback(options[currentIndex])
end

local function addSlider(parent, text, min, max, default, symbol, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 38)
    frame.BackgroundTransparency = 1
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.TextPrimary
    label.TextSize = 11
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local valText = Instance.new("TextLabel")
    valText.Size = UDim2.new(0.3, 0, 0, 14)
    valText.Position = UDim2.new(0.7, 0, 0, 0)
    valText.BackgroundTransparency = 1
    valText.Text = tostring(default)..symbol
    valText.TextColor3 = Theme.TextSecondary
    valText.TextSize = 11
    valText.Font = Enum.Font.Gotham
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.Parent = frame

    local barBg = Instance.new("TextButton")
    barBg.Size = UDim2.new(1, 0, 0, 4)
    barBg.Position = UDim2.new(0, 0, 0, 24)
    barBg.BackgroundColor3 = Theme.ToggleOff
    barBg.Text = ""
    barBg.Parent = frame
    corner(barBg, 2)

    local barFill = Instance.new("Frame")
    local percent = (default - min) / (max - min)
    barFill.Size = UDim2.new(percent, 0, 1, 0)
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Parent = barBg
    corner(barFill, 2)

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 10, 0, 10)
    handle.Position = UDim2.new(1, -5, 0.5, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = barFill
    corner(handle, 10)

    local dragging = false
    barBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local realPct = math.clamp((UserInputService:GetMouseLocation().X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
            barFill.Size = UDim2.new(realPct, 0, 1, 0)
            local val = math.floor(min + ((max - min) * realPct))
            valText.Text = tostring(val)..symbol
            callback(val)
        end
    end)
    callback(default)
end

-- =======================================================
-- ESP AYARLARI VE OLUŞTURMA
-- =======================================================
local ESP = {
    Enabled = false, TeamCheck = false, MaxDistance = 1000,
    Box = { Enabled = false, Style = "Corner", Outline = true, Filled = false, FillTrans = 0.5, Thickness = 1 },
    Tracer = { Enabled = false, Origin = "Bottom", Style = "Line", Thickness = 1, Fade = 1 },
    Health = { Enabled = false, Style = "Bar", Side = "Left", Format = "HP", ShowDist = false, TextSize = 14 },
    Skeleton = { Enabled = false, Color = Color3.new(1,1,1), Thickness = 1, Trans = 1 },
    Name = { Enabled = false, Mode = "DisplayName", ShowDist = false, Unit = "studs", TextSize = 14 }
}

-- Kartlara Yükseklik Değeri (Height) Girmemize Artık Gerek Yok
local mainEsp = createCard(LeftCol, "MAIN ESP", "Core Controls")
addToggle(mainEsp, "ESP Enabled", false, function(v) ESP.Enabled = v end)
addToggle(mainEsp, "Team Check", false, function(v) ESP.TeamCheck = v end)
addDropdown(mainEsp, "Max Distance", {"500", "1000", "2500", "5000"}, 2, function(v) ESP.MaxDistance = tonumber(v) end)

local tracerEsp = createCard(LeftCol, "TRACER", "Origin + Lines")
addToggle(tracerEsp, "Tracer ESP", false, function(v) ESP.Tracer.Enabled = v end)
addDropdown(tracerEsp, "Tracer Origin", {"Bottom", "Center", "Mouse"}, 1, function(v) ESP.Tracer.Origin = v end)
addDropdown(tracerEsp, "Tracer Style", {"Line"}, 1, function(v) ESP.Tracer.Style = v end)
addSlider(tracerEsp, "Tracer Thick", 1, 5, 1, "", function(v) ESP.Tracer.Thickness = v end)
addSlider(tracerEsp, "Tracer Fade", 10, 100, 75, "%", function(v) ESP.Tracer.Fade = v / 100 end)

local skelEsp = createCard(LeftCol, "SKELETON", "Bone Overlay")
addToggle(skelEsp, "Skeleton ESP", false, function(v) ESP.Skeleton.Enabled = v end)
addDropdown(skelEsp, "Skel. Color", {"White", "Red", "Blue"}, 1, function(v) ESP.Skeleton.Color = v == "White" and Color3.new(1,1,1) or (v == "Red" and Color3.new(1,0,0) or Color3.new(0,0,1)) end)
addSlider(skelEsp, "Line Thickness", 1, 5, 2, "", function(v) ESP.Skeleton.Thickness = v end)
addSlider(skelEsp, "Transparency", 10, 100, 100, "%", function(v) ESP.Skeleton.Trans = v / 100 end)

local boxEsp = createCard(RightCol, "BOX ESP", "Shape + Outline")
addToggle(boxEsp, "Box ESP", false, function(v) ESP.Box.Enabled = v end)
addDropdown(boxEsp, "Box Style", {"Corner", "Full"}, 1, function(v) ESP.Box.Style = v end)
addToggle(boxEsp, "Box Outline", true, function(v) ESP.Box.Outline = v end)
addToggle(boxEsp, "Box Filled", false, function(v) ESP.Box.Filled = v end)
addSlider(boxEsp, "Box Fill", 10, 100, 50, "%", function(v) ESP.Box.FillTrans = 1 - (v / 100) end)
addSlider(boxEsp, "Box Thickness", 1, 5, 1, "", function(v) ESP.Box.Thickness = v end)

local healthEsp = createCard(RightCol, "HEALTH", "Bars + Text")
addToggle(healthEsp, "Health ESP", false, function(v) ESP.Health.Enabled = v end)
addDropdown(healthEsp, "Health Style", {"Bar"}, 1, function(v) ESP.Health.Style = v end)
addDropdown(healthEsp, "Bar Side", {"Left", "Right"}, 1, function(v) ESP.Health.Side = v end)
addDropdown(healthEsp, "Text Format", {"HP", "Percent", "None"}, 1, function(v) ESP.Health.Format = v end)
addToggle(healthEsp, "Show Distance", false, function(v) ESP.Health.ShowDist = v end)
addSlider(healthEsp, "Text Size", 10, 30, 14, "", function(v) ESP.Health.TextSize = v end)

local nameEsp = createCard(RightCol, "NAME / INFO", "Oyuncu Bilgisi")
addToggle(nameEsp, "Name ESP", false, function(v) ESP.Name.Enabled = v end)
addDropdown(nameEsp, "Name Mode", {"DisplayName", "Username"}, 1, function(v) ESP.Name.Mode = v end)
addToggle(nameEsp, "Show Distance", true, function(v) ESP.Name.ShowDist = v end)
addDropdown(nameEsp, "Distance Unit", {"studs", "meters"}, 1, function(v) ESP.Name.Unit = v end)
addSlider(nameEsp, "Text Size", 10, 30, 14, "", function(v) ESP.Name.TextSize = v end)

-- =======================================================
-- ESP ÇİZİM MOTORU
-- =======================================================
local ESP_Drawings = {}
local function createDrawings(player)
    local d = { BoxOutline = Drawing.new("Square"), Box = Drawing.new("Square"), BoxFill = Drawing.new("Square"), Tracer = Drawing.new("Line"), HealthBg = Drawing.new("Line"), Health = Drawing.new("Line"), HealthText = Drawing.new("Text"), NameText = Drawing.new("Text"), Skeleton = {} }
    d.BoxOutline.Color = Color3.new(0,0,0); d.BoxOutline.Thickness = 2.5; d.BoxOutline.Filled = false
    d.Box.Color = Color3.new(1,1,1); d.Box.Filled = false
    d.BoxFill.Color = Theme.Accent; d.BoxFill.Filled = true
    d.Tracer.Color = Color3.new(1,1,1)
    d.HealthBg.Color = Color3.new(0,0,0); d.HealthBg.Thickness = 4
    d.Health.Thickness = 2
    d.HealthText.Center = true; d.HealthText.Outline = true; d.HealthText.Color = Color3.new(1,1,1)
    d.NameText.Center = true; d.NameText.Outline = true; d.NameText.Color = Color3.new(1,1,1)
    for i = 1, 15 do local line = Drawing.new("Line"); line.Color = Color3.new(1,1,1); table.insert(d.Skeleton, line) end
    ESP_Drawings[player] = d
end
local function removeDrawings(player)
    if ESP_Drawings[player] then
        for _, v in pairs(ESP_Drawings[player]) do if type(v) == "table" then for _, line in pairs(v) do line:Remove() end else v:Remove() end end
        ESP_Drawings[player] = nil
    end
end
Players.PlayerRemoving:Connect(removeDrawings)

local R15_Bones = { {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"} }
local R6_Bones = { {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"}, {"Torso", "Left Leg"}, {"Torso", "Right Leg"} }

RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not ESP_Drawings[player] then createDrawings(player) end
            local d = ESP_Drawings[player]
            local char = player.Character
            local valid = char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
            local show = false

            if ESP.Enabled and valid then
                local hrp = char.HumanoidRootPart
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                if (not ESP.TeamCheck or player.Team ~= LocalPlayer.Team) and dist <= ESP.MaxDistance then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        show = true
                        local topPos = Camera:WorldToViewportPoint(char:FindFirstChild("Head") and char.Head.Position + Vector3.new(0,0.5,0) or hrp.Position + Vector3.new(0,2,0))
                        local btmPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0,3,0))
                        local h = math.abs(topPos.Y - btmPos.Y)
                        local w = h * 0.6
                        local boxX, boxY = pos.X - w/2, topPos.Y

                        if ESP.Box.Enabled then
                            d.BoxOutline.Visible = ESP.Box.Outline; d.BoxOutline.Position = Vector2.new(boxX, boxY); d.BoxOutline.Size = Vector2.new(w, h)
                            d.Box.Visible = true; d.Box.Position = Vector2.new(boxX, boxY); d.Box.Size = Vector2.new(w, h); d.Box.Thickness = ESP.Box.Thickness
                            d.BoxFill.Visible = ESP.Box.Filled; d.BoxFill.Position = Vector2.new(boxX, boxY); d.BoxFill.Size = Vector2.new(w, h); d.BoxFill.Transparency = ESP.Box.FillTrans
                        else d.Box.Visible = false; d.BoxOutline.Visible = false; d.BoxFill.Visible = false end

                        if ESP.Tracer.Enabled then
                            d.Tracer.Visible = true; d.Tracer.Thickness = ESP.Tracer.Thickness; d.Tracer.Transparency = ESP.Tracer.Fade
                            local origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                            if ESP.Tracer.Origin == "Center" then origin = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                            elseif ESP.Tracer.Origin == "Mouse" then origin = UserInputService:GetMouseLocation() end
                            d.Tracer.From = origin; d.Tracer.To = Vector2.new(pos.X, btmPos.Y)
                        else d.Tracer.Visible = false end

                        if ESP.Health.Enabled then
                            local hp, maxHp = char.Humanoid.Health, char.Humanoid.MaxHealth
                            local hpPct = hp / maxHp
                            d.HealthBg.Visible = true; d.Health.Visible = true
                            local barX = ESP.Health.Side == "Left" and (boxX - 6) or (boxX + w + 6)
                            d.HealthBg.From = Vector2.new(barX, boxY + h); d.HealthBg.To = Vector2.new(barX, boxY)
                            d.Health.From = Vector2.new(barX, boxY + h); d.Health.To = Vector2.new(barX, boxY + h - (h * hpPct))
                            d.Health.Color = Color3.fromRGB(255 - (hpPct*255), hpPct*255, 0)
                            
                            if ESP.Health.Format ~= "None" then
                                d.HealthText.Visible = true; d.HealthText.Size = ESP.Health.TextSize; d.HealthText.Position = Vector2.new(barX - 15, d.Health.To.Y - 5)
                                local txt = ESP.Health.Format == "HP" and math.floor(hp) or math.floor(hpPct*100).."%"
                                if ESP.Health.ShowDist then txt = txt .. " | " .. math.floor(dist) end
                                d.HealthText.Text = txt
                            else d.HealthText.Visible = false end
                        else d.HealthBg.Visible = false; d.Health.Visible = false; d.HealthText.Visible = false end

                        if ESP.Name.Enabled then
                            d.NameText.Visible = true; d.NameText.Size = ESP.Name.TextSize; d.NameText.Position = Vector2.new(pos.X, boxY - ESP.Name.TextSize - 4)
                            local nTxt = ESP.Name.Mode == "DisplayName" and player.DisplayName or player.Name
                            if ESP.Name.ShowDist then nTxt = nTxt .. " ["..math.floor(dist).. (ESP.Name.Unit == "studs" and "s" or "m") .."]" end
                            d.NameText.Text = nTxt
                        else d.NameText.Visible = false end

                        if ESP.Skeleton.Enabled then
                            local isR15 = char:FindFirstChild("UpperTorso") ~= nil
                            local bones = isR15 and R15_Bones or R6_Bones
                            for i, line in ipairs(d.Skeleton) do
                                local bData = bones[i]
                                if bData and char:FindFirstChild(bData[1]) and char:FindFirstChild(bData[2]) then
                                    local p1, s1 = Camera:WorldToViewportPoint(char[bData[1]].Position)
                                    local p2, s2 = Camera:WorldToViewportPoint(char[bData[2]].Position)
                                    if s1 and s2 then
                                        line.Visible = true; line.From = Vector2.new(p1.X, p1.Y); line.To = Vector2.new(p2.X, p2.Y)
                                        line.Color = ESP.Skeleton.Color; line.Thickness = ESP.Skeleton.Thickness; line.Transparency = ESP.Skeleton.Trans
                                    else line.Visible = false end
                                else line.Visible = false end
                            end
                        else for _, line in ipairs(d.Skeleton) do line.Visible = false end end
                    end
                end
            end

            if not show then
                d.Box.Visible = false; d.BoxOutline.Visible = false; d.BoxFill.Visible = false
                d.Tracer.Visible = false; d.HealthBg.Visible = false; d.Health.Visible = false; d.HealthText.Visible = false
                d.NameText.Visible = false
                for _, line in ipairs(d.Skeleton) do line.Visible = false end
            end
        end
    end
end)
