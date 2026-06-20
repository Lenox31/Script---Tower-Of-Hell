local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local PROXY_URL = "https://proxy-keys-production.up.railway.app"

-- VARIABLE GLOBALE (C'est ici qu'elle manquait)
local keyValid = false 

local function isKeyValid(userKey)
    -- Essaie cette liste de fonctions courantes selon ton injecteur
    local httpRequest = request or http_request or syn and syn.request or http.request
    
    if not httpRequest then
        warn("ERREUR : Aucune fonction HTTP trouvée. Ton injecteur est peut-être limité.")
        return false
    end

    local success, res = pcall(function()
        return httpRequest({
            Url = PROXY_URL .. "/verify?key=" .. HttpService:UrlEncode(userKey),
            Method = "GET",
            Headers = { ["x-secret-token"] = "TonMotDePasseTresSecret" }
        })
    end)
    
    if not success then
        warn("ERREUR CRITIQUE DANS L'APPEL HTTP : " .. tostring(res))
        return false
    end
    
    print("Code HTTP reçu : " .. (res.StatusCode or "Inconnu"))
    
    if res.StatusCode == 200 then
        local data = HttpService:JSONDecode(res.Body)
        return data.valid == true
    else
        warn("Le serveur a répondu avec le code : " .. (res.StatusCode or "Aucun"))
        return false
    end
end

local function requestKey()
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 280, 0, 40)
    input.Position = UDim2.new(0, 10, 0, 10)
    input.PlaceholderText = "Entre ta clé ici..."
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 60)
    btn.Text = "Valider"
    
    btn.MouseButton1Click:Connect(function()
        if isKeyValid(input.Text) then
            keyValid = true
            gui:Destroy()
        else
            -- Feedback visuel au lieu du Kick direct pour tester
            btn.Text = "Clé invalide !"
            task.wait(1)
            btn.Text = "Valider"
        end
    end)
    
    repeat task.wait() until keyValid
end

-- Lancement
requestKey()

-------------------------------------------------
-- INITIALISATION (Le code original commence ici)
-------------------------------------------------

local BASE_URL = "https://raw.githubusercontent.com/Lenox31/Script---Tower-Of-Hell/main/"

local function import(fileName)
    -- Ajout de ?t=os.time() pour forcer le rechargement
    local success, src = pcall(function() 
        return game:HttpGet(BASE_URL .. fileName .. ".lua?t=" .. os.time()) 
    end)
    
    if not success then
        warn("Erreur de connexion : " .. fileName)
        return nil
    end
    
    local func, err = loadstring(src)
    if not func then
        warn("Erreur de syntaxe dans " .. fileName .. " : " .. tostring(err))
        return nil
    end
    
    return func()
end

-------------------------------------------------
-- INITIALISATION
-------------------------------------------------
local ThemeConfig = import("ThemeConfig")
local Cheats = import("Cheats")
local UI = import("UI")

if not Cheats then warn("Cheats introuvable") return end
if not UI then warn("UI introuvable") return end

-- Initialisation de la variable manquante
Cheats.isAutoPiloting = false
Cheats.flyKeybind = Enum.KeyCode.F -- Touche par défaut

local Elements = UI.Create(ThemeConfig, Cheats)

-------------------------------------------------
-- LOGIQUE PERSONNAGE
-------------------------------------------------
local function setupCharacter(c)
    local hrp = c:WaitForChild("HumanoidRootPart", 10)
    local hum = c:WaitForChild("Humanoid", 10)
    if not hrp or not hum then return end
    
    -- On applique les états persistants si nécessaire
    if Cheats.flying then Cheats.enableFly(hrp, hum) end
    if Cheats.godModeActive then Cheats.enableGodMode(hum) end
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then setupCharacter(player.Character) end

-------------------------------------------------
-- BOUCLES & ÉVÉNEMENTS
-------------------------------------------------
RunService.RenderStepped:Connect(function()
    if Cheats.updateDirections then Cheats.updateDirections(workspace.CurrentCamera, UIS) end
end)

Elements.autoBtn.MouseButton1Click:Connect(function()
    if Cheats.isAutoPiloting then return end
    
    task.spawn(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum then
            -- Utilisation de pcall pour garantir le déverrouillage
            local success, err = pcall(function()
                Cheats.runWaypoints(hrp, hum)
            end)
            
            if not success then warn("Erreur Auto-Tower : " .. tostring(err)) end
            
            Cheats.isAutoPiloting = false -- GARANTIE : On déverrouille quoi qu'il arrive
        end
    end)
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if Cheats.flyKeybind and input.KeyCode == Cheats.flyKeybind then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if hrp and hum then
            -- On bascule l'état
            if Cheats.flying then
                Cheats.disableFly(hum)
                -- Mise à jour visuelle du bouton (nécessite que 'Elements' contienne les refs)
                if Elements.flySwitch then
                    Elements.flySwitch.BackgroundColor3 = ThemeConfig.THEME.AccentGray
                    Elements.flyCircle:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2, true)
                end
            else
                Cheats.enableFly(hrp, hum)
                -- Mise à jour visuelle du bouton
                if Elements.flySwitch then
                    Elements.flySwitch.BackgroundColor3 = ThemeConfig.THEME.AccentBlue
                    Elements.flyCircle:TweenPosition(UDim2.new(1, -19, 0.5, 0), "Out", "Quad", 0.2, true)
                end
            end
        end
    end
end)