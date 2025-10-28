-- Mirage Hub - Combat System GUI (Professional Design - Tamanho Corrigido)
-- Para Delta Executor

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Garante o PlayerGui (CORRIGIDO PARA DELTA)
local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")

-- =====================================================
-- CONFIGURAÇÕES
-- =====================================================
local CombatSettings = {
    EnableCombat = false,
    DodgeLightAttacks = false,
    DodgeHeavyAttacks = false,
    BlockUltimateAttacks = false,
    AttackOnDash = false,
    NormalDodgeDelay = 0.5,
    HeavyDodgeDelay = 0.7,
    ActivateRange = 15,
    NoStun = false,
    NoReverseInput = false
}

-- =====================================================
-- UTILITÁRIOS
-- =====================================================
local function CreateInstance(className, properties)
    local instance = Instance.new(className)
    for prop, value in pairs(properties) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties.Parent then
        instance.Parent = properties.Parent
    end
    return instance
end

local function AddCorner(parent, radius)
    return CreateInstance("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

local function AddShadow(parent)
    return CreateInstance("ImageLabel", {
        Name = "Shadow",
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = "rbxasset://textures/ui/GuiImagePlaceholder.png",
        ImageColor3 = Color3.fromRGB(0, 0, 0),
        ImageTransparency = 0.7,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(10, 10, 10, 10),
        Parent = parent
    })
end

-- =====================================================
-- GUI PRINCIPAL
-- =====================================================
local ScreenGui = CreateInstance("ScreenGui", {
    Name = "MirageHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui -- CORRIGIDO PARA PlayerGui
})

-- Frame Principal (Sidebar) - 240px de largura
local MainFrame = CreateInstance("Frame", {
    Name = "MainFrame",
    BackgroundColor3 = Color3.fromRGB(18, 18, 22),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 0.5, -250),
    Size = UDim2.new(0, 240, 0, 500),
    Parent = ScreenGui
})

AddCorner(MainFrame, 10)
AddShadow(MainFrame)

-- =====================================================
-- HEADER COM DECORAÇÃO
-- =====================================================
local HeaderDeco = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 15),
    Size = UDim2.new(0, 80, 0, 15),
    Parent = MainFrame
})

local circleColors = {
    Color3.fromRGB(255, 95, 86),
    Color3.fromRGB(255, 189, 46),
    Color3.fromRGB(40, 201, 64)
}

for i = 1, 3 do
    local circle = CreateInstance("Frame", {
        BackgroundColor3 = circleColors[i],
        BorderSizePixel = 0,
        Position = UDim2.new(0, (i-1) * 20, 0, 0),
        Size = UDim2.new(0, 12, 0, 12),
        Parent = HeaderDeco
    })
    AddCorner(circle, 6)
end

-- Logo
local LogoFrame = CreateInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(45, 45, 55),
    BorderSizePixel = 0,
    Position = UDim2.new(1, -50, 0, 10),
    Size = UDim2.new(0, 35, 0, 35),
    Parent = MainFrame
})

AddCorner(LogoFrame, 8)

CreateInstance("ImageLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Image = "rbxassetid://3926305904",
    ImageColor3 = Color3.fromRGB(150, 150, 160),
    Parent = LogoFrame
})

-- Títulos
CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 60),
    Size = UDim2.new(1, -30, 0, 30),
    Font = Enum.Font.GothamBold,
    Text = "Mirage Hub",
    TextColor3 = Color3.fromRGB(240, 240, 245),
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = MainFrame
})

CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 88),
    Size = UDim2.new(1, -30, 0, 20),
    Font = Enum.Font.Gotham,
    Text = "Untitled Boxing Game",
    TextColor3 = Color3.fromRGB(130, 130, 145),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = MainFrame
})

-- Separador
CreateInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(40, 40, 50),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 15, 0, 125),
    Size = UDim2.new(1, -30, 0, 1),
    Parent = MainFrame
})

-- =====================================================
-- NAVEGAÇÃO
-- =====================================================
local ButtonContainer = CreateInstance("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 140),
    Size = UDim2.new(1, 0, 1, -140),
    Parent = MainFrame
})

local activeButton = nil

local function CreateNavButton(text, icon, yPos, isActive)
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = isActive and Color3.fromRGB(35, 35, 45) or Color3.fromRGB(25, 25, 32),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 12, 0, yPos),
        Size = UDim2.new(1, -24, 0, 48),
        AutoButtonColor = false,
        Text = "",
        Parent = ButtonContainer
    })
    
    AddCorner(btn, 8)
    
    local indicator = CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(88, 166, 255),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0.2, 0),
        Size = UDim2.new(0, 3, 0.6, 0),
        Visible = isActive,
        Parent = btn
    })
    AddCorner(indicator, 2)
    
    local iconImg = CreateInstance("ImageLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0.5, -10),
        Size = UDim2.new(0, 20, 0, 20),
        Image = icon,
        ImageColor3 = isActive and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(140, 140, 155),
        Parent = btn
    })
    
    local label = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 45, 0, 0),
        Size = UDim2.new(1, -45, 1, 0),
        Font = Enum.Font.GothamMedium,
        Text = text,
        TextColor3 = isActive and Color3.fromRGB(220, 220, 230) or Color3.fromRGB(160, 160, 175),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = btn
    })
    
    btn.MouseEnter:Connect(function()
        if not isActive then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 38)
            }):Play()
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if not isActive then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(25, 25, 32)
            }):Play()
        end
    end)
    
    if isActive then
        activeButton = btn
    end
    
    return btn
end

CreateNavButton("Combat", "rbxassetid://3926305904", 0, true)
CreateNavButton("ESP", "rbxassetid://3926307971", 60, false)
CreateNavButton("Game", "rbxassetid://3926305904", 120, false)

-- =====================================================
-- PAINEL COMBAT (TAMANHO CORRIGIDO: 550px de largura)
-- =====================================================
local CombatPanel = CreateInstance("Frame", {
    Name = "CombatPanel",
    BackgroundColor3 = Color3.fromRGB(22, 22, 27),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 265, 0.5, -250),
    Size = UDim2.new(0, 550, 0, 500),
    Visible = true,
    Parent = ScreenGui
})

AddCorner(CombatPanel, 10)
AddShadow(CombatPanel)

-- Título do Painel
CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 25, 0, 20),
    Size = UDim2.new(1, -50, 0, 35),
    Font = Enum.Font.GothamBold,
    Text = "Combat",
    TextColor3 = Color3.fromRGB(180, 180, 195),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = CombatPanel
})

-- =====================================================
-- CONTAINER: COMBAT SYSTEM
-- =====================================================
local SystemContainer = CreateInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(28, 28, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 25, 0, 75),
    Size = UDim2.new(1, -50, 0, 195),
    Parent = CombatPanel
})

AddCorner(SystemContainer, 12)

CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 15),
    Size = UDim2.new(1, -40, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "Combat System",
    TextColor3 = Color3.fromRGB(220, 220, 230),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SystemContainer
})

-- =====================================================
-- CONTAINER: COMBAT SETTINGS
-- =====================================================
local SettingsContainer = CreateInstance("Frame", {
    BackgroundColor3 = Color3.fromRGB(28, 28, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 25, 0, 285),
    Size = UDim2.new(1, -50, 0, 190),
    Parent = CombatPanel
})

AddCorner(SettingsContainer, 12)

CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 20, 0, 15),
    Size = UDim2.new(1, -40, 0, 25),
    Font = Enum.Font.GothamBold,
    Text = "Combat Settings",
    TextColor3 = Color3.fromRGB(220, 220, 230),
    TextSize = 16,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = SettingsContainer
})

-- =====================================================
-- FUNÇÃO: CRIAR TOGGLE
-- =====================================================
local function CreateToggle(parent, text, yPos, callback)
    local frame = CreateInstance("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, yPos),
        Size = UDim2.new(1, -40, 0, 40),
        Parent = parent
    })
    
    local label = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.7, 0, 1, 0),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(190, 190, 205),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local toggleBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Color3.fromRGB(45, 45, 55),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -55, 0.5, -12),
        Size = UDim2.new(0, 55, 0, 24),
        Text = "",
        AutoButtonColor = false,
        Parent = frame
    })
    
    AddCorner(toggleBtn, 12)
    
    local circle = CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(230, 230, 240),
        Position = UDim2.new(0, 3, 0.5, -9),
        Size = UDim2.new(0, 18, 0, 18),
        Parent = toggleBtn
    })
    
    AddCorner(circle, 9)
    
    local toggled = false
    
    toggleBtn.MouseButton1Click:Connect(function()
        toggled = not toggled
        callback(toggled)
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        
        if toggled then
            TweenService:Create(toggleBtn, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(88, 166, 255)
            }):Play()
            TweenService:Create(circle, tweenInfo, {
                Position = UDim2.new(1, -21, 0.5, -9)
            }):Play()
        else
            TweenService:Create(toggleBtn, tweenInfo, {
                BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            }):Play()
            TweenService:Create(circle, tweenInfo, {
                Position = UDim2.new(0, 3, 0.5, -9)
            }):Play()
        end
    end)
end

-- =====================================================
-- FUNÇÃO: CRIAR SLIDER
-- =====================================================
local function CreateSlider(parent, text, yPos, min, max, default, callback)
    local frame = CreateInstance("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 20, 0, yPos),
        Size = UDim2.new(1, -40, 0, 50),
        Parent = parent
    })
    
    local label = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.65, 0, 0, 22),
        Font = Enum.Font.Gotham,
        Text = text,
        TextColor3 = Color3.fromRGB(190, 190, 205),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = frame
    })
    
    local valueLabel = CreateInstance("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.new(0.65, 0, 0, 0),
        Size = UDim2.new(0.35, 0, 0, 22),
        Font = Enum.Font.GothamBold,
        Text = tostring(default),
        TextColor3 = Color3.fromRGB(220, 220, 230),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = frame
    })
    
    local sliderBack = CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(40, 40, 50),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 0, 30),
        Size = UDim2.new(1, 0, 0, 4),
        Parent = frame
    })
    
    AddCorner(sliderBack, 2)
    
    local sliderFill = CreateInstance("Frame", {
        BackgroundColor3 = Color3.fromRGB(88, 166, 255),
        BorderSizePixel = 0,
        Size = UDim2.new((default - min) / (max - min), 0, 1, 0),
        Parent = sliderBack
    })
    
    AddCorner(sliderFill, 2)
    
    local sliderBtn = CreateInstance("TextButton", {
        BackgroundColor3 = Color3.fromRGB(250, 250, 255),
        BorderSizePixel = 0,
        Position = UDim2.new((default - min) / (max - min), -6, 0.5, -6),
        Size = UDim2.new(0, 12, 0, 12),
        Text = "",
        AutoButtonColor = false,
        Parent = sliderBack
    })
    
    AddCorner(sliderBtn, 6)
    
    local dragging = false
    
    sliderBtn.MouseButton1Down:Connect(function()
        dragging = true
        TweenService:Create(sliderBtn, TweenInfo.new(0.1), {
            Size = UDim2.new(0, 16, 0, 16),
            Position = UDim2.new((sliderBtn.Position.X.Scale), -8, 0.5, -8)
        }):Play()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                TweenService:Create(sliderBtn, TweenInfo.new(0.1), {
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(sliderBtn.Position.X.Scale, -6, 0.5, -6)
                }):Play()
            end
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local pos = math.clamp((input.Position.X - sliderBack.AbsolutePosition.X) / sliderBack.AbsoluteSize.X, 0, 1)
            sliderBtn.Position = UDim2.new(pos, -8, 0.5, -8)
            sliderFill.Size = UDim2.new(pos, 0, 1, 0)
            
            local value = math.floor((min + (max - min) * pos) * 10) / 10
            valueLabel.Text = tostring(value)
            callback(value)
        end
    end)
end

-- =====================================================
-- CRIAR TOGGLES - COMBAT SYSTEM
-- =====================================================
CreateToggle(SystemContainer, "Enable Combat", 50, function(v)
    CombatSettings.EnableCombat = v
end)

CreateToggle(SystemContainer, "Dodge Light Attacks", 95, function(v)
    CombatSettings.DodgeLightAttacks = v
end)

CreateToggle(SystemContainer, "Dodge Heavy Attacks", 140, function(v)
    CombatSettings.DodgeHeavyAttacks = v
end)

-- =====================================================
-- CRIAR SLIDERS E TOGGLES - COMBAT SETTINGS
-- =====================================================
CreateSlider(SettingsContainer, "Normal Dodge Delay", 50, 0, 2, 0.5, function(v)
    CombatSettings.NormalDodgeDelay = v
end)

CreateSlider(SettingsContainer, "Heavy Dodge Delay", 110, 0, 2, 0.7, function(v)
    CombatSettings.HeavyDodgeDelay = v
end)

-- =====================================================
-- SISTEMA DE DRAG
-- =====================================================
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
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
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Drag para CombatPanel
local panelDragging, panelDragInput, panelDragStart, panelStartPos

CombatPanel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        panelDragging = true
        panelDragStart = input.Position
        panelStartPos = CombatPanel.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                panelDragging = false
            end
        end)
    end
end)

CombatPanel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        panelDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == panelDragInput and panelDragging then
        local delta = input.Position - panelDragStart
        CombatPanel.Position = UDim2.new(
            panelStartPos.X.Scale,
            panelStartPos.X.Offset + delta.X,
            panelStartPos.Y.Scale,
            panelStartPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ Mirage Hub - Combat System carregado!")
print("📐 Tamanho: Sidebar 240px | Painel 550px")