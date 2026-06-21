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
    
    -- Cadre style Terminal
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 320, 0, 300)
    frame.Position = UDim2.new(0.5, -160, 0.5, -150)
    frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    frame.BorderSizePixel = 0
    
    -- Bordures blanches pour le look "Boîte"
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    
    -- Titre
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.Text = "HellbreakerX"
    title.Font = Enum.Font.Code
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 24
    title.BackgroundTransparency = 1

    -- Icone/Texte Licence
    local subtitle = Instance.new("TextLabel", frame)
    subtitle.Position = UDim2.new(0, 0, 0, 70)
    subtitle.Size = UDim2.new(1, 0, 0, 30)
    subtitle.Text = "🔑 License Verification"
    subtitle.Font = Enum.Font.Code
    subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    subtitle.BackgroundTransparency = 1

    -- Input
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 280, 0, 40)
    input.Position = UDim2.new(0.5, -140, 0, 120)
    input.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    input.PlaceholderText = "Enter your key here..."
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.Font = Enum.Font.Code
    local inputStroke = Instance.new("UIStroke", input)
    inputStroke.Color = Color3.fromRGB(255, 255, 255)
    
    -- Bouton
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0.5, -140, 0, 180)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.Text = "[ VERIFY KEY ]"
    btn.Font = Enum.Font.Code
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(255, 255, 255)

    -- Status
    local status = Instance.new("TextLabel", frame)
    status.Position = UDim2.new(0, 20, 0, 250)
    status.Size = UDim2.new(0, 280, 0, 30)
    status.Text = "Status: Waiting..."
    status.Font = Enum.Font.Code
    status.TextColor3 = Color3.fromRGB(255, 255, 255)
    status.TextXAlignment = Enum.TextXAlignment.Left
    status.BackgroundTransparency = 1

    -- Animation de clic
    btn.MouseButton1Click:Connect(function()
        status.Text = "Status: Verifying..."
        btn.Text = "[ ... ]"
        
        task.spawn(function()
            local valid = isKeyValid(input.Text)
            if valid then
                status.Text = "Status: Success!"
                task.wait(0.5)
                gui:Destroy()
                startScript()
            else
                status.Text = "Status: Invalid Key"
                btn.Text = "[ FAILED ]"
                task.wait(1.5)
                btn.Text = "[ VERIFY KEY ]"
                status.Text = "Status: Waiting..."
            end
        end)
    end)
end

requestKey()