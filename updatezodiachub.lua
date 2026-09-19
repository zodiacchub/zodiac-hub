-- [[ ZODIAC HUB - FULL UI SCRIPT ]] --

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- Var olan UI varsa temizle
if CoreGui:FindFirstChild("ZodiacHubUI") then
    CoreGui.ZodiacHubUI:Destroy()
end

-- ScreenGui Oluşturma
local ZodiacGui = Instance.new("ScreenGui")
ZodiacGui.Name = "ZodiacHubUI"
ZodiacGui.ResetOnSpawn = false
ZodiacGui.Parent = (gethui and gethui()) or CoreGui

-- Renk Paleti (Fotoğraftaki Dark Navy Teması)
local Theme = {
    Bg = Color3.fromRGB(15, 17, 26),
    CardBg = Color3.fromRGB(21, 25, 38),
    SidebarBg = Color3.fromRGB(11, 13, 20),
    Accent = Color3.fromRGB(76, 130, 246),
    AccentDark = Color3.fromRGB(50, 95, 195),
    TextPrimary = Color3.fromRGB(240, 242, 250),
    TextSecondary = Color3.fromRGB(130, 135, 155),
    InputBg = Color3.fromRGB(22, 26, 40),
    ToggleOff = Color3.fromRGB(38, 43, 62)
}

-- Yardımcı Fonksiyonlar
local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function addPadding(parent, top, bottom, left, right)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, top)
    pad.PaddingBottom = UDim.new(0, bottom)
    pad.PaddingLeft = UDim.new(0, left)
    pad.PaddingRight = UDim.new(0, right)
    return pad
end

-- =======================================================
-- 1. SAĞ ALT BİLDİRİM (NOTIFICATION)
-- =======================================================
local function showNotification(text)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification"
    NotifFrame.Size = UDim2.new(0, 280, 0, 50)
    NotifFrame.Position = UDim2.new(1, 20, 1, -70) -- Başlangıçta ekran dışında
    NotifFrame.BackgroundColor3 = Theme.CardBg
    NotifFrame.BorderSizePixel = 0
    NotifFrame.Parent = ZodiacGui
    addCorner(NotifFrame, 10)

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = Theme.Accent
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = NotifFrame
    addCorner(AccentBar, 4)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -20, 1, 0)
    Label.Position = UDim2.new(0, 15, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextPrimary
    Label.TextSize = 13
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = NotifFrame

    -- Kayarak Giriş
    TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -300, 1, -70)
    }):Play()

    -- 3 Saniye Sonra Kayarak Çıkış
    task.delay(3, function()
        local tweenOut = TweenService:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 20, 1, -70)
        })
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            NotifFrame:Destroy()
        end)
    end)
end

showNotification("Zodiac Hub başarıyla aktif edildi")

-- =======================================================
-- 2. KEY SİSTEMİ EKRANI (KEY SYSTEM)
-- =======================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 420, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
KeyFrame.BackgroundColor3 = Theme.Bg
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ZodiacGui
addCorner(KeyFrame, 14)
addPadding(KeyFrame, 24, 24, 24, 24)

local SubHeader = Instance.new("TextLabel")
SubHeader.Size = UDim2.new(1, 0, 0, 16)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "ZODIAC ACCESS"
SubHeader.TextColor3 = Theme.TextSecondary
SubHeader.TextSize = 12
SubHeader.Font = Enum.Font.GothamBold
SubHeader.TextXAlignment = Enum.TextXAlignment.Left
SubHeader.Parent = KeyFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(1, 0, 0, 28)
Header.Position = UDim2.new(0, 0, 0, 20)
Header.BackgroundTransparency = 1
Header.Text = "Enter key to unlock menu"
Header.TextColor3 = Theme.TextPrimary
Header.TextSize = 22
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = KeyFrame

local Desc = Instance.new("TextLabel")
Desc.Size = UDim2.new(1, 0, 0, 18)
Desc.Position = UDim2.new(0, 0, 0, 52)
Desc.BackgroundTransparency = 1
Desc.Text = "Main panel appears after successful key check."
Desc.TextColor3 = Theme.TextSecondary
Desc.TextSize = 13
Desc.Font = Enum.Font.Gotham
Desc.TextXAlignment = Enum.TextXAlignment.Left
Desc.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, 0, 0, 42)
KeyInput.Position = UDim2.new(0, 0, 0, 90)
KeyInput.BackgroundColor3 = Theme.InputBg
KeyInput.TextColor3 = Theme.TextPrimary
KeyInput.PlaceholderText = "Enter access key (e.g. ZodiacHub)"
KeyInput.PlaceholderColor3 = Theme.TextSecondary
KeyInput.Text = ""
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = KeyFrame
addCorner(KeyInput, 8)
addPadding(KeyInput, 0, 0, 15, 15)

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0, 120, 0, 40)
UnlockBtn.Position = UDim2.new(1, -120, 1, -40)
UnlockBtn.BackgroundColor3 = Theme.Accent
UnlockBtn.Text = "Unlock"
UnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockBtn.TextSize = 14
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.Parent = KeyFrame
addCorner(UnlockBtn, 8)

-- =======================================================
-- 3. ANA MENÜ (MAIN MENU)
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ZodiacGui
addCorner(MainFrame, 12)

-- Sürükleme (Drag) Özelliği
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Sol Sidebar
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame
addCorner(Sidebar, 12)

-- Logo & Başlık
local HeaderBox = Instance.new("Frame")
HeaderBox.Size = UDim2.new(1, -20, 0, 45)
HeaderBox.Position = UDim2.new(0, 10, 0, 10)
HeaderBox.BackgroundColor3 = Theme.CardBg
HeaderBox.Parent = Sidebar
addCorner(HeaderBox, 8)

local LogoIcon = Instance.new("TextLabel")
LogoIcon.Size = UDim2.new(0, 30, 0, 30)
LogoIcon.Position = UDim2.new(0, 8, 0.5, -15)
LogoIcon.BackgroundColor3 = Theme.Accent
LogoIcon.Text = "ZH"
LogoIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoIcon.TextSize = 12
LogoIcon.Font = Enum.Font.GothamBold
LogoIcon.Parent = HeaderBox
addCorner(LogoIcon, 6)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 0, 18)
Title.Position = UDim2.new(0, 44, 0, 6)
Title.BackgroundTransparency = 1
Title.Text = "Zodiac Menu"
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = HeaderBox

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, -50, 0, 14)
SubTitle.Position = UDim2.new(0, 44, 0, 24)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Panel Controls"
SubTitle.TextColor3 = Theme.TextSecondary
SubTitle.TextSize = 10
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = HeaderBox

-- Menü Listesi Container
local NavList = Instance.new("ScrollingFrame")
NavList.Size = UDim2.new(1, -20, 1, -70)
NavList.Position = UDim2.new(0, 10, 0, 65)
NavList.BackgroundTransparency = 1
NavList.ScrollBarThickness = 0
NavList.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 4)
NavLayout.Parent = NavList

local function createCategoryHeader(name)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 24)
    lbl.BackgroundTransparency = 1
    lbl.Text = name
    lbl.TextColor3 = Theme.TextSecondary
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = NavList
    addPadding(lbl, 8, 0, 8, 0)
end

local function createTabBtn(name, active)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = active and Theme.CardBg or Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = active and 0 or 1
    btn.Text = ""
    btn.Parent = NavList
    addCorner(btn, 6)

    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 8, 0, 8)
    dot.Position = UDim2.new(0, 10, 0.5, -4)
    dot.BackgroundColor3 = active and Theme.Accent or Theme.TextSecondary
    dot.Parent = btn
    addCorner(dot, 10)

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -30, 1, 0)
    txt.Position = UDim2.new(0, 26, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = active and Theme.TextPrimary or Theme.TextSecondary
    txt.TextSize = 12
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = btn
end

-- Menü Kategorileri
createCategoryHeader("MENU")
createTabBtn("MAIN", false)
createTabBtn("ESP", true)
createTabBtn("Aimbot", false)
createTabBtn("Settings", false)
createTabBtn("Oyuncular", false)

createCategoryHeader("DA HOOD")
createTabBtn("Weapons", false)
createTabBtn("Locations", false)
createTabBtn("Misc", false)
createTabBtn("World", false)

-- Sağ İçerik Alanı (Content Grid)
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, -200, 1, -20)
ContentArea.Position = UDim2.new(0, 190, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ScrollBarThickness = 2
ContentArea.ScrollBarImageColor3 = Theme.Accent
ContentArea.Parent = MainFrame

local ContentGrid = Instance.new("UIGridLayout")
ContentGrid.CellSize = UDim2.new(0.485, 0, 0, 215)
ContentGrid.CellPadding = UDim2.new(0, 12, 0, 12)
ContentGrid.Parent = ContentArea

-- Kart ve Eleman Oluşturucu Fonksiyonlar
local function createCard(categoryTitle, cardTitle)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.CardBg
    card.Parent = ContentArea
    addCorner(card, 8)
    addPadding(card, 12, 12, 12, 12)

    local catLbl = Instance.new("TextLabel")
    catLbl.Size = UDim2.new(1, 0, 0, 12)
    catLbl.BackgroundTransparency = 1
    catLbl.Text = string.upper(categoryTitle)
    catLbl.TextColor3 = Theme.TextSecondary
    catLbl.TextSize = 9
    catLbl.Font = Enum.Font.GothamBold
    catLbl.TextXAlignment = Enum.TextXAlignment.Left
    catLbl.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 18)
    titleLbl.Position = UDim2.new(0, 0, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = cardTitle
    titleLbl.TextColor3 = Theme.TextPrimary
    titleLbl.TextSize = 14
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = card

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -34)
    container.Position = UDim2.new(0, 0, 0, 34)
    container.BackgroundTransparency = 1
    container.Parent = card

    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = container

    return container
end

local function addToggle(parent, text, default)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundTransparency = 1
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
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -36, 0.5, -9)
    toggleBg.BackgroundColor3 = default and Theme.Accent or Theme.ToggleOff
    toggleBg.Parent = frame
    addCorner(toggleBg, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    addCorner(knob, 10)
end

local function addDropdown(parent, text, valueText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 26)
    frame.BackgroundTransparency = 1
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
    ddBox.Size = UDim2.new(0, 80, 0, 22)
    ddBox.Position = UDim2.new(1, -80, 0.5, -11)
    ddBox.BackgroundColor3 = Theme.InputBg
    ddBox.Parent = frame
    addCorner(ddBox, 4)

    local ddVal = Instance.new("TextLabel")
    ddVal.Size = UDim2.new(1, 0, 1, 0)
    ddVal.BackgroundTransparency = 1
    ddVal.Text = valueText
    ddVal.TextColor3 = Theme.TextPrimary
    ddVal.TextSize = 11
    ddVal.Font = Enum.Font.Gotham
    ddVal.Parent = ddBox
end

local function addSlider(parent, text, percentText)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 32)
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
    valText.Text = percentText
    valText.TextColor3 = Theme.TextSecondary
    valText.TextSize = 11
    valText.Font = Enum.Font.Gotham
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.Parent = frame

    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, 0, 0, 4)
    barBg.Position = UDim2.new(0, 0, 0, 20)
    barBg.BackgroundColor3 = Theme.ToggleOff
    barBg.Parent = frame
    addCorner(barBg, 2)

    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0.5, 0, 1, 0)
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Parent = barBg
    addCorner(barFill, 2)

    local handle = Instance.new("Frame")
    handle.Size = UDim2.new(0, 10, 0, 10)
    handle.Position = UDim2.new(1, -5, 0.5, -5)
    handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    handle.Parent = barFill
    addCorner(handle, 10)
end

-- =======================================================
-- KARTLARIN YERLEŞTİRİLMESİ (2. FOTOĞRAF)
-- =======================================================

-- 1. MAIN ESP / Core Controls
local mainEsp = createCard("MAIN ESP", "Core Controls")
addToggle(mainEsp, "ESP Enabled", false)
addToggle(mainEsp, "Team Check", false)
addDropdown(mainEsp, "Max Distance", "1000")

-- 2. BOX ESP / Shape + Outline
local boxEsp = createCard("BOX ESP", "Shape + Outline")
addToggle(boxEsp, "Box ESP", false)
addDropdown(boxEsp, "Box Style", "Corner")
addToggle(boxEsp, "Box Outline", true)
addToggle(boxEsp, "Box Filled", false)
addSlider(boxEsp, "Box Fill", "50%")
addSlider(boxEsp, "Box Thickness", "20%")

-- 3. TRACER / Origin + Lines
local tracerEsp = createCard("TRACER", "Origin + Lines")
addToggle(tracerEsp, "Tracer ESP", false)
addDropdown(tracerEsp, "Tracer Origin", "Bottom")
addDropdown(tracerEsp, "Tracer Style", "Line")

-- 4. HEALTH / Bars + Text
local healthEsp = createCard("HEALTH", "Bars + Text")
addToggle(healthEsp, "Health ESP", false)
addDropdown(healthEsp, "Health Style", "Bar")
addDropdown(healthEsp, "Bar Side", "Left")

-- =======================================================
-- MANTIK KONTROLÜ (KEY LOGIC)
-- =======================================================
UnlockBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == "ZodiacHub" then
        KeyFrame:Destroy()
        MainFrame.Visible = true
        showNotification("Giriş Başarılı! Hoşgeldin.")
    else
        KeyInput.Text = ""
        KeyInput.PlaceholderText = "Yanlış Key! Tekrar Dene."
        KeyInput.PlaceholderColor3 = Color3.fromRGB(255, 80, 80)
    end
end)
