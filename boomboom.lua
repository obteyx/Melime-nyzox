local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Attendre que le jeu soit complètement chargé
repeat wait() until game:IsLoaded()

-- Créer la fenêtre principale avec Rayfield
local Window = Rayfield:CreateWindow({
    Name = "ACS script ez free bounty",
    LoadingTitle = "Chargement...",
    LoadingSubtitle = "by Nyzox & Melime ( 98 aussi )",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "ACSExplosiveSettings"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false,
    Key = "nyzoxmelimelesgoats"
})

-- Variables nécessaires
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Définir les paramètres de l'ESP
_G.SendNotifications = true
_G.DefaultSettings = false
_G.TeamCheck = false
_G.ESPVisible = true
_G.TextColor = Color3.fromRGB(255, 80, 10)
_G.TextSize = 14
_G.Center = true
_G.Outline = true
_G.OutlineColor = Color3.fromRGB(0, 0, 0)
_G.TextTransparency = 0.7
_G.TextFont = Drawing.Fonts.UI

-- Variable pour l'activation de l'ESP
local ESPEnabled = true

-- Fonction pour créer l'ESP
local function CreateESP()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= Players.LocalPlayer.Name then
            local ESP = Drawing.new("Text")

            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) and workspace[v.Name]:FindFirstChild("HumanoidRootPart") then
                    local Vector, OnScreen = Camera:WorldToViewportPoint(workspace[v.Name]:WaitForChild("Head").Position)

                    ESP.Size = _G.TextSize
                    ESP.Center = _G.Center
                    ESP.Outline = _G.Outline
                    ESP.OutlineColor = _G.OutlineColor
                    ESP.Color = _G.TextColor
                    ESP.Transparency = _G.TextTransparency
                    ESP.Font = _G.TextFont

                    if OnScreen then
                        local Dist = (workspace[v.Name].HumanoidRootPart.Position - workspace[Players.LocalPlayer.Name].HumanoidRootPart.Position).Magnitude
                        ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)
                        ESP.Text = ("(" .. tostring(math.floor(Dist)) .. ") " .. v.Name .. " [" .. workspace[v.Name].Humanoid.Health .. "]")
                        ESP.Visible = _G.ESPVisible
                    else
                        ESP.Visible = false
                    end
                else
                    ESP.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                ESP.Visible = false
            end)
        end
    end
end

-- Créer un onglet pour l'ESP dans Rayfield
local VisualTab = Window:CreateTab("ESP", 4483362458)

-- Créer un bouton "Toggle ESP" dans l'onglet ESP
VisualTab:CreateButton({
    Name = "Toggle ESP",
    Callback = function()
        ESPEnabled = not ESPEnabled
        _G.ESPVisible = ESPEnabled
    end
})

-- Créer un bouton "Boom Boom" dans l'onglet ESP
VisualTab:CreateButton({
    Name = "Boom Boom Loop (En boucle)",
    Callback = function()
        local plr = game.Players.LocalPlayer
        local Evt = game.ReplicatedStorage.ACS_Engine.Eventos

        local Settings = {
            ["ExplosiveHit"] = true,
            ["ExPressure"] = math.huge,
            ["ExpRadius"] = math.huge,
            ["DestroyJointRadiusPercent"] = math.huge,
            ["ExplosionDamage"] = math.huge,
        }

        -- Boucle pour envoyer les événements d'explosion
        while wait() do
            pcall(function()
                for _, v in pairs(game.Players:GetChildren()) do
                    -- Déclenche l'explosion pour chaque joueur
                    Evt.Hit:FireServer(v.Character.Head.Position, v.Character.Head, v.Character.Head.Position, Enum.Material.Plastic, Settings)
                end
            end)
        end
    end
})

-- Créer un Color Picker pour la couleur de l'ESP
VisualTab:CreateColorPicker({
    Name = "ESP Color",
    DefaultColor = _G.TextColor,
    Callback = function(color)
        _G.TextColor = color
    end
})


-- Créer un Slider pour la taille du texte
VisualTab:CreateSlider({
    Name = "ESP Text Size",
    Min = 10,
    Max = 30,
    Default = _G.TextSize,
    Callback = function(size)
        _G.TextSize = size
    end
})

-- Créer un Toggle pour activer/désactiver le contour du texte
VisualTab:CreateToggle({
    Name = "Outline Text",
    Default = _G.Outline,
    Callback = function(value)
        _G.Outline = value
    end
})

-- Créer un Color Picker pour la couleur du contour du texte
VisualTab:CreateColorPicker({
    Name = "Outline Color",
    DefaultColor = _G.OutlineColor,
    Callback = function(color)
        _G.OutlineColor = color
    end
})

-- Créer un Slider pour ajuster la transparence du texte
VisualTab:CreateSlider({
    Name = "Text Transparency",
    Min = 0,
    Max = 1,
    Default = _G.TextTransparency,
    Callback = function(value)
        _G.TextTransparency = value
    end
})

-- Créer un Toggle pour activer/désactiver l'ESP
VisualTab:CreateToggle({
    Name = "Show ESP",
    Default = _G.ESPVisible,
    Callback = function(value)
        _G.ESPVisible = value
    end
})

-- Mettre à jour l'ESP
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        CreateESP() -- Crée et met à jour l'ESP
    end
end)

Window:Display()
