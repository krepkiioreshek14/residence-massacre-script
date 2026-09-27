local OrionLib = loadstring(game:HttpGet(('https://githubusercontent.com')))()

local Window = OrionLib:MakeWindow({
    Name = "Residence Massacre Advanced Hub v2.0", 
    HidePremium = true, 
    SaveConfig = false
})

local LocalPlayer = game.Players.LocalPlayer
local SurvivalTab = Window:MakeTab({ Name = "Выживание", Icon = "rbxassetid://4483345998" })

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

OrionLib:Init()
.