-- Kiểm tra ID game
if game.PlaceId ~= 18687417158 then
    return warn("Script only works in the specified game (ID: 18687417158){[NOLI🎭] Forsaken}")
end

-- Thông báo khi đúng ID game
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✓ Game Check Passed",
    Text = "Script is now executing...",
    Duration = 5
})

-- Lưu lại hàm gốc
local oldSetClipboard = setclipboard

-- Ghi đè
setclipboard = function(text)
    if text == "https://discord.gg/ZRTkpWuK" then
        warn("hookes test", text)
        return -- không làm gì
    end
    -- Nếu không bị chặn, gọi hàm gốc
    return oldSetClipboard(text)
end

task.wait(1) -- Đợi 1s trước khi thực thi 





task.spawn(function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Forsaken/main/Hitboxfunction"))()
wait(2)
getgenv().RV = 0
end)

task.spawn(function()
-- Break maxstamina Loop (standalone version)
local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems")
    :WaitForChild("Character")
    :WaitForChild("Game")
    :WaitForChild("Sprinting"))

if staminaModule then
    -- Hook thuộc tính MaxStamina để không thể bị thay đổi
    local mt = getrawmetatable(staminaModule)
    setreadonly(mt, false)
    local oldIndex = mt.__newindex
    mt.__newindex = function(t, k, v)
        if k == "MaxStamina" then
            warn("[BlockFunction] Prevented setting MSN:", v)
            return
        end
        return oldIndex(t, k, v)
    end
    setreadonly(mt, true)
    
    -- Hook __staminaChangedEvent:Fire để không cho script khác gọi
    if staminaModule.__staminaChangedEvent then
        staminaModule.__staminaChangedEvent.Fire = function() end
    end

    print("[Forsaken] Are you kidding me?")
else
    warn("[BlockInfStamina] staminaModule not found.")
end
end)

task.wait(1)


local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

function Notification(Message, Time)
if _G.ChooseNotify == "Obsidian" then
Library:Notify(Message, Time or 5)
elseif _G.ChooseNotify == "Roblox" then
game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Error",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
end
if _G.NotificationSound then
        local sound = Instance.new("Sound", workspace)
            sound.SoundId = "rbxassetid://4590662766"
            sound.Volume = _G.VolumeTime or 2
            sound.PlayOnRemove = true
            sound:Destroy()
        end
    end

Library:SetDPIScale(85)

local Window = Library:CreateWindow({
    Title = "[NOLI🎭] Forsaken",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "Script by IganhK",
	   Icon = 82204364945595, -- ID logo

    AutoLock = false,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
	Tab = Window:AddTab("Game", "rbxassetid://7734053426"),
	Tab2 = Window:AddTab("  - = 2=-", "rbxassetid://7734053426"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

local Main1Group = Tabs.Tab:AddLeftGroupbox("Main")

-- first, set a default global delay
_G.AutoGeneralDelay = 1.8

-- add a slider to tweak the delay
Main1Group:AddSlider("GeneralDelay", {
    Text = "General Delay (s)",
    Min = 1.8,
    Max = 10,
    Default = _G.AutoGeneralDelay,
    Rounding = 1,
    Callback = function(val)
        _G.AutoGeneralDelay = val
    end
})

-- then your toggle, using that delay
Main1Group:AddToggle("AutoGeneral", {
    Text = "Auto General",
    Default = false,
    Callback = function(Value)
        _G.AutoGeneral = Value
        -- spawn a new loop task whenever toggled on
        task.spawn(function()
            while _G.AutoGeneral do
                if workspace.Map.Ingame:FindFirstChild("Map") then
                    for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator"
                        and v:FindFirstChild("Remotes")
                        and v.Remotes:FindFirstChild("RE") then
                            v.Remotes.RE:FireServer()
                        end
                    end
                end
                task.wait(_G.AutoGeneralDelay)
            end
        end)
    end
})

Main1Group:AddToggle("Inf Stamina", {
    Text = "Infinite Stamina",
    Default = false, 
    Callback = function(Value) 
_G.InfStamina = Value
while _G.InfStamina do
local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
if staminaModule then

    staminaModule.Stamina = 69696969
    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
end
task.wait()
end
    end
})

Main1Group:AddToggle("ToggleRestoreGUI", {
    Text = "Rest0re Stamina GUI",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local gui = player:WaitForChild("PlayerGui"):FindFirstChild("RestoreStaminaGui")

        -- Nếu chưa tồn tại GUI thì tạo mới
        if not gui then
            gui = Instance.new("ScreenGui")
            gui.Name = "RestoreStaminaGui"
            gui.ResetOnSpawn = false
            gui.Parent = player:WaitForChild("PlayerGui")

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 260, 0, 120)
            mainFrame.Position = UDim2.new(0.5, -130, 1, -150)
            mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            mainFrame.BorderColor3 = Color3.new(1, 0, 0)
            mainFrame.BorderSizePixel = 1
            mainFrame.Active = true
            mainFrame.Draggable = true
            mainFrame.Parent = gui

            local title = Instance.new("TextLabel")
            title.Size = UDim2.new(1, 0, 0, 30)
            title.BackgroundTransparency = 1
            title.Text = "RestOre Stamina"
            title.TextColor3 = Color3.new(1, 0, 0)
            title.TextScaled = true
            title.Font = Enum.Font.Code
            title.Parent = mainFrame

            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, -20, 0, 50)
            button.Position = UDim2.new(0, 10, 0, 50)
            button.BackgroundColor3 = Color3.new(0, 0, 0)
            button.BorderColor3 = Color3.new(1, 0, 0)
            button.BorderSizePixel = 1
            button.Text = "Activate"
            button.TextColor3 = Color3.new(1, 0, 0)
            button.TextScaled = true
            button.Font = Enum.Font.Code
            button.Parent = mainFrame

            button.MouseButton1Click:Connect(function()
    _G.InfStamina = true
    local suc, err = pcall(function()
        local sprinting = require(game.ReplicatedStorage:WaitForChild("Systems")
            :WaitForChild("Character")
            :WaitForChild("Game")
            :WaitForChild("Sprinting"))
        
        if sprinting and sprinting.DefaultConfig then
            local maxStamina = sprinting.DefaultConfig.MaxStamina or 100 -- lấy MaxStamina, fallback = 100
            sprinting.Stamina = maxStamina
            sprinting.__staminaChangedEvent:Fire(sprinting.Stamina)
        end
    end)
    if not suc then
        warn("InfStamina Error:", err)
    end
end)
        end

        -- Bật/Tắt GUI
        gui.Enabled = state
    end
})


Main1Group:AddDivider()


Main1Group:AddLabel("--== Shedletsky ==--", true) 
Main1Group:AddToggle("AutoSlash (Passive)", {
    Text = "Auto Slash (Passive)",
    Default = false,
    Callback = function(Value)
        _G.AutoSlash = Value
        task.spawn(function()
            local TweenService = game:GetService("TweenService")
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

            local function GetHRP()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                return char:FindFirstChild("HumanoidRootPart")
            end

            local function GetHumanoid()
                local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                return char:FindFirstChild("Humanoid")
            end

            -- 🔁 MỚI: Chỉ cho phép khi LocalPlayer là Shedletsky Survivor
            local function IsShedletskySurvivor()
                local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                return character and character.Name == "Shedletsky"
            end

            local function GetNearestKiller()
                local nearest, minDist = nil, math.huge
                local hrp = GetHRP()
                if not hrp then return end
                for _, v in pairs(workspace.Players:GetChildren()) do
                    if v.Name == "Killers" then
                        for _, killer in pairs(v:GetChildren()) do
                            if killer ~= LocalPlayer.Character then
                                local hrp2 = killer:FindFirstChild("HumanoidRootPart")
                                local hum = killer:FindFirstChildOfClass("Humanoid")
                                if hrp2 and hum and hum.Health > 0 then
                                    local dist = (hrp.Position - hrp2.Position).Magnitude
                                    if dist <= 20 then
                                        local directionToLocal = (hrp.Position - hrp2.Position).Unit
                                        local killerLook = hrp2.CFrame.LookVector.Unit
                                        local dotLook = killerLook:Dot(directionToLocal)

                                        local killerVelocity = hrp2.Velocity.Unit
                                        local dotMove = killerVelocity:Dot(directionToLocal)

                                        -- Killer phải nhìn và đi về phía LocalPlayer
                                        if dotLook > 0.11 and dotMove > 0.8 and dist < minDist then
                                            minDist = dist
                                            nearest = hrp2
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                return nearest
            end

            while _G.AutoSlash do
                -- ❌ Nếu không phải Shedletsky thì không hoạt động
                if not IsShedletskySurvivor() then
                    task.wait(1)
                    continue
                end

                local humanoid = GetHumanoid()
                local hrp = GetHRP()
                if humanoid and humanoid.WalkSpeed < 26 and hrp then
                    local target = GetNearestKiller()
                    if target then
                        -- Slash
                        local args = { "UseActorAbility", "Slash" }
                        Remote:FireServer(unpack(args))

                        -- Xoay liên tục trong 3s
                        local startTime = tick()
                        while tick() - startTime < 2.2 and _G.AutoSlash do
                            if not target.Parent then break end
                            local dir = (target.Position - hrp.Position).Unit
                            local look = CFrame.new(hrp.Position, hrp.Position + Vector3.new(dir.X, 0, dir.Z))
                            hrp.CFrame = look
                            task.wait()
                        end

                        task.wait(37)
                    end
                end
                task.wait(0.25)
            end
        end)
    end
})

getgenv().AutoAimShed = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local lastAimTime = 0 -- thời điểm lần aim cuối

local function GetHRP()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart") or nil
end

local function GetNearestKiller()
    local hrp = GetHRP()
    if not hrp then return nil end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return nil end
    local nearest, minDist
    for _, killer in pairs(killersFolder:GetChildren()) do
        if killer ~= LocalPlayer.Character then
            local hrp2 = killer:FindFirstChild("HumanoidRootPart")
            local hum = killer:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum and hum.Health > 0 then
                local dist = (hrp.Position - hrp2.Position).Magnitude
                if not minDist or dist < minDist then
                    minDist = dist
                    nearest = hrp2
                end
            end
        end
    end
    return nearest
end

if not getgenv().AutoAimHooked then
    getgenv().AutoAimHooked = true

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if not checkcaller() and method == "FireServer" and self == Remote then
            local a1, a2 = args[1], args[2]

            if getgenv().AutoAimShed and a1 == "UseActorAbility" and a2 == "Slash" then
                -- Check cooldown
                if tick() - lastAimTime < 40 then
                    return oldNamecall(self, ...)
                end
                lastAimTime = tick()

                local result = oldNamecall(self, ...)

                task.spawn(function()
                    local start = tick()
                    while tick() - start <= 1.5 and getgenv().AutoAimShed do
                        local hrp, target = GetHRP(), GetNearestKiller()
                        if hrp and target then
                            local tgtPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
                            hrp.CFrame = CFrame.new(hrp.Position, tgtPos)
                        end
                        task.wait()
                    end
                end)

                return result
            end
        end

        return oldNamecall(self, ...)
    end)
end

-- Toggle trong Obsidian Lib
Main1Group:AddToggle("AutoAimShed", {
    Text = "Auto Aim",
    Default = false,
    Callback = function(v)
        getgenv().AutoAimShed = v
    end
})


Main1Group:AddDivider()


Main1Group:AddLabel("--== Chance ==--", true)
--// Auto Aim Chance (ObsidianLib)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Workspace = game:GetService("Workspace")

-- Config
local aimDuration = 1.7
local trackedAnimations = {
    ["103601716322988"] = true,
    ["133491532453922"] = true,
    ["86371356500204"] = true,
    ["76649505662612"] = true,
    ["81698196845041"] = true
}

-- State
local Humanoid, HRP = nil, nil
local lastTriggerTime = 0
local aiming = false
local originalWS, originalJP, originalAutoRotate = nil, nil, nil

-- Hàm lấy killer gần nhất
local function GetNearestKiller()
    if not HRP then return nil end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return nil end
    local nearest, minDist
    for _, killer in pairs(killersFolder:GetChildren()) do
        if killer ~= LocalPlayer.Character then
            local hrp2 = killer:FindFirstChild("HumanoidRootPart")
            local hum = killer:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum and hum.Health > 0 then
                local dist = (HRP.Position - hrp2.Position).Magnitude
                if not minDist or dist < minDist then
                    minDist = dist
                    nearest = hrp2
                end
            end
        end
    end
    return nearest
end

-- Hàm lấy animation đang chơi
local function GetPlayingAnimationIds()
    local ids = {}
    if Humanoid then
        for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
            if track.Animation and track.Animation.AnimationId then
                local id = track.Animation.AnimationId:match("%d+")
                if id then ids[id] = true end
            end
        end
    end
    return ids
end

-- Setup khi spawn
local function SetupChar(char)
    Humanoid = char:WaitForChild("Humanoid")
    HRP = char:WaitForChild("HumanoidRootPart")
end
if LocalPlayer.Character then
    SetupChar(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(SetupChar)

-- Tạo toggle trong ObsidianLib
Main1Group:AddToggle("AutoAimChance", {
    Text = "Auto Aim",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAimChance = Value
    end
})

-- Loop aim
RunService.RenderStepped:Connect(function()
    if not getgenv().AutoAimChance or not Humanoid or not HRP then return end

    -- Phát hiện animation Chance
    local playing = GetPlayingAnimationIds()
    local triggered = false
    for id in pairs(trackedAnimations) do
        if playing[id] then
            triggered = true
            break
        end
    end

    if triggered then
        lastTriggerTime = tick()
        aiming = true
    end

    -- Aim trong 1.7s sau khi phát hiện animation
    if aiming and tick() - lastTriggerTime <= aimDuration then
        if not originalWS then
            originalWS = Humanoid.WalkSpeed
            originalJP = Humanoid.JumpPower
            originalAutoRotate = Humanoid.AutoRotate
        end
        Humanoid.AutoRotate = false
        HRP.AssemblyAngularVelocity = Vector3.zero

        local targetHRP = GetNearestKiller()
        if targetHRP then
            local predictedPos = targetHRP.Position
            local direction = (predictedPos - HRP.Position).Unit
            local yRot = math.atan2(-direction.X, -direction.Z)
            HRP.CFrame = CFrame.new(HRP.Position) * CFrame.Angles(0, yRot, 0)
        end
    elseif aiming then
        aiming = false
        if originalWS and originalJP and originalAutoRotate ~= nil then
            Humanoid.WalkSpeed = originalWS
            Humanoid.JumpPower = originalJP
            Humanoid.AutoRotate = originalAutoRotate
            originalWS, originalJP, originalAutoRotate = nil, nil, nil
        end
    end
end)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- RemoteEvent
local remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

-- Trạng thái toggle
local AutoCoinFlip = false
local delayTime = 0.6

-- Lấy số Charges của Reroll
local function getRerollCharges()
    local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    if not mainUI then return nil end
    local abilityContainer = mainUI:FindFirstChild("AbilityContainer")
    if not abilityContainer then return nil end
    local reroll = abilityContainer:FindFirstChild("Reroll")
    if reroll and reroll:FindFirstChild("Charges") and reroll.Charges:IsA("TextLabel") then
        return tonumber(reroll.Charges.Text)
    end
    return nil
end

-- Toggle
Main1Group:AddToggle("ToggleCoinFlip", {
    Text = "Auto CoinFlip",
    Default = false,
    Callback = function(v)
        AutoCoinFlip = v
    end
})

-- Loop
task.spawn(function()
    while true do
        if AutoCoinFlip then
            local char = LocalPlayer.Character
            if char 
            and char.Parent 
            and char.Parent.Name == "Survivors" 
            and char.Name == "Chance" then
                
                local charges = getRerollCharges()
                if not charges or charges < 3 then
                    remote:FireServer("UseActorAbility", "CoinFlip")
                end
            end
        end
        task.wait(delayTime)
    end
end)

-- Divider + Label
Main1Group:AddDivider()
Main1Group:AddLabel("--== Guest 1337 ==--", true)

--// Auto Block + Punch cho Guest1337 Survivor (Obsidian Lib)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local lp = Players.LocalPlayer

-- Remote
local NetworkEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

-- Biến
_G.AutoBlockPunch_Enabled = false
_G.AutoBlockPunch_Range = 18
local cooldown = 25 -- thời gian cooldown (giây)
local lastActionTime = 0

local clickedTracks = {}
local animationIds = {
    ["126830014841198"] = true, ["126355327951215"] = true, ["121086746534252"] = true,
    ["18885909645"] = true, ["98456918873918"] = true, ["105458270463374"] = true,
    ["83829782357897"] = true, ["125403313786645"] = true, ["118298475669935"] = true,
    ["82113744478546"] = true, ["70371667919898"] = true, ["99135633258223"] = true,
    ["97167027849946"] = true, ["109230267448394"] = true, ["139835501033932"] = true,
    ["126896426760253"] = true,
}

-- Kiểm tra localplayer là Guest1337 survivor (không ở team Killers)
local function isGuestSurvivor()
    if not lp.Character or lp.Character.Name ~= "Guest1337" then
        return false
    end
    return lp.Character.Parent and lp.Character.Parent.Name ~= "Killers"
end

-- Gửi remote block
local function remoteBlock()
    NetworkEvent:FireServer("UseActorAbility", "Block")
end

-- Gửi remote punch + aim
local function remotePunchAndAim(targetRoot)
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not (hrp and targetRoot) then return end

    local startTime = tick()
    local aimConn
    aimConn = RunService.Heartbeat:Connect(function()
        if tick() - startTime > 1 or not targetRoot.Parent then
            if aimConn then aimConn:Disconnect() end
            return
        end
        hrp.CFrame = CFrame.new(hrp.Position, targetRoot.Position)
    end)

    NetworkEvent:FireServer("UseActorAbility", "Punch")
end

-- Obsidian Lib UI
Main1Group:AddToggle("AutoBlockPunchToggle", {
    Text = "Auto Block + Punch",
    Default = false,
    Callback = function(v)
        _G.AutoBlockPunch_Enabled = v
    end
})

Main1Group:AddInput("AutoBlockPunchRange", {
    Default = tostring(_G.AutoBlockPunch_Range),
    Numeric = true,
    Text = "Detection Range",
    Placeholder = "5 ~ 50",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 5 and num <= 50 then
            _G.AutoBlockPunch_Range = num
        else
            Library:Notify("Invalid range (5-50)", 5)
        end
    end
})

-- Loop chính
RunService.Heartbeat:Connect(function()
    if not _G.AutoBlockPunch_Enabled or not isGuestSurvivor() then return end

    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end

    for _, killer in ipairs(killersFolder:GetChildren()) do
        local root = killer:FindFirstChild("HumanoidRootPart")
        local humanoid = killer:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            local dist = (root.Position - myRoot.Position).Magnitude
            if dist <= _G.AutoBlockPunch_Range then
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    local anim = track.Animation
                    local id = anim and anim.AnimationId and string.match(anim.AnimationId, "%d+")
                    if id and animationIds[id] and not clickedTracks[track] then
                        -- kiểm tra cooldown
                        if tick() - lastActionTime >= cooldown then
                            lastActionTime = tick() -- cập nhật thời điểm hành động
                            clickedTracks[track] = true
                            remoteBlock()
                            remotePunchAndAim(root)
                            task.spawn(function()
                                track.Stopped:Wait()
                                clickedTracks[track] = nil
                            end)
                        end
                    end
                end
            end
        end
    end
end)

--// Auto Aim (Charge) cho Guest1337 Survivor + Aim Camera
getgenv().AutoAimCharge = false

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera

local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local lastAimTime = 0 -- Cooldown 40s

local function GetHRP()
    local char = lp.Character
    return char and char:FindFirstChild("HumanoidRootPart") or nil
end

local function GetNearestKiller()
    local hrp = GetHRP()
    if not hrp then return nil end
    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return nil end
    local nearest, minDist
    for _, killer in pairs(killersFolder:GetChildren()) do
        if killer ~= lp.Character then
            local hrp2 = killer:FindFirstChild("HumanoidRootPart")
            local hum = killer:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum and hum.Health > 0 then
                local dist = (hrp.Position - hrp2.Position).Magnitude
                if not minDist or dist < minDist then
                    minDist = dist
                    nearest = hrp2
                end
            end
        end
    end
    return nearest
end

local function isGuestSurvivor()
    if not lp.Character or lp.Character.Name ~= "Guest1337" then
        return false
    end
    return lp.Character.Parent and lp.Character.Parent.Name ~= "Killers"
end

if not getgenv().AutoAimChargeHooked then
    getgenv().AutoAimChargeHooked = true

    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local args = {...}
        local method = getnamecallmethod()

        if not checkcaller() and method == "FireServer" and self == Remote then
            local a1, a2 = args[1], args[2]

            if getgenv().AutoAimCharge and a1 == "UseActorAbility" and a2 == "Charge" and isGuestSurvivor() then
                -- Cooldown 40s
                if tick() - lastAimTime < 40 then
                    return oldNamecall(self, ...)
                end
                lastAimTime = tick()

                local result = oldNamecall(self, ...)

                -- Aim liên tục 1.0s vào Killer gần nhất + xoay camera
                task.spawn(function()
                    local start = tick()
                    while tick() - start <= 1 and getgenv().AutoAimCharge do
                        local hrp, target = GetHRP(), GetNearestKiller()
                        if hrp and target then
                            local tgtPos = Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z)
                            -- Xoay nhân vật
                            hrp.CFrame = CFrame.new(hrp.Position, tgtPos)
                            -- Xoay camera theo hướng mục tiêu
                            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                        end
                        task.wait()
                    end
                end)

                return result
            end
        end

        return oldNamecall(self, ...)
    end)
end

-- Toggle Obsidian Lib
Main1Group:AddToggle("AutoAimCharge", {
    Text = "Auto Aim (Charge)",
    Default = false,
    Callback = function(v)
        getgenv().AutoAimCharge = v
    end
})





local Main1o5Group = Tabs.Tab:AddLeftTabbox() -- hoặc :AddLeftTabbox()

local M105One = Main1o5Group:AddTab("--== Player ==--")

--// Obsidian UI - M105One
M105One:AddDivider()

-- Input stamina
M105One:AddInput("MaxStaminaValue", {
    Default = "",
    Numeric = true,
    Finished = true,
    Text = "Max Stamina (10-1000)",
    Placeholder = "Enter",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 10 and num <= 1000 then
            _G.MaxStaminaValue = num
        else
            Library:Notify("Die, Wise, Cry", 5)
        end
    end
})

-- Toggle Apply Stamina
M105One:AddToggle("ApplyStamina", {
    Text = "Apply Stamina",
    Default = false,
    Callback = function(Value)
        _G.ApplyStamina = Value
        task.spawn(function()
            while _G.ApplyStamina do
                local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
                if staminaModule then
                    staminaModule.MaxStamina = _G.MaxStaminaValue or 110
                    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
                end
                task.wait(3)
            end
            -- Khi tắt thì set về 110
            if not _G.ApplyStamina then
                local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
                if staminaModule then
                    staminaModule.MaxStamina = 110
                    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
                end
            end
        end)
    end
})

M105One:AddLabel("-= Sprint Speed =-", true)

-- Input Survivor Speed
M105One:AddInput("SurvivorSpeed", {
    Default = "",
    Numeric = true,
    Finished = true,
    Text = "Survivor Speed (26-50)",
    Placeholder = "Enter",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 26 and num <= 50 and num ~= 35 and num ~= 45 then
            _G.SurvivorSpeed = num
        else
            Library:Notify("Die, Wise, Cry", 5)
        end
    end
})

-- Input Killer Speed
M105One:AddInput("KillerSpeed", {
    Default = "",
    Numeric = true,
    Finished = true,
    Text = "Killer Speed (27.5-50)",
    Placeholder = "Enter",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 27.5 and num <= 50 and num ~= 35 and num ~= 45 then
            _G.KillerSpeed = num
        else
            Library:Notify("Die, Wise, Cry", 5)
        end
    end
})

-- Toggle Apply Sprint Speed
M105One:AddToggle("ApplySprintSpeed", {
    Text = "Apply Sprint Speed",
    Default = false,
    Callback = function(Value)
        _G.ApplySprintSpeed = Value
        task.spawn(function()
            while _G.ApplySprintSpeed do
                local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
                local char = game.Players.LocalPlayer.Character
                if staminaModule and char and char.Parent then
                    local parentName = char.Parent.Name -- "Survivors" hoặc "Killers"
                    if parentName == "Survivors" then
                        if _G.SurvivorSpeed and _G.SurvivorSpeed ~= 35 and _G.SurvivorSpeed ~= 45 then
                            staminaModule.SprintSpeed = _G.SurvivorSpeed
                        end
                    elseif parentName == "Killers" then
                        if _G.KillerSpeed and _G.KillerSpeed ~= 35 and _G.KillerSpeed ~= 45 then
                            staminaModule.SprintSpeed = _G.KillerSpeed
                        end
                    end
                end
                task.wait(7)
            end

            -- Khi tắt set về default
            if not _G.ApplySprintSpeed then
                local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
                local char = game.Players.LocalPlayer.Character
                if staminaModule and char and char.Parent then
                    local parentName = char.Parent.Name
                    if parentName == "Survivors" then
                        staminaModule.SprintSpeed = 26 -- default survivor
                    elseif parentName == "Killers" then
                        staminaModule.SprintSpeed = 27.5 -- default killer
                    end
                end
            end
        end)
    end
})




























local M105Two = Main1o5Group:AddTab("--== Hitbox ==--")

M105Two:AddDivider()


_G.RV_Survivor = 0
_G.RV_Killer = 0

-- Input Survivor
M105Two:AddInput("Set dist Survivor", {
    Default = "0 ~ 1000",
    Numeric = true,
    Text = "Hitbox Dist (Survivor)",
    Placeholder = "Enter a number...",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 and num <= 1000 then
            _G.RV_Survivor = num
        else
            Library:Notify("Invalid value (0-1000)", 5)
        end
    end
})

-- Input Killer
M105Two:AddInput("Set dist Killer", {
    Default = "0 ~ 1000",
    Numeric = true,
    Text = "Hitbox Dist (Killer)",
    Placeholder = "Enter a number...",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0 and num <= 1000 then
            _G.RV_Killer = num
        else
            Library:Notify("Invalid value (0-1000)", 5)
        end
    end
})

-- Hàm áp dụng dựa trên thư mục Parent của nhân vật
local function applyHitboxDist()
    local lp = game.Players.LocalPlayer
    local char = lp.Character
    if not char then return end

    if char.Parent and char.Parent.Name == "Survivors" then
        getgenv().RV = _G.RV_Survivor
        Library:Notify("Survivor Dist: " .. tostring(_G.RV_Survivor))
    elseif char.Parent and char.Parent.Name == "Killers" then
        getgenv().RV = _G.RV_Killer
        Library:Notify("Killer Dist: " .. tostring(_G.RV_Killer))
    end
end

-- Theo dõi khi nhân vật đổi vai trò (Parent đổi)
local lp = game.Players.LocalPlayer
lp.CharacterAdded:Connect(function(char)
    char.AncestryChanged:Connect(function(_, parent)
        if parent and (parent.Name == "Survivors" or parent.Name == "Killers") then
            applyHitboxDist()
        end
    end)
    task.wait(0.5)
    applyHitboxDist()
end)

-- Nút Apply thủ công
M105Two:AddButton("Apply Hitbox Dist", function()
    applyHitboxDist()
end)

-- Chạy ngay khi load script
task.wait(0.5)
applyHitboxDist()

M105Two:AddDivider()
M105Two:AddLabel("You want to be hard to detect", true)
M105Two:AddLabel("Survivors: 0 ~ 15", true)
M105Two:AddLabel("Killers: 10 ~ 30", true)































































local Main2Group = Tabs.Tab:AddRightGroupbox("Other")

Main2Group:AddToggle("General", {
    Text = "Esp General",
    Default = false, 
    Callback = function(Value) 
_G.EspGeneral = Value
if _G.EspGeneral == false then
if workspace.Map.Ingame:FindFirstChild("Map") then
	for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
		if v.Name == "Generator" then
			for x, n in pairs(v:GetChildren()) do
				if n.Name:find("Esp_") then
					n:Destroy()
				end
			end
		end
	end
end
end
while _G.EspGeneral do
if workspace.Map.Ingame:FindFirstChild("Map") then
for i, v in pairs(workspace.Map.Ingame:FindFirstChild("Map"):GetChildren()) do
if v.Name == "Generator" and v:FindFirstChild("Progress") then
if v:FindFirstChild("Esp_Highlight") then
	if v:FindFirstChild("Progress").Value == 100 then
		v:FindFirstChild("Esp_Highlight").FillColor = Color3.fromRGB(0, 255, 0)
		v:FindFirstChild("Esp_Highlight").OutlineColor = Color3.fromRGB(0, 255, 0)
	else
		v:FindFirstChild("Esp_Highlight").FillColor = _G.ColorLight or Color3.new(255, 255, 255)
		v:FindFirstChild("Esp_Highlight").OutlineColor = _G.ColorLight or Color3.new(255, 255, 255)
	end
end
if _G.EspHighlight == true and v:FindFirstChild("Esp_Highlight") == nil then
	local Highlight = Instance.new("Highlight")
	Highlight.Name = "Esp_Highlight"
	Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
	Highlight.FillTransparency = 0.5
	Highlight.OutlineTransparency = 0
	Highlight.Adornee = v
	Highlight.Parent = v
	elseif _G.EspHighlight == false and v:FindFirstChild("Esp_Highlight") then
	v:FindFirstChild("Esp_Highlight"):Destroy()
end
if v:FindFirstChild("Esp_Gui") and v["Esp_Gui"]:FindFirstChild("TextLabel") then
	v["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
	        (_G.EspName == true and "General ("..v.Progress.Value.."%)" or "")..
            (_G.EspDistance == true and "\nDistance [ Fix ]" or "")
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
    v["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
end
if _G.EspGui == true and v:FindFirstChild("Esp_Gui") == nil then
	GuiGenEsp = Instance.new("BillboardGui", v)
	GuiGenEsp.Adornee = v
	GuiGenEsp.Name = "Esp_Gui"
	GuiGenEsp.Size = UDim2.new(0, 100, 0, 150)
	GuiGenEsp.AlwaysOnTop = true
	GuiGenEsp.StudsOffset = Vector3.new(0, 3, 0)
	GuiGenEspText = Instance.new("TextLabel", GuiGenEsp)
	GuiGenEspText.BackgroundTransparency = 1
	GuiGenEspText.Font = Enum.Font.Code
	GuiGenEspText.Size = UDim2.new(0, 100, 0, 100)
	GuiGenEspText.TextSize = 15
	GuiGenEspText.TextColor3 = Color3.new(0,0,0) 
	GuiGenEspText.TextStrokeTransparency = 0.5
	GuiGenEspText.Text = ""
	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = GuiGenEspText
	elseif _G.EspGui == false and v:FindFirstChild("Esp_Gui") then
	v:FindFirstChild("Esp_Gui"):Destroy()
end
end
end
end
task.wait()
end
    end
})

local function CreateItemESP(model, color, labelText)
	if model:FindFirstChild("ItemESP_Gui") then return end

	local head = model:FindFirstChildWhichIsA("BasePart")
	if not head then return end

	local gui = Instance.new("BillboardGui")
	gui.Name = "ItemESP_Gui"
	gui.Adornee = head
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.StudsOffset = Vector3.new(0, 2, 0)
	gui.AlwaysOnTop = true
	gui.Parent = head

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextColor3 = color
	lbl.Text = labelText
	lbl.Parent = gui

	-- Thêm viền chữ
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(0, 0, 0) -- viền đen
	stroke.Thickness = 1.5
	stroke.Parent = lbl
end

local function ClearItemESP(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("BillboardGui") and v.Name == "ItemESP_Gui" then
			v:Destroy()
		end
	end
end

local function HandleESP(itemName, color, labelText, enabledFlag)
	local RunService = game:GetService("RunService")
	local workspace = game:GetService("Workspace")
	local existing = {}

	-- Quét hiện tại
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == itemName then
			CreateItemESP(obj, color, labelText)
			table.insert(existing, obj)
		end
	end

	-- Theo dõi model mới thêm
	local con
	con = workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") and obj.Name == itemName and _G[enabledFlag] then
			task.wait(0.1)
			CreateItemESP(obj, color, labelText)
			table.insert(existing, obj)
		end
	end)

	-- Dọn khi tắt
	repeat task.wait(0.5) until not _G[enabledFlag]
	con:Disconnect()
	for _, obj in ipairs(existing) do
		ClearItemESP(obj)
	end
	table.clear(existing)
end

-- Toggle BloxyCola
Main2Group:AddToggle("EspBloxyCola", {
	Text = "ESP BloxyCola",
	Default = false,
	Callback = function(v)
		_G.EspBloxyCola = v
		if v then
			task.spawn(function()
				HandleESP("BloxyCola", Color3.fromRGB(0, 255, 255), "Bloxy", "EspBloxyCola")
			end)
		end
	end
})

-- Toggle Medkit
Main2Group:AddToggle("EspMedkit", {
	Text = "ESP Medkit",
	Default = false,
	Callback = function(v)
		_G.EspMedkit = v
		if v then
			task.spawn(function()
				HandleESP("Medkit", Color3.fromRGB(255, 255, 0), "Medkit", "EspMedkit")
			end)
		end
	end
})

-- helper to apply ESP GUI to a single character model
function Esp_Player(characterModel)
    -- destroy any existing highlight
    if characterModel:FindFirstChild("Esp_Highlight") then
        characterModel.Esp_Highlight:Destroy()
    end

    -- remove any old GUI
    for _, gui in ipairs(characterModel:GetDescendants()) do
        if gui.Name == "Esp_Gui" then
            gui:Destroy()
        end
    end

    -- if ESP is disabled, ensure any lingering GUI is removed
    if _G.EspGui == false then
        -- nothing to create, just return
        return
    end

    -- only run if Esp_Gui is enabled
    if not _G.EspGui then return end

    local head = characterModel:FindFirstChild("Head")
    if not head then return end

    -- create new BillboardGui
    local gui = Instance.new("BillboardGui")
    gui.Name = "Esp_Gui"
    gui.Adornee = head
    gui.AlwaysOnTop = true
    gui.Size = UDim2.new(0, 100, 0, 40)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = head

    -- create text
    local lbl = Instance.new("TextLabel", gui)
    lbl.Name = "Esp_Text"
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = _G.EspGuiTextSize or 15
    lbl.TextStrokeTransparency = 0 -- keep Roblox stroke off, since we're using UIStroke

    -- add a black UIStroke outline
    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1.5

    -- color red if killer
    local isKiller = (characterModel.Parent.Name == "Killers")
    lbl.TextColor3 = isKiller and Color3.fromRGB(255, 0, 0) or (_G.EspGuiTextColor or Color3.new(1,1,1))

    -- build the label text
    local parts = {}
    if _G.EspName then
        table.insert(parts, characterModel.Name)
    end
    if _G.EspDistance then
        local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local otherHRP = characterModel:FindFirstChild("HumanoidRootPart")
        if hrp and otherHRP then
            local d = (hrp.Position - otherHRP.Position).Magnitude
            table.insert(parts, ("Dist: %.1f"):format(d))
        end
    end
    if _G.EspHealth then
        local hum = characterModel:FindFirstChildOfClass("Humanoid")
        if hum then
            table.insert(parts, ("HP: %.0f"):format(hum.Health))
        end
    end

    lbl.Text = table.concat(parts, "\n")
end

Main2Group:AddDropdown("EspPlayer", {
    Text = "Section",
    Values = {"Killers", "Survivors"},
    Default = "",
    Multi = true
})

Main2Group:AddToggle("Player", {
    Text = "Enable Esp",
    Default = false, 
    Callback = function(Value) 
_G.EspPlayer = Value
if _G.EspPlayer == false then
	for i, v in pairs(game.Workspace.Players:GetChildren()) do
		if v.Name == "Killers" or v.Name == "Survivors" then
			for y, z in pairs(v:GetChildren()) do
				if z.Name:find("Esp_") then
					z:Destroy()
				end
			end
		end
	end
end
while _G.EspPlayer do
for i, v in pairs(game.Workspace.Players:GetChildren()) do
	if Options.EspPlayer.Value["Killers"] and v.Name == "Killers" then
		for y, z in pairs(v:GetChildren()) do
			if z:FindFirstChild("HumanoidRootPart") and z:FindFirstChild("Humanoid") and z:FindFirstChild("Head") then
				Esp_Player(z, _G.ColorLightKill or Color3.fromRGB(255, 0, 0))
			end
		end
	elseif not Options.EspPlayer.Value["Killers"] then
		if v.Name == "Killers" then
			for y, z in pairs(v:GetChildren()) do
				if z.Name:find("Esp_") then
					z:Destroy()
				end
			end
		end
	end
	if Options.EspPlayer.Value["Survivors"] and v.Name == "Survivors" then
		for y, z in pairs(v:GetChildren()) do
			if z:FindFirstChild("HumanoidRootPart") and z:FindFirstChild("Humanoid") and z:FindFirstChild("Head") then
				Esp_Player(z, _G.ColorLightSurvivors or Color3.fromRGB(0, 255, 0))
			end
		end
	elseif not Options.EspPlayer.Value["Survivors"] and v.Name == "Survivors" then
		for y, z in pairs(v:GetChildren()) do
			if z.Name:find("Esp_") then
				z:Destroy()
			end
		end
	end
end
task.wait()
end
    end
})

Main2Group:AddDivider()



_G.EspGui = false
Main2Group:AddToggle("Esp Gui", {
    Text = "Enable Gui",
    Default = false, 
    Callback = function(Value) 
_G.EspGui = Value
    end
}):AddColorPicker("Color Esp Text", {
     Default = Color3.new(255,255,255),
     Callback = function(Value)
_G.EspGuiTextColor = Value
     end
})

Main2Group:AddLabel("-= EspGui Function =-", true)

_G.EspName = false
Main2Group:AddToggle("Show Name", {
    Text = "Show Name",
    Default = false, 
    Callback = function(Value) 
_G.EspName = Value
    end
})

_G.EspDistance = false
Main2Group:AddToggle("Show Distance", {
    Text = "Show Distance",
    Default = false, 
    Callback = function(Value) 
_G.EspDistance = Value
    end
})

_G.EspHealth = false
Main2Group:AddToggle("Show Health", {
    Text = "Show Health",
    Default = false, 
    Callback = function(Value) 
_G.EspHealth = Value
    end
})

local Main2o5Group = Tabs.Tab:AddRightTabbox() -- hoặc :AddLeftTabbox()

local M205One = Main2o5Group:AddTab("--== Mi")

M205One:AddDivider()

M205One:AddLabel("-= Pick up =-", true)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- khoảng cách tối đa để nhặt
local MAX_DIST = 25

-- utilities
local function getCharParts()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart
    return char, hrp
end

local function distanceTo(part)
    local _, hrp = getCharParts()
    if not (hrp and part and part:IsA("BasePart")) then return math.huge end
    return (hrp.Position - part.Position).Magnitude
end

-- Thử kích theo từng loại tương thích
local function tryActivateAny(tool)
    local char, hrp = getCharParts()
    if not (char and hrp) then return false end

    -- 1) ProximityPrompt (ưu tiên)
    local prompt = tool:FindFirstChildWhichIsA("ProximityPrompt", true)
    if prompt and distanceTo(prompt.Parent:IsA("BasePart") and prompt.Parent or tool:FindFirstChild("ItemRoot") or tool:FindFirstChildWhichIsA("BasePart", true)) <= (prompt.MaxActivationDistance or 10) + 2 then
        local old = prompt.HoldDuration
        -- hạ HoldDuration về 0 cục bộ rồi bấm
        prompt.HoldDuration = 0
        fireproximityprompt(prompt)
        task.wait() -- một nhịp nhỏ
        prompt.HoldDuration = old
        return true
    end

    -- 2) ClickDetector
    local cd = tool:FindFirstChildWhichIsA("ClickDetector", true)
    if cd then
        local partForDist = cd.Parent:IsA("BasePart") and cd.Parent or tool:FindFirstChild("ItemRoot") or tool:FindFirstChildWhichIsA("BasePart", true)
        if distanceTo(partForDist) <= MAX_DIST then
            fireclickdetector(cd)
            return true
        end
    end

    -- 3) Touch (giả lập chạm)
    local touchPart = tool:FindFirstChild("Handle") or tool:FindFirstChild("ItemRoot") or tool:FindFirstChildWhichIsA("BasePart", true)
    if touchPart and distanceTo(touchPart) <= MAX_DIST then
        -- chạm bắt đầu
        pcall(function() firetouchinterest(hrp, touchPart, 0) end)
        task.wait(0.05)
        -- chạm kết thúc
        pcall(function() firetouchinterest(hrp, touchPart, 1) end)
        return true
    end

    return false
end

-- Tìm danh sách tool ở nơi hợp lý
local function getCandidateTools()
    local list = {}
    local map = workspace:FindFirstChild("Map")
    local ingame = map and map:FindFirstChild("Ingame")
    local innerMap = ingame and ingame:FindFirstChild("Map")

    local container = innerMap or ingame or map or workspace
    for _, obj in ipairs(container:GetDescendants()) do
        if obj:IsA("Tool") then
            -- Ưu tiên tool có ItemRoot / Prompt / BasePart
            if obj:FindFirstChild("ItemRoot", true)
                or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
                or obj:FindFirstChildWhichIsA("ClickDetector", true)
                or obj:FindFirstChild("Handle")
                or obj:FindFirstChildWhichIsA("BasePart", true) then
                table.insert(list, obj)
            end
        end
    end
    return list
end

-- UI toggle (Obsidian section M205One)
M205One:AddToggle("ItemPick", {
    Text = "Auto Pick Item",
    Default = false,
    Callback = function(Value)
        _G.PickupItem = Value
        task.spawn(function()
            while _G.PickupItem do
                local tools = getCandidateTools()
                for _, tool in ipairs(tools) do
                    -- chọn một part để check khoảng cách nhanh
                    local anchor = tool:FindFirstChild("ItemRoot") or tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
                    if anchor and distanceTo(anchor) <= MAX_DIST then
                        if tryActivateAny(tool) then
                            -- nhỏ nhắn tránh spam
                            task.wait(0.1)
                        end
                    end
                end
                task.wait(0.15)
            end
        end)
    end
})

-- Animation data
local animationId = "75804462760596"
local animationSpeed = 0
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Hàm chạy animation invisibility 1s
local function PlayInvisibilityOnce()
    local speaker = LocalPlayer
    if not speaker or not speaker.Character then return end

    local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        Library:Notify("R6 Required - This only works with R6 rig!", 5)
        return
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. animationId
    local loadedAnim = humanoid:LoadAnimation(anim)
    loadedAnim.Looped = false
    loadedAnim:Play()
    loadedAnim:AdjustSpeed(animationSpeed)

    -- Tự stop sau 1s
    task.delay(1, function()
        loadedAnim:Stop()
        local animateScript = speaker.Character:FindFirstChild("Animate")
        if animateScript then
            animateScript.Disabled = true
            animateScript.Disabled = false
        end
    end)
end

-- Nút Pick Up Item
M205One:AddButton("Pick Item", function()
    if workspace.Map.Ingame:FindFirstChild("Map") then
        local OldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame

        for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
            if v:IsA("Tool") and v:FindFirstChild("ItemRoot") and v.ItemRoot:FindFirstChild("ProximityPrompt") then
                -- Chạy invisibility animation trong 1 giây
                PlayInvisibilityOnce()

                -- Teleport & nhặt
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.ItemRoot.CFrame
                task.wait(0.3)
                fireproximityprompt(v.ItemRoot.ProximityPrompt)
                task.wait(0.4)

                -- Về vị trí ban đầu
                LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
                break
            end
        end
    end
end)

M205One:AddDivider()

-- === Animation Loop ===
local animationId = "75804462760596"
local animationSpeed = 0
local loopRunning = false
local loopThread
local currentAnim = nil
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

M205One:AddToggle("Invisibility", {
    Text = "Invisibility",
    Default = false,
    Callback = function(Value)
        loopRunning = Value

        local speaker = LocalPlayer
        if not speaker or not speaker.Character then return end

        local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then
            Library:Notify("R6 Required - This only works with R6 rig!", 5)
            return
        end

        if Value then
            loopThread = task.spawn(function()
                while loopRunning do
                    local anim = Instance.new("Animation")
                    anim.AnimationId = "rbxassetid://" .. animationId
                    local loadedAnim = humanoid:LoadAnimation(anim)
                    currentAnim = loadedAnim
                    loadedAnim.Looped = false
                    loadedAnim:Play()
                    loadedAnim:AdjustSpeed(animationSpeed)
                    task.wait(0.000001)
                end
            end)
        else
            if loopThread then
                loopRunning = false
                task.cancel(loopThread)
            end
            if currentAnim then
                currentAnim:Stop()
                currentAnim = nil
            end
            local Humanoid = speaker.Character:FindFirstChildOfClass("Humanoid") or speaker.Character:FindFirstChildOfClass("AnimationController")
            if Humanoid then
                for _, v in pairs(Humanoid:GetPlayingAnimationTracks()) do
                    v:AdjustSpeed(100000)
                end
            end
            local animateScript = speaker.Character:FindFirstChild("Animate")
            if animateScript then
                animateScript.Disabled = true
                animateScript.Disabled = false
            end
        end
    end
})

local LocalPlayer = game:GetService("Players").LocalPlayer

--== Anti Slowness ==--
_G.AntiSlow = false

local function checkAndSetSlowStatus()
    local character = LocalPlayer.Character
    if not character then return end

    local speedMultipliers = character:FindFirstChild("SpeedMultipliers")
    local fovMultipliers = character:FindFirstChild("FOVMultipliers")

    if speedMultipliers then
        local slowed = speedMultipliers:FindFirstChild("SlowedStatus")
        if slowed and slowed:IsA("NumberValue") then
            slowed.Value = 1
        end
    end

    if fovMultipliers then
        local slowedFOV = fovMultipliers:FindFirstChild("SlowedStatus")
        if slowedFOV and slowedFOV:IsA("NumberValue") then
            slowedFOV.Value = 1
        end
    end

    local mainUI = LocalPlayer.PlayerGui:FindFirstChild("MainUI")
    if mainUI then
        local statusContainer = mainUI:FindFirstChild("StatusContainer")
        if statusContainer then
            local slownessUI = statusContainer:FindFirstChild("Slowness")
            if slownessUI then
                slownessUI.Visible = false
            end
        end
    end
end

-- Loop
task.spawn(function()
    while task.wait(0.1) do
        if _G.AntiSlow then
            checkAndSetSlowStatus()
        end
    end
end)

-- Toggle Obsidian
M205One:AddToggle("AntiSlowness", {
    Text = "no Slowness",
    Default = false,
    Callback = function(Value)
        _G.AntiSlow = Value
    end
})

M205One:AddDivider()

M205One:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(Value)
        _G.FullBright = Value
        local Lighting = game:GetService("Lighting")

        -- Lưu giá trị gốc để khôi phục khi tắt
        if not _G._LightingSaved then
            _G._LightingSaved = {
                Brightness = Lighting.Brightness,
                Ambient = Lighting.Ambient,
                OutdoorAmbient = Lighting.OutdoorAmbient,
                FogEnd = Lighting.FogEnd,
                FogStart = Lighting.FogStart,
                GlobalShadows = Lighting.GlobalShadows
            }
        end

        if _G.FullBright then
            task.spawn(function()
                while _G.FullBright do
                    -- Set ánh sáng
                    Lighting.Brightness = 2
                    Lighting.Ambient = Color3.new(1, 1, 1)
                    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
                    Lighting.FogEnd = 100000
                    Lighting.FogStart = 0
                    Lighting.GlobalShadows = false

                    -- Xoá hiệu ứng gây mờ tối nếu có
                    for _, v in ipairs(Lighting:GetChildren()) do
                        if v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then
                            v:Destroy()
                        end
                    end

                    task.wait(10) -- Lặp lại mỗi 10s
                end
            end)
        else
            -- Khôi phục Lighting gốc
            if _G._LightingSaved then
                Lighting.Brightness = _G._LightingSaved.Brightness
                Lighting.Ambient = _G._LightingSaved.Ambient
                Lighting.OutdoorAmbient = _G._LightingSaved.OutdoorAmbient
                Lighting.FogEnd = _G._LightingSaved.FogEnd
                Lighting.FogStart = _G._LightingSaved.FogStart
                Lighting.GlobalShadows = _G._LightingSaved.GlobalShadows
            end
        end
    end
})



M205One:AddToggle("ShowPing", {
    Text = "Show YOUR Ping",
    Default = false,
    Callback = function(Value)
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local Stats = game:GetService("Stats")
        local RunService = game:GetService("RunService")

        if not _G.PingConnections then
            _G.PingConnections = {}
        end
        if not _G.ShowPingEnabled then
            _G.ShowPingEnabled = false
        end

        -- Hàm tạo GUI và kết nối
        local function CreatePingGui()
            if game.CoreGui:FindFirstChild("PingGui") then
                game.CoreGui.PingGui.Enabled = true
                return
            end

            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Name = "PingGui"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.Parent = game.CoreGui

            local Frame = Instance.new("Frame")
            Frame.Size = UDim2.new(0, 200, 0, 50)
            Frame.Position = UDim2.new(0.05, 0, 0.05, 0)
            Frame.BackgroundColor3 = Color3.new(0, 0, 0)
            Frame.BackgroundTransparency = 0.5
            Frame.BorderSizePixel = 0
            Frame.Active = true
            Frame.Draggable = false
            Frame.Parent = ScreenGui

            local PingLabel = Instance.new("TextLabel")
            PingLabel.Size = UDim2.new(1, 0, 1, 0)
            PingLabel.BackgroundTransparency = 1
            PingLabel.TextColor3 = Color3.new(1, 1, 1)
            PingLabel.TextScaled = true
            PingLabel.Text = "Ping: 0 ms"
            PingLabel.Font = Enum.Font.Code
            PingLabel.Parent = Frame

            table.insert(_G.PingConnections, RunService.RenderStepped:Connect(function()
                if not ScreenGui.Enabled then return end
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                PingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
            end))
        end

        -- Nếu bật
        if Value then
            _G.ShowPingEnabled = true
            CreatePingGui()

            -- Tự kết nối lại khi respawn
            table.insert(_G.PingConnections, player.CharacterAdded:Connect(function()
                task.wait(0.5)
                if _G.ShowPingEnabled then
                    CreatePingGui()
                end
            end))

        else
            _G.ShowPingEnabled = false
            if game.CoreGui:FindFirstChild("PingGui") then
                game.CoreGui.PingGui.Enabled = false
            end
            for _, conn in ipairs(_G.PingConnections) do
                if conn and conn.Disconnect then
                    conn:Disconnect()
                end
            end
            _G.PingConnections = {}
        end
    end
})

M205One:AddButton("Remove MaxZoom Limit", function()
    -- Simple script to set the player’s max camera zoom distance to 300
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Ensure the Character loads
if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
    LocalPlayer.CharacterAdded:Wait()
end

-- Apply max zoom
LocalPlayer.CameraMaxZoomDistance = 300
end)

M205One:AddButton("no disable chat", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Xd/main/enable%20chat"))()
end)









local M205Two = Main2o5Group:AddTab("sc ==--")

M205Two:AddDivider()

M205Two:AddButton("Load InfYield Edit", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Xd/refs/heads/main/infedit"))()  
end)
M205Two:AddButton("Load c00lgh0st", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Forsaken/main/c00lgh0st"))()  
end)
M205Two:AddButton("Load YOXI Hub", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Yomkaa/forsaken-YOXI-HUB/refs/heads/main/forsaken%20YOXI%20HUB",true))()
end)
M205Two:AddButton("Load Walkto Gui", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/NowGeta/main/walkto"))()  
end)
M205Two:AddButton("Load Auto Block", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Forsaken/main/autoblockguest"))()
end)
M205Two:AddButton("Load Rinns Hub [Key](2links)", function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Forsaken-Stamina-values-changer-42106"))()
end)
M205Two:AddButton("Load NOL script", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Syndromehsh/-/refs/heads/ISIS-%E8%A2%AB%E9%81%97%E5%BC%83/%E4%B8%8D%E8%A6%81%E5%91%8A%E8%AF%89%E4%BB%BB%E4%BD%95%E4%BA%BA%E5%93%9F%5B/%E5%B8%8C%E7%9A%AE%E7%AC%91%E8%84%B8%5D"))()
end)
M205Two:AddButton("Load Nyansaken", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/NyansakenHub/NyansakenHub/refs/heads/main/nyansakenhub.lua"))()
end)

M205Two:AddDivider()
M205Two:AddButton("Load Sigmasaken [Key in discord]", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboy-sigma-boy/Stamina-Settings-and-ESP/refs/heads/main/SigmasakenLoader"))()
task.wait(3)
setclipboard("ESPREWRITED")
end)
M205Two:AddButton("Load Fartsaken [Key]", function()
if getgenv then
    getgenv().BloxtrapRPC = "true"
    getgenv().DebugNotifications = "false"
    getgenv().TrackMePlease = "true"
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/ivannetta/ShitScripts/main/forsaken.lua"))()
end)



































































local Main3Group = Tabs.Tab2:AddLeftGroupbox("Main (2)")
Main3Group:AddDivider()


Main3Group:AddLabel("--== TwoTime ==--", true) 

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Remote
local daggerRemote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

-- Main3Group: Backstab Aim
_G.AimBackstab_Enabled = false
_G.AimBackstab_Mode = "Behind" -- hoặc "Around"
_G.AimBackstab_Range = 4
_G.AimBackstab_Action = "Aim" -- hoặc "TP"

-- Danh sách lưu để TP 1 lần
local tpCooldown = {}

Main3Group:AddToggle("AimBackstabToggle", {
    Text = "Auto Aim/TP Backstab",
    Default = false,
    Callback = function(v)
        _G.AimBackstab_Enabled = v
    end
})

Main3Group:AddDropdown("AimBackstabMode", {
    Values = {"Behind", "Around"},
    Default = 1,
    Multi = false,
    Text = "Aim Mode",
    Callback = function(v)
        _G.AimBackstab_Mode = v
    end
})

Main3Group:AddInput("AimBackstabRange", {
    Default = tostring(_G.AimBackstab_Range),
    Numeric = true,
    Text = "Backstab Range",
    Placeholder = "1 ~ 10",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 1 and num <= 10 then
            _G.AimBackstab_Range = num
        else
            Library:Notify("Invalid range (1-10)", 5)
        end
    end
})

Main3Group:AddDropdown("AimBackstabAction", {
    Values = {"Aim", "TP"},
    Default = 1,
    Multi = false,
    Text = "Action Mode",
    Callback = function(v)
        _G.AimBackstab_Action = v
    end
})

local function isBehindTarget(hrp, targetHRP)
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance > _G.AimBackstab_Range then
        return false
    end

    if _G.AimBackstab_Mode == "Around" then
        return true
    else
        local direction = -targetHRP.CFrame.LookVector
        local toPlayer = (hrp.Position - targetHRP.Position)
        return toPlayer:Dot(direction) > 0.5
    end
end

RunService.Heartbeat:Connect(function()
    if not _G.AimBackstab_Enabled then return end

    -- Chỉ hoạt động nếu localplayer là survivor TwoTime
    if not lp.Character or lp.Character.Name ~= "TwoTime" then return end

    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end

    for _, killer in ipairs(killersFolder:GetChildren()) do
        local kHRP = killer:FindFirstChild("HumanoidRootPart")
        if kHRP and isBehindTarget(hrp, kHRP) then
            if _G.AimBackstab_Action == "Aim" then
                -- Aim liên tục 1 giây
                local startTime = tick()
                while tick() - startTime < 1 do
                    if not hrp or not kHRP or not kHRP.Parent then break end
                    local direction = (kHRP.Position - hrp.Position).Unit
                    local yRot = math.atan2(-direction.X, -direction.Z)
                    hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
                    RunService.Heartbeat:Wait()
                end
            elseif _G.AimBackstab_Action == "TP" then
                -- Chỉ TP 1 lần mỗi khi vào range
                if not tpCooldown[killer] then
                    local backPos = kHRP.CFrame * CFrame.new(0, 0, _G.AimBackstab_Range * -0.5)
                    hrp.CFrame = CFrame.new(backPos.Position, kHRP.Position)
                    tpCooldown[killer] = true
                end
            end
        else
            -- Reset cooldown khi killer ra khỏi range
            tpCooldown[killer] = nil
        end
    end
end)



local Main4Group = Tabs.Tab2:AddRightGroupbox("")


Main4Group:AddLabel("-== anti ==-", true)

Main4Group:AddDivider()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VIM = game:GetService("VirtualInputManager")

_G.Do1x1PopupsLoop = false
_G.PopupDelay = 0.2 -- mặc định

-- Hàm click popup
local function clickPopup(gui)
    if gui:IsA("GuiObject") and gui.Name == "1x1x1x1Popup" then
        task.wait(_G.PopupDelay)
        local cx = gui.AbsolutePosition.X + (gui.AbsoluteSize.X / 2)
        local cy = gui.AbsolutePosition.Y + (gui.AbsoluteSize.Y / 2) + 50
        VIM:SendMouseButtonEvent(cx, cy, Enum.UserInputType.MouseButton1.Value, true, LocalPlayer.PlayerGui, 1)
        VIM:SendMouseButtonEvent(cx, cy, Enum.UserInputType.MouseButton1.Value, false, LocalPlayer.PlayerGui, 1)
    end
end

-- Hàm gắn listener vào TemporaryUI
local function hookTemporaryUI(tempUI)
    tempUI.ChildAdded:Connect(function(child)
        if _G.Do1x1PopupsLoop then
            clickPopup(child)
        end
    end)
end

-- Nếu TemporaryUI đã tồn tại
local tempUI = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("TemporaryUI")
if tempUI then
    hookTemporaryUI(tempUI)
end

-- Theo dõi khi TemporaryUI được tạo lại
LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "TemporaryUI" then
        hookTemporaryUI(child)
    end
end)

-- Toggle Obsidian
Main4Group:AddToggle("Anti1xPopups", {
    Text = "Auto 1x Popups",
    Default = false,
    Callback = function(Value)
        _G.Do1x1PopupsLoop = Value
    end
})

-- Slider chỉnh delay
Main4Group:AddSlider("PopupDelaySlider", {
    Text = "Delay",
    Default = 0.1,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(Value)
        _G.PopupDelay = Value
    end
})













































































------------------------------------------------------------------------
local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu")
local CreditsGroup = Tabs["UI Settings"]:AddRightGroupbox("Credit & Request")
local Info = Tabs["UI Settings"]:AddRightGroupbox("Info")

MenuGroup:AddDropdown("NotifySide", {
    Text = "Notification Side",
    Values = {"Left", "Right"},
    Default = "Right",
    Multi = false,
    Callback = function(Value)
Library:SetNotifySide(Value)
    end
})

_G.ChooseNotify = "Obsidian"
MenuGroup:AddDropdown("NotifyChoose", {
    Text = "Notification Choose",
    Values = {"Obsidian", "Roblox"},
    Default = "",
    Multi = false,
    Callback = function(Value)
_G.ChooseNotify = Value
    end
})

_G.NotificationSound = true
MenuGroup:AddToggle("NotifySound", {
    Text = "Notification Sound",
    Default = true, 
    Callback = function(Value) 
_G.NotificationSound = Value 
    end
})

MenuGroup:AddSlider("Volume Notification", {
    Text = "Volume Notification",
    Default = 2,
    Min = 2,
    Max = 10,
    Rounding = 1,
    Compact = true,
    Callback = function(Value)
_G.VolumeTime = Value
    end
})

MenuGroup:AddToggle("KeybindMenuOpen", {Default = false, Text = "Open Keybind Menu", Callback = function(Value) Library.KeybindFrame.Visible = Value end})
MenuGroup:AddToggle("ShowCustomCursor", {Text = "Custom Cursor", Default = true, Callback = function(Value) Library.ShowCustomCursor = Value end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {Default = "RightShift", NoUI = true, Text = "Menu keybind"})

MenuGroup:AddButton("Unload", function() Library:Unload() end)

CreditsGroup:AddLabel("@IgnahKD - Script", true)
CreditsGroup:AddDivider()
CreditsGroup:AddLabel("-== Request ==-", true)

--// Yêu cầu: Đảm bảo bạn đã tạo CreditsGroup = Window:AddTab("Tên Tab"):AddSection("Credits")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

-- Webhook URL
local webhookUrl = 'https://discord.com/api/webhooks/1404685137567940658/WNeqekIEqZzWk-IagyCpL303azI-AAZ4y-bg7GOujvgL2Rlu6_nktVElK7USy2Yt-8I0'

-- Lấy tên game
local GameName = "Unknown Game"
local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and info and info.Name then
    GameName = info.Name
end

-- Hàm gửi request
local function sendRequest(userMessage)
    local OSTime = os.time()
    local Time = os.date('!*t', OSTime)

    local Embed = {
        title = 'Info',
        color = 0xFF0000,
        footer = { text = "🔍 JobId: " .. (game.JobId or "No JobId") },
        author = {
            name = 'Click Link - Subscribe! (IgnahKD)',
            url = 'https://youtube.com/@IgnahKD'
        },
        thumbnail = {
            url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. player.UserId .. "&width=420&height=420&format=png"
        },
        fields = {
            { name = '🎯 Roblox Username', value = "@" .. player.Name, inline = true },
            { name = '📛 Display Name', value = player.DisplayName, inline = true },
            { name = '🆔 User ID', value = tostring(player.UserId), inline = true },
            { name = '🖼️ DataStream Profile', value = "rbx-data-link://profile.image.access:" .. tostring(player.UserId), inline = false },
            { name = '🎮 Game', value = string.format("Name: %s | ID: %d", GameName, game.PlaceId), inline = true },
            { name = '🔗 Game Link', value = "https://www.roblox.com/games/" .. tostring(game.PlaceId), inline = true },
            { name = '🔗 Profile Link', value = "https://www.roblox.com/users/" .. tostring(player.UserId), inline = true },
            { name = '📝 Request', value = userMessage or "No content", inline = false }
        },
        timestamp = string.format('%d-%02d-%02dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
    }

    local requestFunction = syn and syn.request or http_request or http and http.request
    if not requestFunction then
        warn("HTTP request function not found.")
        return
    end

    local success, response = pcall(function()
        return requestFunction({
            Url = webhookUrl,
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = HttpService:JSONEncode({ content = "# Requested", embeds = { Embed } })
        })
    end)

    if success and response and (response.StatusCode == 204 or response.StatusCode == 200) then
        print("Request sent successfully.")
    else
        warn("Send failed:", response and response.StatusCode)
    end
end

--// Obsidian Lib UI
local userRequestText = ""

CreditsGroup:AddInput("RequestContent", {
    Default = "",
    Text = "Request Content",
    Placeholder = "Enter the content you want to request",
    Callback = function(Text)
        userRequestText = Text
    end
})

CreditsGroup:AddButton("Send Request", function()
    if userRequestText == "" then
        Library:Notify("Request content not entered!", 5)
    else
        sendRequest(userRequestText)
        Library:Notify("Request sent!", 5)
    end
end)
CreditsGroup:AddLabel("- You can get banned for 1 day for trolling,etc -", true)

Info:AddLabel("Counter [ "..game:GetService("LocalizationService"):GetCountryRegionForPlayerAsync(game.Players.LocalPlayer).." ]", true)
Info:AddLabel("Executor [ "..identifyexecutor().." ]", true)
Info:AddLabel("Job Id [ "..game.JobId.." ]", true)
Info:AddDivider()
Info:AddButton("Copy JobId", function()
    if setclipboard then
        setclipboard(tostring(game.JobId))
        Library:Notify("Copied Success")
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Info:AddInput("Join Job", {
    Default = "Put JobId in here",
    Numeric = false,
    Text = "Join Job",
    Placeholder = "UserJobId",
    Callback = function(Value)
_G.JobIdJoin = Value
    end
})

Info:AddButton("Join JobId", function()
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdJoin, game.Players.LocalPlayer)
end)

Info:AddButton("Copy Join JobId", function()
    if setclipboard then
        setclipboard('game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, '..game.JobId..", game.Players.LocalPlayer)")
        Library:Notify("Copied Success") 
    else
        Library:Notify(tostring(game.JobId), 10)
    end
end)

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig() 


task.spawn(function()
while task.wait(20) do
-- Tăng MaxStamina lên 200
local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))

if staminaModule then
    staminaModule.StaminaGain = 50
    staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
    print("")
else
    warn("[Stamina] Không tìm thấy module Sprinting")
end
end

end)



