-- Kiểm tra ID game
if game.PlaceId ~= 99078474560152 then
    return warn("Script only works in the specified game (ID: 99078474560152){M.E.G. Endless Reality}")
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
    Title = "               [UPDATE] M.E.G. Endless Reality",
    Center = true,
    AutoShow = true,
    Resizable = true,
    Footer = "Script by IganhK [Beta Version]",
	   Icon = 98629859043211, -- ID logo

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










local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local vestEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("VestEvent")
local lp = Players.LocalPlayer

-- Toggle auto GodMode (fire VestEvent repeatedly while enabled)
Main1Group:AddToggle("GodModeAuto", {
    Text = "GodMode [Lost all money :)]",
    Default = false,
    Callback = function(value)
        _G.GodModeAuto = value

        -- spawn loop so it doesn't block UI
        if value then
            task.spawn(function()
                while _G.GodModeAuto do
                    local success, err = pcall(function()
                        -- safe args: pass the LocalPlayer (most remotes expect the player or player.UserId; adjust if needed)
                        local args = { lp }
                        vestEvent:FireServer(unpack(args))
                    end)

                    if not success then
                        -- optional notify; replace Library:Notify with your UI lib if needed
                        pcall(function()
                            if Library and Library.Notify then
                                Library:Notify("GodMode failed: "..tostring(err), 3)
                            else
                                warn("GodMode failed:", err)
                            end
                        end)
                    end

                    task.wait(1) -- gửi 1s 1 lần
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local moneyConn

Main1Group:AddToggle("InfMoney", {
    Text = "Inf Money [Lost All Money :)]",
    Default = false,
    Callback = function(state)
        if state then
            local leaderstats = lp:WaitForChild("leaderstats")
            local money = leaderstats:WaitForChild("Money")

            -- set value ngay lập tức
            money.Value = 9223372036854776000

            -- theo dõi khi bị thay đổi thì chỉnh lại
            moneyConn = money:GetPropertyChangedSignal("Value"):Connect(function()
                if money.Value ~= 9223372036854776000 then
                    money.Value = 9223372036854776000
                end
            end)

        else
            -- tắt theo dõi
            if moneyConn then
                moneyConn:Disconnect()
                moneyConn = nil
            end
        end
    end
})


Main1Group:AddButton("Shop [Rayfield]", function()
loadstring(game:HttpGet('https://raw.githubusercontent.com/YegozovutSemyon/MEGHUB/refs/heads/main/source'))()
end)



--m105one
M105One:AddDivider()
M105One:AddLabel("-= Sprint speed =-")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local sprintSpeedConn
local sprintSpeedValue = 20 -- mặc định
local defaultSpeed = 20     -- tốc độ mặc định trong game

-- ⚡ Input chỉnh tốc độ
M105One:AddInput("SprintSpeedInput", {
    Text = "- Speed input",
    Placeholder = "Enter value",
    Numeric = true,
    Finished = true,
    Callback = function(value)
        local num = tonumber(value)
        if num and num > 0 then
            sprintSpeedValue = num
        end
    end
})

-- 🏃 Toggle bật/tắt Sprint Speed
M105One:AddToggle("SprintSpeedToggle", {
    Text = "Using custom",
    Default = false,
    Callback = function(state)
        local sprintValue = lp:WaitForChild("PlayerGui"):WaitForChild("MainGUI")
            .Vignette.Movement:WaitForChild("SprintSpeed")

        if state then
            -- Bật → set giá trị ngay
            sprintValue.Value = sprintSpeedValue

            -- Theo dõi nếu bị thay đổi thì chỉnh lại
            sprintSpeedConn = sprintValue:GetPropertyChangedSignal("Value"):Connect(function()
                if sprintValue.Value ~= sprintSpeedValue then
                    sprintValue.Value = sprintSpeedValue
                end
            end)
        else
            -- Tắt → đưa giá trị về mặc định
            sprintValue.Value = defaultSpeed

            -- Ngắt kết nối theo dõi
            if sprintSpeedConn then
                sprintSpeedConn:Disconnect()
                sprintSpeedConn = nil
            end
        end
    end
})














local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- =========================
-- CONFIG
-- =========================
_G.UseOutline = false
_G.EspGui = false
_G.EspName = true
_G.EspDistance = true
_G.EspItemColor = Color3.fromRGB(0, 255, 0)
_G.EspNpcColor = Color3.fromRGB(255, 255, 0)

local folderEspList = { ["PowerBox"] = true, ["Puzzles"] = true }
local objEspList = { ["Item"] = true, ["ItemF"] = true, ["ItemE"] = true }
local ignoredNPC = { ["Trap"] = true, ["ThePhone"] = true, ["Ragdoll"] = true }

-- =========================
-- OUTLINE
-- =========================
local function addOutline(obj, color)
	if not obj then return end
	if not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
	if obj:FindFirstChild("OutlineESP") then return end

	local adornee
	if obj:IsA("Model") then
		if obj.PrimaryPart then adornee = obj else return end
	else
		adornee = obj
	end

	local h = Instance.new("Highlight")
	h.Name = "OutlineESP"
	h.Adornee = adornee
	h.FillTransparency = 1
	h.OutlineTransparency = 0
	h.OutlineColor = color
	h.Parent = adornee
end

local function clearOutline(obj)
	if obj and obj:FindFirstChild("OutlineESP") then
		obj.OutlineESP:Destroy()
	end
end

-- =========================
-- LABEL ESP
-- =========================
local function espLabel(obj, color)
	-- Xoá label cũ
	for _, gui in ipairs(obj:GetDescendants()) do
		if gui.Name == "Esp_Gui" then gui:Destroy() end
	end

	if not _G.EspGui then return end

	local adorneePart
	if obj:IsA("Model") and obj.PrimaryPart then
		adorneePart = obj.PrimaryPart
	elseif obj:IsA("BasePart") then
		adorneePart = obj
	else
		return
	end

	local gui = Instance.new("BillboardGui")
	gui.Name = "Esp_Gui"
	gui.Adornee = adorneePart
	gui.AlwaysOnTop = true
	gui.Size = UDim2.new(0, 120, 0, 50)
	gui.StudsOffset = Vector3.new(0, 2.5, 0)
	gui.Parent = adorneePart

	local lbl = Instance.new("TextLabel", gui)
	lbl.BackgroundTransparency = 1
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.Font = Enum.Font.Code
	lbl.TextSize = 15
	lbl.TextStrokeTransparency = 0
	lbl.TextColor3 = color

	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.new(0, 0, 0)
	stroke.Thickness = 1.5

	local parts = {}
	if _G.EspName then
		table.insert(parts, obj.Name)
	end
	if _G.EspDistance then
		local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		local p = adorneePart.Position
		if hrp then
			local d = (hrp.Position - p).Magnitude
			table.insert(parts, ("Dist: %.1f"):format(d))
		end
	end

	lbl.Text = table.concat(parts, "\n")
end

-- =========================
-- CLEAR ALL
-- =========================
local function clearAllESP()
	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:FindFirstChild("OutlineESP") then obj.OutlineESP:Destroy() end
		for _, gui in ipairs(obj:GetDescendants()) do
			if gui.Name == "Esp_Gui" then gui:Destroy() end
		end
	end
end

Main2Group:AddDivider()
-- =========================
-- ESP ITEMS
-- =========================
local espItemsRunning = false
Main2Group:AddToggle("ESPItems", {
	Text = "Enable ESP Items",
	Default = false,
	Callback = function(state)
		espItemsRunning = state
		if not state then clearAllESP() return end

		while espItemsRunning do
			for _, obj in ipairs(workspace:GetDescendants()) do
				-- Folder
				if folderEspList[obj.Name] and obj:IsA("Model") and obj.PrimaryPart then
					if _G.UseOutline then addOutline(obj, _G.EspItemColor) else clearOutline(obj) end
					espLabel(obj, _G.EspItemColor)
				end
				-- Object
				if objEspList[obj.Name] and obj:IsA("BasePart") then
					if _G.UseOutline then addOutline(obj, _G.EspItemColor) else clearOutline(obj) end
					espLabel(obj, _G.EspItemColor)
				end
			end
			task.wait(1)
		end
	end
})
:AddColorPicker("ItemColor", {
	Default = Color3.fromRGB(0, 255, 0),
	Callback = function(Value)
		_G.EspItemColor = Value
	end
})
-- =========================
-- ESP NPC
-- =========================
local espNpcRunning = false
Main2Group:AddToggle("ESPNPC", {
	Text = "Enable ESP NPC",
	Default = false,
	Callback = function(state)
		espNpcRunning = state
		if not state then clearAllESP() return end

		while espNpcRunning do
			local npcFolder = workspace:FindFirstChild("NPCS")
			if npcFolder then
				for _, npc in ipairs(npcFolder:GetChildren()) do
					if not ignoredNPC[npc.Name] then
						if npc:IsA("Model") and npc.PrimaryPart then
							if _G.UseOutline then addOutline(npc, _G.EspNpcColor) else clearOutline(npc) end
							espLabel(npc, _G.EspNpcColor)
						end
					end
				end
			end
			task.wait(1)
		end
	end
})
:AddColorPicker("NpcColor", {
	Default = Color3.fromRGB(255, 255, 0),
	Callback = function(Value)
		_G.EspNpcColor = Value
	end
})
Main2Group:AddDivider()
-- =========================
-- ESP CÀI ĐẶT PHỤ TRỢ
-- =========================
Main2Group:AddLabel("-= EnableEsp function =-")
Main2Group:AddDivider()
Main2Group:AddToggle("OutlineESP", {
	Text = "Enable Outline",
	Default = false,
	Callback = function(Value)
		_G.UseOutline = Value
	end
})

Main2Group:AddToggle("Esp Gui", {
	Text = "Enable Label",
	Default = false,
	Callback = function(Value)
		_G.EspGui = Value
	end
})
Main2Group:AddDivider()
Main2Group:AddLabel("-= EspGui function =-")
Main2Group:AddDivider()
Main2Group:AddToggle("Show Name", {
	Text = "Show Name",
	Default = true,
	Callback = function(Value)
		_G.EspName = Value
	end
})

Main2Group:AddToggle("Show Distance", {
	Text = "Show Distance",
	Default = true,
	Callback = function(Value)
		_G.EspDistance = Value
	end
})











--m205one
M205One:AddDivider()
M205One:AddLabel("- No-Clipped Ending")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

M205One:AddButton("Exit Backroom (Special level)", function()
    local player = Players.LocalPlayer
    TeleportService:Teleport(93228425740454, player)
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
