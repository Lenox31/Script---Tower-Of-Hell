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
    local frame = Instance.new("Frame", gui)
    frame.Size = UDim2.new(0, 300, 0, 150)
    frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    
    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 280, 0, 40)
    input.Position = UDim2.new(0, 10, 0, 10)
    input.PlaceholderText = "Enter your key here..."
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, 60)
    btn.Text = "Validate"
    
    btn.MouseButton1Click:Connect(function()
        if isKeyValid(input.Text) then
            gui:Destroy()
            startScript()
        else
            player:Kick("Invalid key! Access denied.")
        end
    end)
end

requestKey()