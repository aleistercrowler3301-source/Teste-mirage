local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.2, 0, 0.8, 0)
MainFrame.Position = UDim2.new(0.4, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0.1, 0)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.1, 0)
Title.Text = "Mod Menu"
Title.TextSize = 36
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.SourceSansBold
Title.Parent = MainFrame

local FPSCounter = Instance.new("TextLabel")
FPSCounter.Size = UDim2.new(1, 0, 0.05, 0)
FPSCounter.Position = UDim2.new(0, 0, 0.1, 0)
FPSCounter.Text = "FPS: 0"
FPSCounter.TextColor3 = Color3.fromRGB(255, 255, 255)
FPSCounter.BackgroundTransparency = 1
FPSCounter.Font = Enum.Font.SourceSans
FPSCounter.TextSize = 20
FPSCounter.Parent = MainFrame

local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Size = UDim2.new(1, 0, 0.75, 0)
ButtonsContainer.Position = UDim2.new(0, 0, 0.15, 0)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.ClipsDescendants = true
ButtonsContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.FillDirection = Enum.FillDirection.Vertical
UIListLayout.Padding = UDim.new(0.02, 0)
UIListLayout.Parent = ButtonsContainer

local PageLeft = Instance.new("TextButton")
PageLeft.Size = UDim2.new(0.5, 0, 0.05, 0)
PageLeft.Position = UDim2.new(0, 0, 0.95, 0)
PageLeft.Text = "<"
PageLeft.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PageLeft.Font = Enum.Font.SourceSansBold
PageLeft.TextSize = 20
PageLeft.Parent = MainFrame

local PageRight = Instance.new("TextButton")
PageRight.Size = UDim2.new(0.5, 0, 0.05, 0)
PageRight.Position = UDim2.new(0.5, 0, 0.95, 0)
PageRight.Text = ">"
PageRight.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
PageRight.Font = Enum.Font.SourceSansBold
PageRight.TextSize = 20
PageRight.Parent = MainFrame

local RunService = game:GetService("RunService")
RunService.RenderStepped:Connect(function(dt)
    FPSCounter.Text = "FPS: " .. tostring(math.floor(1 / dt))
end)

local buttons = {
    {name = "Button1", type = "button", callback = function() print("Button1 clicked") end},
    {name = "Toggle1", type = "toggle", on = function() print("Toggle On") end, off = function() print("Toggle Off") end},
}

local currentPage = 1
local itemsPerPage = 5

local function renderPage(page)
    for _, child in ipairs(ButtonsContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    local startIndex = (page - 1) * itemsPerPage + 1
    local endIndex = math.min(page * itemsPerPage, #buttons)
    for i = startIndex, endIndex do
        local item = buttons[i]
        local btn = Instance.new("TextButton", ButtonsContainer)
        btn.Size = UDim2.new(1, 0, 0.1, 0)
        btn.Text = item.name
        btn.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        btn.TextColor3 = Color3.fromRGB(0, 0, 0)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 20
        local UICornerBtn = Instance.new("UICorner")
        UICornerBtn.CornerRadius = UDim.new(0.1, 0)
        UICornerBtn.Parent = btn
        if item.type == "button" then
            btn.MouseButton1Click:Connect(item.callback)
        elseif item.type == "toggle" then
            local toggled = false
            btn.MouseButton1Click:Connect(function()
                toggled = not toggled
                btn.BackgroundColor3 = toggled and Color3.fromRGB(100, 200, 100) or Color3.fromRGB(200, 200, 200)
                if toggled then
                    item.on()
                else
                    item.off()
                end
            end)
        end
    end
end

PageLeft.MouseButton1Click:Connect(function()
    if currentPage > 1 then
        currentPage = currentPage - 1
        renderPage(currentPage)
    end
end)

PageRight.MouseButton1Click:Connect(function()
    if currentPage < math.ceil(#buttons / itemsPerPage) then
        currentPage = currentPage + 1
        renderPage(currentPage)
    end
end)

renderPage(currentPage)