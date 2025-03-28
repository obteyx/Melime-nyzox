local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Attendre que le jeu soit complètement chargé
repeat wait() until game:IsLoaded()

-- Créer la fenêtre principale avec Rayfield
local Window = Rayfield:CreateWindow({
    Name = "ACS Explosive - Game Cheats",
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
    Key = "nyzoxmelimelesgoats"  -- Remplace "VOTRE_CLE" par la clé que tu souhaites utiliser (si nécessaire)
})

-- Variables nécessaires
local plr = game.Players.LocalPlayer
local Evt = game.ReplicatedStorage.ACS_Engine.Eventos

local Settings = {
    ["ExplosiveHit"] = true,
    ["ExPressure"] = math.huge,
    ["ExpRadius"] = math.huge,
    ["DestroyJointRadiusPercent"] = math.huge,
    ["ExplosionDamage"] = math.huge,
}

local ESPEnabled = false
local ESPColor = Color3.fromRGB(255, 0, 0)

local SilentAimEnabled = false
local FOV = 80  -- FOV pour l'aimbot
local HitChance = 90  -- Chance de toucher pour Silent Aim

-- Créer un onglet pour les actions sur les joueurs
local PlayerTab = Window:CreateTab("Player Actions", 4483362458)

-- Créer un bouton "Boom Boom"
PlayerTab:CreateButton({
    Name = "Boom Boom",
    Callback = function()
        -- Code pour faire exploser tous les joueurs
        for _, player in pairs(game.Players:GetChildren()) do
            if player.Character and player.Character.Head then
                Evt.Hit:FireServer(player.Character.Head.Position, player.Character.Head, player.Character.Head.Position, Enum.Material.Plastic, Settings)
            end
        end
        print("Boom Boom activé !")
    end
})

-- Créer un onglet pour ESP
local VisualTab = Window:CreateTab("ESP", 4483362458)

-- Activer/Désactiver l'ESP
VisualTab:CreateButton({
    Name = "Toggle ESP",
    Callback = function()
        ESPEnabled = not ESPEnabled
        print("ESP " .. (ESPEnabled and "Enabled" or "Disabled"))
    end
})

-- Sélectionner la couleur de l'ESP
VisualTab:CreateColorPicker({
    Name = "ESP Color",
    DefaultColor = ESPColor,
    Callback = function(color)
        ESPColor = color
        print("Couleur ESP changée")
    end
})

-- Créer un onglet pour l'Aimbot
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

-- Activer/Désactiver le Silent Aim
AimbotTab:CreateButton({
    Name = "Toggle Silent Aim",
    Callback = function()
        SilentAimEnabled = not SilentAimEnabled
        print("Silent Aim " .. (SilentAimEnabled and "Activé" or "Désactivé"))
    end
})

-- Mettre à jour l'ESP et gérer l'Aimbot et Silent Aim
local RunService = game:GetService("RunService")
local plrs = game:GetService("Players")

-- Fonction pour mettre à jour l'ESP
RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        -- Met à jour l'ESP avec une boîte ou d'autres éléments visuels
        for _, player in pairs(plrs:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local humanoidRootPart = player.Character.HumanoidRootPart
                -- Afficher un box pour l'ESP
                local box = Drawing.new("Square")
                box.Size = Vector2.new(50, 50)
                box.Position = Vector2.new(humanoidRootPart.Position.X, humanoidRootPart.Position.Y)
                box.Color = ESPColor
                box.Filled = false
                box.Thickness = 2
                box.Visible = true
            end
        end
    end
end)

-- Aimbot et Silent Aim
RunService.RenderStepped:Connect(function()
    if SilentAimEnabled then
        local closestPlayer = nil
        local closestDistance = math.huge

        for _, player in pairs(plrs:GetPlayers()) do
            if player ~= plr and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local playerPos = player.Character.HumanoidRootPart.Position
                local screenPos = game:GetService("Workspace").CurrentCamera:WorldToScreenPoint(playerPos)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                
                -- Trouver le joueur le plus proche
                if distance < closestDistance and distance < FOV then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end

        if closestPlayer then
            -- Viser automatiquement sur le joueur le plus proche
            local humanoidRootPart = closestPlayer.Character.HumanoidRootPart
            local camera = game:GetService("Workspace").CurrentCamera
            camera.CFrame = CFrame.new(camera.CFrame.Position, humanoidRootPart.Position)

            -- Chance de toucher
            if math.random(1, 100) <= HitChance then
                -- Tirer sur le joueur (implémenter le tir ici)
                print("Silent Aim: Tir sur " .. closestPlayer.Name)
            end
        end
    end
end)

-- Afficher la fenêtre de Rayfield
Window:Display()