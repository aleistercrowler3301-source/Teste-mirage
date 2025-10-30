-- ═══════════════════════════════════════════════════════════════
--  MIRAGE HUB - PROFESSIONAL GUI SYSTEM
--  Version: 2.0.0
--  Game: Untitled Boxing Game
--  Created by: Professional Dev Team
-- ═══════════════════════════════════════════════════════════════

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ═══════════════════════════════════════════════════════════════
--  CONFIGURATION
-- ═══════════════════════════════════════════════════════════════

local CONFIG = {
    Colors = {
        Background = Color3.fromRGB(18, 18, 22),
        Surface = Color3.fromRGB(25, 25, 30),
        SurfaceLight = Color3.fromRGB(32, 32, 37),
        Primary = Color3.fromRGB(88, 101, 242),
        Accent = Color3.fromRGB(114, 137, 218),
        TextPrimary = Color3.fromRGB(255, 255, 255),
        TextSecondary = Color3.fromRGB(142, 146, 151),
        Border = Color3.fromRGB(40, 40, 45),
        Success = Color3.fromRGB(67, 181, 129),
        Warning = Color3.fromRGB(250, 166, 26),
        Danger = Color3.fromRGB(237, 66, 69),
        MacRed = Color3.fromRGB(255, 95, 86),
        MacYellow = Color3.fromRGB(255, 189, 46),
        MacGreen = Color3.fromRGB(40, 201, 64)
    },
    Sizes = {
        Normal = UDim2.new(0, 680, 0, 520),
        Minimized = UDim2.new(0, 220, 0, 60),
        Maximized = UDim2.new(1, -60, 1, -60)
    },
    Positions = {
        Normal = UDim2.new(0.5, -340, 0.5, -260),
        Minimized = UDim2.new(1, -240, 0, 20),
        Maximized = UDim2.new(0, 30, 0, 30)
    },
    Animation = {
        Fast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        Smooth = TweenInfo.new(0.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    }
}

-- ═══════════════════════════════════════════════════════════════
--  UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════

local function createInstance(className, properties)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    return instance
end

local function applyCorner(parent, radius)
    return createInstance("UICorner", {
        CornerRadius = UDim.new(0, radius),
        Parent = parent
    })
end

local function applyStroke(parent, color, thickness)
    return createInstance("UIStroke", {
        Color = color,
        Thickness = thickness,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent
    })
end

local function tween(object, properties, tweenInfo)
    TweenService:Create(object, tweenInfo or CONFIG.Animation.Normal, properties):Play()
end

-- ═══════════════════════════════════════════════════════════════
--  MAIN SETUP
-- ═══════════════════════════════════════════════════════════════

local ScreenGui = createInstance("ScreenGui", {
    Name = "MirageHubPro",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true
})

pcall(function()
    ScreenGui.Parent = game:GetService("CoreGui")
end)
if ScreenGui.Parent ~= game:GetService("CoreGui") then
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

local currentState = "Normal"
local isDragging = false

-- ═══════════════════════════════════════════════════════════════
--  MAIN FRAME
-- ═══════════════════════════════════════════════════════════════

local MainFrame = createInstance("Frame", {
    Name = "MainFrame",
    Size = CONFIG.Sizes.Normal,
    Position = CONFIG.Positions.Normal,
    BackgroundColor3 = CONFIG.Colors.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = ScreenGui
})

applyCorner(MainFrame, 14)
applyStroke(MainFrame, CONFIG.Colors.Border, 1)

local Shadow = createInstance("ImageLabel", {
    Name = "Shadow",
    BackgroundTransparency = 1,
    Position = UDim2.new(0, -20, 0, -20),
    Size = UDim2.new(1, 40, 1, 40),
    ZIndex = 0,
    Image = "rbxassetid://6014261993",
    ImageColor3 = Color3.fromRGB(0, 0, 0),
    ImageTransparency = 0.5,
    ScaleType = Enum.ScaleType.Slice,
    SliceCenter = Rect.new(100, 100, 100, 100),
    Parent = MainFrame
})

-- ═══════════════════════════════════════════════════════════════
--  TITLE BAR
-- ═══════════════════════════════════════════════════════════════

local TitleBar = createInstance("Frame", {
    Name = "TitleBar",
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = MainFrame
})

applyCorner(TitleBar, 14)

createInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 1, -14),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = TitleBar
})

-- macOS Decorative Circles
local function createMacCircle(color, position)
    local circle = createInstance("Frame", {
        Size = UDim2.new(0, 12, 0, 12),
        Position = position,
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    applyCorner(circle, 6)
    return circle
end

createMacCircle(CONFIG.Colors.MacRed, UDim2.new(0, 20, 0, 24))
createMacCircle(CONFIG.Colors.MacYellow, UDim2.new(0, 38, 0, 24))
createMacCircle(CONFIG.Colors.MacGreen, UDim2.new(0, 56, 0, 24))

local TitleLabel = createInstance("TextLabel", {
    Name = "Title",
    Size = UDim2.new(1, -180, 0, 22),
    Position = UDim2.new(0, 80, 0, 12),
    BackgroundTransparency = 1,
    Text = "Mirage Hub",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamBold,
    TextSize = 17,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
})

local SubtitleLabel = createInstance("TextLabel", {
    Name = "Subtitle",
    Size = UDim2.new(1, -180, 0, 16),
    Position = UDim2.new(0, 80, 0, 34),
    BackgroundTransparency = 1,
    Text = "Untitled Boxing Game",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = TitleBar
})

local StatusIndicator = createInstance("Frame", {
    Name = "StatusIndicator",
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(1, -148, 0, 24),
    BackgroundColor3 = CONFIG.Colors.Success,
    BorderSizePixel = 0,
    Parent = TitleBar
})

applyCorner(StatusIndicator, 6)

local pulseConnection
pulseConnection = RunService.RenderStepped:Connect(function()
    local time = tick()
    StatusIndicator.BackgroundColor3 = Color3.fromRGB(
        math.floor(67 + math.sin(time * 2) * 20),
        math.floor(181 + math.sin(time * 2) * 20),
        math.floor(129 + math.sin(time * 2) * 20)
    )
end)

-- Control Buttons
local function createControlButton(icon, name, position, hoverColor)
    local button = createInstance("TextButton", {
        Name = name,
        Size = UDim2.new(0, 36, 0, 36),
        Position = position,
        BackgroundColor3 = CONFIG.Colors.SurfaceLight,
        BorderSizePixel = 0,
        Text = icon,
        TextColor3 = CONFIG.Colors.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        Parent = TitleBar
    })
    
    applyCorner(button, 8)
    
    button.MouseEnter:Connect(function()
        tween(button, {
            BackgroundColor3 = hoverColor or CONFIG.Colors.Border,
            TextColor3 = CONFIG.Colors.TextPrimary
        }, CONFIG.Animation.Fast)
    end)
    
    button.MouseLeave:Connect(function()
        tween(button, {
            BackgroundColor3 = CONFIG.Colors.SurfaceLight,
            TextColor3 = CONFIG.Colors.TextSecondary
        }, CONFIG.Animation.Fast)
    end)
    
    return button
end

local MinimizeBtn = createControlButton("—", "Minimize", UDim2.new(1, -124, 0, 12), CONFIG.Colors.Border)
local MaximizeBtn = createControlButton("⛶", "Maximize", UDim2.new(1, -82, 0, 12), CONFIG.Colors.Border)
local CloseBtn = createControlButton("✕", "Close", UDim2.new(1, -40, 0, 12), CONFIG.Colors.Danger)

-- ═══════════════════════════════════════════════════════════════
--  CONTENT CONTAINER
-- ═══════════════════════════════════════════════════════════════

local ContentContainer = createInstance("Frame", {
    Name = "Content",
    Size = UDim2.new(1, 0, 1, -92),
    Position = UDim2.new(0, 0, 0, 60),
    BackgroundTransparency = 1,
    Parent = MainFrame
})

-- ═══════════════════════════════════════════════════════════════
--  SIDEBAR
-- ═══════════════════════════════════════════════════════════════

local Sidebar = createInstance("Frame", {
    Name = "Sidebar",
    Size = UDim2.new(0, 200, 1, 0),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = ContentContainer
})

local function createSidebarButton(icon, text, position, isActive)
    local button = createInstance("TextButton", {
        Name = text .. "Button",
        Size = UDim2.new(1, -24, 0, 48),
        Position = position,
        BackgroundColor3 = isActive and CONFIG.Colors.SurfaceLight or Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = isActive and 0 or 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Parent = Sidebar
    })
    
    applyCorner(button, 10)
    
    if isActive then
        applyStroke(button, CONFIG.Colors.Primary, 1.5)
    end
    
    local iconLabel = createInstance("TextLabel", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(0, 16, 0.5, -14),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = isActive and CONFIG.Colors.Primary or CONFIG.Colors.TextSecondary,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        Parent = button
    })
    
    local textLabel = createInstance("TextLabel", {
        Size = UDim2.new(1, -56, 1, 0),
        Position = UDim2.new(0, 52, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = isActive and CONFIG.Colors.TextPrimary or CONFIG.Colors.TextSecondary,
        Font = isActive and Enum.Font.GothamBold or Enum.Font.Gotham,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = button
    })
    
    button.MouseEnter:Connect(function()
        if not isActive then
            tween(button, {BackgroundTransparency = 0, BackgroundColor3 = CONFIG.Colors.SurfaceLight}, CONFIG.Animation.Fast)
            tween(textLabel, {TextColor3 = CONFIG.Colors.TextPrimary}, CONFIG.Animation.Fast)
            tween(iconLabel, {TextColor3 = CONFIG.Colors.TextPrimary}, CONFIG.Animation.Fast)
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isActive then
            tween(button, {BackgroundTransparency = 1}, CONFIG.Animation.Fast)
            tween(textLabel, {TextColor3 = CONFIG.Colors.TextSecondary}, CONFIG.Animation.Fast)
            tween(iconLabel, {TextColor3 = CONFIG.Colors.TextSecondary}, CONFIG.Animation.Fast)
        end
    end)
    
    return button
end

createSidebarButton("⚔️", "Combat", UDim2.new(0, 12, 0, 20), true)
createSidebarButton("👁️", "ESP", UDim2.new(0, 12, 0, 78), false)
createSidebarButton("🎮", "Game", UDim2.new(0, 12, 0, 136), false)
createSidebarButton("⚙️", "Settings", UDim2.new(0, 12, 0, 194), false)

-- ═══════════════════════════════════════════════════════════════
--  MAIN CONTENT
-- ═══════════════════════════════════════════════════════════════

local MainContent = createInstance("Frame", {
    Name = "MainContent",
    Size = UDim2.new(1, -200, 1, 0),
    Position = UDim2.new(0, 200, 0, 0),
    BackgroundTransparency = 1,
    Parent = ContentContainer
})

local ScrollFrame = createInstance("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 6,
    ScrollBarImageColor3 = CONFIG.Colors.Border,
    CanvasSize = UDim2.new(0, 0, 0, 550),
    Parent = MainContent
})

local PageTitle = createInstance("TextLabel", {
    Size = UDim2.new(1, -40, 0, 40),
    Position = UDim2.new(0, 24, 0, 16),
    BackgroundTransparency = 1,
    Text = "Combat",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScrollFrame
})

local PageDescription = createInstance("TextLabel", {
    Size = UDim2.new(1, -40, 0, 20),
    Position = UDim2.new(0, 24, 0, 52),
    BackgroundTransparency = 1,
    Text = "Configure combat system settings and automation",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = ScrollFrame
})

-- ═══════════════════════════════════════════════════════════════
--  SECTION BUILDER
-- ═══════════════════════════════════════════════════════════════

local function createSection(title, description, position, width)
    local section = createInstance("Frame", {
        Name = title,
        Size = UDim2.new(width, -12, 0, 0),
        Position = position,
        BackgroundColor3 = CONFIG.Colors.Surface,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = ScrollFrame
    })
    
    applyCorner(section, 12)
    applyStroke(section, CONFIG.Colors.Border, 1)
    
    createInstance("UIPadding", {
        PaddingTop = UDim.new(0, 20),
        PaddingBottom = UDim.new(0, 20),
        PaddingLeft = UDim.new(0, 20),
        PaddingRight = UDim.new(0, 20),
        Parent = section
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = section
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0, 24),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = section
        })
    end
    
    local container = createInstance("Frame", {
        Name = "Container",
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, description and 50 or 30),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = section
    })
    
    createInstance("UIListLayout", {
        Padding = UDim.new(0, 12),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = container
    })
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  TOGGLE COMPONENT
-- ═══════════════════════════════════════════════════════════════

local function createToggle(parent, text, description, defaultState)
    local container = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, description and 60 or 44),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(0.7, 0, 0, 32),
            Position = UDim2.new(0, 0, 0, 22),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = container
        })
    end
    
    local toggleBg = createInstance("Frame", {
        Size = UDim2.new(0, 52, 0, 30),
        Position = UDim2.new(1, -52, 0, 7),
        BackgroundColor3 = defaultState and CONFIG.Colors.Success or CONFIG.Colors.Border,
        BorderSizePixel = 0,
        Parent = container
    })
    
    applyCorner(toggleBg, 15)
    
    local toggleButton = createInstance("TextButton", {
        Size = UDim2.new(0, 24, 0, 24),
        Position = defaultState and UDim2.new(0, 25, 0.5, -12) or UDim2.new(0, 3, 0.5, -12),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = toggleBg
    })
    
    applyCorner(toggleButton, 12)
    
    local enabled = defaultState or false
    
    toggleButton.MouseButton1Click:Connect(function()
        enabled = not enabled
        tween(toggleButton, {
            Position = enabled and UDim2.new(0, 25, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
        }, CONFIG.Animation.Fast)
        tween(toggleBg, {
            BackgroundColor3 = enabled and CONFIG.Colors.Success or CONFIG.Colors.Border
        }, CONFIG.Animation.Fast)
    end)
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  SLIDER COMPONENT
-- ═══════════════════════════════════════════════════════════════

local function createSlider(parent, text, description, min, max, default)
    local container = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, description and 74 or 58),
        BackgroundTransparency = 1,
        Parent = parent
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0.6, 0, 0, 20),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = container
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0, 60, 0, 20),
        Position = UDim2.new(1, -60, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(default or 50),
        TextColor3 = CONFIG.Colors.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Right,
        Parent = container
    })
    
    if description then
        createInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 28),
            Position = UDim2.new(0, 0, 0, 22),
            BackgroundTransparency = 1,
            Text = description,
            TextColor3 = CONFIG.Colors.TextSecondary,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = container
        })
    end
    
    local sliderBg = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 6),
        Position = description and UDim2.new(0, 0, 1, -12) or UDim2.new(0, 0, 1, -6),
        BackgroundColor3 = CONFIG.Colors.Border,
        BorderSizePixel = 0,
        Parent = container
    })
    
    applyCorner(sliderBg, 3)
    
    local sliderFill = createInstance("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundColor3 = CONFIG.Colors.Primary,
        BorderSizePixel = 0,
        Parent = sliderBg
    })
    
    applyCorner(sliderFill, 3)
    
    local sliderButton = createInstance("TextButton", {
        Size = UDim2.new(0, 18, 0, 18),
        Position = UDim2.new(0.5, -9, 0.5, -9),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = sliderBg
    })
    
    applyCorner(sliderButton, 9)
    applyStroke(sliderButton, CONFIG.Colors.Primary, 2)
    
    return container
end

-- ═══════════════════════════════════════════════════════════════
--  BUILD UI CONTENT
-- ═══════════════════════════════════════════════════════════════

local SystemSection = createSection("Combat System", "Enable and configure combat automation", UDim2.new(0, 24, 0, 90), 0.48)
local SettingsSection = createSection("Combat Settings", "Fine-tune combat behavior and timing", UDim2.new(0.52, 0, 0, 90), 0.48)

createToggle(SystemSection, "Enable Combat", "Activate automatic combat system", true)
createToggle(SystemSection, "Dodge Light Attacks", "Automatically dodge light punches", true)
createToggle(SystemSection, "Dodge Heavy Attacks", "Automatically dodge heavy punches", true)
createToggle(SystemSection, "Block Ultimate Attacks", "Block ultimate moves automatically", true)
createToggle(SystemSection, "Attack on Dash", "Counter-attack when enemy dashes", false)

createSlider(SettingsSection, "Normal Dodge Delay", "Reaction time for normal dodges (ms)", 0, 500, 150)
createSlider(SettingsSection, "Heavy Dodge Delay", "Reaction time for heavy dodges (ms)", 0, 500, 200)
createSlider(SettingsSection, "Activation Range", "Maximum distance to activate (studs)", 0, 100, 25)
createToggle(SettingsSection, "No Stun", "Prevent stun effects on player", false)
createToggle(SettingsSection, "No Reverse Input", "Disable input reversal effects", false)

-- ═══════════════════════════════════════════════════════════════
--  FOOTER
-- ═══════════════════════════════════════════════════════════════

local Footer = createInstance("Frame", {
    Name = "Footer",
    Size = UDim2.new(1, 0, 0, 32),
    Position = UDim2.new(0, 0, 1, -32),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BorderSizePixel = 0,
    Parent = MainFrame
})

createInstance("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = CONFIG.Colors.Border,
    BorderSizePixel = 0,
    Parent = Footer
})

createInstance("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
    BackgroundTransparency = 1,
    Text = "v2.0.0 • Professional Edition",
    TextColor3 = CONFIG.Colors.TextSecondary,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = Footer
})

createInstance("TextLabel", {
    Size = UDim2.new(0, 200, 1, 0),
    Position = UDim2.new(1, -216, 0, 0),
    BackgroundTransparency = 1,
    Text = "● Connected",
    TextColor3 = CONFIG.Colors.Success,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Footer
})

-- ═══════════════════════════════════════════════════════════════
--  NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════

local NotificationContainer = createInstance("Frame", {
    Name = "NotificationContainer",
    Size = UDim2.new(0, 320, 1, -20),
    Position = UDim2.new(1, -330, 0, 10),
    BackgroundTransparency = 1,
    Parent = ScreenGui
})

createInstance("UIListLayout", {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Parent = NotificationContainer
})

local function createNotification(title, message, duration, notifType)
    local notif = createInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 80),
        BackgroundColor3 = CONFIG.Colors.Surface,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = NotificationContainer
    })
    
    applyCorner(notif, 10)
    applyStroke(notif, CONFIG.Colors.Border, 1)
    
    createInstance("Frame", {
        Size = UDim2.new(0, 4, 1, 0),
        BackgroundColor3 = notifType == "success" and CONFIG.Colors.Success or 
                           notifType == "warning" and CONFIG.Colors.Warning or
                           notifType == "error" and CONFIG.Colors.Danger or CONFIG.Colors.Primary,
        BorderSizePixel = 0,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 16, 0, 20),
        BackgroundTransparency = 1,
        Text = notifType == "success" and "✓" or notifType == "warning" and "⚠" or notifType == "error" and "✕" or "ℹ",
        TextColor3 = notifType == "success" and CONFIG.Colors.Success or 
                     notifType == "warning" and CONFIG.Colors.Warning or
                     notifType == "error" and CONFIG.Colors.Danger or CONFIG.Colors.Primary,
        Font = Enum.Font.GothamBold,
        TextSize = 24,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, -76, 0, 20),
        Position = UDim2.new(0, 64, 0, 16),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = CONFIG.Colors.TextPrimary,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif
    })
    
    createInstance("TextLabel", {
        Size = UDim2.new(1, -76, 0, 32),
        Position = UDim2.new(0, 64, 0, 38),
        BackgroundTransparency = 1,
        Text = message,
        TextColor3 = CONFIG.Colors.TextSecondary,
        Font = Enum.Font.Gotham,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif
    })
    
    notif.Size = UDim2.new(1, 0, 0, 0)
    tween(notif, {Size = UDim2.new(1, 0, 0, 80)}, CONFIG.Animation.Normal)
    
    task.delay(duration or 3, function()
        tween(notif, {Size = UDim2.new(1, 0, 0, 0)}, CONFIG.Animation.Normal)
        task.wait(0.3)
        notif:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════
--  WINDOW CONTROLS
-- ═══════════════════════════════════════════════════════════════

CloseBtn.MouseButton1Click:Connect(function()
    tween(MainFrame, {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In))
    task.wait(0.3)
    ScreenGui:Destroy()
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    if currentState ~= "Minimized" then
        currentState = "Minimized"
        tween(MainFrame, {Size = CONFIG.Sizes.Minimized, Position = CONFIG.Positions.Minimized})
        ContentContainer.Visible = false
        Footer.Visible = false
    else
        currentState = "Normal"
        ContentContainer.Visible = true
        Footer.Visible = true
        tween(MainFrame, {Size = CONFIG.Sizes.Normal, Position = CONFIG.Positions.Normal})
    end
end)

MaximizeBtn.MouseButton1Click:Connect(function()
    if currentState == "Minimized" then
        ContentContainer.Visible = true
        Footer.Visible = true
    end
    
    if currentState ~= "Maximized" then
        currentState = "Maximized"
        tween(MainFrame, {Size = CONFIG.Sizes.Maximized, Position = CONFIG.Positions.Maximized})
    else
        currentState = "Normal"
        tween(MainFrame, {Size = CONFIG.Sizes.Normal, Position = CONFIG.Positions.Normal})
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  DRAG SYSTEM
-- ═══════════════════════════════════════════════════════════════

local dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 and currentState == "Normal" then
        isDragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if isDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        isDragging = false
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  KEYBIND SYSTEM
-- ═══════════════════════════════════════════════════════════════

local isGuiVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightShift then
        isGuiVisible = not isGuiVisible
        
        if isGuiVisible then
            MainFrame.Visible = true
            tween(MainFrame, {
                Position = currentState == "Normal" and CONFIG.Positions.Normal or 
                          currentState == "Minimized" and CONFIG.Positions.Minimized or 
                          CONFIG.Positions.Maximized
            }, CONFIG.Animation.Normal)
            createNotification("GUI Shown", "Press Right Shift to hide", 2, "info")
        else
            tween(MainFrame, {Position = UDim2.new(0.5, 0, -0.5, 0)}, CONFIG.Animation.Normal)
            task.wait(0.3)
            MainFrame.Visible = false
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  PERFORMANCE MONITOR
-- ═══════════════════════════════════════════════════════════════

local PerformanceFrame = createInstance("Frame", {
    Name = "Performance",
    Size = UDim2.new(0, 120, 0, 60),
    Position = UDim2.new(0, 12, 1, -72),
    BackgroundColor3 = CONFIG.Colors.Surface,
    BackgroundTransparency = 0.3,
    BorderSizePixel = 0,
    Visible = false,
    Parent = Sidebar
})

applyCorner(PerformanceFrame, 8)

local FPSLabel = createInstance("TextLabel", {
    Size = UDim2.new(1, -16, 0, 20),
    Position = UDim2.new(0, 8, 0, 8),
    BackgroundTransparency = 1,
    Text = "FPS: 60",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = PerformanceFrame
})

local PingLabel = createInstance("TextLabel", {
    Size = UDim2.new(1, -16, 0, 20),
    Position = UDim2.new(0, 8, 0, 32),
    BackgroundTransparency = 1,
    Text = "Ping: 0ms",
    TextColor3 = CONFIG.Colors.TextPrimary,
    Font = Enum.Font.GothamMedium,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = PerformanceFrame
})

local lastFrameTime = tick()
local frameCount = 0

RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastFrameTime >= 1 then
        local fps = frameCount
        FPSLabel.Text = "FPS: " .. tostring(fps)
        FPSLabel.TextColor3 = fps >= 55 and CONFIG.Colors.Success or fps >= 30 and CONFIG.Colors.Warning or CONFIG.Colors.Danger
        frameCount = 0
        lastFrameTime = tick()
    end
end)

-- ═══════════════════════════════════════════════════════════════
--  INITIALIZATION
-- ═══════════════════════════════════════════════════════════════

task.wait(0.5)
createNotification(
    "Mirage Hub Loaded",
    "Professional Edition v2.0.0 • Press Right Shift to toggle",
    4,
    "success"
)

print("╔═══════════════════════════════════════════════════════╗")
print("║          MIRAGE HUB - PROFESSIONAL EDITION            ║")
print("╠═══════════════════════════════════════════════════════╣")
print("║  Version: 2.0.0                                       ║")
print("║  Status: ✓ Loaded Successfully                        ║")
print("║  Game: Untitled Boxing Game                           ║")
print("╠═══════════════════════════════════════════════════════╣")
print("║  Keybinds:                                            ║")
print("║  • Right Shift: Toggle GUI Visibility                 ║")
print("║  • Drag Title Bar: Move Window                        ║")
print("╠═══════════════════════════════════════════════════════╣")
print("║  Features:                                            ║")
print("║  ✓ Professional UI Design                             ║")
print("║  ✓ Smooth Animations                                  ║")
print("║  ✓ Window Controls (Min/Max/Close)                    ║")
print("║  ✓ Notification System                                ║")
print("║  ✓ Performance Monitoring                             ║")
print("║  ✓ Draggable Interface                                ║")
print("║  ✓ macOS Style Decorations                            ║")
print("╚═══════════════════════════════════════════════════════╝")

ScreenGui.Destroying:Connect(function()
    if pulseConnection then
        pulseConnection:Disconnect()
    end
    print("Mirage Hub: Unloaded successfully")
end)

-- ═══════════════════════════════════════════════════════════════
--  END OF SCRIPT
-- ═══════════════════════════════════════════════════════════════