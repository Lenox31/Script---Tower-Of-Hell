local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local PROXY_URL = "https://proxy-keys-production.up.railway.app"

-- 1. VERIFICATION FUNCTION
local function isKeyValid(userKey)
    local httpRequest = request or http_request or (syn and syn.request) or http.request
    
    if not httpRequest then
        warn("ERROR: No HTTP function found.")
        return false
    end

    local success, res = pcall(function()
        return httpRequest({
            Url = PROXY_URL .. "/verify?key=" .. HttpService:UrlEncode(userKey),
            Method = "GET"
        })
    end)
    
    if not success then return false end
    
    if res.StatusCode == 200 then
        local data = HttpService:JSONDecode(res.Body)
        return data.valid == true
    end
    return false
end

-- 2. SCRIPT STARTUP (Encapsulated)
local function startScript()
    print("Key verified, starting script...")
    local BASE_URL = "https://raw.githubusercontent.com/Lenox31/Script---Tower-Of-Hell/main/"

    local function import(fileName)
        local success, src = pcall(function() 
            return game:HttpGet(BASE_URL .. fileName .. ".lua?t=" .. os.time()) 
        end)
        if not success then return nil end
        
        local func, err = loadstring(src)
        if not func then return nil end
        return func()
    end

    local ThemeConfig = import("ThemeConfig")
    local Cheats = import("Cheats")
    local UI = import("UI")

    if not Cheats or not UI then warn("Modules not found") return end

    Cheats.isAutoPiloting = false
    Cheats.flyKeybind = Enum.KeyCode.F
    local Elements = UI.Create(ThemeConfig, Cheats)

    local function setupCharacter(c)
        local hrp = c:WaitForChild("HumanoidRootPart", 10)
        local hum = c:WaitForChild("Humanoid", 10)
        if not hrp or not hum then return end
        if Cheats.flying then Cheats.enableFly(hrp, hum) end
        if Cheats.godModeActive then Cheats.enableGodMode(hum) end
    end

    player.CharacterAdded:Connect(setupCharacter)
    if player.Character then setupCharacter(player.Character) end

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
                pcall(function() Cheats.runWaypoints(hrp, hum) end)
                Cheats.isAutoPiloting = false
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
                if Cheats.flying then
                    Cheats.disableFly(hum)
                    if Elements.flySwitch then
                        Elements.flySwitch.BackgroundColor3 = ThemeConfig.THEME.AccentGray
                        Elements.flyCircle:TweenPosition(UDim2.new(0, 3, 0.5, 0), "Out", "Quad", 0.2, true)
                    end
                else
                    Cheats.enableFly(hrp, hum)
                    if Elements.flySwitch then
                        Elements.flySwitch.BackgroundColor3 = ThemeConfig.THEME.AccentBlue
                        Elements.flyCircle:TweenPosition(UDim2.new(1, -19, 0.5, 0), "Out", "Quad", 0.2, true)
                    end
                end
            end
        end
    end)
end

-- 3. KEY INTERFACE
local function requestKey()
    local TweenService = game:GetService("TweenService")
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "KeyAuthUI"
    
    -- Cadre principal (Modern Dark)
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 350, 0, 220)
    frame.Position = UDim2.new(0.5, -175, 0.5, -110)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 15)
    
    -- Effet de bordure brillante
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(60, 60, 70)
    stroke.Thickness = 2
    
    -- Titre
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Text = "HELLBREAKER X"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 20
    title.BackgroundTransparency = 1

    -- Input Field
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 300, 0, 50)
    input.Position = UDim2.new(0.5, -150, 0, 60)
    input.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    input.PlaceholderText = "Enter your key..."
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)
    
    -- Bouton de validation
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 300, 0, 50)
    btn.Position = UDim2.new(0.5, -150, 0, 130)
    btn.BackgroundColor3 = Color3.fromRGB(75, 120, 255)
    btn.Text = "VERIFY KEY"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    -- Animation au survol (Hover Effect)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(95, 140, 255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(75, 120, 255)}):Play()
    end)

    -- Logique de vérification
    btn.MouseButton1Click:Connect(function()
        btn.Text = "Verifying..."
        btn.Active = false
        
        task.spawn(function()
            local valid = isKeyValid(input.Text)
            if valid then
                btn.Text = "Success!"
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(80, 200, 80)}):Play()
                task.wait(0.5)
                TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
                task.wait(0.5)
                gui:Destroy()
                startScript()
            else
                btn.Text = "Invalid Key"
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(200, 80, 80)}):Play()
                task.wait(1)
                btn.Text = "VERIFY KEY"
                btn.Active = true
                TweenService:Create(btn, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(75, 120, 255)}):Play()
            end
        end)
    end)
end

requestKey()