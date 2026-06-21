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
    local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    gui.Name = "KeyAuthUI"
    
    -- Cadre principal
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 340, 0, 360) -- Hauteur augmentée pour loger les nouveaux éléments
    frame.Position = UDim2.new(0.5, -170, 0.5, -180)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    frame.BorderSizePixel = 0
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    -- Titre
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 60)
    title.Text = "HellbreakerX"
    title.Font = Enum.Font.GothamBold
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 22
    title.BackgroundTransparency = 1

    -- Texte "License Verification"
    local licenseLabel = Instance.new("TextLabel", frame)
    licenseLabel.Size = UDim2.new(1, 0, 0, 20)
    licenseLabel.Position = UDim2.new(0, 0, 0, 60)
    licenseLabel.Text = "🔑 License Verification"
    licenseLabel.Font = Enum.Font.Gotham
    licenseLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    licenseLabel.TextSize = 14
    licenseLabel.BackgroundTransparency = 1

    -- Input
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 300, 0, 45)
    input.Position = UDim2.new(0.5, -150, 0, 90)
    input.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    input.PlaceholderText = "Enter your key..."
    input.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Gotham
    Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)
    
    -- Bouton
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 300, 0, 45)
    btn.Position = UDim2.new(0.5, -150, 0, 155)
    btn.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    btn.Text = "Verify Key"
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    -- Fine barre blanche sous le bouton
    local line = Instance.new("Frame", frame)
    line.Size = UDim2.new(0, 300, 0, 1)
    line.Position = UDim2.new(0.5, -150, 0, 220)
    line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    line.BorderSizePixel = 0
    line.BackgroundTransparency = 0.5 -- Légèrement transparente pour le look "pro"

    -- Status sous la barre
    local status = Instance.new("TextLabel", frame)
    status.Size = UDim2.new(0, 300, 0, 30)
    status.Position = UDim2.new(0.5, -150, 0, 230)
    status.Text = "Status: Waiting..."
    status.Font = Enum.Font.Gotham
    status.TextColor3 = Color3.fromRGB(200, 200, 200)
    status.BackgroundTransparency = 1

    -- Animation de clic
    btn.MouseButton1Click:Connect(function()
        status.Text = "Status: Verifying..."
        status.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        task.spawn(function()
            local valid = isKeyValid(input.Text)
            if valid then
                status.Text = "Status: Success!"
                status.TextColor3 = Color3.fromRGB(80, 255, 80)
                task.wait(0.5)
                gui:Destroy()
                startScript()
            else
                status.Text = "Status: Invalid Key"
                status.TextColor3 = Color3.fromRGB(255, 80, 80)
                task.wait(1.5)
                status.Text = "Status: Waiting..."
                status.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
        end)
    end)
end

requestKey()