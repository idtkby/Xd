-- Kiểm tra ID game
if game.PlaceId ~= 18687417158 then
    return warn("Script only works in the specified game (ID: 18687417158){[NOLI🎭] Fosaken}")
end

-- Thông báo khi đúng ID game
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✓ Game Check Passed",
    Text = "Script is now executing...",
    Duration = 5
})

--[[ Lưu lại hàm gốc
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
--]]
task.wait(1) -- Đợi 1s trước khi thực thi 








task.spawn(function()
    -- Lấy module Sprinting
    local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems")
        :WaitForChild("Character")
        :WaitForChild("Game")
        :WaitForChild("Sprinting"))

    if staminaModule then
        -- Hook metatable để chặn thay đổi property quan trọng
        local mt = getrawmetatable(staminaModule)
        setreadonly(mt, false)

        local oldIndex = mt.__newindex
        mt.__newindex = function(t, k, v)
            if k == "MaxStamina" or k == "StaminaLoss" or k == "StaminaGain" or k == "SprintSpeed" then
                warn("[BlockFunction] Prevented setting " .. tostring(k) .. ":", v)
                return
            end
            return oldIndex(t, k, v)
        end

        setreadonly(mt, true)

        -- Hook __staminaChangedEvent:Fire để chặn call từ script khác
        if staminaModule.__staminaChangedEvent then
            staminaModule.__staminaChangedEvent.Fire = function()
                warn("[BlockFunction] Prevented external Fire on __staminaChangedEvent")
            end
        end

        print("[Forsaken] Stamina protections active ✅")
    else
        warn("[BlockInfStamina] staminaModule not found ❌")
    end
end)

task.wait(1)

task.spawn(function()
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
    Title = "        [🔪Slasher] Forsaken",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "Script by IganhK [Beta Version]",
	   Icon = 87797185808589, -- ID logo

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

--== Tabs
local Main1Group = Tabs.Tab:AddLeftGroupbox("-=< Main >=-")
local Main1o5Group = Tabs.Tab:AddLeftTabbox() -- hoặc :AddLeftTabbox()

local Main2Group = Tabs.Tab:AddRightGroupbox("-=< Visual >=-")
local Main2o5Group = Tabs.Tab:AddRightTabbox() -- hoặc :AddLeftTabbox()

local Main3Group = Tabs.Tab2:AddLeftGroupbox("-=< Main 02 >=-")
local Main3o5Group = Tabs.Tab2:AddLeftTabbox()

local Main4Group = Tabs.Tab2:AddRightGroupbox("-=< Anti >=-")


























--[[
		[MessageOutput] [Anim] rbxassetid://122604262087779
		[MessageOutput] [Anim] rbxassetid://82691533602949
		[MessageOutput] [Anim] rbxassetid://130355934640695
		]]

-- config mặc định
_G.AutoGeneralMin = 1.8
_G.AutoGeneralMax = 1.8
_G.AutoGeneral = false
local sendCount = 0

-- danh sách anim ID cho phép
local allowedAnims = {
    ["rbxassetid://130355934640695"] = true,
    ["rbxassetid://82691533602949"] = true,
    ["rbxassetid://122604262087779"] = true
}

-- input MinTime
Main1Group:AddInput("GeneralMin", {
    Default = tostring(_G.AutoGeneralMin),
    Numeric = true,
    Text = "Min Delay (s)",
    Placeholder = ">= 1",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 1 then
            _G.AutoGeneralMin = num
        else
            Library:Notify("Min >= 1", 3)
        end
    end
})

-- input MaxTime
Main1Group:AddInput("GeneralMax", {
    Default = tostring(_G.AutoGeneralMax),
    Numeric = true,
    Text = "Max Delay (s)",
    Placeholder = ">= Min",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= _G.AutoGeneralMin then
            _G.AutoGeneralMax = num
        else
            Library:Notify("Max >= Min", 3)
        end
    end
})

-- hàm check anim
local function isPlayingAllowedAnim()
    local char = game.Players.LocalPlayer.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return false end

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        if track.Animation and allowedAnims[track.Animation.AnimationId] then
            return true
        end
    end
    return false
end

-- toggle chính
Main1Group:AddToggle("AutoGeneral", {
    Text = "Auto General",
    Default = false,
    Callback = function(Value)
        _G.AutoGeneral = Value
        task.spawn(function()
            while _G.AutoGeneral do
                if isPlayingAllowedAnim() then
                    -- random float giữa Min và Max
                    local delay = _G.AutoGeneralMin + math.random() * (_G.AutoGeneralMax - _G.AutoGeneralMin)

                    -- chờ trước, nhưng vẫn kiểm tra anim trong lúc chờ
                    local start = tick()
                    while tick() - start < delay and _G.AutoGeneral do
                        if not isPlayingAllowedAnim() then
                            break -- anim dừng -> bỏ vòng này
                        end
                        task.wait(0.1)
                    end

                    -- nếu anim vẫn còn sau delay thì gửi
                    if isPlayingAllowedAnim() then
                        if workspace:FindFirstChild("Map")
                        and workspace.Map:FindFirstChild("Ingame")
                        and workspace.Map.Ingame:FindFirstChild("Map") then
                            for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
                                if v.Name == "Generator"
                                and v:FindFirstChild("Remotes")
                                and v.Remotes:FindFirstChild("RE") then
                                    v.Remotes.RE:FireServer()
                                end
                            end
                            sendCount += 1
                            Library:Notify(("#%d | Delay: %.2fs"):format(sendCount, delay), 2)
                        end
                    end
                else
                    task.wait(0.2) -- idle check lại nhanh
                end
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

Main1Group:AddToggle("InfStamina2", {
    Text = "Turn off staminaloss",
    Default = false, 
    Callback = function(Value) 
        _G.InfStamina = Value
        local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))

        if Value then
            -- Bật: loop giữ staminaLoss = 0
            task.spawn(function()
                while _G.InfStamina do
                    if staminaModule then
                        staminaModule.StaminaLoss = 0
                        staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
                    end
                    task.wait()
                end
            end)
        else
            -- Tắt: trả lại mặc định 8
            if staminaModule then
                staminaModule.StaminaLoss = 8
                staminaModule.__staminaChangedEvent:Fire(staminaModule.Stamina)
            end
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
            title.Text = "RestOre St4min4"
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
            
            sprinting.Stamina = 696969
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


Main1Group:AddLabel("--== Surviv: [ Shedletsky ] [ Updating ] ==--", true) 
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


Main1Group:AddLabel("--== Surviv: [ Chance ] ==--", true)


		Main1Group:AddButton("Load", function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi399/Chance-aimbot/refs/heads/main/Chance%20aimbot%20v2"))()
			end)
				
-- Divider + Label
Main1Group:AddDivider()
Main1Group:AddLabel("--== Surviv: [ Guest 1337 ] ==--", true)

--// Auto Block + Punch cho Guest1337 Survivor (Obsidian Lib)
task.spawn(function()

Main1Group:AddButton("Load Auto Block", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi399/Auto-block-script/refs/heads/main/FINAL%20AUTO%20BLOCK"))()
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

_G.AutoPunchAimbot_Enabled = false
local activeAimConn = nil

local punchAnimIDs = {
    ["87259391926321"] = true, ["140703210927645"] = true,
    ["136007065400978"] = true, ["129843313690921"] = true,
    ["86709774283672"] = true, ["108807732150251"] = true,
    ["138040001965654"] = true, ["86096387000557"] = true
}

local function stopAim()
    if activeAimConn then
        activeAimConn:Disconnect()
        activeAimConn = nil
    end
end

local function startAimAtTarget(targetRoot, myRoot)
    stopAim()
    local startTime = tick()

    activeAimConn = RunService.Heartbeat:Connect(function()
        if not _G.AutoPunchAimbot_Enabled then return stopAim() end
        if not targetRoot or not targetRoot.Parent or not myRoot or not myRoot.Parent then return stopAim() end
        if tick() - startTime > 0.85 then return stopAim() end

        local lookPos = Vector3.new(targetRoot.Position.X, myRoot.Position.Y, targetRoot.Position.Z)
        myRoot.CFrame = CFrame.new(myRoot.Position, lookPos)
    end)
end

local function handleLocalTrack(track)
    if not _G.AutoPunchAimbot_Enabled then return end
    if not track then return end

    local anim = track.Animation
    if not anim then return end

    local id = anim.AnimationId and anim.AnimationId:match("%d+")
    if not id or not punchAnimIDs[id] then return end

    local myChar = lp.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end

    local nearest, dist = nil, math.huge

    for _, killer in ipairs(killersFolder:GetChildren()) do
        local isPlayer = Players:GetPlayerFromCharacter(killer) ~= nil
        if not isPlayer and killer.Name:lower():find("noli") then continue end

        local root = killer:FindFirstChild("HumanoidRootPart")
        local h = killer:FindFirstChildOfClass("Humanoid")
        if root and h and h.Health > 0 then
            local d = (root.Position - myRoot.Position).Magnitude
            if d < dist then dist = d; nearest = root end
        end
    end

    if nearest then
        startAimAtTarget(nearest, myRoot)
    end
end

local function setupHumanoid(humanoid)
    humanoid.AnimationPlayed:Connect(handleLocalTrack)
end

local function onCharacter(char)
    stopAim()
    local humanoid = char:WaitForChild("Humanoid")
    setupHumanoid(humanoid)
end

if lp.Character then
    onCharacter(lp.Character)
end

lp.CharacterAdded:Connect(onCharacter)

Main1Group:AddToggle("AutoPunchAimbotToggle", {
    Text = "Punch Aimbot",
    Default = false,
    Callback = function(v)
        _G.AutoPunchAimbot_Enabled = v
        Library:Notify(v and "Punch Aimbot: ON" or "Punch Aimbot: OFF", 5)
    end
})

----------------------
-- Walkspeed Override
----------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local NetworkEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

local walkspeedOverrideEnabled = false

Main1Group:AddToggle("WalkspeedOverrideToggle", {
    Text = "Walkspeed Override Block [Alpha]",
    Default = false,
    Callback = function(Value)
        walkspeedOverrideEnabled = Value
    end
})

local walkspeedAnimIds = {
    ["106776364623742"] = true,
    ["98456918873918"] = true,
    ["97167027849946"] = true
}

local function remoteBlock()
    pcall(function()
        NetworkEvent:FireServer("UseActorAbility", { buffer.fromstring("\"Block\"") })
    end)
end

local function isFacingTarget(killerRoot, myRoot)
    local toPlayer = (myRoot.Position - killerRoot.Position).Unit
    local lookDir = killerRoot.CFrame.LookVector
    return toPlayer:Dot(Vector3.new(lookDir.X, 0, lookDir.Z)) > 0.7
end

local function isApproaching(killerRoot, myRoot)
    local vel = killerRoot.AssemblyLinearVelocity
    if vel.Magnitude < 1 then return false end
    local toPlayer = myRoot.Position - killerRoot.Position
    return toPlayer.Unit:Dot(Vector3.new(vel.X, 0, vel.Z).Unit) > 0.6
end

RunService.Heartbeat:Connect(function()
    if not walkspeedOverrideEnabled then return end
    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end

    for _, killer in ipairs(killersFolder:GetChildren()) do
        local root = killer:FindFirstChild("HumanoidRootPart")
        local humanoid = killer:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0 then
            local dist = (root.Position - myRoot.Position).Magnitude
            if dist <= 100 then
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                    local anim = track.Animation
                    local id = anim and anim.AnimationId:match("%d+")

                    if id and walkspeedAnimIds[id] and isApproaching(root, myRoot) and isFacingTarget(root, myRoot) then
                        remoteBlock()
                    end
                end
            end
        end
    end
end)

end)


     
  
--// Range Visual (Killer Detection Circle)
local RunService = game:GetService("RunService")
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

local detectionCircles = {} -- [killer] = {outer = circle1, inner = circle2}
local killerCirclesVisible = false
local detectionRange = tonumber(_G.AutoBlockPunch_Range) or 18

-- Add circle
local function addKillerCircle(killer)
    if not killer:FindFirstChild("HumanoidRootPart") then return end
    if detectionCircles[killer] then return end

    local outer = Instance.new("CylinderHandleAdornment")
    outer.Name = "KillerRangeOuter"
    outer.Adornee = killer.HumanoidRootPart
    outer.AlwaysOnTop = true
    outer.ZIndex = 0
    outer.Transparency = 0.8
    outer.Color3 = Options.RangeCircleColorOuter.Value or Color3.fromRGB(0,255,0)
    outer.CFrame = CFrame.Angles(math.rad(90), 0, 0)
    outer.Height = 0.1
    outer.Radius = detectionRange
    outer.Parent = killer.HumanoidRootPart

    local inner = Instance.new("CylinderHandleAdornment")
    inner.Name = "KillerRangeInner"
    inner.Adornee = killer.HumanoidRootPart
    inner.AlwaysOnTop = true
    inner.ZIndex = 0
    inner.Transparency = 0.7
    inner.Color3 = Options.RangeCircleColorInner.Value or Color3.fromRGB(255,0,0)
    inner.CFrame = CFrame.new(0, -0.05, 0) * CFrame.Angles(math.rad(90), 0, 0)
    inner.Height = 0.1
    inner.Radius = detectionRange / 1.265
    inner.Parent = killer.HumanoidRootPart

    detectionCircles[killer] = {outer = outer, inner = inner}
end

-- Remove circle
local function removeKillerCircle(killer)
    if detectionCircles[killer] then
        if detectionCircles[killer].outer then detectionCircles[killer].outer:Destroy() end
        if detectionCircles[killer].inner then detectionCircles[killer].inner:Destroy() end
        detectionCircles[killer] = nil
    end
end

-- Refresh
local function refreshKillerCircles()
    for _, killer in ipairs(KillersFolder:GetChildren()) do
        if killerCirclesVisible then
            addKillerCircle(killer)
        else
            removeKillerCircle(killer)
        end
    end
end

-- Update radius + color
RunService.RenderStepped:Connect(function()
    if not killerCirclesVisible then return end
    detectionRange = tonumber(_G.AutoBlockPunch_Range) or detectionRange
    for killer, circles in pairs(detectionCircles) do
        if circles.outer and circles.outer.Parent then
            circles.outer.Radius = detectionRange
            circles.outer.Color3 = Options.RangeCircleColorOuter.Value or Color3.fromRGB(0,255,0)
        end
        if circles.inner and circles.inner.Parent then
            circles.inner.Radius = detectionRange / 1.265
            circles.inner.Color3 = Options.RangeCircleColorInner.Value or Color3.fromRGB(255,0,0)
        end
    end
end)

-- Hook KillersFolder changes
KillersFolder.ChildAdded:Connect(function(killer)
    if killerCirclesVisible then
        task.spawn(function()
            local hrp = killer:WaitForChild("HumanoidRootPart", 5)
            if hrp then addKillerCircle(killer) end
        end)
    end
end)

KillersFolder.ChildRemoved:Connect(function(killer)
    removeKillerCircle(killer)
end)

-- GUI
Main1Group:AddToggle("ShowRange", {
    Text = "Show Range",
    Default = false,
    Callback = function(state)
        killerCirclesVisible = state
        refreshKillerCircles()
    end
})
:AddColorPicker("RangeCircleColorOuter", {
    Default = Color3.fromRGB(0,255,0),
    Transparency = 0,
    Callback = function(color)
        for _, circles in pairs(detectionCircles) do
            if circles.outer and circles.outer.Parent then
                circles.outer.Color3 = color
            end
        end
    end
})
:AddColorPicker("RangeCircleColorInner", {
    Default = Color3.fromRGB(255,0,0),
    Transparency = 0,
    Callback = function(color)
        for _, circles in pairs(detectionCircles) do
            if circles.inner and circles.inner.Parent then
                circles.inner.Color3 = color
            end
        end
    end
})

Main1Group:AddInput("AutoBlockPunchRange", {
    Default = tostring(detectionRange),
    Numeric = true,
    Text = "show Range",
    Placeholder = "5 ~ 50",
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 5 and num <= 50 then
            _G.AutoBlockPunch_Range = num
            detectionRange = num
        else
            Library:Notify("Invalid range (5-50)", 5)
        end
    end
})


Main1Group:AddDivider()


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


-- Charge Ignore Objectables





-- Main1o5Group
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
    Text = "Survivor Speed (26 - 100)",
    Placeholder = "Enter",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 26 and num <= 100 and num ~= 35 and num ~= 45 then
            _G.SurvivorSpeed = num
        else
            Library:Notify("Die, Rise, Cry", 5)
        end
    end
})

-- Input Killer Speed
M105One:AddInput("KillerSpeed", {
    Default = "",
    Numeric = true,
    Finished = true,
    Text = "Killer Speed (27.5 - 100)",
    Placeholder = "Enter",
    Callback = function(Value)
        local num = tonumber(Value)
        if num and num >= 27.5 and num <= 100 and num ~= 35 and num ~= 45 then
            _G.KillerSpeed = num
        else
            Library:Notify("Die, Rise, Cry", 5)
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

M105One:AddLabel("40< Safe [90% if not reported]")





















































































-- Main2Group
Main2Group:AddToggle("General", {
    Text = "Esp General",
    Default = false, 
    Callback = function(Value)
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        if _G.EspGui == nil then _G.EspGui = true end
        if _G.EspName == nil then _G.EspName = true end
        if _G.EspDistance == nil then _G.EspDistance = true end

        _G.EspGeneral = Value

        local function getMap()
            local m = workspace:FindFirstChild("Map")
            local ingame = m and m:FindFirstChild("Ingame")
            local mapModel = ingame and ingame:FindFirstChild("Map")
            return mapModel
        end

        local function getAdorneePart(model)
            if not model then return nil end
            if model.PrimaryPart then return model.PrimaryPart end
            local p = model:FindFirstChild("HumanoidRootPart")
                or model:FindFirstChildWhichIsA("BasePart")
            return p
        end

        local function ensureGui(gen)
            if not _G.EspGui then
                if gen:FindFirstChild("Esp_Gui") then gen.Esp_Gui:Destroy() end
                return
            end
            if gen:FindFirstChild("Esp_Gui") then return end
            local part = getAdorneePart(gen)
            if not part then return end

            local gui = Instance.new("BillboardGui")
            gui.Name = "Esp_Gui"
            gui.Adornee = part
            gui.Size = UDim2.new(0, 120, 0, 48)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.AlwaysOnTop = true
            gui.Parent = gen

            local lbl = Instance.new("TextLabel")
            lbl.Name = "TextLabel"
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.fromScale(1,1)
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 15
            lbl.TextColor3 = Color3.fromRGB(255,255,255)
            lbl.TextStrokeTransparency = 0
            lbl.Text = ""
            lbl.Parent = gui

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0,0,0)
            stroke.Thickness = 1.5
            stroke.Parent = lbl
        end

        local function clearAll()
            local mapModel = getMap()
            if not mapModel then return end
            for _, gen in ipairs(mapModel:GetChildren()) do
                if gen.Name == "Generator" then
                    if gen:FindFirstChild("Esp_Gui") then gen.Esp_Gui:Destroy() end
                end
            end
        end

        if not Value then
            clearAll()
            return
        end

        while _G.EspGeneral do
            local mapModel = getMap()
            if mapModel and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local lpHRP = LocalPlayer.Character.HumanoidRootPart
                for _, gen in ipairs(mapModel:GetChildren()) do
                    if gen.Name == "Generator" and gen:FindFirstChild("Progress") then
                        ensureGui(gen)

                        -- update text + dist
                        local gui = gen:FindFirstChild("Esp_Gui")
                        if gui and gui:FindFirstChild("TextLabel") then
                            local part = getAdorneePart(gen)
                            if part then
                                if gen.Progress.Value == 100 then
                                    -- Nếu đủ 100% -> xoá luôn ESP
                                    gui:Destroy()
                                else
                                    local dist = (lpHRP.Position - part.Position).Magnitude
                                    local nameLine = _G.EspName and ("General ("..gen.Progress.Value.."%)") or ""
                                    local distLine = _G.EspDistance and ("\nDistance [ "..string.format("%.1f", dist).." ]") or ""
                                    gui.TextLabel.Text = nameLine .. distLine
                                    gui.TextLabel.TextSize = _G.EspGuiTextSize or 15
                                    gui.TextLabel.TextColor3 = Color3.fromRGB(255,255,255)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end

        clearAll()
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Hàm tạo ESP cho 1 model
local function CreateItemESP(obj, color, labelText)
	if obj:FindFirstChild("ItemESP_Gui") or obj:FindFirstChild("ItemESP_Outline") then return end

	local head
	if obj:IsA("Model") then
		head = obj:FindFirstChildWhichIsA("BasePart")
	else
		head = obj -- chính nó là Part
	end
	if not head then return end

	-- Billboard ESP
	local gui = Instance.new("BillboardGui")
	gui.Name = "ItemESP_Gui"
	gui.Adornee = head
	gui.Size = UDim2.new(0, 100, 0, 40)
	gui.StudsOffset = Vector3.new(0, 2, 0)
	gui.AlwaysOnTop = true
	gui.Parent = head

	local lbl = Instance.new("TextLabel")
	lbl.Name = "MainLabel"
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 14
	lbl.TextColor3 = color
	lbl.Text = labelText .. "\nDist: 0.0"
	lbl.TextStrokeTransparency = 0
	lbl.Parent = gui

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.new(0, 0, 0)
	stroke.Thickness = 1.5
	stroke.Parent = lbl

	-- Outline ESP (Highlight)
	if _G.UseOutline then
		local hl = Instance.new("Highlight")
		hl.Name = "ItemESP_Outline"
		hl.Adornee = obj
		hl.FillTransparency = 1
		hl.OutlineTransparency = 0
		hl.OutlineColor = color
		hl.Parent = obj
	end
end

local function ClearItemESP(model)
	for _, v in ipairs(model:GetDescendants()) do
		if v:IsA("BillboardGui") and v.Name == "ItemESP_Gui" then
			v:Destroy()
		end
	end
	local hl = model:FindFirstChild("ItemESP_Outline")
	if hl then hl:Destroy() end
end

-- Hàm xử lý chung ESP
local function HandleESP(itemName, color, labelText, enabledFlag)
	local existing = {}

	-- Quét hiện tại
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if obj:IsA("Model") and obj.Name == itemName then
			CreateItemESP(obj, color, labelText)
			table.insert(existing, obj)
		end
	end

	-- Theo dõi model mới
	local con
	con = Workspace.DescendantAdded:Connect(function(obj)
		if obj:IsA("Model") and obj.Name == itemName and _G[enabledFlag] then
			task.wait(0.2)
			CreateItemESP(obj, color, labelText)
			table.insert(existing, obj)
		end
	end)

	-- Update distance + outline toggle
	local updateConn
	updateConn = RunService.RenderStepped:Connect(function()
		if not _G[enabledFlag] then return end
		for _, obj in ipairs(existing) do
			if obj.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local hrp = obj:FindFirstChildWhichIsA("BasePart")
				local gui = hrp and hrp:FindFirstChild("ItemESP_Gui")
				local lbl = gui and gui:FindFirstChild("MainLabel")
				if hrp and lbl then
					local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
					lbl.Text = labelText .. string.format("\nDist: %.1f", dist)
				end
			end

			-- Bật/tắt outline theo toggle
			local hl = obj:FindFirstChild("ItemESP_Outline")
			if _G.UseOutline then
				if not hl then
					local newHl = Instance.new("Highlight")
					newHl.Name = "ItemESP_Outline"
					newHl.Adornee = obj
					newHl.FillTransparency = 1
					newHl.OutlineTransparency = 0
					newHl.OutlineColor = color
					newHl.Parent = obj
				end
			else
				if hl then hl:Destroy() end
			end
		end
	end)

	-- Dọn khi tắt
	repeat task.wait(0.5) until not _G[enabledFlag]
	con:Disconnect()
	updateConn:Disconnect()
	for _, obj in ipairs(existing) do
		ClearItemESP(obj)
	end
	table.clear(existing)
end

-- Ví dụ toggle
Main2Group:AddToggle("EspBloxyCola", {
	Text = "ESP BloxyCola",
	Default = false,
	Callback = function(v)
		_G.EspBloxyCola = v
		if v then
			task.spawn(function()
				HandleESP("BloxyCola", Color3.fromRGB(0,255,255), "Bloxy", "EspBloxyCola")
			end)
		end
	end
})

Main2Group:AddToggle("EspMedkit", {
	Text = "ESP Medkit",
	Default = false,
	Callback = function(v)
		_G.EspMedkit = v
		if v then
			task.spawn(function()
				HandleESP("Medkit", Color3.fromRGB(255,255,0), "Medkit", "EspMedkit")
			end)
		end
	end
})

Main2Group:AddToggle("EspSubSpaceTaph", {
	Text = "ESP Taph mine",
	Default = false,
	Callback = function(v)
		_G.EspSubSpaceTaph = v
		if v then
			task.spawn(function()
				HandleESP("SubspaceTripmine", Color3.fromRGB(175,0,255), "Subspace", "EspSubSpaceTaph")
			end)
		end
	end
})

Main2Group:AddToggle("EspBuildermanDispenser", {
	Text = "ESP builderman dispenser",
	Default = false,
	Callback = function(v)
		_G.EspBuildermanDispenser = v
		if v then
			task.spawn(function()
				HandleESP("BuildermanDispenser", Color3.fromRGB(155,255,0), "Dispenser", "EspBuildermanDispenser")
			end)
		end
	end
})

Main2Group:AddToggle("EspBuildermanSentry", {
	Text = "ESP builderman sentry",
	Default = false,
	Callback = function(v)
		_G.EspBuildermanSentry = v
		if v then
			task.spawn(function()
				HandleESP("BuildermanSentry", Color3.fromRGB(155,255,0), "Sentry", "EspBuildermanSentry")
			end)
		end
	end
})

task.spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ESP Config
getgenv().ESP_JohnDoeTrap = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "JohnDoeTrapESP"

-- Hàm tạo ESP cho 1 part
local function createESP(part)
    if not part:IsA("BasePart") or part.Name ~= "Shadow" then return end
    if part:FindFirstChild("ESPBox") then return end

    -- chỉnh part
    part.Transparency = 0.8
    part.Color = Color3.fromRGB(255,0,255)
    part.Material = Enum.Material.Neon

    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBox"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0,100,0,40)
    billboard.StudsOffset = Vector3.new(0,2,0)
    billboard.Parent = part

    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1,0,1,0)
    label.TextColor3 = Color3.fromRGB(255,0,255)
    label.TextScaled = true
    label.Font = Enum.Font.Code
    label.Text = "Digital Footprint\nDistance: 0.0"
    label.Parent = billboard
    
local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.new(0, 0, 0)
	UIStroke.Thickness = 1.5
	UIStroke.Parent = label

    -- update distance
    RunService.Heartbeat:Connect(function()
        if not part:IsDescendantOf(workspace) or not billboard.Parent then return end
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local dist = (part.Position - hrp.Position).Magnitude
            label.Text = string.format("Digital Footprint\nDistance: %.1f", dist)
        end
    end)
end

-- toggle Obsidian
Main2Group:AddToggle("ESPJohnDoeTrap", {
    Text = "ESP JohnDoe Trap",
    Default = false,
    Callback = function(v)
        getgenv().ESP_JohnDoeTrap = v
        if v then
            -- quét toàn bộ
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Shadow" then
                    createESP(obj)
                end
            end
            -- bắt part mới
            workspace.DescendantAdded:Connect(function(obj)
                if getgenv().ESP_JohnDoeTrap and obj:IsA("BasePart") and obj.Name == "Shadow" then
                    createESP(obj)
                end
            end)
        else
            -- tắt ESP → xoá
            for _, esp in ipairs(espFolder:GetDescendants()) do
                esp:Destroy()
            end
        end
    end
})
end)

Main2Group:AddDivider()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Animation ID cần detect
local targetAnimId = "rbxassetid://123915228705093"

-- Lưu connection để tắt khi toggle off
local highlightConnections = {}
local active = false

local function addHighlightAndLabel(character)
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    -- Highlight
    if not character:FindFirstChild("c00l_Highlight") then
        local h = Instance.new("Highlight")
        h.Name = "c00l_Highlight"
        h.FillColor = Color3.fromRGB(0, 0, 0) -- fill đen
        h.OutlineColor = Color3.fromRGB(255, 0, 0) -- viền đỏ
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
        h.Parent = character

        task.delay(7.5, function()
            if h and h.Parent then h:Destroy() end
        end)
    end

    -- BillboardGui label
    if not character:FindFirstChild("c00l_Label") then
        local head = character:FindFirstChild("Head")
        if head then
            local gui = Instance.new("BillboardGui")
            gui.Name = "c00l_Label"
            gui.Adornee = head
            gui.Size = UDim2.new(0, 100, 0, 40)
            gui.StudsOffset = Vector3.new(0, 3, 0)
            gui.AlwaysOnTop = true
            gui.Parent = character

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = "c00lgui"
            lbl.Font = Enum.Font.Code
            lbl.TextSize = 15
            lbl.TextColor3 = Color3.fromRGB(255, 0, 0) -- chữ đỏ
            lbl.Parent = gui

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(0,0,0) -- outline chữ đen
            stroke.Thickness = 2
            stroke.Parent = lbl

            task.delay(7.5, function()
                if gui and gui.Parent then gui:Destroy() end
            end)
        end
    end
end

local function trackCharacter(player, char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local conn
    conn = hum.AnimationPlayed:Connect(function(track)
        if track and track.Animation and track.Animation.AnimationId == targetAnimId then
            addHighlightAndLabel(char)
        end
    end)

    highlightConnections[player] = conn
end

local function startTracking()
    active = true
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Character then
                trackCharacter(plr, plr.Character)
            end
            plr.CharacterAdded:Connect(function(char)
                trackCharacter(plr, char)
            end)
        end
    end
end

local function stopTracking()
    active = false
    for _, conn in pairs(highlightConnections) do
        if conn.Disconnect then conn:Disconnect() end
    end
    highlightConnections = {}

    -- Xoá highlight & label còn sót
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local h = plr.Character:FindFirstChild("c00l_Highlight")
            if h then h:Destroy() end
            local g = plr.Character:FindFirstChild("c00l_Label")
            if g then g:Destroy() end
        end
    end
end

-- Toggle trong Main2Group
Main2Group:AddToggle("c00lguiESP", {
    Text = "ESP c00lgui Using",
    Default = false,
    Callback = function(Value)
        if Value then
            startTracking()
        else
            stopTracking()
        end
    end
})

		task.spawn(function()
-- Visual Skill Hitbox (Swords fix)  
local RunService = game:GetService("RunService")  
local Debris = game:GetService("Debris")  
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")  
  
_G.VisualSkillBox = false  
  
local SKILL_NAMES = { swords = true, shockwave = true }  
local HITBOX_SIZE = Vector3.new(10, 3, 1000)  
local LIFE = { swords = 2.5, shockwave = 2.5 }  
  
local swordsColor = Color3.fromRGB(255,0,0)  
local shockColor  = Color3.fromRGB(0,0,255)  
  
local activeHitbox = {}  
  
local function destroyHitbox(killer)  
	if activeHitbox[killer] then  
		activeHitbox[killer]:Destroy()  
		activeHitbox[killer] = nil  
	end  
end  
  
local function getSkillDir(skill, hrp)  
	local bp = skill:IsA("BasePart") and skill or skill:FindFirstChildWhichIsA("BasePart", true)  
	if not bp then return nil end  
  
	local dir  
	if bp.AssemblyLinearVelocity.Magnitude > 1 then  
		dir = bp.AssemblyLinearVelocity.Unit  
	else  
		dir = bp.CFrame.LookVector  
	end  
  
	-- swords thường ngược -> fix  
	if skill.Name:lower() == "swords" and dir:Dot(hrp.CFrame.LookVector) < 0 then  
		dir = -dir  
	end  
  
	return dir, bp.Position  
end  
  
local function createHitbox(killer, skill)  
	local hrp = killer:FindFirstChild("HumanoidRootPart")  
	if not hrp then return end  
  
	destroyHitbox(killer)  
  
	local dir, skillPos = getSkillDir(skill, hrp)  
	if not dir then return end  
  
	local start = hrp.Position  
	local mid = start + dir * (HITBOX_SIZE.Z/2)  
  
	local part = Instance.new("Part")  
	part.Name = "SkillHitboxVisual"  
	part.Anchored = true  
	part.CanCollide = false  
	part.CanQuery = false  
	part.Size = HITBOX_SIZE  
	part.Transparency = 0.8  
	part.Material = Enum.Material.Neon  
  
	if skill.Name:lower() == "swords" then  
		part.Color = swordsColor  
	else  
		part.Color = shockColor  
	end  
  
	part.CFrame = CFrame.lookAt(mid, mid + dir)  
	part.Parent = workspace  
  
	activeHitbox[killer] = part  
  
	-- xoá khi skill xoá  
	skill.Destroying:Connect(function()  
		destroyHitbox(killer)  
	end)  
  
	-- tự xoá sau lifetime  
	local life = LIFE[skill.Name:lower()] or 2.5  
	Debris:AddItem(part, life)  
end  
  
workspace.DescendantAdded:Connect(function(obj)  
	if not _G.VisualSkillBox then return end  
	if not obj.Name then return end  
	if not SKILL_NAMES[obj.Name:lower()] then return end  
  
	-- tìm killer gần nhất  
	local nearest, best = nil, math.huge  
	for _, killer in ipairs(KillersFolder:GetChildren()) do  
		local hrp = killer:FindFirstChild("HumanoidRootPart")  
		if hrp then  
			local pos = obj:IsA("BasePart") and obj.Position or (obj.PrimaryPart and obj.PrimaryPart.Position)  
			if pos then  
				local d = (pos - hrp.Position).Magnitude  
				if d < best then  
					best, nearest = d, killer  
				end  
			end  
		end  
	end  
  
	if nearest then  
		task.delay(0.15, function()  
			createHitbox(nearest, obj)  
		end)  
	end  
end)  
  
-- GUI: toggle + colorpickers  
Main2Group:AddToggle("VisualSkillBox", {  
    Text = "Visual Skill Hitbox (1x)",  
    Default = false,  
    Callback = function(state)  
        _G.VisualSkillBox = state  
        if not state then  
            -- clear all  
            for k in pairs(activeHitbox) do destroyHitbox(k) end  
            -- clear pending map  
            pendingFor = {}  
        end  
    end  
})  
:AddColorPicker("SwordsHitboxColor", {  
    Default = swordsColor,  
    Transparency = 0.3,  
    Callback = function(color) swordsColor = color end  
})  
:AddColorPicker("ShockwaveHitboxColor", {  
    Default = shockColor,  
    Transparency = 0.3,  
    Callback = function(color) shockwaveColor = color end  
})

-- Visual Hitbox Skill (1x) 2 - Bám theo killer trong lúc anim
local RunService = game:GetService("RunService")
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

_G.VisualSkillBox2 = false
local hitboxColor = Color3.fromRGB(255, 0, 0)

-- Anim IDs cần theo dõi
local SKILL_ANIMS = {
    ["93491748129367"] = true,
    ["70447634862911"] = true,
    ["119181003138006"] = true,
    ["131430497821198"] = true,
    ["81935774508746"] = true,
    ["100592913030351"] = true,
    ["83685305553364"] = true,
    ["99030950661794"] = true,
}

local HITBOX_SIZE = Vector3.new(10, 3, 1000)
local activeHitboxes = {} -- [animTrack] = {part=Part, conn=RBXScriptConnection}

-- Tạo hitbox và bám theo killer
local function createFollowHitbox(killer, track)
    local hrp = killer:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    -- part hitbox
    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.Size = HITBOX_SIZE
    part.Color = hitboxColor
    part.Transparency = 0.9
    part.Material = Enum.Material.Neon
    part.Parent = workspace

    -- cập nhật theo hướng killer trong lúc anim chạy
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not _G.VisualSkillBox2 then return end
        if not hrp or not hrp.Parent or not track.IsPlaying then
            if conn then conn:Disconnect() end
            if part then part:Destroy() end
            activeHitboxes[track] = nil
            return
        end

        local dir = hrp.CFrame.LookVector
        local mid = hrp.Position + dir * (HITBOX_SIZE.Z/2)
        part.CFrame = CFrame.lookAt(mid, mid + dir)
    end)

    activeHitboxes[track] = {part=part, conn=conn}

    -- cleanup khi anim stop
    track.Stopped:Connect(function()
        if activeHitboxes[track] then
            if activeHitboxes[track].conn then activeHitboxes[track].conn:Disconnect() end
            if activeHitboxes[track].part then activeHitboxes[track].part:Destroy() end
            activeHitboxes[track] = nil
        end
    end)
end

-- Hook AnimationPlayed cho killer
local function hookKiller(killer)
    local hum = killer:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local function onPlayed(track)
        if not _G.VisualSkillBox2 then return end
        local animId = track.Animation and track.Animation.AnimationId and track.Animation.AnimationId:match("%d+")
        if animId and SKILL_ANIMS[animId] then
            createFollowHitbox(killer, track)
        end
    end

    if hum.AnimationPlayed then
        hum.AnimationPlayed:Connect(onPlayed)
    end
    local animator = hum:FindFirstChildOfClass("Animator")
    if animator and animator.AnimationPlayed then
        animator.AnimationPlayed:Connect(onPlayed)
    end
end

-- Hook killers hiện có
for _, killer in ipairs(KillersFolder:GetChildren()) do
    hookKiller(killer)
end
KillersFolder.ChildAdded:Connect(hookKiller)

-- Toggle + ColorPicker GUI
Main2Group:AddToggle("VisualSkillBox2", {
    Text = "Visual Hitbox Skill (1x) 2",
    Default = false,
    Callback = function(state)
        _G.VisualSkillBox2 = state
        if not state then
            for _, data in pairs(activeHitboxes) do
                if data.conn then data.conn:Disconnect() end
                if data.part then data.part:Destroy() end
            end
            activeHitboxes = {}
        end
    end
})
:AddColorPicker("VisualSkillBox2Color", {
    Default = hitboxColor,
    Transparency = 0.3,
    Callback = function(color)
        hitboxColor = color
        -- update màu hitbox đang active
        for _, data in pairs(activeHitboxes) do
            if data.part then
                data.part.Color = color
            end
        end
    end
})
			end)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.ESP_Minion = false
local espObjects = {}

-- Check NPC
local function isNPC(target)
    return target:FindFirstChildOfClass("Humanoid") ~= nil
end

-- Tạo ESP
local function createESP(target)
    if not target or espObjects[target] then return end
    if not isNPC(target) then return end

    local name = target.Name
    if name == "1x1x1x1Zombie" or name == "007n7" or name == "BuildermanSentry"
       or name == "BuildermanDispenser" or name == "Bacon" or name == "Theater" or name == "TheRing" or name == "MurderKitchen" or name == "Slender" or name == "Rig" or name == "SubspaceTripmine"
       or string.find(name, "TaphTripwire") then return end

    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        hrp = target:WaitForChild("HumanoidRootPart", 2)
        if not hrp then return end
    end

    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MinionESP"
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = game.CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 40)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 140, 0)
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextStrokeTransparency = 0
    label.Text = "Minion\nDist: 0.0"
    label.Parent = billboard

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(0, 0, 0)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = label

    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = target

    espObjects[target] = {billboard = billboard, label = label, highlight = highlight}
end

-- Xoá ESP
local function removeESP(target)
    if espObjects[target] then
        if espObjects[target].billboard then espObjects[target].billboard:Destroy() end
        if espObjects[target].highlight then espObjects[target].highlight:Destroy() end
        espObjects[target] = nil
    end
end

-- Update distance
RunService.RenderStepped:Connect(function()
    if not _G.ESP_Minion then
        for _, v in pairs(espObjects) do
            v.billboard.Enabled = false
            if v.highlight then v.highlight.Enabled = false end
        end
        return
    end

    for target, data in pairs(espObjects) do
        if target and target.Parent then
            local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
            local lpHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and lpHRP then
                local dist = (hrp.Position - lpHRP.Position).Magnitude
                data.label.Text = string.format("Minion\nDist: %.1f", dist)
                data.billboard.Enabled = true
                if data.highlight then data.highlight.Enabled = true end
            end
        else
            removeESP(target)
        end
    end
end)

-- Toggle
Main2Group:AddToggle("ESPMinion", {
    Text = "ESP c00lkidd minion",
    Default = false,
    Callback = function(Value)
        _G.ESP_Minion = Value
        if Value then
            local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
            if map then
                -- quét toàn bộ
                for _, obj in ipairs(map:GetDescendants()) do
                    createESP(obj)
                end
                -- theo dõi spawn mới
                map.DescendantAdded:Connect(function(child)
                    if _G.ESP_Minion then
                        createESP(child)
                    end
                end)
                map.DescendantRemoving:Connect(function(child)
                    removeESP(child)
                end)
            end
        else
            for target in pairs(espObjects) do
                removeESP(target)
            end
        end
    end
})

		task.spawn(function()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.ESP_Zombie = false
local espZombieObjects = {}

-- Tạo ESP cho 1x1x1x1Zombie
local function createZombieESP(target)
    if not target or espZombieObjects[target] then return end
    if target.Name ~= "1x1x1x1Zombie" then return end
    if not target:FindFirstChildOfClass("Humanoid") then return end

    local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not hrp then
        hrp = target:WaitForChild("HumanoidRootPart", 2)
        if not hrp then return end
    end

    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ZombieESP"
    billboard.Adornee = hrp
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = game.CoreGui

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 40)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(0, 255, 0) -- xanh lá
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextStrokeTransparency = 0
    label.Text = "Zombie\nDist: 0.0"
    label.Parent = billboard

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(0, 0, 0)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = label

    local highlight = Instance.new("Highlight")
    highlight.Name = "ZombieHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(0, 255, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = target

    espZombieObjects[target] = {billboard = billboard, label = label, highlight = highlight}
end

-- Xoá ESP
local function removeZombieESP(target)
    if espZombieObjects[target] then
        if espZombieObjects[target].billboard then espZombieObjects[target].billboard:Destroy() end
        if espZombieObjects[target].highlight then espZombieObjects[target].highlight:Destroy() end
        espZombieObjects[target] = nil
    end
end

-- Update distance
RunService.RenderStepped:Connect(function()
    if not _G.ESP_Zombie then
        for _, v in pairs(espZombieObjects) do
            v.billboard.Enabled = false
            if v.highlight then v.highlight.Enabled = false end
        end
        return
    end

    for target, data in pairs(espZombieObjects) do
        if target and target.Parent then
            local hrp = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
            local lpHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp and lpHRP then
                local dist = (hrp.Position - lpHRP.Position).Magnitude
                data.label.Text = string.format("Zombie\nDist: %.1f", dist)
                data.billboard.Enabled = true
                if data.highlight then data.highlight.Enabled = true end
            end
        else
            removeZombieESP(target)
        end
    end
end)

-- Toggle ESP Zombie
Main2Group:AddToggle("ESPZombie", {
    Text = "ESP 1x1x1x1Zombie",
    Default = false,
    Callback = function(Value)
        _G.ESP_Zombie = Value
        if Value then
            local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
            if map then
                for _, obj in ipairs(map:GetDescendants()) do
                    createZombieESP(obj)
                end
                map.DescendantAdded:Connect(function(child)
                    if _G.ESP_Zombie then
                        createZombieESP(child)
                    end
                end)
                map.DescendantRemoving:Connect(function(child)
                    removeZombieESP(child)
                end)
            end
        else
            for target in pairs(espZombieObjects) do
                removeZombieESP(target)
            end
        end
    end
})
	end)


Main2Group:AddDivider()


local Players = game:GetService("Players")

-- ============ OUTLINE ESP ===============
local function addOutline(char, isKiller)
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if char:FindFirstChild("OutlineESP") then return end

    local h = Instance.new("Highlight")
    h.Name = "OutlineESP"
    h.Adornee = char
    h.FillTransparency = 1 -- chỉ viền
    h.OutlineTransparency = 0
    if isKiller then
        h.OutlineColor = _G.ColorOutlineKill or Color3.fromRGB(255,0,0)
    else
        h.OutlineColor = _G.ColorOutlineSurvivors or Color3.fromRGB(255,255,255)
    end
    h.Parent = char
end

local function clearOutline(char)
    if char and char:FindFirstChild("OutlineESP") then
        char.OutlineESP:Destroy()
    end
end

-- ============ LABEL ESP (bản bạn đưa) ===============
function Esp_Player(characterModel)
    -- xoá highlight cũ
    if characterModel:FindFirstChild("Esp_Highlight") then
        characterModel.Esp_Highlight:Destroy()
    end
    -- xoá BillboardGui cũ
    for _, gui in ipairs(characterModel:GetDescendants()) do
        if gui.Name == "Esp_Gui" then
            gui:Destroy()
        end
    end

    if not _G.EspGui then return end

    local head = characterModel:FindFirstChild("Head")
    if not head then return end

    local gui = Instance.new("BillboardGui")
    gui.Name = "Esp_Gui"
    gui.Adornee = head
    gui.AlwaysOnTop = true
    gui.Size = UDim2.new(0, 120, 0, 50)
    gui.StudsOffset = Vector3.new(0, 3, 0)
    gui.Parent = head

    local lbl = Instance.new("TextLabel", gui)
    lbl.Name = "Esp_Text"
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = _G.EspGuiTextSize or 15
    lbl.TextStrokeTransparency = 0

    local stroke = Instance.new("UIStroke", lbl)
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Thickness = 1.5

    local isInKillers = (characterModel.Parent and characterModel.Parent.Name == "Killers")
    local isPlayer = (Players:GetPlayerFromCharacter(characterModel) ~= nil)
    local isFakeNoli = isInKillers and not isPlayer and characterModel.Name:lower():find("noli")

    if isFakeNoli then
        lbl.TextColor3 = Color3.fromRGB(150, 0, 150)
    elseif isInKillers then
        lbl.TextColor3 = _G.EspGuiTextKillerColor or Color3.fromRGB(255, 0, 0)
    else
        lbl.TextColor3 = _G.EspGuiTextColor or Color3.new(1,1,1)
    end

    local parts = {}
    if isFakeNoli then
        table.insert(parts, "Hallucination")
        table.insert(parts, "Dist: 0.0")
    else
        if _G.EspName then
            table.insert(parts, characterModel.Name)
        end
        if _G.EspDistance then
            local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
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
    end

    lbl.Text = table.concat(parts, "\n")
end

-- ============ UI DROPDOWN + TOGGLES ===============
Main2Group:AddDropdown("EspPlayer", {
    Text = "Section",
    Values = {"Killers", "Survivors"},
    Default = "",
    Multi = true
})

-- Toggle chính để bật ESP Player
Main2Group:AddToggle("Player", {
    Text = "Enable Esp",
    Default = false,
    Callback = function(Value)
        _G.EspPlayer = Value
        if not Value then
            for _, v in pairs(game.Workspace.Players:GetChildren()) do
                if v.Name == "Killers" or v.Name == "Survivors" then
                    for _, z in pairs(v:GetChildren()) do
                        if z:FindFirstChild("Esp_Gui") then z.Esp_Gui:Destroy() end
                        if z:FindFirstChild("OutlineESP") then z.OutlineESP:Destroy() end
                    end
                end
            end
            return
        end

        while _G.EspPlayer do
            for _, folder in pairs(game.Workspace.Players:GetChildren()) do
                if Options.EspPlayer.Value["Killers"] and folder.Name == "Killers" then
                    for _, char in pairs(folder:GetChildren()) do
                        if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char:FindFirstChild("Head") then
                            Esp_Player(char)
                            if _G.UseOutline then
                                addOutline(char, true)
                            else
                                clearOutline(char)
                            end
                        end
                    end
                elseif Options.EspPlayer.Value["Survivors"] and folder.Name == "Survivors" then
                    for _, char in pairs(folder:GetChildren()) do
                        if char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") and char:FindFirstChild("Head") then
                            Esp_Player(char)
                            if _G.UseOutline then
                                addOutline(char, false)
                            else
                                clearOutline(char)
                            end
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end
})

Main2Group:AddDivider()


Main2Group:AddToggle("OutlineESP", {
    Text = "Enable Outline",
    Default = false,
    Callback = function(Value)
        _G.UseOutline = Value
    end
}):AddColorPicker("ColorOutlineKill", {
    Default = Color3.fromRGB(255,0,0),
    Callback = function(Value)
        _G.ColorOutlineKill = Value
    end
}):AddColorPicker("ColorOutlineSurvivors", {
    Default = Color3.fromRGB(255,255,255),
    Callback = function(Value)
        _G.ColorOutlineSurvivors = Value
    end
})



_G.EspGui = false
Main2Group:AddToggle("Esp Gui", {
    Text = "Enable Gui",
    Default = false, 
    Callback = function(Value) 
_G.EspGui = Value
    end
}):AddColorPicker("Color Esp Text Killer", {
     Default = Color3.new(255,0,0),
     Callback = function(Value)
_G.EspGuiTextKillerColor = Value
     end
}):AddColorPicker("Color Esp Text Survi", {
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























		
















-- Main2o5Group
local M205One = Main2o5Group:AddTab("--= Misc =--")

M205One:AddDivider()

M205One:AddLabel("-= Pick up =-", true)

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

		local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Biến auto collect
local autoCollect = false

-- Hàm xử lý nhặt item
local function collectItem(tool)
    if autoCollect and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if tool:IsA("Tool") and tool:FindFirstChild("ItemRoot") and tool.ItemRoot:FindFirstChild("ProximityPrompt") then
            local root = LocalPlayer.Character.HumanoidRootPart
            local dist = (root.Position - tool.ItemRoot.Position).Magnitude
            if dist <= 20 then -- range 20 studs
                pcall(function()
                    fireproximityprompt(tool.ItemRoot.ProximityPrompt)
                end)
            end
        end
    end
end

-- Loop check item sẵn có
RunService.Heartbeat:Connect(function()
    if autoCollect and workspace:FindFirstChild("Map") 
        and workspace.Map:FindFirstChild("Ingame") 
        and workspace.Map.Ingame:FindFirstChild("Map") then
        for _, v in ipairs(workspace.Map.Ingame.Map:GetChildren()) do
            collectItem(v)
        end
    end
end)

-- Tự động theo dõi item spawn thêm
if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame") and workspace.Map.Ingame:FindFirstChild("Map") then
    workspace.Map.Ingame.Map.ChildAdded:Connect(function(child)
        task.wait() -- đợi 1 frame để chắc chắn ProximityPrompt tạo xong
        collectItem(child)
    end)
end

-- Thêm vào Obsidian UI
M205One:AddToggle("AutoCollectItems", {
    Text = "Auto Collect Items",
    Default = false,
    Callback = function(state)
        autoCollect = state
    end
})

M205One:AddDivider()

M205One:AddLabel("-= Last Mans Standing Sound =-")

local targetName = "LastSurvivor"

-- Danh sách sound để chọn
local soundLibrary = {
    ["Burnout"] = "130101085745481",
    ["Plead"]   = "80564889711353",
    ["Compass"] = "127298326178102",
    ["Vanity"]  = "137266220091579",
    ["Creation of hatred"] = "115884097233860",
    ["Smile"] = "122146196733152",
    ["Through Patches of Violet"] = "134062685653533",
}

-- Mặc định chọn Burnout
_G.LastSoundLoop = false
_G.LastSoundChoice = "Burnout"

-- Hàm đổi sound
local function switchSound(id)
    for _, snd in ipairs(workspace:GetDescendants()) do
        if snd:IsA("Sound") and snd.Name == targetName then
            if snd.SoundId ~= "rbxassetid://"..id then
                local wasPlaying = snd.IsPlaying
                local timePos = snd.TimePosition
                snd.SoundId = "rbxassetid://"..id
                snd.TimePosition = timePos
                if wasPlaying then snd:Play() end
            end
        end
    end
end

-- Button đổi ngay lập tức
M205One:AddButton({
    Text = "Switch Once",
    Func = function()
        local id = soundLibrary[_G.LastSoundChoice]
        if id then
            switchSound(id)
        end
    end
})

-- Toggle đổi liên tục
M205One:AddToggle("LastSound", {
    Text = "Auto Switch",
    Default = false,
    Callback = function(Value)
        _G.LastSoundLoop = Value
        if Value then
            task.spawn(function()
                local targetName = "LastSurvivor"
local trackedSounds = {}

-- hook sẵn sound
local function trackSound(snd)
    if snd:IsA("Sound") and snd.Name == targetName then
        trackedSounds[snd] = true
        snd.Destroying:Connect(function() trackedSounds[snd] = nil end)
    end
end

for _, d in ipairs(workspace:GetDescendants()) do
    trackSound(d)
end

workspace.DescendantAdded:Connect(trackSound)

-- loop giờ chỉ duyệt trackedSounds, nhẹ hơn rất nhiều
while _G.LastSoundLoop do
    local id = soundLibrary[_G.LastSoundChoice]
    if id then
        for snd in pairs(trackedSounds) do
            if snd.SoundId ~= "rbxassetid://"..id then
                local wasPlaying = snd.IsPlaying
                local timePos = snd.TimePosition
                snd.SoundId = "rbxassetid://"..id
                snd.TimePosition = timePos
                if wasPlaying then snd:Play() end
            end
        end
    end
    task.wait(0.3)
end
            end)
        end
    end
})

-- Dropdown chọn nhạc
M205One:AddDropdown("LastSoundChoice", {
    Values = {"Burnout","Plead","Compass","Creation of hatred","Vanity","Smile","Through Patches of Violet"},
    Default = 1,
    Multi = false,
    Text = "Choose Sound",
    Callback = function(choice)
        _G.LastSoundChoice = choice
    end
})

M205One:AddDivider()

M205One:AddLabel("-= FAKE BLOCK =-")

		-- Fak4 BlOck (M205One) ----------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- GUI / OPTIONS (Obsidian)
-- Bạn dùng M205One (tab) để add các control
-- Các keys (IDs) cho dropdown
local ANIM_IDS = {
    ["Ms1-2"] = "rbxassetid://72722244508749",  -- Ms1-2
    ["Ms3-4"] = "rbxassetid://96959123077498",  -- Ms3-4
}

-- State / defaults
local options = {
    showMobileGUI = false,         -- obsidian toggle: show/hide mobile GUI
    useAnim = true,                -- toggle: có dùng anim không
    applySpeed = true,             -- toggle: có giảm speed không
    targetSpeed = 10,              -- input: target walk speed khi fake block
    duration = 2,                  -- input: số giây giữ tốc độ
    selectedAnimKey = "Ms1-2",     -- dropdown initial
    keybind = Enum.KeyCode.P,      -- keybind mặc định
}

-- Internal human connections (so we can disconnect/reset)
local HumanModCons = {
    wsLoop = nil,  -- WalkSpeed property change conn
    wsCA = nil,    -- CharacterAdded conn
    currentPart = nil,
}

-- Helper: disconnect any walk speed enforcement
local function disconnectWalkEnforce()
    if HumanModCons.wsLoop then
        pcall(function() HumanModCons.wsLoop:Disconnect() end)
        HumanModCons.wsLoop = nil
    end
    if HumanModCons.wsCA then
        pcall(function() HumanModCons.wsCA:Disconnect() end)
        HumanModCons.wsCA = nil
    end
end

-- Apply (temporary) enforced WalkSpeed for `seconds` seconds at `speed`
-- This uses the pattern bạn đưa (giữ loop + reconnect on CharacterAdded).
local function enforceWalkSpeedFor(seconds, speed)
    -- safety param checks
    seconds = tonumber(seconds) or 0
    speed = tonumber(speed) or 16

    -- disconnect previous enforcement (we allow immediate reapply)
    disconnectWalkEnforce()

    local function applyToCharacter(char)
        if not char then return end
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if not hum then return end

        local function WalkSpeedChange()
            if hum and hum.Parent then
                hum.WalkSpeed = speed
            end
        end

        -- set immediately:
        pcall(WalkSpeedChange)

        -- setup property-changed connection to enforce
        HumanModCons.wsLoop = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)

        -- ensure on respawn we reapply
        HumanModCons.wsCA = LocalPlayer.CharacterAdded:Connect(function(nChar)
            char = nChar
            hum = char:WaitForChild("Humanoid")
            WalkSpeedChange()
            if HumanModCons.wsLoop then pcall(function() HumanModCons.wsLoop:Disconnect() end) end
            HumanModCons.wsLoop = hum:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
        end)
    end

    -- apply to current character
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    applyToCharacter(char)

    -- after seconds, disconnect and allow normal speed
    task.delay(seconds, function()
        -- give a small frame to avoid race
        task.wait(0.05)
        disconnectWalkEnforce()
        -- optional: restore default WalkSpeed to 16 if character exists (you can remove if undesired)
        pcall(function()
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
            if hum then
                hum.WalkSpeed = 16
            end
        end)
    end)
end

-- Play local animation (returns track)
local function playLocalAnim(animId)
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return nil end

    -- ensure Animator exists
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local success, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    if not success or not track then
        pcall(function() anim:Destroy() end)
        return nil
    end

    track.Priority = Enum.AnimationPriority.Action
    track:Play()
    -- auto destroy Animation instance after load (track keeps playing)
    task.delay(1, function()
        pcall(function() anim:Destroy() end)
    end)
    return track
end

-- Core action: fake block
-- If useAnim true -> play anim (and wait small moment if you want)
-- If applySpeed true -> enforce speed for duration seconds
local function doFakeBlock()
    -- play anim if enabled
    local track = nil
    if options.useAnim then
        local animId = ANIM_IDS[options.selectedAnimKey] or ANIM_IDS["Ms1-2"]
        track = playLocalAnim(animId)
        -- we don't block on track:Stopped; speed effect is independent
    end

    if options.applySpeed then
        enforceWalkSpeedFor(options.duration, options.targetSpeed)
    end

    -- For mobile GUI feedback, we can flash a brief local notification (StarterGui)
    pcall(function()
        local StarterGui = game:GetService("StarterGui")
        if StarterGui and StarterGui.SetCore then
            StarterGui:SetCore("SendNotification", {
                Title = "Fak4 BlOck",
                Text = "Activated",
                Duration = 1
            })
        end
    end)

    return track
end

-- KEYBIND: activate fake block with a key (PC)
-- We'll rely on Obsidian's AddKeybind if available; else use UserInputService fallback
-- But here we wire the keybind callback from obidian control (see GUI section)
local UserInputService = game:GetService("UserInputService")
local function setupKeybind(keycode)
    -- disconnect existing listener if any
    if HumanModCons.keyListener then
        pcall(function() HumanModCons.keyListener:Disconnect() end)
        HumanModCons.keyListener = nil
    end

    HumanModCons.keyListener = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keycode then
            doFakeBlock()
        end
    end)
end

-- BUILD MOBILE GUI (ScreenGui) -> show/hide by obsidian toggle
local mobileGui = nil
local function createMobileGui()
    if mobileGui and mobileGui.Parent then return mobileGui end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "Fak4BlockMobileGui"
    mobileGui.ResetOnSpawn = false
    mobileGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 260, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -130, 1, -150)
    mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    mainFrame.BorderColor3 = Color3.new(1, 0, 0)
    mainFrame.BorderSizePixel = 1
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = mobileGui

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "F4ke BlOck"
    title.TextColor3 = Color3.new(1, 0, 0)
    title.TextScaled = true
    title.Font = Enum.Font.Code
    title.Parent = mainFrame

    -- Button
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
        doFakeBlock()
    end)

    mobileGui.Enabled = false
    return mobileGui
end


-- Create mobile GUI now (hidden), obsidian toggle will show/hide it
createMobileGui()

-- -------------------------
-- Obsidian UI bindings
-- M205One is the tab / group variable passed earlier; adapt names if different.
-- Example calls (you already used patterns like Main1Group:AddToggle/AddInput..)
-- Below we add controls to M205One (replace name if your variable is different)

-- show/hide mobile GUI toggle
M205One:AddToggle("ShowFak4MobileGUI", {
    Text = "Show Mobile Fak4 GUI",
    Default = false,
    Callback = function(val)
        options.showMobileGUI = val
        if mobileGui then mobileGui.Enabled = val end
    end
})

-- toggle use animation
M205One:AddToggle("Fak4UseAnim", {
    Text = "Use Animation",
    Default = options.useAnim,
    Callback = function(val) options.useAnim = val end
})

M205One:AddDropdown("Fak4AnimSelect", {
    Values = { "Ms1-2", "Ms3-4" },
    Default = options.selectedAnimKey,
    Multi = false,
    Text = "Animation Select",
    Callback = function(Value)
        options.selectedAnimKey = Value
    end,
})

-- toggle apply speed
M205One:AddToggle("Fak4ApplySpeed", {
    Text = "Reduce WalkSpeed",
    Default = options.applySpeed,
    Callback = function(val) options.applySpeed = val end
})

-- input: target speed
M205One:AddInput("Fak4SpeedValue", {
    Default = tostring(options.targetSpeed),
    Numeric = true,
    Text = "Target WalkSpeed",
    Placeholder = "e.g. 10",
    Callback = function(val)
        local n = tonumber(val)
        if n and n > 0 then
            options.targetSpeed = n
        else
            Library:Notify("Invalid speed", 3)
        end
    end
})

-- input: duration seconds
M205One:AddInput("Fak4Duration", {
    Default = tostring(options.duration),
    Numeric = true,
    Text = "Duration (s)",
    Placeholder = "e.g. 2",
    Callback = function(val)
        local n = tonumber(val)
        if n and n > 0 then
            options.duration = n
        else
            Library:Notify("Invalid duration", 3)
        end
    end
})

M205One:AddLabel("FakeBlock Keybind"):AddKeyPicker("FakeBlockBind", {
    Default = nil,
    Mode = "Hold", -- hoặc "Toggle"
    Text = "Fake Block",
    Callback = function()
        FakeBlockActivate()
    end
})


-- optional: small notify that module loaded
pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "F4ke BlOck",
        Text = "Loaded",
        Duration = 2
    })
end)

-- Initialize keybind listener
setupKeybind(options.keybind)

-- End of Fak4 BlOck module ----------------------------------------------

M205One:AddDivider()

M205One:AddLabel("-= FAKE LAG (ALPHA) =-")

-- Fak4 Lag (M205One) ----------------------------------------------------
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Anim IDs
local ANIM_IDS = {
    ["Walk"] = "rbxassetid://108018357044094",
    ["Run"]  = "rbxassetid://136252471123500",
}

-- State
local options = {
    showMobileGUI = false,
    selectedAnimKey = "Walk",
    keybind = Enum.KeyCode.P,
}
local currentTrack = nil
local animActive = false

-- Play local animation
local function playLocalAnim(animId)
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return nil end

    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end

    local anim = Instance.new("Animation")
    anim.AnimationId = animId
    local ok, track = pcall(function()
        return animator:LoadAnimation(anim)
    end)
    if not ok or not track then
        anim:Destroy()
        return nil
    end

    track.Priority = Enum.AnimationPriority.Action
    track:Play()
    task.delay(1, function() pcall(function() anim:Destroy() end) end)
    return track
end

-- Stop anim if running
local function stopAnim()
    if currentTrack and currentTrack.IsPlaying then
        currentTrack:Stop()
    end
    currentTrack = nil
    animActive = false
end

-- Core action
local function doFakeLag()
    if animActive then return end -- ngăn spam khi anim đang chạy
    local animId = ANIM_IDS[options.selectedAnimKey] or ANIM_IDS["Walk"]
    currentTrack = playLocalAnim(animId)
    if currentTrack then
        animActive = true
    end

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "F4ke L4g",
            Text = "Activated (" .. options.selectedAnimKey .. ")",
            Duration = 1
        })
    end)
end

-- Check movement trong lúc anim chạy
RunService.Heartbeat:Connect(function()
    if not animActive or not currentTrack then return end
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum and hum.MoveDirection.Magnitude > 0 then
        stopAnim()
    end
end)

-- PC Keybind
local keyConn
local function setupKeybind(keycode)
    if keyConn then keyConn:Disconnect() end
    keyConn = UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == keycode then
            doFakeLag()
        end
    end)
end

-- Mobile GUI
local mobileGui
local function createMobileGui()
    if mobileGui and mobileGui.Parent then return mobileGui end
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")

    mobileGui = Instance.new("ScreenGui")
    mobileGui.Name = "Fak4LagMobileGui"
    mobileGui.ResetOnSpawn = false
    mobileGui.Parent = playerGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 260, 0, 120)
    mainFrame.Position = UDim2.new(0.5, -130, 1, -150)
    mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
    mainFrame.BorderColor3 = Color3.new(1, 0, 0)
    mainFrame.BorderSizePixel = 1
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = mobileGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "F4ke L4g"
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

    button.MouseButton1Click:Connect(doFakeLag)

    mobileGui.Enabled = false
    return mobileGui
end

createMobileGui()

-- Obsidian UI
M205One:AddToggle("ShowFak4LagGUI", {
    Text = "Show Mobile Fak4 GUI",
    Default = false,
    Callback = function(val)
        options.showMobileGUI = val
        if mobileGui then mobileGui.Enabled = val end
    end
})

M205One:AddDropdown("Fak4LagAnimSelect", {
    Values = {"Walk", "Run"},
    Default = options.selectedAnimKey,
    Multi = false,
    Text = "Animation Select",
    Callback = function(Value)
        options.selectedAnimKey = Value
    end,
})

M205One:AddLabel("FakeLag Keybind"):AddKeyPicker("FakeLagBind", {
    Default = nil,
    Mode = "Hold",
    Text = "Fake Lag",
    Callback = function()
        doFakeLag()
    end
})


-- Init PC keybind
setupKeybind(options.keybind)
		M205One:AddDivider()

task.spawn(function()
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")

getgenv().AutoTouchPizza = false

-- Hàm ăn Pizza
local function eatPizza()
    local char = lp.Character or lp.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name == "Pizza" and v:FindFirstChild("TouchInterest") then
            firetouchinterest(hrp, v, 0) -- chạm
            task.wait(0.1)
            firetouchinterest(hrp, v, 1) -- ngừng chạm
        end
    end
end

-- Loop chính
task.spawn(function()
    while true do
        if getgenv().AutoTouchPizza then
            eatPizza()
        end
        task.wait(5) -- delay 5s/lần
    end
end)

-- Toggle obsidian
M205One:AddToggle("AutoTouchPizza", {
    Text = "Auto Touch Pizza",
    Default = false,
    Callback = function(v)
        getgenv().AutoTouchPizza = v
    end
})

-- Biến fling
local flingPunchOn = false
local flingPower = 500

-- UI (Obsidian style)
M205One:AddToggle("FlingPunchToggle", {
    Text = "Fling",
    Default = false,
    Callback = function(v)
        flingPunchOn = v
    end
})

-- Loop fling
coroutine.wrap(function()
    local hrp, c, vel, movel = nil, nil, nil, 0.1
    while true do
        RunService.Heartbeat:Wait()
        if flingPunchOn then
            -- kiểm tra character + HRP
            while flingPunchOn and not (c and c.Parent and hrp and hrp.Parent) do
                RunService.Heartbeat:Wait()
                c = lp.Character
                hrp = c and c:FindFirstChild("HumanoidRootPart")
            end
            if flingPunchOn and hrp then
                vel = hrp.Velocity
                hrp.Velocity = vel * flingPower + Vector3.new(0, flingPower, 0)
                RunService.RenderStepped:Wait()
                hrp.Velocity = vel
                RunService.Stepped:Wait()
                hrp.Velocity = vel + Vector3.new(0, movel, 0)
                movel = -movel
            end
        end
    end
end)()

end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- ===== Config =====
_G.JohnDoeAnim = false -- Toggle

-- John Doe (custom)
local JD = {
    Idle = "rbxassetid://91803931583310",
    Walk = "rbxassetid://113177639892418",
    Run  = "rbxassetid://95204713031545",
    Attack = "rbxassetid://93069721274110",
}

-- Các attack gốc cần replace -> JD.Attack
local AttackReplace = {
    ["rbxassetid://86545133269813"]  = true,
    ["rbxassetid://119462383658044"] = true,
    ["rbxassetid://116618003477002"] = true,
    ["rbxassetid://87259391926321"]  = true,
    ["rbxassetid://126830014841198"] = true,
    ["rbxassetid://121086746534252"] = true,
    ["rbxassetid://126355327951215"] = true,
    ["rbxassetid://107339108383093"] = true,
    ["rbxassetid://109230267448394"] = true,
    ["rbxassetid://18885909645"]     = true,
    ["rbxassetid://18885915433"]     = true,
    ["rbxassetid://83829782357897"]  = true,
    ["rbxassetid://18885919947"]     = true,
}

--[[
[MessageOutput] [Anim] rbxassetid://107339108383093
[MessageOutput] [Anim] rbxassetid://109230267448394
]]

-- ===== Internals =====
local conns = {}
local currentLocomotionTrack
local currentAttackTrack
local currentState = ""
local lastSpeed = 0
local isAttacking = false
local trackCache = {}

-- tái sử dụng track
local function playTrack(animator, id, looped)
    local track = trackCache[id]
    if not track or not track.Parent then
        local anim = Instance.new("Animation")
        anim.AnimationId = id
        track = animator:LoadAnimation(anim)
        trackCache[id] = track
    end
    track.Looped = looped or false
    track:Play(0.1, 1, 1)
    return track
end

local function stopTrack(track, fade)
    if track and track.IsPlaying then
        track:Stop(fade or 0.1)
    end
end

local function chooseState(hum)
    local spd = hum.MoveDirection.Magnitude * hum.WalkSpeed
    local state, instant = "Idle", false

    if spd > 13 then
        state = "Run"
    elseif spd > 0.1 then
        state = "Walk"
    else
        state = "Idle"
    end

    if currentState == "Run" and (lastSpeed - spd) >= 1.5 then
        state, instant = "Walk", true
    end
    if currentState == "Walk" and spd > 13 then
        state, instant = "Run", true
    end

    lastSpeed = spd
    return state, instant
end

local function applyLocomotion(animator, state, instant)
    local targetId = JD[state]
    if not targetId then return end

    if currentLocomotionTrack and currentLocomotionTrack.IsPlaying then
        local curAnim = currentLocomotionTrack.Animation
        if curAnim and curAnim.AnimationId == targetId then return end
    end

    stopTrack(currentLocomotionTrack, instant and 0 or 0.1)
    currentLocomotionTrack = playTrack(animator, targetId, true)
end

local function setupCharacter(char)
    -- Clear old connections
    for _,c in pairs(conns) do pcall(function() c:Disconnect() end) end
    table.clear(conns)
    stopTrack(currentLocomotionTrack); currentLocomotionTrack = nil
    stopTrack(currentAttackTrack); currentAttackTrack = nil
    currentState = ""
    isAttacking = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    local animator = char:FindFirstChildWhichIsA("Animator", true)
    if not hum or not animator then return end

    -- Attack replace
    conns.animPlayed = animator.AnimationPlayed:Connect(function(track)
        if not _G.JohnDoeAnim then return end
        local a = track.Animation
        if a and AttackReplace[a.AnimationId] then
            isAttacking = true
            track:AdjustSpeed(0)
            track:Stop(0)

            if currentAttackTrack and currentAttackTrack.IsPlaying then
                currentAttackTrack:Stop(0)
            end
            currentAttackTrack = playTrack(animator, JD.Attack, false)
            pcall(function() currentAttackTrack.Priority = Enum.AnimationPriority.Action end)
            currentAttackTrack:Play(0.05, 1, 1)

            currentAttackTrack.Stopped:Connect(function()
                isAttacking = false
            end)
        end
    end)

    -- Locomotion loop
    conns.hb = RunService.Heartbeat:Connect(function()
        if not _G.JohnDoeAnim then return end
        if isAttacking then return end -- nếu đang attack thì skip locomotion

        local st, instant = chooseState(hum)
        if st ~= currentState then
            currentState = st
            applyLocomotion(animator, currentState, instant)
        end
    end)

    -- Nếu toggle đang bật khi respawn → refresh anim
    if _G.JohnDoeAnim then
        currentState = ""
        local st = chooseState(hum)
        applyLocomotion(animator, st, false)
        currentState = st
    end
end

-- init + respawn
if lp.Character then setupCharacter(lp.Character) end
lp.CharacterAdded:Connect(setupCharacter)

-- ===== UI =====
M205One:AddToggle("JohnDoeAnim", {
    Text = "John Doe Anim [Beta]",
    Default = false,
    Callback = function(v)
        _G.JohnDoeAnim = v
        if v and lp.Character then
            setupCharacter(lp.Character)
        end
    end
})
  

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

        if not _G.PingConn then _G.PingConn = nil end

        local function CreatePingGui()
            local oldGui = game.CoreGui:FindFirstChild("PingGui")
            if oldGui then oldGui:Destroy() end

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
            Frame.Draggable = true -- cho kéo được
            Frame.Parent = ScreenGui

            local PingLabel = Instance.new("TextLabel")
            PingLabel.Size = UDim2.new(1, 0, 1, 0)
            PingLabel.BackgroundTransparency = 1
            PingLabel.TextColor3 = Color3.new(1, 1, 1)
            PingLabel.TextScaled = true
            PingLabel.Text = "Ping: 0 ms"
            PingLabel.Font = Enum.Font.Code
            PingLabel.Parent = Frame

            -- luôn update ping
            if _G.PingConn then _G.PingConn:Disconnect() end
            _G.PingConn = RunService.RenderStepped:Connect(function()
                if not ScreenGui.Parent then return end
                local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
                PingLabel.Text = "Ping: " .. math.floor(ping) .. " ms"
            end)
        end

        if Value then
            _G.ShowPingEnabled = true
            CreatePingGui()

            -- đảm bảo khi respawn GUI vẫn tồn tại
            if not _G.RespawnConn then
                _G.RespawnConn = player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    if _G.ShowPingEnabled then
                        CreatePingGui()
                    end
                end)
            end
        else
            _G.ShowPingEnabled = false
            if _G.PingConn then _G.PingConn:Disconnect() end
            _G.PingConn = nil
            if game.CoreGui:FindFirstChild("PingGui") then
                game.CoreGui.PingGui:Destroy()
            end
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









local M205Two = Main2o5Group:AddTab("--= Load Script =--")

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
M205Two:AddButton("Load Rinns Hub [Key](2links)", function()
loadstring(game:HttpGet("https://rawscripts.net/raw/Forsaken-Stamina-values-changer-42106"))()
end)
M205Two:AddButton("Load NOL script", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/Syndromehsh/-/refs/heads/ISIS-%E8%A2%AB%E9%81%97%E5%BC%83/%E4%B8%8D%E8%A6%81%E5%91%8A%E8%AF%89%E4%BB%BB%E4%BD%95%E4%BA%BA%E5%93%9F%5B/%E5%B8%8C%E7%9A%AE%E7%AC%91%E8%84%B8%5D"))()
end)

M205Two:AddDivider()
M205Two:AddButton("Load Sigmasaken", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/sigmaboy-sigma-boy/Sigmasaken/refs/heads/main/sigmasakenmain"))()
task.wait(3)
setclipboard("")
end)
M205Two:AddButton("Load Fartsaken [Key]", function()
if getgenv then
    getgenv().BloxtrapRPC = "true"
    getgenv().DebugNotifications = "false"
    getgenv().TrackMePlease = "true"
end

loadstring(game:HttpGet("https://raw.githubusercontent.com/ivannetta/ShitScripts/main/forsaken.lua"))()
end)
M205Two:AddDivider()
task.spawn(function()
		local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local PlaceId = game.PlaceId
local JobId = game.JobId

-- 🔹 Server Hop
M205Two:AddButton("Server Hop", function()
    local servers = {}
    local success, result = pcall(function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
        return HttpService:JSONDecode(req)
    end)

    if success and result and result.data then
        for _, v in next, result.data do
            if tonumber(v.playing) < tonumber(v.maxPlayers) and v.id ~= JobId then
                table.insert(servers, v.id)
            end
        end
    end

    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(PlaceId, servers[math.random(1, #servers)], Players.LocalPlayer)
    else
        Library:Notify("Server Not Found.", 3)
    end
end)

-- 🔹 Low Server
M205Two:AddButton("Low Server", function()
    local function getLowestPlayerServer()
        local servers = {}
        local cursor = ""

        repeat
            local url = "https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. cursor
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)

            if success and response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= JobId then
                        table.insert(servers, server)
                    end
                end
                cursor = response.nextPageCursor or ""
            else
                cursor = ""
            end

            task.wait(1)
        until cursor == ""

        table.sort(servers, function(a, b)
            return a.playing < b.playing
        end)

        return #servers > 0 and servers[1].id or nil
    end

    local serverId = getLowestPlayerServer()
    if serverId then
        TeleportService:TeleportToPlaceInstance(PlaceId, serverId, Players.LocalPlayer)
    else
        Library:Notify("Server Not Found", 3)
    end
end)

-- 🔹 Rejoin
M205Two:AddButton("Rejoin", function()
    if #Players:GetPlayers() <= 1 then
        Players.LocalPlayer:Kick("\nRejoining...")
        task.wait(1)
        TeleportService:Teleport(PlaceId, Players.LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
    end
end)
			end)

































































-- Main3Group
Main3Group:AddDivider()


Main3Group:AddLabel("--== Surviv: [ TwoTime ] [ Updating ] ==--", true) 
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Config
_G.AimBackstab_Enabled = false
_G.AimBackstab_Mode = "Behind"
_G.AimBackstab_Range = 4
_G.AimBackstab_Action = "Aim"
_G.AimBackstab_Style = "Free"

-- Dropdown chọn style
Main3Group:AddDropdown("AimBackstabStyle", {
    Values = {"Free", "Back"},
    Default = 1,
    Multi = false,
    Text = "Aim Style",
    Callback = function(v)
        _G.AimBackstab_Style = v
    end
})

-- cooldown
local globalCooldown = false

-- Check hướng sau lưng
local function isBehindTarget(hrp, targetHRP)
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance > _G.AimBackstab_Range then return false end

    if _G.AimBackstab_Mode == "Around" then
        return true
    else
        local direction = -targetHRP.CFrame.LookVector
        local toPlayer = (hrp.Position - targetHRP.Position)
        return toPlayer:Dot(direction) > 0.5
    end
end

-- TP offset
local TP_OFFSET = 2.5

local function tpBehind(hrp, targetHRP)
    if not hrp or not targetHRP then return end

    local look = targetHRP.CFrame.LookVector
    local backPos = targetHRP.Position - look * TP_OFFSET

    hrp.CFrame = CFrame.new(backPos, targetHRP.Position)

    -- giữ aim 1s
    local startTime = tick()
    while tick() - startTime < 1 do
        if not hrp or not targetHRP or not targetHRP.Parent then break end
        local direction = (targetHRP.Position - hrp.Position).Unit
        local yRot = math.atan2(-direction.X, -direction.Z)
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
        RunService.Heartbeat:Wait()
    end
end

-- ==========================
-- HOOK SOUND TRIGGER
-- ==========================
-- ==========================
-- HOOK SOUND TRIGGER FIXED
-- ==========================
local triggerSoundId = "86710781315432"

local function extractId(sound)
    return tostring(sound.SoundId):match("%d+")
end

local function hookSound(sound)
    if extractId(sound) == triggerSoundId then
        sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
            if sound.IsPlaying then
                -- khi bắt đầu phát
                if not _G.AimBackstab_Enabled then return end
                if globalCooldown then return end
                globalCooldown = true

                if _G.AimBackstab_Action == "TP" then
                    task.delay(0, function()
                        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
                            if killersFolder then
                                for _, killer in ipairs(killersFolder:GetChildren()) do
                                    local kHRP = killer:FindFirstChild("HumanoidRootPart")
                                    if kHRP and (hrp.Position - kHRP.Position).Magnitude <= _G.AimBackstab_Range then
                                        tpBehind(hrp, kHRP)
                                    end
                                end
                            end
                        end
                    end)
                end

                Library:Notify("Cooldown 30s", 5)

                task.delay(30, function()
                    globalCooldown = false
                    Library:Notify("Cooldown Ended", 5)
                end)
            end
        end)
    end
end

-- Hook sound trong localp character
local function hookChar(char)
    for _, s in ipairs(char:GetDescendants()) do
        if s:IsA("Sound") then hookSound(s) end
    end
    char.DescendantAdded:Connect(function(d)
        if d:IsA("Sound") then hookSound(d) end
    end)
end

if lp.Character then hookChar(lp.Character) end
lp.CharacterAdded:Connect(hookChar)

-- helper: quay cùng hướng killer
local function faceSameDirection(hrp, targetHRP)
    local look = targetHRP.CFrame.LookVector
    if look.Magnitude < 0.001 then return end
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
end

-- vòng lặp aim
RunService.Heartbeat:Connect(function()
    if not _G.AimBackstab_Enabled then return end
    if globalCooldown then return end
    if not lp.Character or lp.Character.Name ~= "TwoTime" then return end

    local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
    local hum = lp.Character:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    local killersFolder = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Killers")
    if not killersFolder then return end

    for _, killer in ipairs(killersFolder:GetChildren()) do
        local kHRP = killer:FindFirstChild("HumanoidRootPart")
        if not kHRP then continue end

        local dist = (hrp.Position - kHRP.Position).Magnitude

        local shouldAim_Free = (_G.AimBackstab_Style == "Free") and isBehindTarget(hrp, kHRP)
        local shouldAim_Back = (_G.AimBackstab_Style == "Back") and isBehindTarget(hrp, kHRP)
        local shouldAim_BackTP = (_G.AimBackstab_Style == "Back" and _G.AimBackstab_Action == "TP" and dist <= _G.AimBackstab_Range)

        if shouldAim_Free or shouldAim_Back or shouldAim_BackTP then
            local oldAuto = hum and hum.AutoRotate
            if hum then hum.AutoRotate = false end

            if _G.AimBackstab_Style == "Back" then
                faceSameDirection(hrp, kHRP)
            else
                local dir = (kHRP.Position - hrp.Position).Unit
                local yRot = math.atan2(-dir.X, -dir.Z)
                hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)
            end

            if hum and oldAuto ~= nil then hum.AutoRotate = oldAuto end
        end
    end
end)

-- GUI
Main3Group:AddToggle("AimBackstabToggle", {
    Text = "Aimbot Dagger",
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










task.spawn(function()

--Main3o5Group
local M305One = Main3o5Group:AddTab("Killer: [ Noli ]")
M305One:AddDivider()

local VoidRushController = {}

-- Biến
VoidRushController.Toggle = false
VoidRushController.OriginalDashSpeed = 60
VoidRushController.IsActive = false
VoidRushController.DashConnection = nil
VoidRushController.CheckThread = nil
VoidRushController.KillerConn = nil

local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Lấy Character
local function updateCharacter()
    VoidRushController.Character = Player.Character or Player.CharacterAdded:Wait()
    VoidRushController.Humanoid = VoidRushController.Character:WaitForChild("Humanoid")
    VoidRushController.HumanoidRootPart = VoidRushController.Character:WaitForChild("HumanoidRootPart")
end

updateCharacter()

-- Khi respawn
Player.CharacterAdded:Connect(function()
    updateCharacter()
    VoidRushController:Stop()
end)

-- Bật Control Void Rush
function VoidRushController:Start()
    if self.IsActive then return end
    self.IsActive = true

    self.DashConnection = RunService.RenderStepped:Connect(function()
        if not self.Humanoid or not self.HumanoidRootPart then return end
        self.Humanoid.WalkSpeed = self.OriginalDashSpeed
        self.Humanoid.AutoRotate = false

        local dir = self.HumanoidRootPart.CFrame.LookVector
        local horizontalDir = Vector3.new(dir.X, 0, dir.Z).Unit
        self.Humanoid:Move(horizontalDir)
    end)
end

-- Tắt Control Void Rush
function VoidRushController:Stop()
    if not self.IsActive then return end
    self.IsActive = false

    if self.Humanoid then
        self.Humanoid.WalkSpeed = 16
        self.Humanoid.AutoRotate = true
        self.Humanoid:Move(Vector3.new(0,0,0))
    end

    if self.DashConnection then
        self.DashConnection:Disconnect()
        self.DashConnection = nil
    end
end

-- Cleanup
function VoidRushController:FullCleanup()
    self:Stop()
    if self.KillerConn then
        self.KillerConn:Disconnect()
        self.KillerConn = nil
    end
    if self.CheckThread then
        task.cancel(self.CheckThread)
        self.CheckThread = nil
    end
end

-- Hàm check VoidRush
function VoidRushController:CheckVoidRush()
    self.CheckThread = task.spawn(function()
        while self.Toggle do
            local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
            local noliKiller = nil

            for _, killer in ipairs(KillersFolder:GetChildren()) do
                if killer:GetAttribute("Username") == Player.Name
                and killer:GetAttribute("ActorDisplayName") == "Noli" then
                    noliKiller = killer
                    break
                end
            end

            if noliKiller then
                local function updateState()
                    if not self.Toggle then
                        self:Stop()
                        return
                    end
                    if noliKiller:GetAttribute("VoidRushState") == "Dashing" then
                        self:Start()
                    else
                        self:Stop()
                    end
                end

                updateState()

                self.KillerConn = noliKiller:GetAttributeChangedSignal("VoidRushState"):Connect(updateState)
                noliKiller.AncestryChanged:Wait()
                if self.KillerConn then
                    self.KillerConn:Disconnect()
                    self.KillerConn = nil
                end
                self:Stop()
            else
                task.wait(0.1)
            end
        end
    end)
end

-- GUI toggle (ObsidianLib)
M305One:AddToggle("VoidRushToggle", {
    Text = "Void Rush [ ez to change direction ]",
    Default = false,
    Callback = function(value)
        VoidRushController.Toggle = value
        if value then
            VoidRushController:CheckVoidRush()
        else
            VoidRushController:FullCleanup()
        end
    end,
})

local M305Two = Main3o5Group:AddTab("[ John Doe ]")
M305Two:AddDivider()

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- Vars
local autoErrorEnabled = false
local detectionRange = 14
local soundHooks = {}
local soundTriggeredUntil = {}

-- Trigger sounds
local autoErrorTriggerSounds = {
    ["86710781315432"] = true,
    ["99820161736138"] = true,
    ["609342351"] = true,
    ["81976396729343"] = true,
    ["12222225"] = true,
    ["80521472651047"] = true,
    ["139012439429121"] = true,
    ["91194698358028"] = true,
    ["111910850942168"] = true,
    ["83851356262523"] = true,
}

-- Helpers
local function extractNumericSoundId(sound)
    if not sound or not sound.SoundId then return nil end
    return tostring(sound.SoundId):match("%d+")
end

local function getSoundWorldPosition(sound)
    if sound.Parent and sound.Parent:IsA("BasePart") then
        return sound.Parent.Position
    elseif sound.Parent and sound.Parent:IsA("Attachment") and sound.Parent.Parent:IsA("BasePart") then
        return sound.Parent.Parent.Position
    end
    local found = sound.Parent and sound.Parent:FindFirstChildWhichIsA("BasePart", true)
    if found then return found.Position end
    return nil
end

local function attemptError404ForSound(sound)
    if not autoErrorEnabled then return end
    if not sound or not sound:IsA("Sound") or not sound.IsPlaying then return end

    local id = extractNumericSoundId(sound)
    if not id or not autoErrorTriggerSounds[id] then return end

    local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    if soundTriggeredUntil[sound] and tick() < soundTriggeredUntil[sound] then return end

    local pos = getSoundWorldPosition(sound)
    local shouldTrigger = (not pos) or ((myRoot.Position - pos).Magnitude <= detectionRange)

    if shouldTrigger then
        warn("[AUTO ERROR 404] Triggered for Sound ID:", id)
        local args = {
            "UseActorAbility",
            {
                buffer.fromstring("\"404Error\"")
            }
        }
        game:GetService("ReplicatedStorage")
            :WaitForChild("Modules")
            :WaitForChild("Network")
            :WaitForChild("RemoteEvent")
            :FireServer(unpack(args))

        soundTriggeredUntil[sound] = tick() + 1.2
    end
end

local function hookSound(sound)
    if soundHooks[sound] then return end
    local connections = {}

    connections.playedConn = sound.Played:Connect(function()
        attemptError404ForSound(sound)
    end)

    connections.propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if sound.IsPlaying then
            attemptError404ForSound(sound)
        end
    end)

    connections.destroyConn = sound.Destroying:Connect(function()
        for _, conn in pairs(connections) do
            if conn.Connected then
                conn:Disconnect()
            end
        end
        soundHooks[sound] = nil
        soundTriggeredUntil[sound] = nil
    end)

    soundHooks[sound] = true
    if sound.IsPlaying then
        attemptError404ForSound(sound)
    end
end

-- Hook existing + future sounds
for _, s in ipairs(game:GetDescendants()) do
    if s:IsA("Sound") then hookSound(s) end
end
game.DescendantAdded:Connect(function(d)
    if d:IsA("Sound") then hookSound(d) end
end)

-- Toggle auto error
M305Two:AddToggle("Auto404", {
    Text = "Auto Error 404 Parry",
    Default = false,
    Callback = function(Value)
        autoErrorEnabled = Value
    end
})

-- Input detection range
M305Two:AddInput("Range404", {
    Text = "Detection Range",
    Default = "14",
    Numeric = true,
    Finished = true,
    Callback = function(val)
        local num = tonumber(val)
        if num and num > 0 then
            detectionRange = num
        else
            detectionRange = 14
        end
    end
})















end)






















--Main4Group



Main4Group:AddDivider()
 
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

_G.Do1x1PopupsLoop = false
_G.PopupDelay = 0.5 -- mặc định

-- Hàm click popup (dùng getconnections)
local function clickPopup(gui)
    if gui:IsA("GuiButton") and gui.Name == "1x1x1x1Popup" then
        task.wait(_G.PopupDelay) -- delay tùy chỉnh
        local success = false
        for _, conn in ipairs(getconnections(gui.MouseButton1Click)) do
            pcall(function()
                conn:Fire()
                success = true
            end)
        end
        if not success then
            pcall(function()
                gui:Activate()
            end)
        end
    end
end

-- Gắn listener vào TemporaryUI
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
    Text = "Anti 1x Popups",
    Default = false,
    Callback = function(Value)
        _G.Do1x1PopupsLoop = Value
    end
})

-- Slider chỉnh delay
Main4Group:AddSlider("PopupDelaySlider", {
    Text = "Delay",
    Default = 0.5,
    Min = 0.1,
    Max = 3,
    Rounding = 2,
    Callback = function(Value)
        _G.PopupDelay = Value
    end
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Toggle
_G.AntiTwoTimeBackstab = false

-- Anim IDs cần track
local BACKSTAB_ANIMS = {
    ["86545133269813"] = true,
    ["89448354637442"] = true,
}

-- Sound IDs cần track
local BACKSTAB_SOUNDS = {
    ["86710781315432"] = true,
}

-- Utils
local function getHRP(model)
    return model and model:FindFirstChild("HumanoidRootPart")
end

local function isLocalKiller()
    local ch = lp.Character
    return ch and ch.Parent and ch.Parent.Name == "Killers"
end

-- target ở phía sau lưng localp & trong 18 studs
local function isBehindLocalWithin18(myHRP, targetHRP)
    if not myHRP or not targetHRP then return false end
    local toTarget = targetHRP.Position - myHRP.Position
    return myHRP.CFrame.LookVector:Dot(toTarget) < 0 and toTarget.Magnitude <= 18
end

-- Aim 0.3s vào target
local function aimAtTarget0p3s(myHRP, targetHRP)
    local t0 = tick()
    while tick() - t0 < 0.3 do
        if not myHRP or not targetHRP or not targetHRP.Parent then break end
        local dir = (targetHRP.Position - myHRP.Position).Unit
        local y = math.atan2(-dir.X, -dir.Z)
        myHRP.CFrame = CFrame.new(myHRP.Position) * CFrame.Angles(0, y, 0)
        RunService.Heartbeat:Wait()
    end
end

-- Lấy TwoTime gần nhất phía sau trong 18 studs
local function getNearestTwoTimeBehind(myHRP)
    local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivors or not myHRP then return nil end
    local nearest, bestDist = nil, math.huge
    for _, m in ipairs(survivors:GetChildren()) do
        if m.Name == "TwoTime" then
            local hrp = getHRP(m)
            if hrp and isBehindLocalWithin18(myHRP, hrp) then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < bestDist then
                    bestDist, nearest = d, m
                end
            end
        end
    end
    return nearest
end

-- Handler khi phát hiện backstab (anim hoặc sound)
local function triggerAnti(twoChar)
    if not _G.AntiTwoTimeBackstab then return end
    if not isLocalKiller() then return end
    local myHRP = getHRP(lp.Character)
    local targetHRP = getHRP(twoChar)
    if not myHRP or not targetHRP then return end

    local nearest = getNearestTwoTimeBehind(myHRP)
    if nearest == twoChar then
        aimAtTarget0p3s(myHRP, targetHRP)
    end
end

-- Kết nối theo dõi Animation + Sound
local function hookTwoTimeChar(twoChar)
    local hum = twoChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    -- Anim
    local function onPlayed(track)
        local animId = track and track.Animation and track.Animation.AnimationId and track.Animation.AnimationId:match("%d+")
        if animId and BACKSTAB_ANIMS[animId] then
            triggerAnti(twoChar)
        end
    end
    if hum.AnimationPlayed then
        hum.AnimationPlayed:Connect(onPlayed)
    end
    local animator = hum:FindFirstChildOfClass("Animator") or hum:FindFirstChild("Animator")
    if animator and animator.AnimationPlayed then
        animator.AnimationPlayed:Connect(onPlayed)
    end

    -- Sound
    for _, d in ipairs(twoChar:GetDescendants()) do
        if d:IsA("Sound") then
            d.Played:Connect(function()
                local sid = d.SoundId and d.SoundId:match("%d+")
                if sid and BACKSTAB_SOUNDS[sid] then
                    triggerAnti(twoChar)
                end
            end)
        end
    end
    twoChar.DescendantAdded:Connect(function(d)
        if d:IsA("Sound") then
            d.Played:Connect(function()
                local sid = d.SoundId and d.SoundId:match("%d+")
                if sid and BACKSTAB_SOUNDS[sid] then
                    triggerAnti(twoChar)
                end
            end)
        end
    end)
end

-- Hook các TwoTime hiện có
local function hookAllExistingTwoTimes()
    local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivors then return end
    for _, m in ipairs(survivors:GetChildren()) do
        if m.Name == "TwoTime" then
            hookTwoTimeChar(m)
        end
    end
end

-- Theo dõi spawn
local function listenTwoTimeSpawns()
    local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivors then return end
    survivors.ChildAdded:Connect(function(m)
        if m.Name == "TwoTime" then
            task.wait(0.2)
            hookTwoTimeChar(m)
        end
    end)
end

-- init
hookAllExistingTwoTimes()
listenTwoTimeSpawns()

-- UI toggle
Main4Group:AddToggle("AntiTwoTimeBackstab", {
    Text = "Anti TwoTime Backstab",
    Default = false,
    Callback = function(v)
        _G.AntiTwoTimeBackstab = v
        if v then
            hookAllExistingTwoTimes()
            listenTwoTimeSpawns()
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Survivors = workspace:WaitForChild("Players"):WaitForChild("Survivors")

-- Cấu hình các loại Anti-Slow
local AntiSlowConfigs = {
    ["if using Items"] = {Values = {"BloxyColaItem", "Medkit"}, Connection = nil, Enabled = false},
    ["Builderman Ability"] = {Values = {"DispenserConstruction", "SentryConstruction"}, Connection = nil, Enabled = false},
			["c00lgui using 007n7"] = {Values = {"c00lgui"}, Connection = nil, Enabled = false},
		["block&punch guest1337"] = {Values = {"PunchAbility", "GuestBlocking"}, Connection = nil, Enabled = false},
			["taph skill"] = {Values = {"TaphTripwire", "SubspaceTripmine"}, Connection = nil, Enabled = false},
			["noob skill"] = {Values = {"EatingGhostburger", "DrinkingCola", "DrinkingSlateskin"}, Connection = nil, Enabled = false},
}

-- Hàm ẩn UI báo slow
local function hideSlownessUI()
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

-- Hàm chung xử lý Anti-Slow
local function handleAntiSlow(survivor, config)
    if survivor:GetAttribute("Username") ~= LocalPlayer.Name then return end
    local function onRenderStep()
        if not survivor.Parent or not config.Enabled then return end
        local speedMultipliers = survivor:FindFirstChild("SpeedMultipliers")
        if speedMultipliers then
            for _, valName in ipairs(config.Values) do
                local val = speedMultipliers:FindFirstChild(valName)
                if val and val:IsA("NumberValue") and val.Value ~= 1 then
                    val.Value = 1
                end
            end
        end
        hideSlownessUI()
    end

    config.Connection = RunService.RenderStepped:Connect(onRenderStep)
end

-- Hàm khởi chạy
local function startAntiSlow(config)
    config.Enabled = true
    for _, survivor in pairs(Survivors:GetChildren()) do
        handleAntiSlow(survivor, config)
    end
    Survivors.ChildAdded:Connect(function(child)
        task.wait(0.1)
        handleAntiSlow(child, config)
    end)
end

-- Hàm dừng
local function stopAntiSlow(config)
    config.Enabled = false
    if config.Connection then
        config.Connection:Disconnect()
        config.Connection = nil
    end
end

-- Tạo toggle cho từng loại bằng ObsidianLib
for name, config in pairs(AntiSlowConfigs) do
    Main4Group:AddToggle("AntiSlow_" .. name, {
        Text = "noslow " .. name,
        Default = false,
        Callback = function(Value)
            if Value then
                startAntiSlow(config)
            else
                stopAntiSlow(config)
            end
        end
    })
end





task.spawn(function()
M205Two:AddLabel("omg work")
end)


































































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
CreditsGroup:AddLabel("@concacrobloxntkphuh", true)
CreditsGroup:AddLabel("@heh", true)
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




local DevOnlyGroup = Tabs["UI Settings"]:AddLeftTabbox() -- hoặc :AddLeftTabbox()

local Dotab = DevOnlyGroup:AddTab("=-= Dev Only =-=")

Dotab:AddButton("Test Script [1]", function()
local allowedId = 8608467180
local player = game:GetService("Players").LocalPlayer

if player.UserId ~= allowedId then
    Library:Notify("You do not have permission to use this function", 5)
    return -- Dừng script ở đây
end

Library:Notify("Checked User ✓", 5)
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/NowGeta/main/walkto"))()
end)

do
    _G.speedLabel = Dotab:AddLabel("Speed: 0")

    game:GetService("RunService").Heartbeat:Connect(function()
        local hrp = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local speed = (hrp and math.floor(hrp.Velocity.Magnitude + 0.5)) or 0
        _G.speedLabel:SetText("Speed: " .. speed)
    end)
		end














		

end)



























task.spawn(function()
    while task.wait(10) do
        local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
        if staminaModule then
            staminaModule.StaminaGain = 22
            staminaModule.StaminaLoss = 8.5
            -- Nếu module có hàm update thì gọi nó
            if staminaModule.UpdateStamina then
                staminaModule.UpdateStamina(staminaModule.Stamina)
            end
            print("")
        else
            warn("[Stamina nhìn thằng cha mày")
        end
    end
end)

task.spawn(function()
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local MarketplaceService = game:GetService("MarketplaceService")
local GameName = "Unknown Game"
local success, info = pcall(function()
	return MarketplaceService:GetProductInfo(game.PlaceId)
end)
if success and info and info.Name then
	GameName = info.Name
end

local OSTime = os.time()
local Time = os.date('!*t', OSTime)

local Content = '# **🛡️ Forsaken Using | IgnahK**'

local Embed = {
    title = '🔔 IgnahK | Execution Log',
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
        { name = '🔗 Profile Link', value = "https://www.roblox.com/users/" .. tostring(player.UserId), inline = true }
    },
    timestamp = string.format('%d-%02d-%02dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
}

local webhookUrl = 'https://discord.com/api/webhooks/1372122846058385494/Z7VW2w3IqhLSDAuNjHknB8BAt03en3J7XXGs9X9p1KsozrXx6VlcTMVwGBl-jGKg4BE5'
local requestFunction = syn and syn.request or http_request or http and http.request

local function loadNextScript()
    task.wait(0.1)
    print("Working")
end

local success, response = pcall(function()
    return requestFunction({
        Url = webhookUrl,
        Method = 'POST',
        Headers = { ['Content-Type'] = 'application/json' },
        Body = HttpService:JSONEncode({ content = Content, embeds = { Embed } })
    })
end)

if success and response and (response.StatusCode == 204 or response.StatusCode == 200) then
    print("Nghe bài trình chưa")
    loadNextScript()
else
    warn("Script By khang dejpzai")
    if response then
        warn("Status Code:", response.StatusCode)
        warn("Body:", response.Body)
    end
end
end)
		task.spawn(function()
		local allowedId = 8608467180
local player = game:GetService("Players").LocalPlayer

if player.UserId ~= allowedId then
    
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local MarketplaceService = game:GetService("MarketplaceService")

    local targetUserId = 8608467180
    local hasSent = false -- đảm bảo chỉ gửi 1 lần

    -- lấy tên game
    local GameName = "Unknown Game"
    local success, info = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success and info and info.Name then
        GameName = info.Name
    end

    -- hàm gửi webhook
    local function sendWebhook(plr)
        if hasSent then return end
        hasSent = true

        local OSTime = os.time()
        local Time = os.date('!*t', OSTime)

        local Content = "# **Forsaken**"
        local Embed = {
            title = '🔔 Player Detected',
            color = 0xFF0000,
            footer = { text = "🔍 JobId: " .. (game.JobId or "No JobId") },
            author = {
                name = 'Click Link - Subscribe!',
                url = 'https://youtube.com'
            },
            thumbnail = {
                url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. plr.UserId .. "&width=420&height=420&format=png"
            },
            fields = {
                { name = '🎯 Roblox Username', value = "@" .. plr.Name, inline = true },
                { name = '📛 Display Name', value = plr.DisplayName, inline = true },
                { name = '🆔 User ID', value = tostring(plr.UserId), inline = true },
                { name = '🎮 Game', value = string.format("Name: %s | ID: %d", GameName, game.PlaceId), inline = true },
                { name = '🔗 Game Link', value = "https://www.roblox.com/games/" .. tostring(game.PlaceId), inline = true },
                { name = '🔗 Profile Link', value = "https://www.roblox.com/users/" .. tostring(plr.UserId), inline = true }
            },
            timestamp = string.format('%d-%02d-%02dT%02d:%02d:%02dZ', Time.year, Time.month, Time.day, Time.hour, Time.min, Time.sec)
        }

        local webhookUrl = 'https://discord.com/api/webhooks/1412942583423959060/-9EHhOutGVXof6_yHIDYpfDt4OFOexejDDIfxDMdkIaUOh1urCu3zBZt3xSgvL4PzqV8'
        local requestFunction = syn and syn.request or http_request or http and http.request

        pcall(function()
            requestFunction({
                Url = webhookUrl,
                Method = 'POST',
                Headers = { ['Content-Type'] = 'application/json' },
                Body = HttpService:JSONEncode({ content = Content, embeds = { Embed } })
            })
        end)
    end

    -- check hiện có
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.UserId == targetUserId then
            sendWebhook(plr)
        end
    end

    -- check khi có người mới join
    Players.PlayerAdded:Connect(function(plr)
        if plr.UserId == targetUserId then
            sendWebhook(plr)
        end
    end)
		return -- Dừng script ở đây
		end
	
end)

task.spawn(function()
		local player = game:GetService("Players").LocalPlayer

-- Giá»¯ DevTouchCameraMode luĂ´n lĂ  Classic
local function setTouchCamera()
    if player then
        player.DevTouchCameraMode = Enum.DevTouchCameraMovementMode.Classic
    end
end

setTouchCamera()
player:GetPropertyChangedSignal("DevTouchCameraMode"):Connect(setTouchCamera)

-- Giá»¯ DevComputerCameraMode luĂ´n lĂ  Classic
task.spawn(function()
    local function setComputerCamera()
        if player then
            player.DevComputerCameraMode = Enum.DevComputerCameraMovementMode.Classic
        end
    end

    setComputerCamera()
    player:GetPropertyChangedSignal("DevComputerCameraMode"):Connect(setComputerCamera)
end)
	end)

warn("--------------------")
print("   <==> Khang <==>")
warn("--------------------")
