-- Kiểm tra ID game
if game.PlaceId ~= 138103330716004 then
    return warn("Script only works in the specified game (ID: 138103330716004){After 3 AM - Main}")
end

-- Thông báo khi đúng ID game
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "✓ Game Check Passed",
    Text = "Script is now executing...",
    Duration = 5
})
task.wait(1) -- Đợi 1s trước khi thực thi 





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
    Title = "After 3 am",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "Script by IganhK [Beta Version]",
	   Icon = nil, -- ID logo

    AutoLock = false,
    ShowCustomCursor = true,
    NotifySide = "Right",
    TabPadding = 2,
    MenuFadeTime = 0
})

Tabs = {
	Tab = Window:AddTab("Game", "rbxassetid://7734053426"),
	["UI Settings"] = Window:AddTab("UI Settings", "rbxassetid://7733955511")
}

--== Tabs
local Main1Group = Tabs.Tab:AddLeftGroupbox("-=< Main >=-")
local Main1o5Group = Tabs.Tab:AddLeftTabbox() -- hoặc :AddLeftTabbox()

local Main2Group = Tabs.Tab:AddRightGroupbox("-=< Visual >=-")
local Main2o5Group = Tabs.Tab:AddRightTabbox() -- hoặc :AddLeftTabbox()


--== Mini Tabs [Tabbox]
local M105One = Main1o5Group:AddTab("--== Player ==--")

local M205One = Main2o5Group:AddTab("--== Misc ==--")
local M205Two = Main2o5Group:AddTab("--== Load ==--")








local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

-- LOCAL SETTINGS
local ESP_Items_Selected = {}
local ESP_Items_Enabled = false
local ESP_Enemy_Enabled = false
local ShadowMan_Color = Color3.fromRGB(255,0,0)

-- CREATE / CLEAR ESP
local function CreateESP(obj, color, label)
    if obj:FindFirstChild("ESP_Billboard") then return end
    local part = obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    -- Billboard
    local bb = Instance.new("BillboardGui")
    bb.Name = "ESP_Billboard"
    bb.Adornee = part
    bb.Size = UDim2.new(0,100,0,40)
    bb.StudsOffset = Vector3.new(0,2,0)
    bb.AlwaysOnTop = true
    bb.Parent = obj

    local text = Instance.new("TextLabel")
    text.Name = "Text"
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Font = Enum.Font.Code
    text.TextColor3 = color
    text.TextStrokeTransparency = 0
    text.TextSize = 14
    text.Text = label.."\nDist: 0.0"
    text.Parent = bb

    -- Highlight
    if not obj:FindFirstChild("ESP_Outline") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Outline"
        hl.Adornee = obj
        hl.FillTransparency = 1
        hl.OutlineTransparency = 0
        hl.OutlineColor = color
        hl.Parent = obj
    end
end

local function ClearESP(obj)
    local bb = obj:FindFirstChild("ESP_Billboard")
    if bb then bb:Destroy() end
    local hl = obj:FindFirstChild("ESP_Outline")
    if hl then hl:Destroy() end
end

-- ITEM ESP LOOP
task.spawn(function()
    while task.wait(0.2) do
        if not ESP_Items_Enabled then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    ClearESP(obj)
                end
            end
        else
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") then
                    local name = obj.Name
                    if ESP_Items_Selected[name] then
                        local data = ESP_Items_Selected[name]
                        CreateESP(obj, data.Color, name)

                        local part = obj:FindFirstChildWhichIsA("BasePart")
                        if part and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                            local gui = obj:FindFirstChild("ESP_Billboard")
                            local lbl = gui and gui:FindFirstChild("Text")
                            if lbl then
                                local dist = (part.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                                lbl.Text = name..string.format("\nDist: %.1f", dist)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ENEMY ESP
task.spawn(function()
    while task.wait(0.2) do
        for _, enemy in ipairs(workspace:GetDescendants()) do
            if enemy:IsA("Model") and enemy.Name == "ShadowMan" then
                if ESP_Enemy_Enabled then
                    local hp = "?"
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    if hum then hp = math.floor(hum.Health) end
                    CreateESP(enemy, ShadowMan_Color, "ShadowMan\nHP: "..hp)

                    local part = enemy:FindFirstChildWhichIsA("BasePart")
                    if part and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                        local gui = enemy:FindFirstChild("ESP_Billboard")
                        local lbl = gui and gui:FindFirstChild("Text")
                        if lbl then
                            local dist = (part.Position - lp.Character.HumanoidRootPart.Position).Magnitude
                            lbl.Text = "ShadowMan\nHP: "..hp..string.format("\nDist: %.1f", dist)
                        end
                    end
                else
                    ClearESP(enemy)
                end
            end
        end
    end
end)

-- ================= UI SETUP (Obsidian style) =================
local Main2Group = Tabs.Main:AddLeftGroupbox("ESP")

-- Dropdown Item ESP
Main2Group:AddDropdown("ESPItemDropdown", {
    Text = "Item ESP",
    Multi = true,
    Default = {},
    Values = { "Shotgun Ammo", "Flashlight", "Fuel" },
}):OnChanged(function(values)
    ESP_Items_Selected = {}
    for name, _ in pairs(values) do
        ESP_Items_Selected[name] = {
            Color = (name == "Shotgun Ammo" and Color3.fromRGB(255,215,0))
                or (name == "Flashlight" and Color3.new(1,1,1))
                or (name == "Fuel" and Color3.fromRGB(255,0,0))
        }
    end
end)

-- ESP Item Toggle
Main2Group:AddToggle("ESPItemsToggle", {
    Text = "Enable ESP Items",
    Default = false,
}):OnChanged(function(value)
    ESP_Items_Enabled = value
end)

-- ShadowMan ESP Toggle + ColorPicker
Main2Group:AddToggle("ESPEnemyToggle", {
    Text = "ESP ShadowMan",
    Default = false,
}):OnChanged(function(value)
    ESP_Enemy_Enabled = value
end)
Main2Group:AddColorPicker("ShadowColorPicker", {
    Default = ShadowMan_Color,
    Title = "ShadowMan Color",
}):OnChanged(function(value)
    ShadowMan_Color = value
end)












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

M205One:AddButton("no disable chat", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Xd/main/enable%20chat"))()
end)




M205Two:AddDivider()

M205Two:AddButton("Load InfYield Edit", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Xd/refs/heads/main/infedit"))()  
				
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
local webhookUrl = ''

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
loadstring(game:HttpGet(""))()
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
