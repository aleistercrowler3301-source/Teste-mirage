-- Mirage Hub - Combat System GUI (Overlay central + Navigation interna + Top controls)
-- Versão completa: painel centralizado, responsivo e com botões Min/Max/Fechar
-- Para Delta Executor

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Garante o PlayerGui
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
    for prop, value in pairs(properties or {}) do
        if prop ~= "Parent" then
            instance[prop] = value
        end
    end
    if properties and properties.Parent then
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
-- SCREENGUI
-- =====================================================
local ScreenGui = CreateInstance("ScreenGui", {
    Name = "MirageHub",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = PlayerGui
})

-- =====================================================
-- PANEL CENTRAL (overlay)
-- =====================================================
local CombatPanel = CreateInstance("Frame", {
    Name = "CombatPanel",
    BackgroundColor3 = Color3.fromRGB(22, 22, 27),
    BorderSizePixel = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.55, 0, 0.5, 0),
    Size = UDim2.new(0.75, 0, 0.72, 0),
    Visible = true,
    Parent = ScreenGui
})
AddCorner(CombatPanel, 14)
AddShadow(CombatPanel)

-- Inner sidebar (nav) dentro do painel - esquerda escura
local InnerSidebar = CreateInstance("Frame", {
    Name = "InnerSidebar",
    BackgroundColor3 = Color3.fromRGB(18, 18, 22),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 0, 0),
    Size = UDim2.new(0.26, 0, 1, 0),
    Parent = CombatPanel
})
AddCorner(InnerSidebar, 12)

-- Container de botões (navegação) dentro do InnerSidebar
local ButtonContainer = CreateInstance("Frame", {
    Name = "ButtonContainer",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 0, 0, 20),
    Size = UDim2.new(1, 0, 1, -20),
    Parent = InnerSidebar
})

-- Área de conteúdo (à direita) dentro do painel
local ContentArea = CreateInstance("Frame", {
    Name = "ContentArea",
    BackgroundTransparency = 1,
    Position = UDim2.new(0.28, 0, 0, 0),
    Size = UDim2.new(0.72, 0, 1, 0),
    Parent = CombatPanel
})

-- Título no topo do painel (em ContentArea)
CreateInstance("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 25, 0, 18),
    Size = UDim2.new(1, -50, 0, 35),
    Font = Enum.Font.GothamBold,
    Text = "Mirage Hub",
    TextColor3 = Color3.fromRGB(240, 240, 245),
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ContentArea
})

-- =====================================================
-- CONTROLES DO TOPO: Min / Max / Close (no canto superior direito)
-- =====================================================
local TopControls = CreateInstance("Frame", {
    Name = "TopControls",
    BackgroundTransparency = 1,
    Position = UDim2.new(1, -120, 0, 10),
    Size = UDim2.new(0, 108, 0, 24),
    AnchorPoint = Vector2.new(0, 0),
    Parent = CombatPanel
})

local function CreateTopButton(parent, iconText, xOffset)
    local btn = CreateInstance("TextButton", {
        BackgroundColor3 = Color3.fromRGB(30, 30, 34),
        BorderSizePixel = 0,
        Position = UDim2.new(0, xOffset, 0, 0),
        Size = UDim2.new(0, 24, 0, 24),
        Text = iconText,
        Font = Enum.Font.SourceSansBold,
        TextSize = 16,
        TextColor3 = Color3.fromRGB(220, 220, 225),
        AutoButtonColor = false,
        Parent = parent
    })
    AddCorner(btn, 6)

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(30, 30, 34)}):Play()
    end)

    return btn
end

-- estados salvos para restore
local savedState = {
    position = CombatPanel.Position,
    size = CombatPanel.Size,
    anchor = CombatPanel.AnchorPoint,
    innerSidebarSize = InnerSidebar.Size,
    contentPos = ContentArea.Position,
    contentSize = ContentArea.Size
}
local isMinimized = false
local isMaximized = false

-- criar botões
local MinimizeBtn = CreateTopButton(TopControls, "—", 0)
local MaximizeBtn = CreateTopButton(TopControls, "▢", 36)
local CloseBtn = CreateTopButton(TopControls, "✕", 72)

-- Minimize: colapsa o conteúdo do painel (toggle)
MinimizeBtn.MouseButton1Click:Connect(function()
    if isMinimized then
        isMinimized = false
        -- restaurar tamanho/posição
        TweenService:Create(CombatPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = savedState.size,
            Position = savedState.position
        }):Play()
        InnerSidebar.Size = savedState.innerSidebarSize
        ContentArea.Position = savedState.contentPos
        ContentArea.Size = savedState.contentSize
        ContentArea.Visible = true
    else
        -- salvar estado atual para restaurar
        savedState.position = CombatPanel.Position
        savedState.size = CombatPanel.Size
        savedState.innerSidebarSize = InnerSidebar.Size
        savedState.contentPos = ContentArea.Position
        savedState.contentSize = ContentArea.Size

        isMinimized = true
        isMaximized = false

        -- animar redução para cabeçalho compacto
        CombatPanel.AnchorPoint = Vector2.new(0.5, 0)
        local targetSize = UDim2.new(CombatPanel.Size.X.Scale, CombatPanel.Size.X.Offset, 0.12, 0)
        local targetPos = UDim2.new(0.5, 0, 0.08, 0)
        TweenService:Create(CombatPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = targetSize,
            Position = targetPos
        }):Play()

        ContentArea.Visible = false
        InnerSidebar.Size = UDim2.new(1, 0, 0, 48)
    end
end)

-- Maximize: alterna para quase full-screen dentro do viewport
MaximizeBtn.MouseButton1Click:Connect(function()
    if isMaximized then
        isMaximized = false
        TweenService:Create(CombatPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = savedState.size,
            Position = savedState.position
        }):Play()
        InnerSidebar.Size = savedState.innerSidebarSize
        ContentArea.Position = savedState.contentPos
        ContentArea.Size = savedState.contentSize
        ContentArea.Visible = true
    else
        -- salvar estado para restaurar
        savedState.position = CombatPanel.Position
        savedState.size = CombatPanel.Size
        savedState.innerSidebarSize = InnerSidebar.Size
        savedState.contentPos = ContentArea.Position
        savedState.contentSize = ContentArea.Size

        isMaximized = true
        isMinimized = false

        local targetSize = UDim2.new(0.98, 0, 0.96, 0)
        local targetPos = UDim2.new(0.5, 0, 0.5, 0)
        CombatPanel.AnchorPoint = Vector2.new(0.5, 0.5)
        TweenService:Create(CombatPanel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
            Size = targetSize,
            Position = targetPos
        }):Play()

        InnerSidebar.Size = UDim2.new(0.22, 0, 1, 0)
        ContentArea.Position = UDim2.new(0.24, 0, 0, 0)
        ContentArea.Size = UDim2.new(0.76, 0, 1, 0)
        ContentArea.Visible = true
    end
end)

-- Close: anima e esconde o painel
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(CombatPanel, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {
        Position = UDim2.new(CombatPanel.Position.X.Scale, CombatPanel.Position.X.Offset, -0.4, 0)
    }):Play()
    delay(0.14, function()
        CombatPanel.Visible = false
    end)
end)

-- Ajustes para mobile (tamanho dos botões e posicionamento)
local function UpdateTopControlsForMobile()
    local size = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280,720)
    if size.X <= 420 then
        TopControls.Position = UDim2.new(1, -96, 0, 8)
        TopControls.Size = UDim2.new(0, 84, 0, 20)
        MinimizeBtn.Size = UDim2.new(0, 20, 0, 20)
        MaximizeBtn.Size = UDim2.new(0, 20, 0, 20)
        CloseBtn.Size = UDim2.new(0, 20, 0, 20)
        MaximizeBtn.Active = false
    else
        TopControls.Position = UDim2.new(1, -120, 0, 10)
        TopControls.Size = UDim2.new(0, 108, 0, 24)
        MinimizeBtn.Size = UDim2.new(0, 24, 0, 24)
        MaximizeBtn.Size = UDim2.new(0, 24, 0, 24)
        CloseBtn.Size = UDim2.new(0, 24, 0, 24)
        MaximizeBtn.Active = true
    end
end

-- =====================================================
-- FUNÇÃO: criar botões de navegação (usa ButtonContainer)
-- =====================================================
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

-- Criar botões de nav iniciais (exemplos)
CreateNavButton("Info", "rbxassetid://3926305904", 0, true)
CreateNavButton("Main", "rbxassetid://3926307971", 60, false)
CreateNavButton("Bring", "rbxassetid://3926305904", 120, false)
CreateNavButton("Teleport", "rbxassetid://3926307971", 180, false)
CreateNavButton("LocalPlayer", "rbxassetid://3926305904", 240, false)
CreateNavButton("Misc", "rbxassetid://3926307971", 300, false)
CreateNavButton("Tree", "rbxassetid://3926305904", 360, false)
CreateNavButton("Settings", "rbxassetid://3926307971", 420, false)

-- =====================================================
-- CONTAINERS DENTRO DO ContentArea (onde estarão sliders/toggles)
-- =====================================================
local SystemContainer = CreateInstance("Frame", {
    Name = "SystemContainer",
    BackgroundColor3 = Color3.fromRGB(28, 28, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 25, 0, 65),
    Size = UDim2.new(1, -50, 0, 200),
    Parent = ContentArea
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

local SettingsContainer = CreateInstance("Frame", {
    Name = "SettingsContainer",
    BackgroundColor3 = Color3.fromRGB(28, 28, 35),
    BorderSizePixel = 0,
    Position = UDim2.new(0, 25, 0, 285),
    Size = UDim2.new(1, -50, 0, 190),
    Parent = ContentArea
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
-- CRIAR CONTROLES (exemplos)
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

CreateSlider(SettingsContainer, "Normal Dodge Delay", 50, 0, 2, 0.5, function(v)
    CombatSettings.NormalDodgeDelay = v
end)

CreateSlider(SettingsContainer, "Heavy Dodge Delay", 110, 0, 2, 0.7, function(v)
    CombatSettings.HeavyDodgeDelay = v
end)

-- =====================================================
-- RESPONSIVIDADE: adapta CombatPanel / InnerSidebar para mobile
-- =====================================================
local function ApplyResponsive()
    local size = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local w = size.X

    if w <= 420 then
        -- mobile: painel quase full-width e sidebar vira barra superior (top)
        CombatPanel.AnchorPoint = Vector2.new(0.5, 0.5)
        CombatPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        CombatPanel.Size = UDim2.new(0.98, 0, 0.92, 0)

        InnerSidebar.Position = UDim2.new(0, 0, 0, 0)
        InnerSidebar.Size = UDim2.new(1, 0, 0, 86)
        ButtonContainer.Position = UDim2.new(0, 0, 0, 8)
        ButtonContainer.Size = UDim2.new(1, 0, 1, -8)

        ContentArea.Position = UDim2.new(0, 0, 0, 86)
        ContentArea.Size = UDim2.new(1, 0, 1, -86)

        -- ajustar top controls para caber no mobile
        UpdateTopControlsForMobile()
    elseif w <= 900 then
        -- tablet
        CombatPanel.AnchorPoint = Vector2.new(0.5, 0.5)
        CombatPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
        CombatPanel.Size = UDim2.new(0.92, 0, 0.86, 0)

        InnerSidebar.Position = UDim2.new(0, 0, 0, 0)
        InnerSidebar.Size = UDim2.new(0.24, 0, 1, 0)
        ButtonContainer.Position = UDim2.new(0, 0, 0, 20)
        ButtonContainer.Size = UDim2.new(1, 0, 1, -20)

        ContentArea.Position = UDim2.new(0.26, 0, 0, 0)
        ContentArea.Size = UDim2.new(0.74, 0, 1, 0)

        UpdateTopControlsForMobile()
    else
        -- desktop (ligeiramente deslocado para direita)
        CombatPanel.AnchorPoint = Vector2.new(0.5, 0.5)
        CombatPanel.Position = UDim2.new(0.55, 0, 0.5, 0)
        CombatPanel.Size = UDim2.new(0.75, 0, 0.72, 0)

        InnerSidebar.Position = UDim2.new(0, 0, 0, 0)
        InnerSidebar.Size = UDim2.new(0.26, 0, 1, 0)
        ButtonContainer.Position = UDim2.new(0, 0, 0, 20)
        ButtonContainer.Size = UDim2.new(1, 0, 1, -20)

        ContentArea.Position = UDim2.new(0.28, 0, 0, 0)
        ContentArea.Size = UDim2.new(0.72, 0, 1, 0)

        UpdateTopControlsForMobile()
    end
end

ApplyResponsive()
UserInputService.WindowSizeChanged:Connect(ApplyResponsive)
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(ApplyResponsive)
end

-- =====================================================
-- SISTEMA DE DRAG (arrastar painel) - habilitado para desktop/tablet
-- =====================================================
do
    local panelDragging, panelDragInput, panelDragStart, panelStartPos

    CombatPanel.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local view = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            if view.X > 420 then
                panelDragging = true
                panelDragStart = input.Position
                panelStartPos = CombatPanel.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then
                        panelDragging = false
                    end
                end)
            end
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
end

print("✅ Mirage Hub - Combat System carregado!")
print("📐 Layout: overlay central (InnerSidebar dentro do painel). Responsivo para mobile. Top controls: Min/Max/Close adicionados.")