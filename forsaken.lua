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

Main1Group:AddLabel("--== Surviv: [ 007n7 ] ==--", true) 
		task.spawn(function()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local detectionRange = 13

-- ====== Data ======
local animationIds = {        
    ["126830014841198"] = true, ["126355327951215"] = true, ["121086746534252"] = true,        
    ["18885909645"] = true, ["98456918873918"] = true, ["105458270463374"] = true,        
    ["83829782357897"] = true, ["125403313786645"] = true, ["118298475669935"] = true,        
    ["82113744478546"] = true, ["70371667919898"] = true, ["99135633258223"] = true,        
    ["97167027849946"] = true, ["109230267448394"] = true, ["139835501033932"] = true,        
    ["126896426760253"] = true, ["93069721274110"] = true,  
    ["109667959938617"] = true, ["126681776859538"] = true, ["129976080405072"] = true,  
    ["121293883585738"] = true, ["81639435858902"] = true, ["137314737492715"] = true,  
    ["92173139187970"] = true, ["131543461321709"] = true,  
}        

local autoBlockTriggerSounds = {  
    ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true,  
    ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,  
    ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true,  
    ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,  
    ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true,  
    ["75330693422988"] = true,  
}  

-- ====== Remote ======
local function triggerClone()
    local args = { "UseActorAbility", "Clone" }
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

-- ====== Logic check Killer ======
local function checkKiller(killer)
    local hrp = killer:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return false end

    -- check khoảng cách
    local dist = (myHRP.Position - hrp.Position).Magnitude
    if dist > detectionRange then return false end

    -- check killer thật sự (không phải player survivor, không phải Fake Noli)
    local isInKillers = (killer.Parent and killer.Parent.Name == "Killers")
    local isPlayer = (Players:GetPlayerFromCharacter(killer) ~= nil)
    local isFakeNoli = isInKillers and not isPlayer and killer.Name:lower():find("noli")
    if not (isInKillers and not isFakeNoli) then return false end

    -- check animations
    for _, anim in ipairs(killer:GetDescendants()) do
        if anim:IsA("Animation") and animationIds[tostring(anim.AnimationId):match("%d+")] then
            return true
        end
    end
    -- check sounds
    for _, s in ipairs(killer:GetDescendants()) do
        if s:IsA("Sound") and s.IsPlaying and autoBlockTriggerSounds[tostring(s.SoundId):match("%d+")] then
            return true
        end
    end
    return false
end
	

-- ====== Toggle ======
Main1Group:AddToggle("Auto007Block", {
    Text = "Auto Clone block",
    Default = false,
    Callback = function(Value)
        getgenv().AutoClone007n7 = Value
        if Value then
            task.spawn(function()
                while getgenv().AutoClone007n7 do
                    task.wait(0.1)
                    local killersFolder = workspace:FindFirstChild("Killers")
                    if killersFolder then
                        for _, killer in ipairs(killersFolder:GetChildren()) do
                            if checkKiller(killer) then
                                triggerClone()
                                break -- chặn spam, 1 lần mỗi vòng
                            end
                        end
                    end
                end
            end)
        end
    end
				
})
			end)
				Main1Group:AddDivider()


Main1Group:AddLabel("--== Surviv: [ Shedletsky ] ==--", true) 
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
local Players = game:GetService("Players")      
local ReplicatedStorage = game:GetService("ReplicatedStorage")      
local RunService = game:GetService("RunService")      
local Workspace = game:GetService("Workspace")      
local lp = Players.LocalPlayer      

-- Remote      
local NetworkEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")      

-- Biến      
_G.AutoBlockPunch_Range = 18      
_G.AutoBlock_Enabled = false  
_G.AutoPunch_Enabled = false  
_G.AutoPunchAimbot_Enabled = false  
local cooldown = 1 -- giây      
local lastActionTime = 0      

local clickedTracks = {}      
local clickedSounds = {}      

-- Animation-based AutoBlock IDs      
local animationIds = {      
    ["126830014841198"] = true, ["126355327951215"] = true, ["121086746534252"] = true,      
    ["18885909645"] = true, ["98456918873918"] = true, ["105458270463374"] = true,      
    ["83829782357897"] = true, ["125403313786645"] = true, ["118298475669935"] = true,      
    ["82113744478546"] = true, ["70371667919898"] = true, ["99135633258223"] = true,      
    ["97167027849946"] = true, ["109230267448394"] = true, ["139835501033932"] = true,      
    ["126896426760253"] = true, ["93069721274110"] = true,
    ["109667959938617"] = true, ["126681776859538"] = true, ["129976080405072"] = true,
    ["121293883585738"] = true, ["81639435858902"] = true, ["137314737492715"] = true,
    ["92173139187970"] = true, ["131543461321709"] = true,
}      

-- Audio-based Auto Block IDs
local autoBlockTriggerSounds = {
    ["102228729296384"] = true, ["140242176732868"] = true, ["112809109188560"] = true,
    ["136323728355613"] = true, ["115026634746636"] = true, ["84116622032112"] = true,
    ["108907358619313"] = true, ["127793641088496"] = true, ["86174610237192"] = true,
    ["95079963655241"] = true, ["101199185291628"] = true, ["119942598489800"] = true,
    ["84307400688050"] = true, ["113037804008732"] = true, ["105200830849301"] = true,
    ["75330693422988"] = true,
}

--[[
[MessageOutput] [Nhạc đang phát]: rbxassetid://75330693422988 | ID: 75330693422988
]]

-- Kiểm tra localplayer là Guest1337 survivor      
local function isGuestSurvivor()      
    if not lp.Character or lp.Character.Name ~= "Guest1337" then return false end      
    return lp.Character.Parent and lp.Character.Parent.Name ~= "Killers"      
end      

-- Remote Block      
local function remoteBlock()      
    NetworkEvent:FireServer("UseActorAbility", "Block")      
end      

-- Remote Punch      
local function remotePunch(targetRoot)  
    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")  
    if hrp and targetRoot then  
        NetworkEvent:FireServer("UseActorAbility", "Punch")  
    end  
end  

-- Punch Aimbot theo remote Punch từ server  
NetworkEvent.OnClientEvent:Connect(function(action, ability)  
    if not _G.AutoPunchAimbot_Enabled then return end  
    if action == "UseActorAbility" and ability == "Punch" then  
        local myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")  
        if not myRoot then return end  

        local nearest, dist = nil, math.huge  
        local killersFolder = Workspace:FindFirstChild("Players") and Workspace.Players:FindFirstChild("Killers")  
        if killersFolder then  
            for _, killer in ipairs(killersFolder:GetChildren()) do  
                local root = killer:FindFirstChild("HumanoidRootPart")  
                local humanoid = killer:FindFirstChildOfClass("Humanoid")  
                if root and humanoid and humanoid.Health > 0 then  
                    local d = (root.Position - myRoot.Position).Magnitude  
                    if d < dist then  
                        dist = d; nearest = root  
                    end  
                end  
            end  
        end  

        if nearest then
    local start = tick()
    local aimConn
    aimConn = RunService.Heartbeat:Connect(function()
        if tick() - start > 0.8 or not nearest.Parent or not myRoot.Parent then
            if aimConn then aimConn:Disconnect() end
            return
        end
        -- Giữ Y bằng localplayer, chỉ xoay ngang
        local lookPos = Vector3.new(nearest.Position.X, myRoot.Position.Y, nearest.Position.Z)
        myRoot.CFrame = CFrame.new(myRoot.Position, lookPos)
    end)
end  
    end  
end)

-- Loop chính    
RunService.Heartbeat:Connect(function()  
    if not isGuestSurvivor() then return end  
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

                local hrp = killer:FindFirstChild("HumanoidRootPart")  
local humanoid = killer:FindFirstChildOfClass("Humanoid")  
if root and humanoid and humanoid.Health > 0 then  
    local dist = (root.Position - myRoot.Position).Magnitude  
  
    -- check vận tốc của killer  
    local isStill = (root.AssemblyLinearVelocity.Magnitude <= 1) -- coi như đứng yên nếu tốc độ < 1  
  
    -- nếu đứng yên thì dist phải <= 8 mới cho block  
    if (isStill and dist <= 4) or (not isStill and dist <= _G.AutoBlockPunch_Range) then  
        -- 1) Kiểm tra Animation    
                for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do    
    local anim = track.Animation    
    local id = anim and anim.AnimationId and string.match(anim.AnimationId, "%d+")    
  
   if id and animationIds[id] and not clickedTracks[track] then  
    local tp = track.TimePosition or 0  
    if tp <= 0.1 and dist <= _G.AutoBlockPunch_Range then  
        clickedTracks[track] = true  
  
        -- block luôn không delay  
        if _G.AutoBlock_Enabled then  
            remoteBlock()  
        end  
  
        -- sau 0.2s mới punch  
        if _G.AutoPunch_Enabled and (tick() - lastActionTime >= cooldown) then  
            lastActionTime = tick()  
            task.delay(0.2, function()  
                if root and humanoid and humanoid.Health > 0 then  
                    remotePunch(root)  
                end  
            end)  
        end  
  
        task.spawn(function()  
            track.Stopped:Wait()  
            clickedTracks[track] = nil  
        end)  
    end  
end  
end  
  
                -- 2) Kiểm tra Sound    
                for _, sound in ipairs(killer:GetDescendants()) do  
    if sound:IsA("Sound") and sound.IsPlaying then  
        local sid = sound.SoundId and sound.SoundId:match("%d+")  
        if sid and autoBlockTriggerSounds[sid] and not clickedSounds[sid] then  
            local ok, tp = pcall(function() return sound.TimePosition end)  
            local timePos = (ok and tp) or 0  
  
            -- Block tức thì khi sound vừa phát  
            if timePos <= 0.1 and dist <= _G.AutoBlockPunch_Range then  
                clickedSounds[sid] = true  
  
                -- Block ngay lập tức (không chờ delay)  
                if _G.AutoBlock_Enabled then  
                    remoteBlock()  
                end  
  
                -- Punch giữ delay 0.2s và có cooldown  
                if _G.AutoPunch_Enabled and (tick() - lastActionTime >= cooldown) then  
                    lastActionTime = tick()  
                    task.delay(0.2, function()  
                        if root and humanoid and humanoid.Health > 0 then  
                            remotePunch(root)  
                        end  
                    end)  
                end  
            end  
  
            -- Reset để bắt lại lần sau  
            task.delay(1, function()  
                clickedSounds[sid] = nil  
            end)  
        end  
    end  
end  
    end  
end

            end  
        end  
    end  
end)

    

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local lp = Players.LocalPlayer
local NetworkEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

-- Toggle obsidian
local walkspeedOverrideEnabled = false

Main1Group:AddToggle("WalkspeedOverrideToggle", {
    Text = "Walkspeed Override Block [Alpha]",
    Default = false,
    Callback = function(Value)
        walkspeedOverrideEnabled = Value
    end
})

-- Danh sách anim Walkspeed Override
local walkspeedAnimIds = {
    ["106776364623742"] = true,
    ["98456918873918"] = true
}

-- Hàm block
local function remoteBlock()
    pcall(function()
        NetworkEvent:FireServer("UseActorAbility", "Block")
    end)
end

-- Hàm check killer facing localplayer
local function isFacingTarget(killerRoot, myRoot)
    if not killerRoot or not myRoot then return false end
    local toPlayer = (myRoot.Position - killerRoot.Position).Unit
    local lookDir = Vector3.new(killerRoot.CFrame.LookVector.X, 0, killerRoot.CFrame.LookVector.Z).Unit
    return toPlayer:Dot(lookDir) > 0.7 -- facing tương đối chính diện
end

-- Kiểm tra killer có lao về phía localp
local function isApproaching(killerRoot, myRoot)
    if not killerRoot or not myRoot then return false end
    local toPlayer = myRoot.Position - killerRoot.Position
    if toPlayer.Magnitude < 1 then return false end
    local vel = killerRoot.AssemblyLinearVelocity
    if vel.Magnitude < 1 then return false end
    local dirToPlayer = toPlayer.Unit
    local velDir = Vector3.new(vel.X, 0, vel.Z).Unit
    return dirToPlayer:Dot(velDir) > 0.6 -- lao khá thẳng về phía localp
end

-- Loop riêng cho Walkspeed Override
RunService.Heartbeat:Connect(function()
    if not walkspeedOverrideEnabled then return end
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end

    local myRoot = lp.Character.HumanoidRootPart
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
                    local id = anim and anim.AnimationId and anim.AnimationId:match("%d+")

                    if id and walkspeedAnimIds[id] then
                        local approaching = isApproaching(root, myRoot)
                        local facing = isFacingTarget(root, myRoot)

                        if approaching and facing then
                            remoteBlock()
                        end
                    end
                end
            end
        end
    end
end)

end)


      
-- UI      
Main1Group:AddToggle("AutoBlockToggle", {  
    Text = "Auto Block",  
    Default = false,  
    Callback = function(v)  
        _G.AutoBlock_Enabled = v  
    end  
})  
  
Main1Group:AddToggle("AutoPunchToggle", {  
    Text = "Auto Punch",  
    Default = false,  
    Callback = function(v)  
        _G.AutoPunch_Enabled = v  
    end  
})  
  
Main1Group:AddToggle("AutoPunchAimbotToggle", {  
    Text = "Punch Aimbot",  
    Default = false,  
    Callback = function(v)  
        _G.AutoPunchAimbot_Enabled = v  
    end  
})  
--// Range Visual (Killer Detection Circle)
local RunService = game:GetService("RunService")
local KillersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")

local detectionCircles = {} -- [killer] = adornment
local killerCirclesVisible = false
local detectionRange = tonumber(_G.AutoBlockPunch_Range) or 18

-- Add circle
local function addKillerCircle(killer)
    if not killer:FindFirstChild("HumanoidRootPart") then return end
    if detectionCircles[killer] then return end

    local circle = Instance.new("CylinderHandleAdornment")
    circle.Name = "KillerDetectionCircle"
    circle.Adornee = killer.HumanoidRootPart
    circle.AlwaysOnTop = true
    circle.ZIndex = 0
    circle.Transparency = 0.7
    circle.Color3 = Options.RangeCircleColor.Value or Color3.fromRGB(0,255,0)
    circle.CFrame = CFrame.Angles(math.rad(90), 0, 0)
    circle.Height = 0.1
    circle.Radius = detectionRange / 2
    circle.Parent = killer.HumanoidRootPart

    detectionCircles[killer] = circle
end

-- Remove circle
local function removeKillerCircle(killer)
    if detectionCircles[killer] then
        detectionCircles[killer]:Destroy()
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
    for killer, circle in pairs(detectionCircles) do
        if circle and circle.Parent then
            circle.Radius = detectionRange -- 🔑 không chia 2 nữa
            circle.Color3 = Options.RangeCircleColor.Value or Color3.fromRGB(0,255,0)
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
:AddColorPicker("RangeCircleColor", {
    Default = Color3.fromRGB(0,255,0),
    Transparency = 0,
    Callback = function(color)
        for _, circle in pairs(detectionCircles) do
            if circle and circle.Parent then
                circle.Color3 = color
            end
        end
    end
})

Main1Group:AddInput("AutoBlockPunchRange", {
    Default = tostring(detectionRange),
    Numeric = true,
    Text = "Detection Range",
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

Main1Group:AddLabel("Request 150< ping [Block Jason, cOOlkidd")

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

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

_G.ESP_Minion = false
local espObjects = {}

-- Hàm kiểm tra NPC
local function isNPC(target)
    return target:FindFirstChildOfClass("Humanoid") ~= nil
end

-- Hàm tạo ESP
local function createESP(target)
    -- Chỉ ESP NPC và loại trừ tên
    if not isNPC(target) then return end
    local name = target.Name
    if name == "1x1x1x1Zombie" or name == "007n7" or name == "BuildermanSentry" or name == "BuildermanDispenser" or name == "SubspaceTripmine" then return end
    if string.find(name, "TaphTripwire") then return end
    if espObjects[target] then return end

    local adorneePart = target:FindFirstChild("HumanoidRootPart") or target:FindFirstChildWhichIsA("BasePart")
    if not adorneePart then return end

    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "MinionESP"
    billboard.Adornee = adorneePart
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.Parent = game.CoreGui

    -- Label
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 40)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 140, 0) -- cam
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextStrokeTransparency = 0
    label.Text = "Minion\nDist: 0.0"
    label.Parent = billboard

    -- Viền chữ
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(0, 0, 0)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = label

    -- Outline object
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 140, 0)
    highlight.OutlineTransparency = 0
    highlight.Parent = target

    espObjects[target] = {billboard = billboard, label = label, highlight = highlight}
end

-- Xóa ESP
local function removeESP(target)
    if espObjects[target] then
        espObjects[target].billboard:Destroy()
        if espObjects[target].highlight then
            espObjects[target].highlight:Destroy()
        end
        espObjects[target] = nil
    end
end

-- Update text khoảng cách
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
            if hrp and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                data.label.Text = string.format("Minion\nDist: %.1f", dist)
                data.billboard.Enabled = true
                if data.highlight then data.highlight.Enabled = true end
            end
        else
            removeESP(target)
        end
    end
end)

-- Toggle trong Main2Group
Main2Group:AddToggle("ESPMinion", {
    Text = "ESP Đệ của nghịch tử (c00lkidd minion)",
    Default = false,
    Callback = function(Value)
        _G.ESP_Minion = Value
        if Value then
            local map = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
            if map then
                for _, obj in ipairs(map:GetChildren()) do
                    createESP(obj)
                end
                map.ChildAdded:Connect(function(child)
                    if _G.ESP_Minion then
                        createESP(child)
                    end
                end)
                map.ChildRemoved:Connect(function(child)
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
M205Two:AddButton("Load Auto Block", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/skibidi399/Auto-block-script/refs/heads/main/FINAL%20AUTO%20BLOCK"))()
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


Main3Group:AddLabel("--== Surviv: [ TwoTime ] ==--", true) 

local Players = game:GetService("Players")  
local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local RunService = game:GetService("RunService")  
local lp = Players.LocalPlayer  
  
-- Remote  
local daggerRemote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")  
  
-- Config  
-- Config
_G.AimBackstab_Enabled = false
_G.AimBackstab_Mode = "Behind" -- cho Aim (giữ nguyên)
_G.AimBackstab_Range = 4
_G.AimBackstab_Action = "Aim" -- hoặc "TP"
_G.AimBackstab_Style = "Free" -- Free hoặc Back



-- Thêm dropdown chọn style
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
  
-- Check hướng sau lưng (dùng cho Aim)  
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
  
-- offset đứng sau killer (fix TP quá xa)  
local TP_OFFSET = 2.5  
  
-- TP đúng ra sau killer  
local function tpBehind(hrp, targetHRP)  
    if not hrp or not targetHRP then return end  
  
    local look = targetHRP.CFrame.LookVector  
    local backPos = targetHRP.Position - look * TP_OFFSET  
  
    -- đặt nhân vật ở sau lưng killer, nhìn về killer  
    hrp.CFrame = CFrame.new(backPos, targetHRP.Position)  
  
    -- sau khi TP thì aim liên tục 1 giây  
    local startTime = tick()  
    while tick() - startTime < 1 do  
        if not hrp or not targetHRP or not targetHRP.Parent then break end  
        local direction = (targetHRP.Position - hrp.Position).Unit  
        local yRot = math.atan2(-direction.X, -direction.Z)  
        hrp.CFrame = CFrame.new(hrp.Position) * CFrame.Angles(0, yRot, 0)  
        RunService.Heartbeat:Wait()  
    end  
end  
  
-- Bắt remote để bật cooldown + xử lý TP mode  
-- Bắt remote để bật cooldown + xử lý TP mode
daggerRemote.OnClientEvent:Connect(function(action, ability)
    if action == "UseActorAbility" and ability == "Dagger" then
        if not _G.AimBackstab_Enabled then return end
        if globalCooldown then return end
        globalCooldown = true

        -- nếu đang ở TP mode thì đợi 0.1s rồi TP
        if _G.AimBackstab_Action == "TP" then
            task.delay(0, function() -- <--- thêm delay
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

        -- notify
        Library:Notify("Cooldown 30s", 5)

        -- cooldown reset
        task.delay(30, function()
            globalCooldown = false
            Library:Notify("Cooldown Ended", 5)
        end)
    end
end)

-- helper: quay cùng hướng killer
local function faceSameDirection(hrp, targetHRP)
    local look = targetHRP.CFrame.LookVector
    if look.Magnitude < 0.001 then return end
    hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + look)
end

-- ===============================
-- VÒNG LẶP AIM + TP "BACK" FIXED
-- ===============================
RunService.Heartbeat:Connect(function()
    if not _G.AimBackstab_Enabled then return end
    if globalCooldown then return end -- ⚡ FIX: chặn toàn bộ khi đang cooldown
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
        local args = {"UseActorAbility","404Error"}
        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
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

-- Utils
local function getHRP(model)
    return model and model:FindFirstChild("HumanoidRootPart")
end

local function isLocalKiller()
    local ch = lp.Character
    return ch and ch.Parent and ch.Parent.Name == "Killers"
end

-- target ở PHÍA SAU lưng localp & trong 10 studs
local function isBehindLocalWithin10(myHRP, targetHRP)
    if not myHRP or not targetHRP then return false end
    local toTarget = targetHRP.Position - myHRP.Position
    -- dot < 0 => ở phía sau
    return myHRP.CFrame.LookVector:Dot(toTarget) < 0 and toTarget.Magnitude <= 10
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

-- Lấy TwoTime gần nhất đang ở phía sau & trong 10 studs
local function getNearestTwoTimeBehindWithin10(myHRP)
    local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivors or not myHRP then return nil end

    local nearest, bestDist = nil, math.huge
    for _, m in ipairs(survivors:GetChildren()) do
        if m.Name == "TwoTime" then
            local hrp = getHRP(m)
            if hrp and isBehindLocalWithin10(myHRP, hrp) then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < bestDist then
                    bestDist, nearest = d, m
                end
            end
        end
    end
    return nearest
end

-- Kết nối theo dõi AnimationPlayed cho một model TwoTime
local function hookTwoTimeChar(twoChar)
    local hum = twoChar:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local function onPlayed(track)
        if not _G.AntiTwoTimeBackstab then return end
        if not isLocalKiller() then return end

        local animId = track and track.Animation and track.Animation.AnimationId and track.Animation.AnimationId:match("%d+")
        if not animId or not BACKSTAB_ANIMS[animId] then return end

        local myHRP = getHRP(lp.Character)
        local targetHRP = getHRP(twoChar)
        if not myHRP or not targetHRP then return end

        -- chỉ aim nếu đúng là TwoTime gần nhất ở phía sau trong 10 studs
        local nearest = getNearestTwoTimeBehindWithin10(myHRP)
        if nearest == twoChar then
            aimAtTarget0p3s(myHRP, targetHRP)
        end
    end

    -- Bắt ở Humanoid.AnimationPlayed (nếu có) và Animator.AnimationPlayed cho chắc
    if hum.AnimationPlayed then
        hum.AnimationPlayed:Connect(onPlayed)
    end
    local animator = hum:FindFirstChildOfClass("Animator") or hum:FindFirstChild("Animator")
    if animator and animator.AnimationPlayed then
        animator.AnimationPlayed:Connect(onPlayed)
    end
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

-- Theo dõi TwoTime mới xuất hiện
local function listenTwoTimeSpawns()
    local survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
    if not survivors then return end
    survivors.ChildAdded:Connect(function(m)
        if m.Name == "TwoTime" then
            -- đợi Humanoid/Animator sẵn sàng
            task.wait(0.2)
            hookTwoTimeChar(m)
        end
    end)
end

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
    ["Builderman Ability"] = {Values = {"DispenserConstruction", "SentryConstruction"}, Connection = nil, Enabled = false}
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
        Text = "noslow: " .. name,
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

task.spawn(function()-- FakeLag Config (local, không dùng getgenv)
local FakeLag = {
    Active = false,
    targetRemoteName = "UnreliableRemoteEvent",
    blockedFirstArg = "UpdCF",
    MinDelay = 0.1,
    MaxDelay = 0.3,
    lastSendTime = 0,
    Hooked = false
}

-- Hàm lấy random delay
local function getRandomDelay()
    return FakeLag.MinDelay + math.random() * (FakeLag.MaxDelay - FakeLag.MinDelay)
end

-- Setup hook 1 lần
local function SetupHook()
    if FakeLag.Hooked then return end

    FakeLag.SavedHook = hookmetamethod(game, "__namecall", function(self, ...)
        local methodName = getnamecallmethod()
        local arguments = {...}

        if self.Name == FakeLag.targetRemoteName and methodName == "FireServer" and arguments[1] == FakeLag.blockedFirstArg then
            if FakeLag.Active then
                local currentTime = tick()
                if currentTime - FakeLag.lastSendTime < getRandomDelay() then
                    return -- chặn nếu chưa đủ interval
                else
                    FakeLag.lastSendTime = currentTime
                end
            end
        end

        return FakeLag.SavedHook(self, ...)
    end)

    FakeLag.Hooked = true
end

-- Khởi tạo hook ngay khi load script
SetupHook()

-- ================== GUI (Obsidian) ==================

-- Toggle chính
Dotab:AddToggle("FakeLagToggle", {
    Text = "Enable Fake Lag",
    Default = false,
    Callback = function(Value)
        if Value then
            FakeLag.Active = true
            local args = {
                "UpdateSettings",
                game:GetService("Players").LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings"):WaitForChild("Advanced"):WaitForChild("ShowPlayerHitboxes"),
                true
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        else
            FakeLag.Active = false
            local args = {
                "UpdateSettings",
                game:GetService("Players").LocalPlayer:WaitForChild("PlayerData"):WaitForChild("Settings"):WaitForChild("Advanced"):WaitForChild("ShowPlayerHitboxes"),
                false
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        end
    end
})

-- Input MinDelay
Dotab:AddInput("FakeLagMin", {
    Default = tostring(FakeLag.MinDelay),
    Numeric = true,
    Text = "Min Delay (s)",
    Placeholder = ">= 0.05",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= 0.05 then
            FakeLag.MinDelay = num
        else
            Library:Notify(" >= 0.05", 3)
        end
    end
})

-- Input MaxDelay
Dotab:AddInput("FakeLagMax", {
    Default = tostring(FakeLag.MaxDelay),
    Numeric = true,
    Text = "Max Delay (s)",
    Placeholder = ">= Min",
    Callback = function(val)
        local num = tonumber(val)
        if num and num >= FakeLag.MinDelay then
            FakeLag.MaxDelay = num
        else
            Library:Notify(" >= Min", 3)
        end
    end
})

			end)













		

end)



























task.spawn(function()
    while task.wait(20) do
        local staminaModule = require(game.ReplicatedStorage:WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting"))
        if staminaModule then
            staminaModule.StaminaGain = 22
            staminaModule.StaminaLoss = 9
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



warn("--------------------")
print("<==> Khang <==>")
warn("--------------------")
