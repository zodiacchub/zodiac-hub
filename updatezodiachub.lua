-- [[ ZODIAC HUB - FULL UI & WORKING ESP SCRIPT ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Var olan UI varsa temizle
if CoreGui:FindFirstChild("ZodiacHubUI") then
    CoreGui.ZodiacHubUI:Destroy()
end

-- =======================================================
-- ESP AYARLARI VE MOTORU (DRAWING API)
-- =======================================================
local ESP_Settings = {
    Enabled = false,
    TeamCheck = false,
    MaxDistance = 1000,
    Box = { Enabled = false, Style = "Corner", Outline = true, Filled = false, FillTrans = 0.5, Thickness = 1 },
    Tracer = { Enabled = false, Origin = "Bottom", Style = "Line" },
    Health = { Enabled = false, Style = "Bar", Side = "Left" }
}

local ESP_Drawings = {}

local function createDrawings(player)
    local drawings = {
        BoxOutline = Drawing.new("Square"),
        Box = Drawing.new("Square"),
        BoxFill = Drawing.new("Square"),
        Tracer = Drawing.new("Line"),
        HealthBg = Drawing.new("Line"),
        Health = Drawing.new("Line")
    }
    
    -- Varsayılan Çizim Ayarları
    drawings.BoxOutline.Color = Color3.new(0, 0, 0)
    drawings.BoxOutline.Thickness = 2.5
    drawings.BoxOutline.Filled = false

    drawings.Box.Color = Color3.new(1, 1, 1)
    drawings.Box.Thickness = 1
    drawings.Box.Filled = false

    drawings.BoxFill.Color = Color3.fromRGB(76, 130, 246)
    drawings.BoxFill.Filled = true

    drawings.Tracer.Color = Color3.new(1, 1, 1)
    drawings.Tracer.Thickness = 1

    drawings.HealthBg.Color = Color3.new(0, 0, 0)
    drawings.HealthBg.Thickness = 4

    drawings.Health.Color = Color3.new(0, 1, 0)
    drawings.Health.Thickness = 2

    ESP_Drawings[player] = drawings
end

local function removeDrawings(player)
    if ESP_Drawings[player] then
        for _, drawing in pairs(ESP_Drawings[player]) do
            drawing:Remove()
        end
        ESP_Drawings[player] = nil
    end
end

Players.PlayerRemoving:Connect(removeDrawings)

-- ESP Güncelleme Döngüsü
RunService.RenderStepped:Connect(function()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if not ESP_Drawings[player] then
                createDrawings(player)
            end

            local d = ESP_Drawings[player]
            local character = player.Character
            local isValid = character and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid") and character.Humanoid.Health > 0

            local showESP = false
            local pos, onScreen
            
            if ESP_Settings.Enabled and isValid then
                local hrp = character.HumanoidRootPart
                local dist = (Camera.CFrame.Position - hrp.Position).Magnitude
                
                local passTeam = not ESP_Settings.TeamCheck or (player.Team ~= LocalPlayer.Team)
                local passDist = dist <= tonumber(ESP_Settings.MaxDistance)

                if passTeam and passDist then
                    pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        showESP = true
                        
                        -- Boyut Hesaplama
                        local topPos, _ = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                        local bottomPos, _ = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3.5, 0))
                        local height = math.abs(topPos.Y - bottomPos.Y)
                        local width = height * 0.65
                        local boxPos = Vector2.new(pos.X - width / 2, topPos.Y)
                        local boxSize = Vector2.new(width, height)

                        -- Box ESP
                        if ESP_Settings.Box.Enabled then
                            d.BoxOutline.Visible = ESP_Settings.Box.Outline
                            d.BoxOutline.Position = boxPos
                            d.BoxOutline.Size = boxSize
                            
                            d.Box.Visible = true
                            d.Box.Position = boxPos
                            d.Box.Size = boxSize
                            d.Box.Thickness = ESP_Settings.Box.Thickness
                            
                            d.BoxFill.Visible = ESP_Settings.Box.Filled
                            d.BoxFill.Position = boxPos
                            d.BoxFill.Size = boxSize
                            d.BoxFill.Transparency = ESP_Settings.Box.FillTrans
                        else
                            d.Box.Visible = false
                            d.BoxOutline.Visible = false
                            d.BoxFill.Visible = false
                        end

                        -- Tracer ESP
                        if ESP_Settings.Tracer.Enabled then
                            d.Tracer.Visible = true
                            local startPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y) -- Bottom
                            if ESP_Settings.Tracer.Origin == "Center" then
                                startPoint = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            elseif ESP_Settings.Tracer.Origin == "Mouse" then
                                startPoint = UserInputService:GetMouseLocation()
                            end
                            d.Tracer.From = startPoint
                            d.Tracer.To = Vector2.new(pos.X, bottomPos.Y)
                        else
                            d.Tracer.Visible = false
                        end

                        -- Health ESP
                        if ESP_Settings.Health.Enabled then
                            local hp = character.Humanoid.Health
                            local maxHp = character.Humanoid.MaxHealth
                            local hpPercent = hp / maxHp
                            
                            d.HealthBg.Visible = true
                            d.Health.Visible = true
                            
                            local barX = ESP_Settings.Health.Side == "Left" and (boxPos.X - 6) or (boxPos.X + width + 6)
                            
                            d.HealthBg.From = Vector2.new(barX, boxPos.Y + height)
                            d.HealthBg.To = Vector2.new(barX, boxPos.Y)
                            
                            d.Health.From = Vector2.new(barX, boxPos.Y + height)
                            d.Health.To = Vector2.new(barX, boxPos.Y + height - (height * hpPercent))
                            
                            -- Renk değişimi (Yeşilden Kırmızıya)
                            d.Health.Color = Color3.fromRGB(255 - (hpPercent * 255), hpPercent * 255, 0)
                        else
                            d.HealthBg.Visible = false
                            d.Health.Visible = false
                        end
                    end
                end
            end

            -- Eğer ekranda değilse veya hile kapalıysa çizimleri gizle
            if not showESP then
                d.Box.Visible = false
                d.BoxOutline.Visible = false
                d.BoxFill.Visible = false
                d.Tracer.Visible = false
                d.HealthBg.Visible = false
                d.Health.Visible = false
            end
        end
    end
end)


-- =======================================================
-- UI TASARIMI (ARAYÜZ)
-- =======================================================
local ZodiacGui = Instance.new("ScreenGui")
ZodiacGui.Name = "ZodiacHubUI"
ZodiacGui.ResetOnSpawn = false
ZodiacGui.Parent = (gethui and gethui()) or CoreGui

local Theme = {
    Bg = Color3.fromRGB(15, 17, 26),
    CardBg = Color3.fromRGB(21, 25, 38),
    SidebarBg = Color3.fromRGB(11, 13, 20),
    Accent = Color3.fromRGB(76, 130, 246),
    TextPrimary = Color3.fromRGB(240, 242, 250),
    TextSecondary = Color3.fromRGB(130, 135, 155),
    InputBg = Color3.fromRGB(22, 26, 40),
    ToggleOff = Color3.fromRGB(38, 43, 62)
}

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

-- BİLDİRİM
local function showNotification(text)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Size = UDim2.new(0, 280, 0, 50)
    NotifFrame.Position = UDim2.new(1, 20, 1, -70)
    NotifFrame.BackgroundColor3 = Theme.CardBg
    NotifFrame.Parent = ZodiacGui
    addCorner(NotifFrame, 10)

    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 4, 1, 0)
    AccentBar.BackgroundColor3 = Theme.Accent
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

    local ts = game:GetService("TweenService")
    ts:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, -300, 1, -70)}):Play()
    task.delay(3, function()
        local tweenOut = ts:Create(NotifFrame, TweenInfo.new(0.4, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 20, 1, -70)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function() NotifFrame:Destroy() end)
    end)
end

showNotification("Zodiac Hub başarıyla aktif edildi!")

-- =======================================================
-- KEY EKRANI (TAM ORANTILI VE DÜZELTİLMİŞ)
-- =======================================================
local KeyFrame = Instance.new("Frame")
KeyFrame.Name = "KeyFrame"
KeyFrame.Size = UDim2.new(0, 460, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -230, 0.5, -125)
KeyFrame.BackgroundColor3 = Theme.Bg
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ZodiacGui
addCorner(KeyFrame, 14)

local SubHeader = Instance.new("TextLabel")
SubHeader.Size = UDim2.new(0, 200, 0, 16)
SubHeader.Position = UDim2.new(0, 24, 0, 24)
SubHeader.BackgroundTransparency = 1
SubHeader.Text = "ZODIAC ACCESS"
SubHeader.TextColor3 = Theme.TextSecondary
SubHeader.TextSize = 12
SubHeader.Font = Enum.Font.GothamBold
SubHeader.TextXAlignment = Enum.TextXAlignment.Left
SubHeader.Parent = KeyFrame

local Header = Instance.new("TextLabel")
Header.Size = UDim2.new(0, 300, 0, 28)
Header.Position = UDim2.new(0, 24, 0, 44)
Header.BackgroundTransparency = 1
Header.Text = "Enter key to unlock menu"
Header.TextColor3 = Theme.TextPrimary
Header.TextSize = 24
Header.Font = Enum.Font.GothamBold
Header.TextXAlignment = Enum.TextXAlignment.Left
Header.Parent = KeyFrame

local Desc = Instance.new("TextLabel")
Desc.Size = UDim2.new(0, 300, 0, 18)
Desc.Position = UDim2.new(0, 24, 0, 76)
Desc.BackgroundTransparency = 1
Desc.Text = "Main panel appears after successful key check."
Desc.TextColor3 = Theme.TextSecondary
Desc.TextSize = 13
Desc.Font = Enum.Font.Gotham
Desc.TextXAlignment = Enum.TextXAlignment.Left
Desc.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 412, 0, 46)
KeyInput.Position = UDim2.new(0, 24, 0, 120)
KeyInput.BackgroundColor3 = Theme.InputBg
KeyInput.TextColor3 = Theme.TextPrimary
KeyInput.PlaceholderText = "Enter access key (e.g. ZodiacHub)"
KeyInput.PlaceholderColor3 = Theme.TextSecondary
KeyInput.Text = ""
KeyInput.TextSize = 14
KeyInput.Font = Enum.Font.Gotham
KeyInput.Parent = KeyFrame
addCorner(KeyInput, 8)
-- Text'in soluna boşluk bırakmak için UIPadding sadece Input'a eklendi
local InputPad = Instance.new("UIPadding")
InputPad.PaddingLeft = UDim.new(0, 16)
InputPad.Parent = KeyInput

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0, 130, 0, 42)
UnlockBtn.Position = UDim2.new(0, 306, 0, 182) -- Sağa yaslı hizalama
UnlockBtn.BackgroundColor3 = Theme.Accent
UnlockBtn.Text = "Unlock"
UnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockBtn.TextSize = 15
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.Parent = KeyFrame
addCorner(UnlockBtn, 8)

-- =======================================================
-- ANA MENÜ YÜKLEMESİ (MAIN MENU)
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 780, 0, 480)
MainFrame.Position = UDim2.new(0.5, -390, 0.5, -240)
MainFrame.BackgroundColor3 = Theme.Bg
MainFrame.Visible = false
MainFrame.Parent = ZodiacGui
addCorner(MainFrame, 12)

-- Sürükleme Özelliği
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- SOL MENÜ
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, 0)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.Parent = MainFrame
addCorner(Sidebar, 12)

local HeaderBox = Instance.new("Frame")
HeaderBox.Size = UDim2.new(1, -20, 0, 45)
HeaderBox.Position = UDim2.new(0, 10, 0, 10)
HeaderBox.BackgroundColor3 = Theme.CardBg
HeaderBox.Parent = Sidebar
addCorner(HeaderBox, 8)

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

-- İÇERİK KISMI
local ContentArea = Instance.new("ScrollingFrame")
ContentArea.Size = UDim2.new(1, -200, 1, -20)
ContentArea.Position = UDim2.new(0, 190, 0, 10)
ContentArea.BackgroundTransparency = 1
ContentArea.ScrollBarThickness = 2
ContentArea.Parent = MainFrame

local ContentGrid = Instance.new("UIGridLayout")
ContentGrid.CellSize = UDim2.new(0.485, 0, 0, 220)
ContentGrid.CellPadding = UDim2.new(0, 12, 0, 12)
ContentGrid.Parent = ContentArea

-- ETKİLEŞİMLİ BİLEŞEN FONKSİYONLARI
local function createCard(category, titleText)
    local card = Instance.new("Frame")
    card.BackgroundColor3 = Theme.CardBg
    card.Parent = ContentArea
    addCorner(card, 8)
    
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0,12); pad.PaddingBottom = UDim.new(0,12); pad.PaddingLeft = UDim.new(0,12); pad.PaddingRight = UDim.new(0,12)
    pad.Parent = card

    local catLbl = Instance.new("TextLabel")
    catLbl.Size = UDim2.new(1, 0, 0, 12)
    catLbl.BackgroundTransparency = 1
    catLbl.Text = category
    catLbl.TextColor3 = Theme.TextSecondary
    catLbl.TextSize = 9
    catLbl.Font = Enum.Font.GothamBold
    catLbl.TextXAlignment = Enum.TextXAlignment.Left
    catLbl.Parent = card

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(1, 0, 0, 18)
    titleLbl.Position = UDim2.new(0, 0, 0, 12)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = titleText
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
    listLayout.Padding = UDim.new(0, 8)
    listLayout.Parent = container

    return container
end

local function addToggle(parent, text, default, callback)
    local state = default
    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(1, 0, 0, 26)
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
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -36, 0.5, -9)
    toggleBg.BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff
    toggleBg.Parent = frame
    addCorner(toggleBg, 10)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    addCorner(knob, 10)

    frame.MouseButton1Click:Connect(function()
        state = not state
        local ts = game:GetService("TweenService")
        ts:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Theme.ToggleOff}):Play()
        ts:Create(knob, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        callback(state)
    end)
    callback(state)
end

local function addDropdown(parent, text, options, defaultIndex, callback)
    local currentIndex = defaultIndex
    local frame = Instance.new("TextButton")
    frame.Size = UDim2.new(1, 0, 0, 26)
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
    ddBox.Size = UDim2.new(0, 80, 0, 22)
    ddBox.Position = UDim2.new(1, -80, 0.5, -11)
    ddBox.BackgroundColor3 = Theme.InputBg
    ddBox.Parent = frame
    addCorner(ddBox, 4)

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

local function addSlider(parent, text, min, max, default, callback)
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
    valText.Text = tostring(default)
    valText.TextColor3 = Theme.TextSecondary
    valText.TextSize = 11
    valText.Font = Enum.Font.Gotham
    valText.TextXAlignment = Enum.TextXAlignment.Right
    valText.Parent = frame

    local barBg = Instance.new("TextButton")
    barBg.Size = UDim2.new(1, 0, 0, 4)
    barBg.Position = UDim2.new(0, 0, 0, 20)
    barBg.BackgroundColor3 = Theme.ToggleOff
    barBg.Text = ""
    barBg.Parent = frame
    addCorner(barBg, 2)

    local barFill = Instance.new("Frame")
    local percent = (default - min) / (max - min)
    barFill.Size = UDim2.new(percent, 0, 1, 0)
    barFill.BackgroundColor3 = Theme.Accent
    barFill.Parent = barBg
    addCorner(barFill, 2)

    local dragging = false
    barBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local barPos = barBg.AbsolutePosition.X
            local barSize = barBg.AbsoluteSize.X
            local realPercent = math.clamp((mousePos - barPos) / barSize, 0, 1)
            barFill.Size = UDim2.new(realPercent, 0, 1, 0)
            local value = math.floor(min + ((max - min) * realPercent))
            valText.Text = tostring(value)
            callback(value)
        end
    end)
    callback(default)
end

-- =======================================================
-- ESP KARTLARININ EKLENMESİ VE BAĞLANMASI
-- =======================================================

local mainEsp = createCard("MAIN ESP", "Core Controls")
addToggle(mainEsp, "ESP Enabled", false, function(v) ESP_Settings.Enabled = v end)
addToggle(mainEsp, "Team Check", false, function(v) ESP_Settings.TeamCheck = v end)
addDropdown(mainEsp, "Max Distance", {"500", "1000", "2000", "5000"}, 2, function(v) ESP_Settings.MaxDistance = tonumber(v) end)

local boxEsp = createCard("BOX ESP", "Shape + Outline")
addToggle(boxEsp, "Box ESP", false, function(v) ESP_Settings.Box.Enabled = v end)
addDropdown(boxEsp, "Box Style", {"Corner", "Full"}, 1, function(v) ESP_Settings.Box.Style = v end)
addToggle(boxEsp, "Box Outline", true, function(v) ESP_Settings.Box.Outline = v end)
addToggle(boxEsp, "Box Filled", false, function(v) ESP_Settings.Box.Filled = v end)
addSlider(boxEsp, "Box Fill %", 10, 100, 50, function(v) ESP_Settings.Box.FillTrans = 1 - (v / 100) end)
addSlider(boxEsp, "Box Thickness", 1, 5, 1, function(v) ESP_Settings.Box.Thickness = v end)

local tracerEsp = createCard("TRACER", "Origin + Lines")
addToggle(tracerEsp, "Tracer ESP", false, function(v) ESP_Settings.Tracer.Enabled = v end)
addDropdown(tracerEsp, "Tracer Origin", {"Bottom", "Center", "Mouse"}, 1, function(v) ESP_Settings.Tracer.Origin = v end)
addDropdown(tracerEsp, "Tracer Style", {"Line"}, 1, function(v) ESP_Settings.Tracer.Style = v end)

local healthEsp = createCard("HEALTH", "Bars + Text")
addToggle(healthEsp, "Health ESP", false, function(v) ESP_Settings.Health.Enabled = v end)
addDropdown(healthEsp, "Health Style", {"Bar"}, 1, function(v) ESP_Settings.Health.Style = v end)
addDropdown(healthEsp, "Bar Side", {"Left", "Right"}, 1, function(v) ESP_Settings.Health.Side = v end)

-- =======================================================
-- KEY GİRİŞ MANTIĞI
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
