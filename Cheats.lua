local Cheats = {}

-- Variables d'état
Cheats.flying = false
Cheats.speed = 50
Cheats.godModeActive = false
Cheats.isAutoPiloting = false
Cheats.autoPilotTarget = Vector3.zero
Cheats.updateUI = function() end

local godConnection = nil
local RunService = game:GetService("RunService")

local function getPlayer() return game.Players.LocalPlayer end

-- =========================
-- GHOST / GOD MODE
-- =========================

function Cheats.enableGodMode(humanoid)
    if not humanoid then return end
    Cheats.godModeActive = true
    
    if godConnection then godConnection:Disconnect() end
    godConnection = humanoid.HealthChanged:Connect(function(health)
        if health <= 0 and Cheats.godModeActive then
            humanoid:ChangeState(Enum.HumanoidStateType.Dead)
            humanoid.Health = humanoid.MaxHealth
        end
    end)
    -- Reset immédiat au cas où
    humanoid.Health = humanoid.MaxHealth
end

function Cheats.disableGodMode()
    Cheats.godModeActive = false
    if godConnection then
        godConnection:Disconnect()
        godConnection = nil
    end
end

-- =========================
-- FLY SYSTEM
-- =========================

function Cheats.enableFly(hrp, humanoid)
    if not hrp then return end

    -- Nettoyage
    for _, v in pairs(hrp:GetChildren()) do
        if v.Name == "FlyAttachment" or v:IsA("LinearVelocity") or v:IsA("AlignOrientation") then
            v:Destroy()
        end
    end

    Cheats.flying = true
    local att = Instance.new("Attachment", hrp)
    att.Name = "FlyAttachment"

    local lv = Instance.new("LinearVelocity", hrp)
    lv.Attachment0 = att
    lv.RelativeTo = Enum.ActuatorRelativeTo.World
    lv.MaxForce = 999999999

    local align = Instance.new("AlignOrientation", hrp)
    align.Attachment0 = att
    align.Mode = Enum.OrientationAlignmentMode.OneAttachment
    align.RigidityEnabled = true
    align.MaxTorque = 999999999
    align.Responsiveness = 25

    humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

function Cheats.disableFly(humanoid)
    local hrp = getPlayer().Character and getPlayer().Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        for _, v in pairs(hrp:GetChildren()) do
            if v.Name == "FlyAttachment" or v:IsA("LinearVelocity") or v:IsA("AlignOrientation") then
                v:Destroy()
            end
        end
    end
    if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    Cheats.flying = false
end

-- =========================
-- WAYPOINTS SYSTEM
-- =========================

local function createWaypoints()
    local folder = workspace:FindFirstChild("Waypoints") or Instance.new("Folder", workspace)
    folder.Name = "Waypoints"
    if #folder:GetChildren() > 0 then return end
    
    local posList = {
        Vector3.new(0, 12.35, 16), Vector3.new(-19, 12.35, 21),
        Vector3.new(-33, 12.35, 29), Vector3.new(-41.071, 12.35, 19),
        Vector3.new(-41.071, 269.35, 19), Vector3.new(-41.071, 269.35, -19),
        Vector3.new(-99.014, 269.35, -44), Vector3.new(-30.014, 268.35, -18)
    }
    
    for i, pos in ipairs(posList) do
        local p = Instance.new("Part")
        p.Size = Vector3.new(1,1,1); p.Anchored = true; p.CanCollide = false; p.Transparency = 1
        p.Name = "WP_"..i; p.Position = pos; p.Parent = folder
    end
end

function Cheats.runWaypoints(hrp, humanoid)
    if not hrp or not humanoid then return end
    createWaypoints()
    Cheats.enableFly(hrp, humanoid)
    local folder = workspace:FindFirstChild("Waypoints")
    
    Cheats.isAutoPiloting = true -- Verrouillage dès le début
    
    for i = 1, 8 do
        local wp = folder:FindFirstChild("WP_" .. i)
        if wp then
            -- On vérifie à chaque waypoint si le personnage existe encore
            while Cheats.flying and wp do
                local char = getPlayer().Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then 
                    break -- Sort de la boucle si mort
                end
                
                local currentHrp = char.HumanoidRootPart
                local dist = (currentHrp.Position - wp.Position).Magnitude
                
                if dist < 3 then break end -- Point atteint
                
                local dir = (wp.Position - currentHrp.Position).Unit
                local lv = currentHrp:FindFirstChildOfClass("LinearVelocity")
                local al = currentHrp:FindFirstChildOfClass("AlignOrientation")
                
                if lv then lv.VectorVelocity = dir * Cheats.speed end
                if al then al.CFrame = CFrame.lookAt(currentHrp.Position, wp.Position) end
                
                RunService.Heartbeat:Wait()
            end
        end
    end
    
    Cheats.isAutoPiloting = false -- Déverrouillage automatique
    Cheats.disableFly(humanoid)
end

-- =========================
-- REALTIME CONTROL
-- =========================

function Cheats.updateDirections(cam, UIS)
    local char = getPlayer().Character
    if not Cheats.flying or not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if Cheats.isAutoPiloting then return end -- L'auto-pilot prend le dessus

    local hrp = char.HumanoidRootPart
    local lv = hrp:FindFirstChildOfClass("LinearVelocity")
    local align = hrp:FindFirstChildOfClass("AlignOrientation")

    local dir = Vector3.zero
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end

    if lv then lv.VectorVelocity = (dir.Magnitude > 0) and (dir.Unit * Cheats.speed) or Vector3.zero end
    if align then align.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + cam.CFrame.LookVector) end
end

return Cheats