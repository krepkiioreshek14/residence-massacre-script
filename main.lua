local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

local Window = OrionLib:MakeWindow({
    Name = "Residence Massacre Advanced Hub v2.0", 
    HidePremium = true, 
    SaveConfig = false
})

local LocalPlayer = game.Players.LocalPlayer

local SurvivalTab = Window:MakeTab({
    Name = "Выживание",
    Icon = "rbxassetid://4483345998"
})

_G.InfStamina = false
SurvivalTab:AddToggle({
    Name = "Бесконечная выносливость (Stamina)",
    Default = false,
    Callback = function(Value)
        _G.InfStamina = Value
        task.spawn(function()
            while _G.InfStamina do
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Stamina") then
                    LocalPlayer.Character.Stamina.Value = 100
                elseif LocalPlayer:FindFirstChild("Stamina") then
                    LocalPlayer.Stamina.Value = 100
                end
                pcall(function()
                    LocalPlayer.Character:SetAttribute("Stamina", 100)
                    LocalPlayer.Character:SetAttribute("SprintEnergy", 100)
                end)
                task.wait(0.1)
            end
        end)
    end
})

_G.InfOxygen = false
SurvivalTab:AddToggle({
    Name = "Бесконечный кислород (Бункер/Шахта)",
    Default = false,
    Callback = function(Value)
        _G.InfOxygen = Value
        task.spawn(function()
            while _G.InfOxygen do
                pcall(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Oxygen") then
                        LocalPlayer.Character.Oxygen.Value = 100
                    end
                    LocalPlayer.Character:SetAttribute("Oxygen", 100)
                    LocalPlayer.Character:SetAttribute("Air", 100)
                end)
                task.wait(0.1)
            end
        end)
    end
})

_G.InfFlashlight = false
SurvivalTab:AddToggle({
    Name = "Вечный фонарик (No Battery Drain)",
    Default = false,
    Callback = function(Value)
        _G.InfFlashlight = Value
        task.spawn(function()
            while _G.InfFlashlight do
                pcall(function()
                    local flashlight = LocalPlayer.Character:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                    if flashlight and (flashlight.Name:lower():find("light") or flashlight.Name:lower():find("flash")) then
                        if flashlight:FindFirstChild("Battery") then
                            flashlight.Battery.Value = 100
                        end
                        flashlight:SetAttribute("Battery", 100)
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

local Lighting = game:GetService("Lighting")
local OriginalAmbient = Lighting.Ambient
local VisualsTab = Window:MakeTab({ Name = "Визуалы", Icon = "rbxassetid://4483345998" })

_G.FullBright = false
VisualsTab:AddToggle({
    Name = "Режим FullBright (Свет во тьме)",
    Default = false,
    Callback = function(Value)
        _G.FullBright = Value
        if _G.FullBright then
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.Brightness = 2
            Lighting.GlobalShadows = false
        else
            Lighting.Ambient = OriginalAmbient
            Lighting.Brightness = 1
            Lighting.GlobalShadows = true
        end
    end
})

local function CreateHighlight(instance, color, name)
    if not instance:FindFirstChild("HubHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "HubHighlight"
        highlight.FillColor = color
        highlight.FillTransparency = 0.5
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.Parent = instance
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "HubName"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        billboard.ExtentsOffset = Vector3.new(0, 3, 0)
        billboard.Parent = instance
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = color
        textLabel.TextSize = 14
        textLabel.Font = Enum.Font.SourceSansBold
        textLabel.Text = name
        textLabel.Parent = billboard
    end
end

_G.MonsterESP = false
VisualsTab:AddToggle({
    Name = "Подсветка монстров (ESP)",
    Default = false,
    Callback = function(Value)
        _G.MonsterESP = Value
        task.spawn(function()
            while _G.MonsterESP do
                for _, obj in pairs(workspace:GetChildren()) do
                    if obj:IsA("Model") and (obj.Name:lower():find("monster") or obj.Name:lower():find("mutant") or obj.Name:lower():find("larry") or obj.Name:lower():find("blood")) then
                        if obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head") then
                            CreateHighlight(obj, Color3.fromRGB(255, 0, 0), "МОНСТР!")
                        end
                    end
                end
                task.wait(1.5)
            end
        end)
    end
})

local PlayerTab = Window:MakeTab({
    Name = "Телепорты и Настройки",
    Icon = rbxassetid://4483345998
})

local function TeleportTo(position)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(position)
    end
end

PlayerTab:AddButton({
    Name = "ТП к Генератору питания",
    Callback = function()
        local gen = workspace:FindFirstChild("Generator") or workspace:FindFirstChild("PowerBox") or workspace:FindFirstChild("FuseBox")
        if gen then
            TeleportTo(gen:IsA("Model") and gen.PrimaryPart.Position or gen.Position + Vector3.new(0,3,0))
        else
            OrionLib:MakeNotification({Name = "Упс", Content = "Генератор еще не появился на карте!", Time = 2})
        end
    end
})

PlayerTab:AddButton({
    Name = "ТП Безопасная Зона (Внутрь дома)",
    Callback = function()
        TeleportTo(Vector3.new(-34, 10, -47))
    end
})

PlayerTab:AddSlider({
    Name = "Скорость бега игрока",
    Min = 16, Max = 120, Default = 16, Increment = 1, ValueName = "Speed",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end    
})

OrionLib:Init()