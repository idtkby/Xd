local Players = game:GetService("Players")
local playerData = game:GetService("Players").LocalPlayer:WaitForChild("PlayerData")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
local TweenService = game:GetService("TweenService")
local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local Humanoid, Animator
local player = Players.LocalPlayer
local purchasedEmotesFolder = playerData:WaitForChild("Purchased"):WaitForChild("Emotes")
local Remote = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")

--=Hub=

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Nyansaken Hub",
   Icon = 119855670079790,
   LoadingTitle = "Loading Nyansaken Hub...",
   LoadingSubtitle = "by PKDLL",
   ShowText = "Nyansaken",
   Theme = "Default",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "NyansakenHub",
      FileName = "Nyansaken Hub"
   },
   Discord = {
      Enabled = false,
      Invite = "dsc.gg/nyansaken-hub",
      RememberJoins = true
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Nyan-System",
      Subtitle = "Key System",
      Note = "(dsc.gg/nyansaken-hub) - Join our discord right now", -- Use this to tell the user how to get a key
      FileName = "nyansakenkey", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"HELLNAHMAN", "ARTISTDOOFUS", "ADMINYANCIEL", "PDKLLISCOOL", "FREESCHLEP", "CHANCEMS4", "GENSUPDATE"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- Helpers
local detectionRange = 18
local facingCheckEnabled = false
local looseFacing = true
local predictionValue = 4

local autoBlockTriggerSounds = {
    ["102228729296384"] = true,
    ["140242176732868"] = true,
    ["112809109188560"] = true,
    ["136323728355613"] = true,
    ["115026634746636"] = true,
    ["84116622032112"] = true,
    ["108907358619313"] = true,
    ["127793641088496"] = true,
    ["86174610237192"] = true,
    ["95079963655241"] = true,
    ["101199185291628"] = true,
    ["119942598489800"] = true,
    ["84307400688050"] = true
}

-- Tabs
local Combat = Window:CreateTab("Combat", "swords")
local Generators = Window:CreateTab("Generators", "package-2")
local ESP = Window:CreateTab("ESP", "scan-eye")
local StaminaSet = Window:CreateTab("Stamina Settings", "footprints")
local Aimbot = Window:CreateTab("Aimbot", "crosshair")
local Miscs = Window:CreateTab("Misc", "circle-ellipsis")
local AntiSlows = Window:CreateTab("Anti Slow", "accessibility")
local AchieveTab = Window:CreateTab("Achievements", "medal")

-- == Variables ==
local genEnabled = false
local genInterval = 1.25
local re = true
local Check = false
local lt = 0

-- == UI Elements ==
local autoGenToggle = Generators:CreateToggle({
	Name = "Auto Do Generator",
	CurrentValue = genEnabled,
	Flag = "AutoGenToggle",
	Callback = function(Value)
		genEnabled = Value
	end,
})

local genIntervalSlider = Generators:CreateSlider({
	Name = "Do Generator Interval (Seconds)",
	Range = {1, 15},
	Increment = 0.25,
	Suffix = "s",
	CurrentValue = genInterval,
	Flag = "GenIntervalSlider",
	Callback = function(Value)
		genInterval = Value
	end,
})

-- == Hook RF/RE để detect vào/ra gen + cooldown ==
local Old
Old = hookmetamethod(game, "__namecall", function(Self, ...)
	local Args = { ... }
	local Method = getnamecallmethod()
	if not checkcaller() and typeof(Self) == "Instance" then
		if Method == "InvokeServer" or Method == "FireServer" then
			if tostring(Self) == "RF" then
				if Args[1] == "enter" then
					Check = true
				elseif Args[1] == "leave" then
					Check = false
				end
			elseif tostring(Self) == "RE" then
				lt = os.clock()
			end
		end
	end
	return Old(Self, unpack(Args))
end)

-- == Auto Generator Loop ==
game:GetService("RunService").Stepped:Connect(function()
	if genEnabled and Check and re and os.clock() - lt >= genInterval then
		re = false
		task.spawn(function()
			for _, gen in ipairs(workspace.Map.Ingame:WaitForChild("Map"):GetChildren()) do
				if gen.Name == "Generator" and gen:FindFirstChild("Remotes") then
					gen.Remotes.RE:FireServer()
				end
			end
			task.wait(genInterval)
			re = true
		end)
	end
end)

-- === ESP Toggles ===
local killersESPToggle = false
local survivorsESPToggle = false
local itemESPEnabled = false

ESP:CreateSection("Main ESP")

ESP:CreateToggle({
   Name = "Killers ESP",
   CurrentValue = false,
   Flag = "KillersESP",
   Callback = function(Value)
      killersESPToggle = Value
   end,
})

ESP:CreateToggle({
   Name = "Survivors ESP",
   CurrentValue = false,
   Flag = "SurvivorsESP",
   Callback = function(Value)
      survivorsESPToggle = Value
   end,
})

-- === ESP Logic ===
local camera = workspace.CurrentCamera

local killersFolder = workspace:WaitForChild("Players"):WaitForChild("Killers")
local survivorsFolder = workspace:WaitForChild("Players"):WaitForChild("Survivors")

local function attachBillboard(model, color)
	if model:FindFirstChild("ESP_NameBillboard") then return end
	local head = model:FindFirstChild("Head") or model:FindFirstChildWhichIsA("BasePart")
	if not head then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_NameBillboard"
	billboard.Adornee = head
	billboard.StudsOffset = Vector3.new(0, 3, 0)
	billboard.AlwaysOnTop = true
	billboard.Size = UDim2.new(0, 200, 0, 50)
	billboard.Parent = model

	local label = Instance.new("TextLabel")
	label.Name = "NameLabel"
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.TextColor3 = color
	label.TextStrokeTransparency = 0
	label.TextStrokeColor3 = Color3.new(0, 0, 0)
	label.TextScaled = false
	label.TextWrapped = false
	label.ClipsDescendants = true
	label.TextTruncate = Enum.TextTruncate.None
	label.AutomaticSize = Enum.AutomaticSize.X
	label.TextXAlignment = Enum.TextXAlignment.Center
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextSize = 10
	label.Font = Enum.Font.GothamBold
	label.Text = "Loading..."
	label.Parent = billboard
end

local function updateBillboardText(model)
	local billboard = model:FindFirstChild("ESP_NameBillboard")
	if not billboard then return end

	local label = billboard:FindFirstChild("NameLabel")
	if not label then return end

	local actorText = model:GetAttribute("ActorDisplayName") or "???"
	local skinText = model:GetAttribute("SkinNameDisplay")
	local username = model:GetAttribute("Username") or "Unknown"

	-- Use pre-tagged attribute
	if actorText == "Noli" and model:GetAttribute("IsFakeNoli") == true then
		actorText = actorText .. " (FAKE)"
	end

	local displayText = actorText
	if skinText and tostring(skinText) ~= "" then
		displayText = displayText .. " | " .. skinText
	end

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		local hp = math.floor(humanoid.Health)
		local maxhp = math.floor(humanoid.MaxHealth)
		displayText = string.format("%s (HP: %d/%d)", displayText, hp, maxhp)
	end

	label.Text = displayText
end

-- Bảng lưu Noli theo username
local noliByUsername = {}

local function clearFakeTags()
    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            killer:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function scanNolis()
    noliByUsername = {}

    for _, killer in ipairs(killersFolder:GetChildren()) do
        if killer:GetAttribute("ActorDisplayName") == "Noli" then
            local username = killer:GetAttribute("Username")
            if username then
                if not noliByUsername[username] then
                    noliByUsername[username] = {}
                end
                table.insert(noliByUsername[username], killer)
            end
        end
    end

    for username, models in pairs(noliByUsername) do
        if #models > 1 then
            -- Noli đầu tiên là thật, những cái sau fake
            for i = 2, #models do
                models[i]:SetAttribute("IsFakeNoli", true)
            end
            models[1]:SetAttribute("IsFakeNoli", false)
        else
            -- Chỉ có 1 Noli thì không fake
            models[1]:SetAttribute("IsFakeNoli", false)
        end
    end
end

local function updateFakeNolis()
    clearFakeTags()
    scanNolis()
end

local function setupModel(model, isKiller)
	if not model:IsA("Model") or not model:FindFirstChildOfClass("Humanoid") then return end
	local color = isKiller and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(255, 255, 0)

	attachBillboard(model, color)
	updateBillboardText(model)

	if not model:FindFirstChild("ESP_Highlight") then
		local highlight = Instance.new("Highlight")
		highlight.Name = "ESP_Highlight"
		highlight.FillTransparency = 1
		highlight.OutlineTransparency = 0
		highlight.OutlineColor = color
		highlight.Adornee = model
		highlight.Parent = model
	end

	model:GetAttributeChangedSignal("ActorDisplayName"):Connect(function()
		updateBillboardText(model)
	end)
	model:GetAttributeChangedSignal("SkinNameDisplay"):Connect(function()
		updateBillboardText(model)
	end)

	local humanoid = model:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			updateBillboardText(model)
		end)
		humanoid:GetPropertyChangedSignal("MaxHealth"):Connect(function()
			updateBillboardText(model)
		end)
	end

	model.AncestryChanged:Connect(function(_, parent)
		if not parent then
			local bb = model:FindFirstChild("ESP_NameBillboard")
			if bb then bb:Destroy() end

			local hl = model:FindFirstChild("ESP_Highlight")
			if hl then hl:Destroy() end
		end
	end)
end

local function scanFolder(folder, isKiller)
	for _, model in ipairs(folder:GetChildren()) do
		setupModel(model, isKiller)
	end
end

task.spawn(function()
	while true do
		scanFolder(killersFolder, true)
		scanFolder(survivorsFolder, false)
		task.wait(5)
	end
end)

local function handleChildAdded(folder, isKiller)
	folder.ChildAdded:Connect(function(child)
		task.spawn(function()
			repeat task.wait() until child:IsDescendantOf(folder)
			local timeout = 3
			local timer = 0
			while (not child:FindFirstChild("Head") and not child:FindFirstChildWhichIsA("BasePart")) or not child:FindFirstChildOfClass("Humanoid") do
				task.wait(0.1)
				timer += 0.1
				if timer > timeout then return end
			end
			task.wait(0.2) -- để đảm bảo Attribute đã gán xong
			setupModel(child, isKiller)
		end)
	end)
end

handleChildAdded(killersFolder, true)
handleChildAdded(survivorsFolder, false)
updateFakeNolis()

-- Khi có Noli biến mất, quét lại
killersFolder.ChildRemoved:Connect(function(removed)
    if removed:GetAttribute("ActorDisplayName") == "Noli" then
        updateFakeNolis()
    end
end)

-- Khi có Noli mới thêm vào, quét lại sau 0.2s để attribute được cập nhật
killersFolder.ChildAdded:Connect(function(added)
    if added:GetAttribute("ActorDisplayName") == "Noli" then
        task.defer(function()
            task.wait(0.2)
            updateFakeNolis()
        end)
    end
end)

-- Rescan định kỳ tránh lỗi sai sót
task.spawn(function()
    while true do
        task.wait(10)
        updateFakeNolis()
    end
end)

RunService.RenderStepped:Connect(function()
	for _, folderData in pairs({
		{folder = killersFolder, toggle = killersESPToggle},
		{folder = survivorsFolder, toggle = survivorsESPToggle},
	}) do
		for _, model in ipairs(folderData.folder:GetChildren()) do
			local bb = model:FindFirstChild("ESP_NameBillboard")
			local hl = model:FindFirstChild("ESP_Highlight")

			if bb then bb.Enabled = folderData.toggle end
			if hl then hl.Enabled = folderData.toggle end

			if folderData.toggle and bb and bb.Adornee then
				local dist = (camera.CFrame.Position - bb.Adornee.Position).Magnitude
				local scale = math.clamp(1 / (dist / 20), 0.5, 2)

				local label = bb:FindFirstChild("NameLabel")
				if label then
					label.TextSize = math.clamp(10 * scale, 12, 20)
					bb.Size = UDim2.new(0, label.TextBounds.X + 20, 0, 50 * scale)
				end
			end
		end
	end
end)

local camera = workspace.CurrentCamera

-- Generator thật
local DEFAULT_SIZE = 5
local MIN_SIZE = 3
local MAX_SIZE = 15

-- Fake Generator
local FAKE_DEFAULT_SIZE = 10
local FAKE_MIN_SIZE = 5
local FAKE_MAX_SIZE = 20

local trackedGenerators = {}
local partEspName = "NurbsPath"
local espTransparency = 0.5
local partEspTrigger = nil
local espConnection = nil
local generatorESPEnabled = false

-- == % Progress Format ==
local function getProgressPercent(value)
    if value == 0 then return "0%"
    elseif value == 26 then return "25%"
    elseif value == 52 then return "50%"
    elseif value == 78 then return "75%"
    elseif value == 100 then return "100%"
    else
    return ""
    end
end

-- == Scale Calculation ==
local function calculateScale(pos, isFake)
    if not camera then return DEFAULT_SIZE end
    local distance = (camera.CFrame.Position - pos).Magnitude

    local defaultSize = isFake and FAKE_DEFAULT_SIZE or DEFAULT_SIZE
    local minSize = isFake and FAKE_MIN_SIZE or MIN_SIZE
    local maxSize = isFake and FAKE_MAX_SIZE or MAX_SIZE

    local scale = defaultSize * (20 / distance)
    return math.clamp(scale, minSize, maxSize)
end

-- == BillboardGUI ESP ==
local function createOrUpdateProgressESP(model, progressValue)
    if not model or not model:IsA("Model") then return end

    local adornee = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart")
    if not adornee then return end

    local billboard = model:FindFirstChild("Progress_ESP")
    if not billboard then
        billboard = Instance.new("BillboardGui")
        billboard.Name = "Progress_ESP"
        billboard.Adornee = adornee
        billboard.Size = UDim2.new(0, DEFAULT_SIZE*10, 0, DEFAULT_SIZE*3)
        billboard.StudsOffset = Vector3.new(0,3,0)
        billboard.AlwaysOnTop = true
        billboard.Parent = model

        local label = Instance.new("TextLabel")
        label.Name = "ProgressLabel"
        label.Size = UDim2.new(1,0,1,0)
        label.BackgroundTransparency = 1
        label.TextScaled = true
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard
    end

    local label = billboard:FindFirstChild("ProgressLabel")
    if label then
        if model.Name == "FakeGenerator" then
            label.Text = "Fake Generator"
            label.TextColor3 = Color3.fromRGB(255,0,0)
        else
            label.Text = getProgressPercent(progressValue)
            label.TextColor3 = Color3.fromRGB(255,255,255)
        end
    end

    local isFake = model.Name == "FakeGenerator"
    task.spawn(function()
        while billboard.Parent do
            local scale = calculateScale(adornee.Position, isFake)
            billboard.Size = UDim2.new(0, scale*10, 0, scale*3)
            task.wait(0.1)
        end
    end)
end

-- == BoxHandleAdornment ESP ==
local function attachESP(part)
    if not part or not part:IsA("BasePart") then return end
    if part:FindFirstChild("ESP_Fill") then return end

    local fill = Instance.new("BoxHandleAdornment")
    fill.Name = "ESP_Fill"
    fill.Adornee = part
    fill.AlwaysOnTop = true
    fill.ZIndex = 1
    fill.Size = part.Size
    fill.Transparency = espTransparency

    if part.Parent and part.Parent.Name == "FakeGenerator" then
        fill.Color3 = Color3.fromRGB(255,0,0)
    else
        fill.Color3 = Color3.fromRGB(220,150,255)
    end

    fill.Parent = part
end

local function attachESPForExistingParts()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
            attachESP(v)
        end
    end
end

-- == Update Generators ==
local function updateGenerators()
    local rootMap = workspace:FindFirstChild("Map")
    if not rootMap then return end
    local ingame = rootMap:FindFirstChild("Ingame")
    if not ingame then return end
    local gameMap = ingame:FindFirstChild("Map")
    if not gameMap then return end

    for _, obj in ipairs(gameMap:GetDescendants()) do
        if obj.Name == "Generator" or obj.Name == "FakeGenerator" then
            local progress = obj:FindFirstChild("Progress")
            local lastProgress = trackedGenerators[obj]

            if obj.Name == "Generator" and progress and progress:IsA("ValueBase") then
                if lastProgress ~= progress.Value then
                    createOrUpdateProgressESP(obj, progress.Value)
                    trackedGenerators[obj] = progress.Value
                end
            elseif obj.Name == "FakeGenerator" then
                createOrUpdateProgressESP(obj, 0)
                trackedGenerators[obj] = 0
            elseif lastProgress ~= nil then
                createOrUpdateProgressESP(obj, nil)
                trackedGenerators[obj] = nil
            end
        end
    end
end

-- == Continuous Scale Update ==
local function updateAllESPSizes()
    for gen in pairs(trackedGenerators) do
        local billboard = gen:FindFirstChild("Progress_ESP")
        local adornee = gen.PrimaryPart or gen:FindFirstChildWhichIsA("BasePart")
        if billboard and adornee then
            local isFake = gen.Name == "FakeGenerator"
            local scale = calculateScale(adornee.Position, isFake)
            billboard.Size = UDim2.new(0, scale*10, 0, scale*3)
        end
    end
end

-- == Start/Stop ESP ==
local updateThrottle = 0
local function startGeneratorESP()
    attachESPForExistingParts()
    if not partEspTrigger then
        partEspTrigger = workspace.DescendantAdded:Connect(function(v)
            if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
                attachESP(v)
            end
        end)
    end
    if not espConnection then
        espConnection = RunService.RenderStepped:Connect(function(dt)
            if generatorESPEnabled then
                updateThrottle += dt
                if updateThrottle >= 0.25 then
                    updateGenerators()
                    updateThrottle = 0
                end
                updateAllESPSizes()
            end
        end)
    end
end

local function stopGeneratorESP()
    if partEspTrigger then
        partEspTrigger:Disconnect()
        partEspTrigger = nil
    end
    if espConnection then
        espConnection:Disconnect()
        espConnection = nil
    end
    for gen in pairs(trackedGenerators) do
        createOrUpdateProgressESP(gen, nil)
    end
    trackedGenerators = {}
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower() == partEspName:lower() then
            local adorn = v:FindFirstChild("ESP_Fill")
            if adorn then adorn:Destroy() end
        end
    end
end

local colorByName = {
	BloxyCola = Color3.fromRGB(255, 140, 0),
	Medkit = Color3.fromRGB(255, 100, 255),
}

local espParts = {}
local partEspTrigger = nil

local function FindInTable(tbl, value)
	for _, v in pairs(tbl) do
		if v == value then return true end
	end
	return false
end

local function createNameTag(part, tagName, color)
	if part:FindFirstChild("ESP_Billboard") then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Billboard"
	billboard.Size = UDim2.new(0, 100, 0, 30)
	billboard.Adornee = part
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.Parent = part

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = color
	textLabel.TextStrokeTransparency = 0
	textLabel.Text = tagName
	textLabel.Font = Enum.Font.SourceSansBold
	textLabel.TextScaled = false
	textLabel.TextSize = 10
	textLabel.Parent = billboard
end

local function createBoxESP(part)
	if not part or not part:IsA("BasePart") then return end
	if part.Name ~= "ItemRoot" or not part.Parent then return end

	local tagName = part.Parent.Name
	local color = colorByName[tagName] or Color3.fromRGB(255, 255, 255)

	if part:FindFirstChild(tagName.."_PESP") then return end

	local box = Instance.new("BoxHandleAdornment")
	box.Name = tagName.."_PESP"
	box.Adornee = part
	box.Size = part.Size
	box.Transparency = 0.5
	box.Color3 = color
	box.ZIndex = 0
	box.AlwaysOnTop = true
	box.Parent = part

	createNameTag(part, tagName, color)
	table.insert(espParts, tagName)
end

function enableItemESP()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "ItemRoot" then
			createBoxESP(v)
		end
	end

	if not partEspTrigger then
		partEspTrigger = workspace.DescendantAdded:Connect(function(part)
			if part:IsA("BasePart") and part.Name == "ItemRoot" then
				createBoxESP(part)
			end
		end)
	end
end

function disableItemESP()
	for _, v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") and v.Name == "ItemRoot" then
			if v:FindFirstChild("ESP_Billboard") then
				v:FindFirstChild("ESP_Billboard"):Destroy()
			end
			local tagName = v.Parent and v.Parent.Name
			if tagName and v:FindFirstChild(tagName.."_PESP") then
				v:FindFirstChild(tagName.."_PESP"):Destroy()
			end
		end
	end

	espParts = {}
	if partEspTrigger then
		partEspTrigger:Disconnect()
		partEspTrigger = nil
	end
end

ESP:CreateToggle({
	Name = "Items ESP",
	CurrentValue = false,
	Flag = "ItemESP_Toggle",
	Callback = function(Value)
		itemESPEnabled = Value
		if itemESPEnabled then
			enableItemESP()
		else
			disableItemESP()
		end
	end,
})

ESP:CreateToggle({
   Name = "Generators ESP",
   CurrentValue = false,
   Flag = "GeneratorsESP",
   Callback = function(Value)
      generatorESPEnabled = Value
      if Value then
         startGeneratorESP()
      else
         stopGeneratorESP()
      end
   end,
})

local ingame = workspace:WaitForChild("Map"):WaitForChild("Ingame")

--=====================
-- Builderman ESP
--=====================
local dispenserPartNames = { "SprayCan", "UpperHolder", "Root" }
local dispenserESPColor = Color3.fromRGB(0, 162, 255)
local sentryESPColor = Color3.fromRGB(128, 128, 128)
local espTransparency = 0.5

local function isDispenser(model)
	return model:IsA("Model") and model.Name:lower():find("dispenser")
end

local function isSentry(model)
	return model:IsA("Model") and model.Name:lower():find("sentry")
end

local function createBillboardESP(part, labelText, color)
	if part:FindFirstChild("BillboardESP") then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "BillboardESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.Adornee = part
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, part.Size.Y + 1, 0)
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextScaled = false
	label.TextSize = 13
	label.Parent = billboard
end

local function createDispenserESP(part)
	if not _G.DispenserESPEnabled then return end
	if not part:IsA("BasePart") then return end
	if not table.find(dispenserPartNames, part.Name) then return end

	if not part:FindFirstChild(part.Name.."_PESP") then
		local adorn = Instance.new("BoxHandleAdornment")
		adorn.Name = part.Name.."_PESP"
		adorn.Adornee = part
		adorn.AlwaysOnTop = true
		adorn.ZIndex = 0
		adorn.Size = part.Size
		adorn.Transparency = espTransparency
		adorn.Color3 = dispenserESPColor
		adorn.Parent = part
	end

	if part.Name == "SprayCan" and not part:FindFirstChild("BillboardESP") then
		createBillboardESP(part, "Dispenser", dispenserESPColor)
	end
end

local function createSentryESP(part)
	if not _G.SentryESPEnabled then return end
	if not part:IsA("BasePart") then return end
	if part.Name ~= "Root" then return end

	if not part:FindFirstChild("Root_PESP") then
		local adorn = Instance.new("BoxHandleAdornment")
		adorn.Name = "Root_PESP"
		adorn.Adornee = part
		adorn.AlwaysOnTop = true
		adorn.ZIndex = 0
		adorn.Size = part.Size
		adorn.Transparency = espTransparency
		adorn.Color3 = sentryESPColor
		adorn.Parent = part
	end

	if not part:FindFirstChild("BillboardESP") then
		createBillboardESP(part, "Sentry", sentryESPColor)
	end
end

--=====================
-- CustomESP cho Taph
--=====================
local CustomESP_tripwarePartNames = { "Hook1", "Hook2", "Wire" }
local CustomESP_tripwareColor = Color3.fromRGB(255, 85, 0)
local CustomESP_subspaceColor = Color3.fromRGB(160, 32, 240)
local CustomESP_espTransparency = 0.5

local function CustomESP_isTripware(model)
	return model:IsA("Model") and model.Name:find("TaphTripwire") ~= nil
end

local function CustomESP_isSubspace(model)
	return model:IsA("Model") and model.Name == "SubspaceTripmine"
end

local function CustomESP_createBillboard(part, labelText, color)
	if part:FindFirstChild("CustomESP_BillboardESP") then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "CustomESP_BillboardESP"
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.Adornee = part
	billboard.AlwaysOnTop = true
	billboard.StudsOffset = Vector3.new(0, part.Size.Y + 1, 0)
	billboard.Parent = part

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = color
	label.Font = Enum.Font.GothamBold
	label.TextScaled = false
	label.TextSize = 13
	label.Parent = billboard
end

local function CustomESP_createTripwareESP(part)
	if not _G.CustomESP_TripwareEnabled then return end
	if not part:IsA("BasePart") then return end
	if not table.find(CustomESP_tripwarePartNames, part.Name) then return end

	if not part:FindFirstChild(part.Name.."_CustomESP_PESP") then
		local adorn = Instance.new("BoxHandleAdornment")
		adorn.Name = part.Name.."_CustomESP_PESP"
		adorn.Adornee = part
		adorn.AlwaysOnTop = true
		adorn.ZIndex = 0
		adorn.Size = part.Size
		adorn.Transparency = CustomESP_espTransparency
		adorn.Color3 = CustomESP_tripwareColor
		adorn.Parent = part
	end

	if part.Name == "Wire" and not part:FindFirstChild("CustomESP_BillboardESP") then
		CustomESP_createBillboard(part, "Tripwire", CustomESP_tripwareColor)
	end
end

local function CustomESP_createSubspaceESP(part)
	if not _G.CustomESP_SubspaceEnabled then return end
	if not part:IsA("BasePart") then return end
	if part.Name ~= "SubspaceBox" then return end

	if not part:FindFirstChild("SubspaceBox_CustomESP_PESP") then
		local adorn = Instance.new("BoxHandleAdornment")
		adorn.Name = "SubspaceBox_CustomESP_PESP"
		adorn.Adornee = part
		adorn.AlwaysOnTop = true
		adorn.ZIndex = 0
		adorn.Size = part.Size
		adorn.Transparency = CustomESP_espTransparency
		adorn.Color3 = CustomESP_subspaceColor
		adorn.Parent = part
	end

	if not part:FindFirstChild("CustomESP_BillboardESP") then
		CustomESP_createBillboard(part, "Subspace Tripmine", CustomESP_subspaceColor)
	end
end

--=====================
-- Xoá ESP helper
--=====================
local function removeESPByNamePattern(parent, pattern)
	for _, child in ipairs(parent:GetChildren()) do
		if child.Name:find(pattern) then
			child:Destroy()
		end
	end
end

--=====================
-- Enable/Disable
--=====================
function EnableDispenserESP() _G.DispenserESPEnabled = true end
function DisableDispenserESP()
	_G.DispenserESPEnabled = false
	for _, part in ipairs(ingame:GetDescendants()) do
		if part.Parent and isDispenser(part.Parent) then
			removeESPByNamePattern(part, "_PESP")
			removeESPByNamePattern(part, "BillboardESP")
		end
	end
end

function EnableSentryESP() _G.SentryESPEnabled = true end
function DisableSentryESP()
	_G.SentryESPEnabled = false
	for _, part in ipairs(ingame:GetDescendants()) do
		if part.Parent and isSentry(part.Parent) then
			removeESPByNamePattern(part, "_PESP")
			removeESPByNamePattern(part, "BillboardESP")
		end
	end
end

function EnableTripwareESP() _G.CustomESP_TripwareEnabled = true end
function DisableTripwareESP()
	_G.CustomESP_TripwareEnabled = false
	for _, part in ipairs(ingame:GetDescendants()) do
		if part.Parent and CustomESP_isTripware(part.Parent) then
			removeESPByNamePattern(part, "_CustomESP_PESP")
			removeESPByNamePattern(part, "CustomESP_BillboardESP")
		end
	end
end

function EnableSubspaceESP() _G.CustomESP_SubspaceEnabled = true end
function DisableSubspaceESP()
	_G.CustomESP_SubspaceEnabled = false
	for _, part in ipairs(ingame:GetDescendants()) do
		if part.Parent and CustomESP_isSubspace(part.Parent) then
			removeESPByNamePattern(part, "_CustomESP_PESP")
			removeESPByNamePattern(part, "CustomESP_BillboardESP")
		end
	end
end

--=====================
-- Event lắng nghe object spawn
--=====================
ingame.DescendantAdded:Connect(function(part)
	local parent = part.Parent
	if parent then
		if isDispenser(parent) then createDispenserESP(part) end
		if isSentry(parent) then createSentryESP(part) end
		if CustomESP_isTripware(parent) then CustomESP_createTripwareESP(part) end
		if CustomESP_isSubspace(parent) then CustomESP_createSubspaceESP(part) end
	end
end)

--=====================
-- 1 vòng loop duy nhất update tất cả
--=====================
task.spawn(function()
	while true do
		local parts = ingame:GetDescendants()
		for _, part in ipairs(parts) do
			local parent = part.Parent
			if not parent then continue end
			if _G.DispenserESPEnabled and isDispenser(parent) then createDispenserESP(part) end
			task.wait(0.5)
			if _G.SentryESPEnabled and isSentry(parent) then createSentryESP(part) end
			task.wait(0.5)
			if _G.CustomESP_TripwareEnabled and CustomESP_isTripware(parent) then CustomESP_createTripwareESP(part) end
			task.wait(0.5)
			if _G.CustomESP_SubspaceEnabled and CustomESP_isSubspace(parent) then CustomESP_createSubspaceESP(part) end
			task.wait(0.5)
		end
		task.wait(2)
	end
end)

--=====================
-- Rayfield Toggles
--=====================
ESP:CreateSection("Builderman ESP")
ESP:CreateToggle({
	Name = "Dispenser ESP",
	CurrentValue = false,
	Flag = "ToggleBuilderDispenserESP",
	Callback = function(v) if v then EnableDispenserESP() else DisableDispenserESP() end end
})
ESP:CreateToggle({
	Name = "Sentry ESP",
	CurrentValue = false,
	Flag = "ToggleBuilderSentryESP",
	Callback = function(v) if v then EnableSentryESP() else DisableSentryESP() end end
})

ESP:CreateSection("Taph ESP")
ESP:CreateToggle({
	Name = "Tripwire ESP",
	CurrentValue = false,
	Flag = "ToggleBuilderTripwareESP",
	Callback = function(v) if v then EnableTripwareESP() else DisableTripwareESP() end end
})
ESP:CreateToggle({
	Name = "Subspace Tripmine ESP",
	CurrentValue = false,
	Flag = "ToggleBuilderSubspaceESP",
	Callback = function(v) if v then EnableSubspaceESP() else DisableSubspaceESP() end end
})

local Camera = workspace.CurrentCamera

getgenv().AimbotConfig = getgenv().AimbotConfig or {}

getgenv().AimbotConfig.Slash = getgenv().AimbotConfig.Slash or { Enabled = false, Smoothness = 1, Prediction = 0.25, Duration = 2 }
getgenv().AimbotConfig.Shoot = getgenv().AimbotConfig.Shoot or { Enabled = false, Smoothness = 1, Prediction = 0.25, Duration = 1.3 }
getgenv().AimbotConfig.TrueShoot = getgenv().AimbotConfig.TrueShoot or { Enabled = false, Smoothness = 1, Prediction = 0.25, Duration = 1.3 }
getgenv().AimbotConfig.ThrowPizza = getgenv().AimbotConfig.ThrowPizza or { Enabled = false, Smoothness = 1, Prediction = 0.25, Duration = 1.5 }
getgenv().AimbotConfig.Killers = getgenv().AimbotConfig.Killers or { Enabled = false, Duration = 3 }
getgenv().AimbotConfig.SelectedSkills = getgenv().AimbotConfig.SelectedSkills or {
    "Slash", "Punch", "Stab", "Nova", "VoidRush", 
    "WalkspeedOverride", "Behead", "GashingWound", 
    "CorruptNature", "CorruptEnergy", "MassInfection", "Entanglement"
}
------------------------------------------------
-- GUI
Aimbot:CreateSection("Shedletsky")
-- Slash
Aimbot:CreateToggle({
    Name = "Aimbot Slash",
    CurrentValue = getgenv().AimbotConfig.Slash.Enabled,
    Flag = "AutoAimSlash",
    Callback = function(Value)
        getgenv().AimbotConfig.Slash.Enabled = Value
    end,
})

Aimbot:CreateSlider({
    Name = "Smoothness Slash",
    Range = {0, 101},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = getgenv().AimbotConfig.Slash.Smoothness * 100,
    Flag = "SmoothnessSlash",
    Callback = function(Value)
        getgenv().AimbotConfig.Slash.Smoothness = Value / 100
    end,
})

Aimbot:CreateSlider({
    Name = "Prediction Slash",
    Range = {0, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = getgenv().AimbotConfig.Slash.Prediction,
    Flag = "PredictionSlash",
    Callback = function(Value)
        getgenv().AimbotConfig.Slash.Prediction = Value
    end,
})

------------------------------------------------
Aimbot:CreateSection("Chance")
-- Shoot
Aimbot:CreateToggle({
    Name = "Aimbot Shoot",
    CurrentValue = getgenv().AimbotConfig.Shoot.Enabled,
    Flag = "AutoAimShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.Shoot.Enabled = Value
    end,
})

Aimbot:CreateSlider({
    Name = "Smoothness Shoot",
    Range = {0, 101},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = getgenv().AimbotConfig.Shoot.Smoothness * 100,
    Flag = "SmoothnessShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.Shoot.Smoothness = Value / 100
    end,
})

Aimbot:CreateSlider({
    Name = "Prediction Shoot",
    Range = {0, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = getgenv().AimbotConfig.Shoot.Prediction,
    Flag = "PredictionShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.Shoot.Prediction = Value
    end,
})

------------------------------------------------
Aimbot:CreateParagraph({Title = "True Shoot Aimbot", Content = "For Chance True Shoot Only"})

Aimbot:CreateToggle({
    Name = "Aimbot True Shoot",
    CurrentValue = getgenv().AimbotConfig.TrueShoot.Enabled,
    Flag = "AutoAimTrueShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.TrueShoot.Enabled = Value
    end,
})

Aimbot:CreateSlider({
    Name = "Smoothness True Shoot",
    Range = {0, 101},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = getgenv().AimbotConfig.TrueShoot.Smoothness * 100,
    Flag = "SmoothnessTrueShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.TrueShoot.Smoothness = Value / 100
    end,
})

Aimbot:CreateSlider({
    Name = "Prediction True Shoot",
    Range = {0, 2},
    Increment = 0.05,
    Suffix = "s",
    CurrentValue = getgenv().AimbotConfig.TrueShoot.Prediction,
    Flag = "PredictionTrueShoot",
    Callback = function(Value)
        getgenv().AimbotConfig.TrueShoot.Prediction = Value
    end,
})

------------------------------------------------
Aimbot:CreateSection("Elliot")

Aimbot:CreateToggle({
    Name = "Aimbot Throw Pizza",
    CurrentValue = getgenv().AimbotConfig.ThrowPizza.Enabled,
    Flag = "AutoAimThrowPizza",
    Callback = function(Value)
        getgenv().AimbotConfig.ThrowPizza.Enabled = Value
    end,
})

Aimbot:CreateSlider({
    Name = "Smoothness Throw Pizza",
    Range = {0, 101},
    Increment = 1,
    Suffix = "ms",
    CurrentValue = getgenv().AimbotConfig.ThrowPizza.Smoothness * 100,
    Flag = "SmoothnessThrowPizza",
    Callback = function(Value)
        getgenv().AimbotConfig.ThrowPizza.Smoothness = Value / 100
    end,
})

Aimbot:CreateSlider({
    Name = "Prediction Throw Pizza",
    Range = {0, 2},
    Increment = 0.2,
    Suffix = "s",
    CurrentValue = getgenv().AimbotConfig.ThrowPizza.Prediction,
    Flag = "PredictionThrowPizza",
    Callback = function(Value)
        getgenv().AimbotConfig.ThrowPizza.Prediction = Value
    end,
})

------------------------------------------------
Aimbot:CreateSection("Killers")

Aimbot:CreateToggle({
    Name = "Killers's Aimbot",
    CurrentValue = getgenv().AimbotConfig.Killers.Enabled,
    Flag = "EnableAimbotAll",
    Callback = function(Value)
        getgenv().AimbotConfig.Killers.Enabled = Value
    end,
})

------------------------------------------------
-- Hàm kiểm tra skill Killers
local function isKillerSkill(skillName)
    for _, v in ipairs(getgenv().AimbotConfig.SelectedSkills) do
        if v == skillName then return true end
    end
    return false
end

-- Hàm lấy mục tiêu gần nhất theo khoảng cách
local function getNearestTargetByDistance()
    local nearest
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myPos = myChar.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myPos).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                nearest = player
            end
        end
    end
    return nearest
end

-- Hàm lấy mục tiêu có MaxHP lớn hơn 300
local function getNearestTargetByMaxHP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.MaxHealth > 300 then
                return player
            end
        end
    end
end

-- Aim vào rootpart (dùng cho các kỹ năng cận chiến)
local function aimrootpart(target, duration, prediction, smoothness)
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not target or not target.Character then return end
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    if not root or not myRoot then return end

    task.spawn(function()
        local start = tick()
        while tick() - start < duration and root.Parent and myRoot.Parent do
            local predictedPos = root.Position + (root.Velocity * prediction)
            local targetCFrame = CFrame.lookAt(myRoot.Position, predictedPos)
            myRoot.CFrame = myRoot.CFrame:Lerp(targetCFrame, math.clamp(smoothness, 0, 1))
            task.wait()
        end
    end)
end

-- Aimlock vào camera (dùng cho kỹ năng bắn xa)
local function aimlock(target, duration, prediction, smoothness)
    local start = tick()
    local cam = workspace.CurrentCamera
    local conn
    conn = RunService.RenderStepped:Connect(function()
        if tick() - start > duration or not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then
            conn:Disconnect()
            return
        end
        local hrp = target.Character.HumanoidRootPart
        local pos = hrp.Position + (hrp.Velocity * prediction)
        local cf = CFrame.new(cam.CFrame.Position, pos)
        cam.CFrame = cam.CFrame:Lerp(cf, math.clamp(smoothness, 0, 1))
    end)
end

------------------------------------------------
-- Xử lý sự kiện skill
RemoteEvent.OnClientEvent:Connect(function(...)
    local args = {...}
    if args[1] == "UseActorAbility" then
        local skill = args[2]
        local player = getgenv().Player
        local character = getgenv().getCharacter()

        if character and skill == "Slash" 
           and getgenv().AimbotConfig.Slash.Enabled 
           and character.Name == "Shedletsky" then

            local target = getNearestTargetByMaxHP()
            if target then
                aimrootpart(
                    target, 
                    getgenv().AimbotConfig.Slash.Duration, 
                    getgenv().AimbotConfig.Slash.Prediction, 
                    getgenv().AimbotConfig.Slash.Smoothness
                )
            end
        end

        -- Shoot
        if skill == "Shoot" then
            if getgenv().AimbotConfig.Shoot.Enabled then
                local target = getNearestTargetByMaxHP()
                if target then
                    aimrootpart(target, getgenv().AimbotConfig.Shoot.Duration, getgenv().AimbotConfig.Shoot.Prediction, getgenv().AimbotConfig.Shoot.Smoothness)
                end
            end

            if getgenv().AimbotConfig.TrueShoot.Enabled then
                local target = getNearestTargetByMaxHP()
                if target then
                    aimlock(target, getgenv().AimbotConfig.TrueShoot.Duration, getgenv().AimbotConfig.TrueShoot.Prediction, getgenv().AimbotConfig.TrueShoot.Smoothness)
                end
            end
        end

        -- ThrowPizza
        if skill == "ThrowPizza" and getgenv().AimbotConfig.ThrowPizza.Enabled then
            local target = getNearestTargetByDistance()
            if target then
                aimrootpart(target, getgenv().AimbotConfig.ThrowPizza.Duration, getgenv().AimbotConfig.ThrowPizza.Prediction, getgenv().AimbotConfig.ThrowPizza.Smoothness)
            end
        end

        -- Killers
        if getgenv().AimbotConfig.Killers.Enabled and isKillerSkill(skill) then
            local target = getNearestTargetByDistance()
            if target then
                aimlock(target, getgenv().AimbotConfig.Killers.Duration, 0, 1)
            end
        end
    end
end)


local staminaLoopToggle = false
local maxStamina = 100
local minStamina = 0
local staminaGain = 20
local staminaLoss = 10
local sprintSpeed = 26
local staminaLossDisabled = false

StaminaSet:CreateToggle({
   Name = "Inj3ct Stamina",
   CurrentValue = false,
   Flag = "StaminaLoopToggle",
   Callback = function(Value)
      staminaLoopToggle = Value
   end,
})

StaminaSet:CreateInput({
   Name = "Max Stamina",
   PlaceholderText = "e.g. 100",
   CurrentValue = tostring(maxStamina),
   RemoveTextAfterFocusLost = false,
   Flag = "MaxStaminaInput",
   Callback = function(Text)
      maxStamina = tonumber(Text) or maxStamina
   end,
})

StaminaSet:CreateInput({
   Name = "Min Stamina",
   PlaceholderText = "e.g. 0",
   CurrentValue = tostring(minStamina),
   RemoveTextAfterFocusLost = false,
   Flag = "MinStaminaInput",
   Callback = function(Text)
      minStamina = tonumber(Text) or minStamina
   end,
})

StaminaSet:CreateInput({
   Name = "Stamina Gain",
   PlaceholderText = "e.g. 10",
   CurrentValue = tostring(staminaGain),
   RemoveTextAfterFocusLost = false,
   Flag = "StaminaGainInput",
   Callback = function(Text)
      staminaGain = tonumber(Text) or staminaGain
   end,
})

StaminaSet:CreateInput({
   Name = "Stamina Loss",
   PlaceholderText = "e.g. 10",
   CurrentValue = tostring(staminaLoss),
   RemoveTextAfterFocusLost = false,
   Flag = "StaminaLossInput",
   Callback = function(Text)
      staminaLoss = tonumber(Text) or staminaLoss
   end,
})

StaminaSet:CreateInput({
   Name = "Sprint Speed",
   PlaceholderText = "e.g. 26",
   CurrentValue = tostring(sprintSpeed),
   RemoveTextAfterFocusLost = false,
   Flag = "SprintSpeedInput",
   Callback = function(Text)
      sprintSpeed = tonumber(Text) or sprintSpeed
   end,
})

StaminaSet:CreateToggle({
   Name = "Disable Stamina Loss",
   CurrentValue = false,
   Flag = "ToggleStaminaLossDisabled",
   Callback = function(Value)
      staminaLossDisabled = Value
   end,
})

task.spawn(function()
   local Sprinting = game:GetService("ReplicatedStorage"):WaitForChild("Systems"):WaitForChild("Character"):WaitForChild("Game"):WaitForChild("Sprinting")
   local stamina = require(Sprinting)

   local defaultValues = {
      MaxStamina = 100,
      MinStamina = 0,
      StaminaGain = 20,
      StaminaLoss = 10,
      SprintSpeed = 26,
   }

   while task.wait() do
      if staminaLoopToggle then
         stamina.MaxStamina = maxStamina
         stamina.MinStamina = minStamina
         stamina.StaminaGain = staminaGain
         stamina.StaminaLoss = staminaLoss
         stamina.SprintSpeed = sprintSpeed
         stamina.StaminaLossDisabled = staminaLossDisabled
      else
         stamina.MaxStamina = defaultValues.MaxStamina
         stamina.MinStamina = defaultValues.MinStamina
         stamina.StaminaGain = defaultValues.StaminaGain
         stamina.StaminaLoss = defaultValues.StaminaLoss
         stamina.SprintSpeed = defaultValues.SprintSpeed
         stamina.StaminaLossDisabled = false
      end
   end
end)

local char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()

Players.LocalPlayer.CharacterAdded:Connect(function(v)
	char = v
end)

-- Khởi tạo genv biến toàn cục
getgenv().Players = game:GetService("Players")
getgenv().ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().player = getgenv().Players.LocalPlayer
getgenv().device = getgenv().player:GetAttribute("Device")

-- Nếu device là table, lấy phần tử đầu tiên
if type(getgenv().device) == "table" then
    getgenv().device = genv().device[1]
end

getgenv().device = tostring(getgenv().device or "PC") -- đảm bảo là string và có giá trị mặc định

-- Tạo section cho GUI
Miscs:CreateSection("Device")

-- Tạo dropdown
Miscs:CreateDropdown({
    Name = "Spoof Device",
    Options = {"PC", "Mobile", "Console"},
    CurrentOption = getgenv().device,
    MultipleOptions = false,
    Callback = function(selectedOption)
        local selected = selectedOption[1]
        RemoteEvent:FireServer("SetDevice", selected)
    end,
})


Miscs:CreateSection("Footsteps")
Miscs:CreateToggle({
    Name = "Anti Footsteps",
    CurrentValue = false,
    Flag = "AntiFootsteps",
    Callback = function(value)
		if value then
			getgenv().HookFootstepPlayed(true)
		else
			getgenv().HookFootstepPlayed(false)
        end
    end,
})

-- Dùng getgenv() để lưu biến toàn cục
getgenv().Players = game:GetService("Players")
getgenv().originalValues = {}
getgenv().paths = {
    "HideKillerWins",
    "HidePlaytime",
    "HideSurvivorWins"
}
getgenv().toggleState = false

-- Hàm lưu giá trị gốc của một player
getgenv().saveOriginalValues = function(player)
    if not getgenv().originalValues[player.UserId] then
        getgenv().originalValues[player.UserId] = {}
    end
    for _, key in ipairs(getgenv().paths) do
        local value = player:FindFirstChild("PlayerData")
            and player.PlayerData:FindFirstChild("Settings")
            and player.PlayerData.Settings:FindFirstChild("Privacy")
            and player.PlayerData.Settings.Privacy:FindFirstChild(key)
        if value then
            getgenv().originalValues[player.UserId][key] = value.Value
        end
    end
end

-- Hàm đặt tất cả value = false
getgenv().setAllFalse = function(player)
    for _, key in ipairs(getgenv().paths) do
        local value = player:FindFirstChild("PlayerData")
            and player.PlayerData:FindFirstChild("Settings")
            and player.PlayerData.Settings:FindFirstChild("Privacy")
            and player.PlayerData.Settings.Privacy:FindFirstChild(key)
        if value then
            value.Value = false
        end
    end
end

-- Hàm khôi phục giá trị gốc
getgenv().restoreValues = function(player)
    if getgenv().originalValues[player.UserId] then
        for key, val in pairs(getgenv().originalValues[player.UserId]) do
            local value = player:FindFirstChild("PlayerData")
                and player.PlayerData:FindFirstChild("Settings")
                and player.PlayerData.Settings:FindFirstChild("Privacy")
                and player.PlayerData.Settings.Privacy:FindFirstChild(key)
            if value then
                value.Value = val
            end
        end
    end
end

-- Hàm toggle
getgenv().togglePrivacy = function(disable)
    for _, player in ipairs(getgenv().Players:GetPlayers()) do
        if disable then
            getgenv().saveOriginalValues(player)
            getgenv().setAllFalse(player)
        else
            getgenv().restoreValues(player)
        end
    end
    getgenv().toggleState = disable
end

-- Khi có player mới vào, nếu toggle đang bật thì set false luôn
getgenv().Players.PlayerAdded:Connect(function(player)
    if getgenv().toggleState == true then
        getgenv().saveOriginalValues(player)
        getgenv().setAllFalse(player)
    end
end)

Miscs:CreateSection("Stats")
Miscs:CreateToggle({
    Name = "Anti Hidden Stats",
    CurrentValue = false,
    Flag = "AntiHiddenStats",
    Callback = function(value)
		if value then
			getgenv().togglePrivacy(true)
		else
			getgenv().togglePrivacy(false)
        end
    end,
})

Miscs:CreateSection("FOV")
Miscs:CreateInput({
    Name = "Input FOV",
    PlaceholderText = "80", -- text gợi ý mặc định
    RemoveTextAfterFocusLost = false,
    Flag = "FOVInput",
    Callback = function(thefoxtext)
        -- chuyển chuỗi nhập thành số
        local fovvalueinput = tonumber(thefoxtext)
        if fovvalueinput then
            game:GetService("ReplicatedStorage")
                :WaitForChild("Modules")
                :WaitForChild("Network")
                :WaitForChild("RemoteEvent")
                :FireServer(
                    "UpdateSettings",
                    game:GetService("Players").LocalPlayer
                        :WaitForChild("PlayerData")
                        :WaitForChild("Settings")
                        :WaitForChild("Game")
                        :WaitForChild("FieldOfView"),
                    fovvalueinput
                )
        end
    end,
})

Miscs:CreateSection("Items")

local RoundTimer = ReplicatedStorage:WaitForChild("RoundTimer")
local autoPickupEnabled = true

-- Check còn sống
local function isAlive(char)
	return char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0
end

-- Khi TimeLeft = 0
local hasDropped = false
RoundTimer:GetAttributeChangedSignal("TimeLeft"):Connect(function()
	if not autoPickupEnabled or hasDropped then return end

	local timeLeft = RoundTimer:GetAttribute("TimeLeft")
	if timeLeft and timeLeft <= 0.2 then
		local char = game:GetService("Players").LocalPlayer.Character
		if not char then return end

		-- Equip tất cả tool từ Backpack
		for _, v in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
			if v:IsA("Tool") then
				v.Parent = char
			end
		end
		task.wait()

		-- Drop tool ra workspace
		for _, v in pairs(char:GetChildren()) do
			if v:IsA("Tool") then
				v.Parent = workspace
			end
		end

		hasDropped = true
	end
end)

-- Auto Pickup Tool khi còn sống
task.spawn(function()
	while task.wait(1) do
		local char = game:GetService("Players").LocalPlayer.Character
		if autoPickupEnabled and isAlive(char) then
			local mapIngame = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Ingame")
			if mapIngame then
				for _, tool in ipairs(mapIngame:GetChildren()) do
					if tool:IsA("Tool") then
						char.Humanoid:EquipTool(tool)
					end
				end
			end
		end
	end
end)

Miscs:CreateToggle({
	Name = "Auto Pickup Drop Items (Working Ingame/Lobby)",
	CurrentValue = false,
	Flag = "AutoPickupTool",
	Callback = function(Value)
		autoPickupEnabled = Value
	end,
})

_G.pickUpNear = false
_G.pickUpAll = false

local function autoPickUpLoop()
    while task.wait(0.2) do
        if not _G.pickUpNear and not _G.pickUpAll then break end

        pcall(function()
            local items = {}
            for _, v in pairs(workspace.Map.Ingame:GetDescendants()) do
                if v:IsA("Tool") then
                    table.insert(items, v.ItemRoot)
                end
            end

            for _, v in pairs(items) do
                if _G.pickUpNear then
                    local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Position).magnitude
                    if magnitude <= 10 then
                        fireproximityprompt(v.ProximityPrompt)
                    end
                end

                if _G.pickUpAll then
                    if not game.Players.LocalPlayer.Backpack:FindFirstChild(v.Parent.Name) then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
                        task.wait(0.3)
                        fireproximityprompt(v.ProximityPrompt)
                    end
                end
            end
        end)
    end
end

Miscs:CreateToggle({
    Name = "Auto Pick Up Near Items",
    CurrentValue = false,
    Flag = "AutoPickUpItems",
    Callback = function(call)
        _G.pickUpNear = call
        if call then
            task.spawn(autoPickUpLoop)
        end
    end,
})

Miscs:CreateToggle({
    Name = "Auto Pick Up All Items",
    CurrentValue = false,
    Flag = "AutoPickUpAll",
    Callback = function(call)
        _G.pickUpAll = call
        if call then
            task.spawn(autoPickUpLoop)
        end
    end,
})

-- === Section Creation ===
Miscs:CreateSection("Invisibility")


-- === Animation Loop ===
local animationId = "75804462760596"
local animationSpeed = 0
local loopRunning = false
local loopThread
local currentAnim = nil

Miscs:CreateToggle({
   Name = "Invisibility",
   CurrentValue = false,
   Flag = "ToggleAnimLoop",
   Callback = function(Value)
      loopRunning = Value

      local speaker = Players.LocalPlayer
      if not speaker or not speaker.Character then return end

      local humanoid = speaker.Character:FindFirstChildOfClass("Humanoid")
      if not humanoid or humanoid.RigType ~= Enum.HumanoidRigType.R6 then
         Rayfield:Notify({
            Title = "R6 Required",
            Content = "This only works with R6 rig!",
            Duration = 5
         })
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
   end,
})

local Survivors = workspace:WaitForChild("Players"):WaitForChild("Survivors")

-- Cấu hình các loại Anti-Slow
local AntiSlowConfigs = {
    Slowness = {Values = {"SlowedStatus"}, Connection = nil, Enabled = false},
    Skills = {Values = {"StunningKiller", "EatFriedChicken", "GuestBlocking", "PunchAbility", "SubspaceTripmine",
                        "TaphTripwire", "PlasmaBeam", "SpawnProtection", "c00lgui", "ShootingGun", 
                        "TwoTimeStab", "TwoTimeCrouching", "DrinkingCola", "DrinkingSlateskin", 
                        "SlateskinStatus", "EatingGhostburger"}, Connection = nil, Enabled = false},
    Items = {Values = {"BloxyColaItem", "Medkit"}, Connection = nil, Enabled = false},
    Emotes = {Values = {"Emoting"}, Connection = nil, Enabled = false},
    Builderman = {Values = {"DispenserConstruction", "SentryConstruction"}, Connection = nil, Enabled = false}
}

-- Hàm ẩn UI báo slow
local function hideSlownessUI()
    local mainUI = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("MainUI")
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
    if survivor:GetAttribute("Username") ~= game:GetService("Players").LocalPlayer.Name then return end
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

-- Tạo toggle cho từng loại
for name, config in pairs(AntiSlowConfigs) do
    AntiSlows:CreateToggle({
        Name = "Anti-Slow " .. name,
        CurrentValue = false,
        Flag = "AntiSlow" .. name,
        Callback = function(value)
            if value then
                startAntiSlow(config)
            else
                stopAntiSlow(config)
            end
        end
    })
end

Miscs:CreateSection("1x1x1x1")

Miscs:CreateToggle({
    Name = "Auto Close 1x1x1x1 Popups",
    CurrentValue = false,
    Flag = "Toggle_1x1Popup",
    Callback = function(Value)
        DoLoop = Value
        task.spawn(function()
            local player = game:GetService("Players").LocalPlayer
            local Survivors = workspace:WaitForChild("Players"):WaitForChild("Survivors")
            while DoLoop and task.wait() do
                -- Auto Close 1x1x1x1 Popups
                local temp = player.PlayerGui:FindFirstChild("TemporaryUI")
                if temp and temp:FindFirstChild("1x1x1x1Popup") then
                    temp["1x1x1x1Popup"]:Destroy()
                end

                -- Anti-Slow SlowedStatus
                for _, survivor in pairs(Survivors:GetChildren()) do
                    if survivor:GetAttribute("Username") == player.Name then
                        -- SpeedMultipliers
                        local speedMultipliers = survivor:FindFirstChild("SpeedMultipliers")
                        if speedMultipliers then
                            local val = speedMultipliers:FindFirstChild("SlowedStatus")
                            if val and val:IsA("NumberValue") then
                                val.Value = 1
                            end
                        end
                        -- FOVMultipliers
                        local fovMultipliers = survivor:FindFirstChild("FOVMultipliers")
                        if fovMultipliers then
                            local val = fovMultipliers:FindFirstChild("SlowedStatus")
                            if val and val:IsA("NumberValue") then
                                val.Value = 1
                            end
                        end
                    end
                end
            end
        end)
    end
})

getgenv().LMSSongs = {
    ["Burnout"] = "rbxassetid://130101085745481",
    ["Compass"] = "rbxassetid://127298326178102",
    ["Vanity"] = "rbxassetid://137266220091579",
    ["Close To Me"] = "rbxassetid://90022574613230",
    ["Plead"] = "rbxassetid://80564889711353",
    ["Creation Of Hatred"] = "rbxassetid://115884097233860",
}

getgenv().selectedSong = "Compass"

getgenv().currentLastSurvivor = nil
getgenv().currentSongId = nil
getgenv().originalSongId = nil

getgenv().isToggleOn = false

Miscs:CreateSection("Last Man Standing")

Miscs:CreateToggle({
    Name = "LMS Replacer Song",
    CurrentValue = false,
    Flag = "LMS_Toggle",
    Callback = function(value)
        getgenv().isToggleOn = value
        local theme = game.Workspace:FindFirstChild("Themes")
        if not theme then return end
        local lastSurvivor = theme:FindFirstChild("LastSurvivor")
        if not lastSurvivor then return end

        if value then

            if not getgenv().originalSongId then
                getgenv().originalSongId = lastSurvivor.SoundId
            end
            local songId = getgenv().LMSSongs[getgenv().selectedSong]
            if songId then
                lastSurvivor.SoundId = songId
                lastSurvivor:Play()
                getgenv().currentLastSurvivor = lastSurvivor
                getgenv().currentSongId = songId
            end
        else

            if getgenv().originalSongId then
                lastSurvivor.SoundId = getgenv().originalSongId
                lastSurvivor:Play()
            end
            getgenv().currentLastSurvivor = nil
            getgenv().currentSongId = nil
            getgenv().originalSongId = nil
        end
    end,
})

Miscs:CreateDropdown({
    Name = "LMS Song",
    Options = {"Burnout", "Compass", "Vanity", "Close To Me", "Plead", "Creation Of Hatred"},
    CurrentOption = selectedSong,
    MultipleOptions = false,
    Callback = function(mysongslist)
        if type(mysongslist) == "table" then
            getgenv().selectedSong = mysongslist[1]
        else
            getgenv().selectedSong = mysongslist
        end

        if getgenv().isToggleOn then
            local theme = game.Workspace:FindFirstChild("Themes")
            if theme then
                local lastSurvivor = theme:FindFirstChild("LastSurvivor")
                if lastSurvivor then
                    local songId = getgenv().LMSSongs[getgenv().selectedSong]
                    if songId then
                        lastSurvivor.SoundId = songId
                        lastSurvivor:Play()
                        getgenv().currentLastSurvivor = lastSurvivor
                        getgenv().currentSongId = songId
                    end
                end
            end
        end
    end,
})

-- Sử dụng getgenv() để lưu biến toàn cục
getgenv().chatWindow = game:GetService("TextChatService"):WaitForChild("ChatWindowConfiguration")
getgenv().chatEnabled = false
getgenv().connection = nil

Miscs:CreateSection("Chat")
Miscs:CreateToggle({
    Name = "Toggle Chat Visibility",
    CurrentValue = false,
    Flag = "ChatWindowToggle",
    Callback = function(value)
        getgenv().chatEnabled = value
        if getgenv().chatEnabled then
            -- Kết nối Heartbeat để bật liên tục
            getgenv().connection = game:GetService("RunService").RenderStepped:Connect(function()
                getgenv().chatWindow.Enabled = true
            end)
        else
            -- Ngắt kết nối Heartbeat khi toggle tắt
            if getgenv().connection then
                getgenv().connection:Disconnect()
                getgenv().connection = nil
            end
            -- Tắt chat window khi toggle off
            getgenv().chatWindow.Enabled = false
        end
    end
})

-- Variables
getgenv().Players = game:GetService("Players")
getgenv().LocalPlayer = getgenv().Players.LocalPlayer
getgenv().Remote = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent

-- Lấy global environment an toàn
local globalEnv = getgenv()

-- Khai báo các service
globalEnv.Players = game:GetService("Players")
globalEnv.RunService = game:GetService("RunService")
globalEnv.Camera = workspace.CurrentCamera
globalEnv.Player = globalEnv.Players.LocalPlayer

-- Biến cấu hình
globalEnv.walkSpeed = 100 -- tốc độ di chuyển
globalEnv.blockAnimationId = {18885940850, 18885937766}
globalEnv.toggle = false -- trạng thái bật/tắt
globalEnv.connection = nil

-- Hàm lấy Character
function globalEnv.getCharacter()
    return globalEnv.Player.Character or globalEnv.Player.CharacterAdded:Wait()
end

-- Heartbeat loop
function globalEnv.onHeartbeat()
    local player = globalEnv.Player
    local character = globalEnv.getCharacter()

    if character.Name ~= "c00lkidd" then return end
    local char = globalEnv.getCharacter()
    local rootPart = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local lv = rootPart and rootPart:FindFirstChild("LinearVelocity")
    if not rootPart or not humanoid or not lv then return end

    if lv then
        lv.VectorVelocity = Vector3.new(math.huge, math.huge, math.huge)
        lv.Enabled = false -- Tắt LinearVelocity
    end

-- Biến kiểm soát dừng di chuyển
local stopMovement = false

-- Hàm kiểm tra giá trị của Result
local validValues = {
    Timeout = true,
    Collide = true,
    Hit = true
}

local function watchResult(result)
    local function checkValue()
        if validValues[result.Value] then
            stopMovement = true
        end
    end
    checkValue()
    result:GetPropertyChangedSignal("Value"):Connect(checkValue)
end

-- Khi Character xuất hiện
local function onCharacterAdded(character)
    local result = character:FindFirstChild("Result")
    if result and result:IsA("StringValue") then
        watchResult(result)
    end
    character.ChildAdded:Connect(function(child)
        if child.Name == "Result" and child:IsA("StringValue") then
            watchResult(child)
        end
    end)
end

-- Lắng nghe khi Player có Character
Player.CharacterAdded:Connect(onCharacterAdded)
if Player.Character then
    onCharacterAdded(Player.Character)
end

    if not stopMovement then
        local lookVector = globalEnv.Camera.CFrame.LookVector
        local moveDir = Vector3.new(lookVector.X, 0, lookVector.Z)
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit
            rootPart.Velocity = Vector3.new(moveDir.X * globalEnv.walkSpeed, rootPart.Velocity.Y, moveDir.Z * globalEnv.walkSpeed)
            rootPart.CFrame = CFrame.new(rootPart.Position, rootPart.Position + moveDir)
        end
    end
end

-- Tạo hook chung
getgenv().createHook = function(remoteName)
    getgenv()["original_" .. remoteName] = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}

        if self == getgenv().Remote and method == "FireServer" then
            if args[1] == getgenv().LocalPlayer.Name .. remoteName then
                return -- block
            end
        end

        return getgenv()["original_" .. remoteName](self, ...) -- gọi hook gốc
    end)
    return getgenv()["original_" .. remoteName]
end

getgenv().isFiringDusekkar = false

-- Bật hook
getgenv().enableHook = function(remoteName)
    if not getgenv()["hook_" .. remoteName] then
        getgenv()["hook_" .. remoteName] = getgenv().createHook(remoteName)
    end

    if remoteName == "DusekkarCancel" then
        if not getgenv().isFiringDusekkar then
            getgenv().isFiringDusekkar = true
            task.spawn(function()
                task.wait(4)
                local ReplicatedStorage = game:GetService("ReplicatedStorage")
                local RemoteEvent = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
                RemoteEvent:FireServer({game:GetService("Players").LocalPlayer.Name .. "DusekkarCancel"})
                getgenv().isFiringDusekkar = false -- cho phép gọi lại khi cần
            end)
        end
    end
end

-- Tắt hook
getgenv().disableHook = function(remoteName)
    if getgenv()["hook_" .. remoteName] then
        hookmetamethod(game, "__namecall", getgenv()["hook_" .. remoteName]) -- phục hồi hook gốc

        getgenv()["hook_" .. remoteName] = nil
        getgenv()["original_" .. remoteName] = nil
    end
end

-- Cài đặt các hàm cho từng loại
getgenv().EnableC00lkidd = function() getgenv().enableHook("C00lkiddCollision") end
getgenv().DisableC00lkidd = function() getgenv().disableHook("C00lkiddCollision") end

getgenv().EnableVoidRush = function() getgenv().enableHook("VoidRushCollision") end
getgenv().DisableVoidRush = function() getgenv().disableHook("VoidRushCollision") end

getgenv().EnableCharge = function() getgenv().enableHook("Guest1337Collision") end
getgenv().DisableCharge = function() getgenv().disableHook("Guest1337Collision") end

getgenv().EnableProtection = function() getgenv().enableHook("DusekkarCancel") end
getgenv().DisableProtection = function() getgenv().disableHook("DusekkarCancel") end

getgenv().blockFootstepPlayed = false

getgenv().HookFootstepPlayed = function(enable)
    if enable then
        if not getgenv().originalFootstepHook then
            getgenv().originalFootstepHook = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                local args = {...}

                -- Chặn FootstepPlayed trong UnreliableRemoteEvent
                if method == "FireServer" and self.Name == "UnreliableRemoteEvent" then
                    if args[1] == "FootstepPlayed" and getgenv().blockFootstepPlayed then
                        return -- Block FootstepPlayed
                    end
                end

                return getgenv().originalFootstepHook(self, ...)
            end)
        end
        getgenv().blockFootstepPlayed = true
    else
        getgenv().blockFootstepPlayed = false
    end
end

Combat:CreateSection("c00lkidd")
Combat:CreateToggle({
    Name = "Walkspeed Override Controller",
    CurrentValue = false,
    Flag = "AutoMove",
    Callback = function(value)
        if value then
            globalEnv.connection = globalEnv.RunService.Heartbeat:Connect(globalEnv.onHeartbeat)
        else
            if globalEnv.connection then
                globalEnv.connection:Disconnect()
            end
        end
    end
})

Combat:CreateToggle({
    Name = "Walkspeed-Override Ignore Objectables",
    CurrentValue = false,
    Flag = "IgnoreC00lkidd",
    Callback = function(Value)
        if Value then
            getgenv().EnableC00lkidd()
        else
            getgenv().DisableC00lkidd()
        end
    end
})


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

-- GUI toggle
Combat:CreateSection("Noli")

Combat:CreateToggle({
    Name = "Void Rush Controller",
    CurrentValue = false,
    Callback = function(value)
        VoidRushController.Toggle = value
        if value then
            VoidRushController:CheckVoidRush()
        else
            VoidRushController:FullCleanup()
        end
    end,
})

Combat:CreateToggle({
    Name = "Void-Rush Ignore Objectables",
    CurrentValue = false,
    Flag = "IgnoreVoidRush",
    Callback = function(Value)
        if Value then
            getgenv().EnableVoidRush()
        else
            getgenv().DisableVoidRush()
        end
    end
})

-- Functions
local function setupCharacter(character)
    local Humanoid = character:WaitForChild("Humanoid")
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    _G.Humanoid = Humanoid
    _G.HumanoidRootPart = HumanoidRootPart
    DEFAULT_WALK_SPEED = Humanoid.WalkSpeed
end

local function startCharge()
    if isChargeActive then return end
    isChargeActive = true

    connection = RunService.RenderStepped:Connect(function()
        if not _G.Humanoid or not _G.HumanoidRootPart then return end
        _G.Humanoid.WalkSpeed = ORIGINAL_DASH_SPEED
        _G.Humanoid.AutoRotate = false

        local direction = _G.HumanoidRootPart.CFrame.LookVector
        local horizontal = Vector3.new(direction.X, 0, direction.Z)
        if horizontal.Magnitude > 0 then
            _G.Humanoid:Move(horizontal.Unit)
        end
    end)
end

local function stopCharge()
    if not isChargeActive then return end
    isChargeActive = false
    if _G.Humanoid then
        _G.Humanoid.WalkSpeed = DEFAULT_WALK_SPEED
        _G.Humanoid.AutoRotate = true
        _G.Humanoid:Move(Vector3.new(0, 0, 0))
    end
    if connection then
        connection:Disconnect()
        connection = nil
    end
end

if game:GetService("Players").LocalPlayer.Character then
    setupCharacter(game:GetService("Players").LocalPlayer.Character)
end

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(setupCharacter)

RunService.RenderStepped:Connect(function()
    if not chargecontrol then return end
    if not game:GetService("Players").LocalPlayer.Character then return end

    local speedMultipliers = game:GetService("Players").LocalPlayer.Character:FindFirstChild("SpeedMultipliers")
    if speedMultipliers then
        local charge = speedMultipliers:FindFirstChild("Guest1337Charge")
        if charge then
            startCharge()
        else
            stopCharge()
        end
    else
        stopCharge()
    end
end)

Combat:CreateSection("Dusekkar")
Combat:CreateToggle({
    Name = "Anti-Cancelled Protection",
    CurrentValue = false,
    Flag = "ProtectionDusekkar",
    Callback = function(Value)
        if Value then
            getgenv().EnableProtection()
        else
            getgenv().DisableProtection()
        end
    end
})

--// Services
local RNG = Random.new()

--// Character references
local Character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid:WaitForChild("Animator")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
	Character = char
	Humanoid = char:WaitForChild("Humanoid")
	Animator = Humanoid:WaitForChild("Animator")
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

local Enabled = false
local MaxRange = 120

Combat:CreateSection("Hitbox")

Combat:CreateToggle({
	Name = "Killers/Survivors Slient Aim (Work With Guest 1337, Shedletsky, And Crouch Stab Two Time)",
	CurrentValue = false,
	Callback = function(Value)
		Enabled = Value
	end,
})

Combat:CreateInput({
	Name = "Slient Aim Distance",
	PlaceholderText = "120",
	RemoveTextAfterFocusLost = false,
	Callback = function(Value)
		local num = tonumber(Value)
		if num then
			MaxRange = num
		end
	end,
})

--// Animation ID list
local AttackAnimations = {
	"rbxassetid://131430497821198", "rbxassetid://83829782357897", "rbxassetid://126830014841198",
	"rbxassetid://126355327951215", "rbxassetid://121086746534252", "rbxassetid://105458270463374",
	"rbxassetid://127172483138092", "rbxassetid://18885919947", "rbxassetid://18885909645",
	"rbxassetid://87259391926321", "rbxassetid://106014898528300", "rbxassetid://86545133269813",
	"rbxassetid://89448354637442", "rbxassetid://90499469533503", "rbxassetid://116618003477002",
	"rbxassetid://106086955212611", "rbxassetid://107640065977686", "rbxassetid://77124578197357",
	"rbxassetid://101771617803133", "rbxassetid://134958187822107", "rbxassetid://111313169447787",
	"rbxassetid://71685573690338", "rbxassetid://129843313690921", "rbxassetid://97623143664485",
	"rbxassetid://136007065400978", "rbxassetid://86096387000557", "rbxassetid://108807732150251",
	"rbxassetid://138040001965654", "rbxassetid://73502073176819", "rbxassetid://86709774283672",
	"rbxassetid://140703210927645", "rbxassetid://96173857867228", "rbxassetid://121255898612475",
	"rbxassetid://98031287364865", "rbxassetid://119462383658044", "rbxassetid://77448521277146",
	"rbxassetid://103741352379819", "rbxassetid://131696603025265", "rbxassetid://122503338277352",
	"rbxassetid://97648548303678", "rbxassetid://94162446513587", "rbxassetid://84426150435898",
	"rbxassetid://93069721274110", "rbxassetid://114620047310688", "rbxassetid://97433060861952",
	"rbxassetid://82183356141401", "rbxassetid://100592913030351", "rbxassetid://121293883585738",
	"rbxassetid://70447634862911", "rbxassetid://92173139187970", "rbxassetid://106847695270773",
	"rbxassetid://125403313786645", "rbxassetid://81639435858902", "rbxassetid://137314737492715",
	"rbxassetid://120112897026015", "rbxassetid://82113744478546", "rbxassetid://118298475669935",
	"rbxassetid://126681776859538", "rbxassetid://129976080405072", "rbxassetid://109667959938617",
	"rbxassetid://74707328554358", "rbxassetid://133336594357903", "rbxassetid://86204001129974",
	"rbxassetid://124243639579224", "rbxassetid://70371667919898", "rbxassetid://131543461321709",
	"rbxassetid://136323728355613", "rbxassetid://109230267448394"
}

--// Hitbox ride logic
RunService.Heartbeat:Connect(function()
	if not Enabled then return end
	if not HumanoidRootPart then return end

	local playing = false
	for _, track in ipairs(Humanoid:GetPlayingAnimationTracks()) do
		if table.find(AttackAnimations, track.Animation.AnimationId)
			and (track.TimePosition / track.Length < 0.75) then
			playing = true
			break
		end
	end

	if not playing then return end

	local Target
	local NearestDist = MaxRange

	local function scanGroup(group)
		for _, obj in ipairs(group) do
			if obj == Character or not obj:FindFirstChild("HumanoidRootPart") then continue end
			local dist = (obj.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
			if dist < NearestDist then
				NearestDist = dist
				Target = obj
			end
		end
	end

	scanGroup(workspace.Players:GetDescendants())
	local npcs = workspace:FindFirstChild("Map", true) and workspace.Map:FindFirstChild("NPCs", true)
	if npcs then
		scanGroup(npcs:GetChildren())
	end

	if not Target then return end

	local ping = game:GetService("Players").LocalPlayer:GetNetworkPing()
	local randomOffset = Vector3.new(RNG:NextNumber(-1.5, 1.5), 0, RNG:NextNumber(-1.5, 1.5))
	local predicted = Target.HumanoidRootPart.Position + randomOffset + (Target.HumanoidRootPart.Velocity * (ping * 1.25))
	local neededVelocity = (predicted - HumanoidRootPart.Position) / (ping * 2)

	local oldVelocity = HumanoidRootPart.Velocity
	HumanoidRootPart.Velocity = neededVelocity
	RunService.RenderStepped:Wait()
	HumanoidRootPart.Velocity = oldVelocity
end)

getgenv().Lighting = game:GetService("Lighting")
getgenv().Workspace = game:GetService("Workspace")

-- Biến lưu trạng thái toggle
getgenv().removeEffectsEnabled = false
getgenv().lightingConnection = nil
getgenv().workspaceConnection = nil

-- Các instance cần xóa trong Lighting
getgenv().lightingTargets = {
    "BlindnessBlur",
    "SubspaceVFXBlur",
    "SubspaceVFXColorCorrection"
}

-- Các instance cần xóa trong Workspace
getgenv().workspaceTargets = {
    "GlitchParts"
}

-- Hàm xóa các instance trong Lighting
getgenv().removeLightingInstances = function()
    for _, name in ipairs(getgenv().lightingTargets) do
        local obj = getgenv().Lighting:FindFirstChild(name)
        if obj then
            obj:Destroy()
        end
    end
end

-- Hàm xóa các instance trong Workspace
getgenv().removeWorkspaceInstances = function()
    for _, name in ipairs(getgenv().workspaceTargets) do
        local obj = getgenv().Workspace:FindFirstChild(name)
        if obj then
            obj:Destroy()
        end
    end
end

-- Bật toggle
getgenv().enableRemoveEffects = function()
    getgenv().removeLightingInstances()
    getgenv().removeWorkspaceInstances()

    -- Theo dõi Lighting
    getgenv().lightingConnection = getgenv().Lighting.ChildAdded:Connect(function(child)
        if table.find(getgenv().lightingTargets, child.Name) then
            child:Destroy()
        end
    end)

    -- Theo dõi Workspace
    getgenv().workspaceConnection = getgenv().Workspace.ChildAdded:Connect(function(child)
        if table.find(getgenv().workspaceTargets, child.Name) then
            child:Destroy()
        end
    end)

    getgenv().removeEffectsEnabled = true
end

-- Tắt toggle
getgenv().disableRemoveEffects = function()
    if getgenv().lightingConnection then
        getgenv().lightingConnection:Disconnect()
        getgenv().lightingConnection = nil
    end
    if getgenv().workspaceConnection then
        getgenv().workspaceConnection:Disconnect()
        getgenv().workspaceConnection = nil
    end
    getgenv().removeEffectsEnabled = false
end

Combat:CreateSection("Blindness")
Combat:CreateToggle({
    Name = "Anti Blindness",
    CurrentValue = false,
    Flag = "RemoveBlindness",
    Callback = function(value)
        if value then
            getgenv().enableRemoveEffects()
        else
            getgenv().disableRemoveEffects()
        end
    end
})

-- Hàm lấy GUI an toàn
local function getRerollGui()
    local success, gui = pcall(function()
        return game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("MainUI", 5)
            :WaitForChild("AbilityContainer", 5)
            :WaitForChild("Reroll", 5)
    end)
    return success and gui or nil
end

-- Biến toggle và slider
local AutoCoinFlip = false
local MaxCharges = 3    -- mặc định 3
local Delay = 0.25       -- Delay cố định


Combat:CreateSection("Chance")
-- Toggle Auto Coin Flip
Combat:CreateToggle({
    Name = "Auto CoinFlip",
    CurrentValue = false,
    Flag = "AutoCoinFlip",
    Callback = function(value)
        AutoCoinFlip = value
    end
})

-- Slider giới hạn charges
Combat:CreateSlider({
    Name = "Charges",
    Range = {1, 3},
    Increment = 1,
    Suffix = "charges",
    CurrentValue = MaxCharges,
    Flag = "MaxChargesSlider",
    Callback = function(value)
        MaxCharges = value
    end
})

-- Thiết lập Remote chính
getgenv().StorageReplicated = game:GetService("ReplicatedStorage")
getgenv().NetworkRemote = getgenv().StorageReplicated:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
getgenv().MainRemote = getgenv().NetworkRemote

-- Bảng lưu hook gốc và hook hiện tại
getgenv().baseHooks = {}
getgenv().currentHooks = {}

-- Tạo hook chung cho remote theo tên
getgenv().initHook = function(targetRemote)
    getgenv().originalHookFunction = hookmetamethod(game, "__namecall", function(self, ...)
        getgenv().methodCalled = getnamecallmethod()
        getgenv().parameters = {...}

        if self == getgenv().MainRemote and getgenv().methodCalled == "FireServer" then
            -- Kiểm tra remote có chứa username
            if type(getgenv().parameters[1]) == "string" and getgenv().parameters[1]:find(game.Players.LocalPlayer.Name) and getgenv().parameters[1]:find(targetRemote) then
                -- Nếu là remote gửi vector, thay bằng hướng camera
                if #getgenv().parameters >= 2 and typeof(getgenv().parameters[2]) == "Vector3" then
                    getgenv().camera = workspace.CurrentCamera
                    getgenv().parameters[2] = getgenv().camera.CFrame.LookVector
                    return getgenv().baseHooks[targetRemote](self, unpack(getgenv().parameters))
                end

                -- Block remote nếu không muốn gửi
                return
            end
        end

        return getgenv().baseHooks[targetRemote](self, ...)
    end)

    getgenv().baseHooks[targetRemote] = getgenv().originalHookFunction
    return getgenv().originalHookFunction
end

-- Bật hook
getgenv().activateHook = function(targetRemote)
    if not getgenv().currentHooks[targetRemote] then
        getgenv().currentHooks[targetRemote] = getgenv().initHook(targetRemote)
    end
end

-- Tắt hook, restore hook gốc
getgenv().deactivateHook = function(targetRemote)
    if getgenv().currentHooks[targetRemote] and getgenv().baseHooks[targetRemote] then
        hookmetamethod(game, "__namecall", getgenv().baseHooks[targetRemote])
        getgenv().currentHooks[targetRemote] = nil
        getgenv().baseHooks[targetRemote] = nil
    end
end

Combat:CreateToggle({
    Name = "Chance True Shoot",
    CurrentValue = false,
    Flag = "ChanceTrueShoot",
    Callback = function(value)
        if value then
            getgenv().activateHook("ChanceFireShot")
        else
            getgenv().deactivateHook("ChanceFireShot")
        end
    end
})

-- Loop auto coin flip
spawn(function()
    while true do
        local gui = getRerollGui()
        if gui then
            local chargesLabel = gui:FindFirstChild("Charges")
            local currentCharges = chargesLabel and tonumber(chargesLabel.Text) or 0

            if AutoCoinFlip and currentCharges < MaxCharges then
                local ok, err = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer("UseActorAbility", "CoinFlip")
                end)
            end
        end

        wait(Delay)
    end
end)

Combat:CreateSection("Guest 1337 -- Charge")
Combat:CreateToggle({
    Name = "Charge Controller",
    CurrentValue = false,
    Flag = "ChargeControlToggle",
    Callback = function(Value)
        toggled = Value
        if toggled then
            chargecontrol = true
        else
            chargecontrol = false
            stopCharge()
        end
    end
})

Combat:CreateToggle({
    Name = "Charge Ignore Objectables",
    CurrentValue = false,
    Flag = "IgnoreCharge",
    Callback = function(Value)
        if Value then
            getgenv().EnableCharge()
        else
            getgenv().DisableCharge()
        end
    end
})


-- Services
local killerNames = { "Jason", "c00lkidd", "JohnDoe", "1x1x1x1", "Noli" }

-- Vars
local enabled = false
local cooldown = false
local lastTarget = nil
local range = 4
local mode = "Behind"
local daggerCooldownText

-- Helpers
local counterAnimIDs = { "126830014841198", "126355327951215", "121086746534252", "18885909645",
"98456918873918", "105458270463374", "83829782357897", "125403313786645",
"118298475669935", "82113744478546", "70371667919898", "99135633258223",
"97167027849946", "109230267448394", "139835501033932", "126896426760253",
"109667959938617", "126681776859538", "129976080405072", "121293883585738",
"81639435858902", "137314737492715", "92173139187970" }

local function killerPlayingCounterAnim(killer)
    local humanoid = killer:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid:FindFirstChildOfClass("Animator") then return false end
    for _, track in ipairs(humanoid.Animator:GetPlayingAnimationTracks()) do
        if track.Animation and track.Animation.AnimationId then
            local animIdNum = track.Animation.AnimationId:match("%d+")
            for _, id in ipairs(counterAnimIDs) do
                if tostring(animIdNum) == id then
                    return true
                end
            end
        end
    end
    return false
end

local function isBehindTarget(hrp, targetHRP)
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance > range then return false end
    if mode == "Around" then return true end
    local direction = -targetHRP.CFrame.LookVector
    local toPlayer = (hrp.Position - targetHRP.Position)
    return toPlayer:Dot(direction) > 0.5
end

-- Dagger cooldown refresh
local function refreshDaggerRef()
    local mainui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"):FindFirstChild("MainUI")
    if mainui and mainui:FindFirstChild("AbilityContainer") then
        local dagger = mainui.AbilityContainer:FindFirstChild("Dagger")
        if dagger and dagger:FindFirstChild("CooldownTime") then
            daggerCooldownText = dagger.CooldownTime
            return
        end
    end
    daggerCooldownText = nil
end

game:GetService("Players").LocalPlayer.PlayerGui.DescendantAdded:Connect(refreshDaggerRef)
game:GetService("Players").LocalPlayer.PlayerGui.DescendantRemoving:Connect(function(obj)
    if obj == daggerCooldownText then
        daggerCooldownText = nil
    end
end)
refreshDaggerRef()

-- GUI Elements
Combat:CreateSection("Two Time")
-- Backstab Toggle
Combat:CreateToggle({
    Name = "Auto Backstab",
    CurrentValue = false,
    Flag = "BackstabEnabled",
    Callback = function(value)
        enabled = value
    end
})

-- Range
Combat:CreateSlider({
    Name = "Range",
    Range = {1, 20},
    Increment = 1,
    Suffix = "studs",
    CurrentValue = 4,
    Flag = "BackstabRange",
    Callback = function(value)
        range = value
    end
})

-- Mode
Combat:CreateDropdown({
    Name = "Mode",
    Options = {"Behind", "Around"},
    CurrentOption = "Behind",
    Flag = "BackstabMode",
    Callback = function(option)
        mode = option
    end
})

-- Main RenderStepped logic
game:GetService("RunService").RenderStepped:Connect(function()
    if not daggerCooldownText or not daggerCooldownText.Parent then return end
    if tonumber(daggerCooldownText.Text) then return end
    if not enabled or cooldown then return end

    local char = game:GetService("Players").LocalPlayer.Character
    if not (char and char:FindFirstChild("HumanoidRootPart")) then return end
    local hrp = char.HumanoidRootPart
    local stats = game:GetService("Stats")

    for _, name in ipairs(killerNames) do
        local killer = workspace:WaitForChild("Players"):WaitForChild("Killers"):FindFirstChild(name)
        if killer and killer:FindFirstChild("HumanoidRootPart") then
            local kHRP = killer.HumanoidRootPart

            if isBehindTarget(hrp, kHRP) and killer ~= lastTarget then
                cooldown = true
                lastTarget = killer

                local start = tick()
                local didDagger = false
                local connection
                connection = game:GetService("RunService").Heartbeat:Connect(function()
                    if not (char and char.Parent and kHRP and kHRP.Parent) then
                        connection:Disconnect()
                        return
                    end

                    local elapsed = tick() - start
                    if elapsed >= 0.5 then
                        connection:Disconnect()
                        return
                    end

                    local ping = tonumber(stats.Network.ServerStatsItem["Data Ping"]:GetValueString():match("%d+")) or 50
                    local pingSeconds = ping / 1000
                    local killerVelocity = kHRP.Velocity
                    local moveDir = killerVelocity.Magnitude > 0.1 and killerVelocity.Unit or Vector3.new()
                    local pingOffset = moveDir * (pingSeconds * killerVelocity.Magnitude)
                    local predictedPos = kHRP.Position + pingOffset

                    local targetPos
                    if mode == "Behind" then
                        targetPos = predictedPos - (kHRP.CFrame.LookVector * 0.3)
                    else
                        local lookVec = kHRP.CFrame.LookVector
                        local rightVec = kHRP.CFrame.RightVector
                        local rel = (hrp.Position - kHRP.Position)
                        local lateralSpeed = killerVelocity:Dot(rightVec)
                        local baseOffset = (rel.Magnitude > 0.1) and rel.Unit * 0.3 or Vector3.new()
                        local lateralOffset = rightVec * lateralSpeed * 0.3
                        targetPos = predictedPos + baseOffset + lateralOffset
                    end

                    hrp.CFrame = CFrame.new(targetPos, targetPos + kHRP.CFrame.LookVector)

                    if not didDagger then
                        didDagger = true
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer("UseActorAbility", "Dagger")
                    end
                end)

                task.delay(2, function()
                    while isBehindTarget(hrp, kHRP) do
                        game:GetService("RunService").Heartbeat:Wait()
                    end
                    lastTarget = nil
                    cooldown = false
                end)

                break
            end
        end
    end
end)

Combat:CreateSection("Guest 1337 -- Auto Block")

Combat:CreateToggle({
    Name = "Auto Block (80% Accurate)",
    CurrentValue = false,
    Flag = "AutoBlockAudio",
    Callback = function(state)
        autoBlockAudioOn = state
    end,
})

Combat:CreateInput({
Name = "Block Range",
PlaceholderText = "18",
RemoveTextAfterFocusLost = false,
Callback = function(Text)
detectionRange = tonumber(Text) or detectionRange
end
})

Combat:CreateSection("Guest 1337 -- Auto Punch")

Combat:CreateToggle({
Name = "Auto Punch",
CurrentValue = false,
Callback = function(Value) autoPunchOn = Value end
})

Combat:CreateToggle({
Name = "Punch Aimbot",
CurrentValue = false,
Callback = function(Value) aimPunch = Value end
})

Combat:CreateSlider({
    Name = "Aim Prediction",
    Range = {0, 10},
    Increment = 0.1,
    Suffix = "studs",
    CurrentValue = predictionValue,
    Flag = "PredictionSlider",
    Callback = function(Value)
        predictionValue = Value
    end,
})

--== Persistent Storage ==--
local savedRangeRaging = game:GetService("Players").LocalPlayer:FindFirstChild("RagingPaceRange")
if not savedRangeRaging then
    savedRangeRaging = Instance.new("NumberValue")
    savedRangeRaging.Name = "RagingPaceRange"
    savedRangeRaging.Value = 19 -- default
    savedRangeRaging.Parent = game:GetService("Players").LocalPlayer
end

local savedRange404 = game:GetService("Players").LocalPlayer:FindFirstChild("Error404Range")
if not savedRange404 then
    savedRange404 = Instance.new("NumberValue")
    savedRange404.Name = "Error404Range"
    savedRange404.Value = 19 -- default
    savedRange404.Parent = game:GetService("Players").LocalPlayer
end

--== Settings ==--
local RANGE_RAGING = savedRangeRaging.Value
local RANGE_404 = savedRange404.Value
local SPAM_DURATION = 3
local COOLDOWN_TIME = 5
local activeCooldownsRaging = {}
local activeCooldowns404 = {}
local enabledRaging = false
local enabled404 = false

--== Animation List ==--
local animsToDetectRaging = {
    ["72722244508749"] = false,
    ["77448521277146"] = true,
    ["86096387000557"] = true,
    ["86371356500204"] = true,
    ["86545133269813"] = true,
    ["86709774283672"] = true,
    ["87259391926321"] = true,
    ["89448354637442"] = true,
    ["96959123077498"] = false,
    ["103601716322988"] = true,
    ["108807732150251"] = true,
    ["115194624791339"] = true,
    ["116618003477002"] = true,
    ["119462383658044"] = true,
    ["121255898612475"] = true,
    ["131696603025265"] = true,
    ["133491532453922"] = true,
    ["136007065400978"] = true,
    ["138040001965654"] = true,
    ["140703210927645"] = true,
}

-- Nếu Error404 cũng detect cùng anims thì có thể dùng chung bảng trên
-- Nếu khác thì bạn thay bảng này
local animsToDetect404 = animsToDetectRaging

--== Remote Function ==--
local function fireSkill(skillName)
    local args = { "UseActorAbility", skillName }
    ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end

-- thay thế toàn bộ hàm isAnimationMatching bằng đoạn dưới
local function isAnimationMatching(anim, animTable)
    if not anim or not anim.Animation then
        return false
    end
    local id = anim.Animation.AnimationId
    if type(id) ~= "string" then
        return false
    end
    local numId = id:match("%d+")
    if not numId then
        return false
    end
    return animTable[numId] == true
end

--== Main Detection ==--
local function detectAndSpam(skillName, range, cooldownTable, animTable)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= game:GetService("Players").LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local targetHRP = player.Character.HumanoidRootPart
            local myChar = game:GetService("Players").LocalPlayer.Character
            if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                local dist = (targetHRP.Position - myChar.HumanoidRootPart.Position).Magnitude
                if dist <= range and (not cooldownTable[player] or tick() - cooldownTable[player] >= COOLDOWN_TIME) then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                            if isAnimationMatching(track, animTable) then
                                cooldownTable[player] = tick()
                                task.spawn(function()
                                    local startTime = tick()
                                    while tick() - startTime < SPAM_DURATION do
                                        fireSkill(skillName)
                                        task.wait(0.05)
                                    end
                                end)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    if enabledRaging then
        detectAndSpam("RagingPace", RANGE_RAGING, activeCooldownsRaging, animsToDetectRaging)
    end
    if enabled404 then
        detectAndSpam("404Error", RANGE_404, activeCooldowns404, animsToDetect404)
    end
end)

--== UI ==--
Combat:CreateSection("Killers Parry")

-- Toggle & input RagingPace
Combat:CreateToggle({
    Name = "Auto Raging Pace",
    CurrentValue = false,
    Flag = "RagingPaceToggle",
    Callback = function(Value)
        enabledRaging = Value
    end,
})
Combat:CreateInput({
    Name = "RagingPace Range (studs)",
    PlaceholderText = tostring(RANGE_RAGING),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then
            RANGE_RAGING = num
            savedRangeRaging.Value = num
        end
    end,
})

-- Toggle & input Error404
Combat:CreateToggle({
    Name = "Auto 404Error",
    CurrentValue = false,
    Flag = "Error404Toggle",
    Callback = function(Value)
        enabled404 = Value
    end,
})
Combat:CreateInput({
    Name = "404Error Range (studs)",
    PlaceholderText = tostring(RANGE_404),
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then
            RANGE_404 = num
            savedRange404.Value = num
        end
    end,
})

-- ==== ACHIEVEMENTS SECTION ====
AchieveTab:CreateSection("Fun")

local function unlock(achieve)
   local remote = game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent")
   remote:FireServer("UnlockAchievement", achieve)
end

AchieveTab:CreateButton({
   Name = "[.] (Meet ogologl's best friend for the first time)",
   Callback = function() unlock("MeetBrandon") end,
})

AchieveTab:CreateButton({
   Name = "[Meow meow meow] (Interact with the cat in the lobby more than 15 times)",
   Callback = function() unlock("ILoveCats") end,
})

AchieveTab:CreateButton({
   Name = "[Coming straight from YOUR house.] (??? - I Love TV)",
   Callback = function() unlock("TVTIME") end,
})

AchieveTab:CreateButton({
   Name = "[A Captain and his Ship] (Hear his tale)",
   Callback = function() unlock("MeetDemophon") end,
})

local roundtime
local positionSet = false -- Để biết đã chỉnh X scale chưa

-- Hàm chỉnh position X scale thêm 0.39 một lần
local function adjustPosition()
    if roundtime and not positionSet then
        roundtime.Position = UDim2.new(
            roundtime.Position.X.Scale + 0.39,
            roundtime.Position.X.Offset,
            roundtime.Position.Y.Scale,
            roundtime.Position.Y.Offset
        )
        positionSet = true -- Đánh dấu đã chỉnh
    end
end

-- Loop check cho đến khi tìm thấy
task.spawn(function()
    while not roundtime do
        roundtime = player:FindFirstChild("PlayerGui")
            and player.PlayerGui:FindFirstChild("RoundTimer")
            and player.PlayerGui.RoundTimer:FindFirstChild("Main")
        task.wait(0.1)
    end

    -- Lần đầu chỉnh
    adjustPosition()

    -- Loop giữ nguyên vị trí
    while roundtime do
        roundtime.Position = UDim2.new(
            roundtime.Position.X.Scale,
            roundtime.Position.X.Offset,
            roundtime.Position.Y.Scale,
            roundtime.Position.Y.Offset
        )
        task.wait(0.5) -- refresh mỗi 0.5 giây
    end
end)

local function fireRemoteBlock()
local args = {"UseActorAbility", "Block"}
ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
end


-- ===== Robust Sound Auto Block (replace your current Sound Auto Block) =====
local soundHooks = {}     -- [Sound] = {playedConn, propConn, destroyConn}
local soundBlockedUntil = {} -- [Sound] = timestamp when we can block again (throttle)

local function extractNumericSoundId(sound)
    if not sound or not sound.SoundId then return nil end
    local sid = tostring(sound.SoundId)

    -- Prefer numeric id if present
    local num = sid:match("%d+")
    if num then return num end

    -- Fallbacks (these won't match your numeric whitelist, but kept for completeness)
    local hash = sid:match("[&%?]hash=([^&]+)")
    if hash then return "&hash="..hash end
    local path = sid:match("rbxasset://sounds/.+")
    if path then return path end

    return nil
end

local function getSoundWorldPosition(sound)
    if not sound then return nil end
    if sound.Parent and sound.Parent:IsA("BasePart") then
        return sound.Parent.Position, sound.Parent
    end
    if sound.Parent and sound.Parent:IsA("Attachment") and sound.Parent.Parent and sound.Parent.Parent:IsA("BasePart") then
        return sound.Parent.Parent.Position, sound.Parent.Parent
    end
    -- deep search for any BasePart ancestor/descendant
    local found = sound.Parent and sound.Parent:FindFirstChildWhichIsA("BasePart", true)
    if found then
        return found.Position, found
    end
    return nil, nil
end

local function attemptBlockForSound(sound)
    if not autoBlockAudioOn then return end
    if not sound or not sound:IsA("Sound") then return end

    -- Only care when actually playing
    if not sound.IsPlaying then return end

    local id = extractNumericSoundId(sound)
    if not id or not autoBlockTriggerSounds[id] then return end

    local myRoot = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    -- Throttle one block per sound for a short window
    if soundBlockedUntil[sound] and tick() < soundBlockedUntil[sound] then
        return
    end

    local soundPos, soundPart = getSoundWorldPosition(sound)
    local shouldBlock = false
    local facingOK = true

    if soundPos then
        local dist = (myRoot.Position - soundPos).Magnitude
        if dist <= detectionRange then
            shouldBlock = true
            -- Only do facing check if we have a BasePart to use (soundPart)
            if facingCheckEnabled and soundPart and soundPart:IsA("BasePart") then
                facingOK = isFacing(myRoot, soundPart)
            end
        end
    else
        -- No position available -> block anyway (per your request)
        shouldBlock = true
        facingOK = true
    end

    if shouldBlock and facingOK then
        fireRemoteBlock()
        soundBlockedUntil[sound] = tick() + 1.2
    end
end

local function hookSound(sound)
    if not sound or not sound:IsA("Sound") then return end
    if soundHooks[sound] then return end -- already hooked

    local playedConn = sound.Played:Connect(function()
        -- handle immediate play
        pcall(attemptBlockForSound, sound)
    end)

    local propConn = sound:GetPropertyChangedSignal("IsPlaying"):Connect(function()
        if sound.IsPlaying then
            pcall(attemptBlockForSound, sound)
        end
    end)

    local destroyConn
    destroyConn = sound.Destroying:Connect(function()
        -- cleanup
        if playedConn and playedConn.Connected then playedConn:Disconnect() end
        if propConn and propConn.Connected then propConn:Disconnect() end
        if destroyConn and destroyConn.Connected then destroyConn:Disconnect() end
        soundHooks[sound] = nil
        soundBlockedUntil[sound] = nil
    end)

    soundHooks[sound] = {playedConn, propConn, destroyConn}

    -- If it's already playing right now, check it immediately
    if sound.IsPlaying then
        task.spawn(function() pcall(attemptBlockForSound, sound) end)
    end
end

-- Hook existing Sounds across the game (covers workspace, SoundService, Lighting, etc.)
for _, desc in ipairs(game:GetDescendants()) do
    if desc:IsA("Sound") then
        pcall(hookSound, desc)
    end
end

-- Hook any future Sounds
game.DescendantAdded:Connect(function(desc)
    if desc:IsA("Sound") then
        pcall(hookSound, desc)
    end
end)
-- ===== End Robust Sound Auto Block =====

-- Auto Punch
local autoPunchLoop
local punchCooldown = 0.005 -- delay giữa các lần punch để tránh spam quá nhanh
local lastPunch = 0

autoPunchLoop = RunService.RenderStepped:Connect(function()
    if not autoPunchOn then
        return
    end

    local gui = PlayerGui:FindFirstChild("MainUI")
    local punchBtn = gui and gui:FindFirstChild("AbilityContainer") and gui.AbilityContainer:FindFirstChild("Punch")
    local charges = punchBtn and punchBtn:FindFirstChild("Charges")

    if charges and charges.Text == "1" then
        local myChar = Players.LocalPlayer.Character
        local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local humanoid = myChar and myChar:FindFirstChild("Humanoid")

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") 
            and obj.Humanoid.MaxHealth > 300 
            and obj:FindFirstChild("HumanoidRootPart") then

                local root = obj.HumanoidRootPart
                if myRoot and (root.Position - myRoot.Position).Magnitude <= 10 then
                    -- Cooldown check
                    if tick() - lastPunch >= punchCooldown then
                        lastPunch = tick()

                        -- Aim Punch
                        if aimPunch and humanoid then
                            humanoid.AutoRotate = false
                            task.spawn(function()
                                local start = tick()
                                while tick() - start < 2 and root and root.Parent do
                                    if myRoot then
                                        local predictedPos = root.Position + (root.CFrame.LookVector * predictionValue)
                                        myRoot.CFrame = CFrame.lookAt(myRoot.Position, predictedPos)
                                    end
                                    task.wait()
                                end
                                if humanoid then
                                    humanoid.AutoRotate = true
                                end
                            end)
                        end

                        -- Trigger punch
                        for _, conn in ipairs(getconnections(punchBtn.MouseButton1Click)) do
                            pcall(function()
                                conn:Fire()
                            end)
                        end
                    end
                    break -- chỉ punch 1 target mỗi vòng loop
                end
            end
        end
    end
end)


-- Global environment
genv = {}
genv.running = false
genv.animTrack = nil
genv.toggleValue = false

-- Get character & humanoid safely
function genv.getCharacterHumanoid()
    local character = game:GetService("Players").LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    return character, humanoid
end

-- Get or create animator safely
function genv.getAnimator(humanoid)
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = humanoid
    end
    return animator
end

-- Handle toggle
function genv.handleToggle(enabled)
    genv.running = enabled

    -- Stop animation & reset transparency if disabling
    if not enabled and genv.animTrack then
        genv.animTrack:Stop()
        genv.animTrack = nil
    end

    local character, _ = genv.getCharacterHumanoid()
    local rootPart = character and character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        rootPart.Transparency = enabled and rootPart.Transparency or 1
    end
end

-- Survivor check & auto toggle
local survivorValue = playerData:WaitForChild("Equipped"):WaitForChild("Survivor")

function genv.updateToggle()
    local character, humanoid = genv.getCharacterHumanoid()
    local isTarget = survivorValue.Value == "007n7" and humanoid and humanoid.MaxHealth < 300
    genv.handleToggle(isTarget)
end

-- Rayfield Combat UI
Combat:CreateSection("007n7")

-- Toggle thủ công
Combat:CreateToggle({
    Name = "Invisible Upon Cloning (007n7)",
    CurrentValue = false,
    Flag = "InvisibleToggle",
    Callback = function(Value)
        genv.toggleValue = Value
        if Value then
            genv.updateToggle()
        else
            genv.handleToggle(false)
        end
    end
})

-- Update when Survivor changes
survivorValue:GetPropertyChangedSignal("Value"):Connect(function()
    if genv.toggleValue then
        genv.updateToggle()
    end
end)

-- Auto-update on respawn
game:GetService("Players").LocalPlayer.CharacterAdded:Connect(function(char)
    -- Small delay to ensure character exists
    task.wait(0.1)
    if genv.toggleValue then
        genv.updateToggle()
    end
end)

-- Main loop using RunService.Heartbeat
RunService.Heartbeat:Connect(function()
    if not genv.running then return end

    local character, humanoid = genv.getCharacterHumanoid()
    if not character or not humanoid then return end

    local animator = genv.getAnimator(humanoid)
    local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    if humanoid.MaxHealth < 300 and torso and torso.Transparency ~= 0 then
        if not genv.animTrack or not genv.animTrack.IsPlaying then
            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://75804462760596"
            genv.animTrack = animator:LoadAnimation(animation)
            genv.animTrack.Looped = true
            genv.animTrack:Play()
            genv.animTrack:AdjustSpeed(0)
            if rootPart then
                rootPart.Transparency = 0.4
            end
        end
    else
        if genv.animTrack and genv.animTrack.IsPlaying then
            genv.animTrack:Stop()
            genv.animTrack = nil
            if rootPart then
                rootPart.Transparency = 1
            end
        end
    end
end)
-- Hàm lấy danh sách emote từ Purchased.Emotes
local function getEmoteList()
    local list = {}
    for _, emote in ipairs(purchasedEmotesFolder:GetChildren()) do
        table.insert(list, emote.Name)
    end
    return list
end

--==================== GUI 1 (Dropdown) ====================--
local emoteList = getEmoteList()
local selectedEmote = emoteList[1]

local emoteGuiMain = Instance.new("ScreenGui")
emoteGuiMain.Name = "CustomEmoteGuiMain"
emoteGuiMain.ResetOnSpawn = false
emoteGuiMain.DisplayOrder = 999998
emoteGuiMain.Enabled = false
emoteGuiMain.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local emoteGuiToggle = Instance.new("ScreenGui")
emoteGuiToggle.Name = "CustomEmoteGuiToggle"
emoteGuiToggle.ResetOnSpawn = false
emoteGuiToggle.DisplayOrder = 999999
emoteGuiToggle.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

local toggleEmoteGuiButton = Instance.new("ImageButton")
toggleEmoteGuiButton.Size = UDim2.new(0, 60, 0, 60)
toggleEmoteGuiButton.Position = UDim2.new(0.05, 340, 0.05, -47.5)
toggleEmoteGuiButton.AnchorPoint = Vector2.new(0.5, 0.5)
toggleEmoteGuiButton.BackgroundTransparency = 1
toggleEmoteGuiButton.Image = "rbxassetid://73335752800725"
toggleEmoteGuiButton.ZIndex = 999999
toggleEmoteGuiButton.Parent = emoteGuiToggle

local survivorValue = playerData:WaitForChild("Equipped"):WaitForChild("Survivor")
local guiVisible = false

local function updateToggle()
    local isTarget = survivorValue.Value == "007n7"
    emoteGuiToggle.Enabled = isTarget
    if not isTarget then
        emoteGuiMain.Enabled = false
        guiVisible = false
    end
end
updateToggle()
survivorValue:GetPropertyChangedSignal("Value"):Connect(updateToggle)

local playButton = Instance.new("TextButton")
playButton.Size = UDim2.new(0, 160, 0, 36)
playButton.Position = UDim2.new(1, -204, 0, 150)
playButton.BackgroundColor3 = Color3.fromRGB(80,80,80)
playButton.TextColor3 = Color3.new(1,1,1)
playButton.Font = Enum.Font.SourceSans
playButton.TextSize = 18
playButton.Text = "Boombox Clone (007n7)"
playButton.Parent = emoteGuiMain

local dropdownFrame = Instance.new("Frame")
dropdownFrame.Size = UDim2.new(0, 220, 0, 40)
dropdownFrame.Position = UDim2.new(1, -240, 0, 100)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdownFrame.BorderSizePixel = 0
dropdownFrame.Parent = emoteGuiMain

local dropdownButton = Instance.new("TextButton")
dropdownButton.Size = UDim2.new(1,0,1,0)
dropdownButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
dropdownButton.TextColor3 = Color3.new(1,1,1)
dropdownButton.Font = Enum.Font.SourceSans
dropdownButton.TextSize = 18
dropdownButton.Text = selectedEmote and ("Emote: "..selectedEmote) or "Chọn Emote"
dropdownButton.Parent = dropdownFrame

local emoteListFrame = Instance.new("ScrollingFrame")
emoteListFrame.Size = UDim2.new(1,0,0, math.clamp(#emoteList,1,8) * 30)
emoteListFrame.Position = UDim2.new(0,0,1,2)
emoteListFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
emoteListFrame.BorderSizePixel = 0
emoteListFrame.Visible = false
emoteListFrame.CanvasSize = UDim2.new(0,0,0, #emoteList * 30)
emoteListFrame.ScrollBarThickness = 6
emoteListFrame.Parent = dropdownFrame

local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Vertical
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = emoteListFrame

local function populateDropdown(list)
    for _, child in ipairs(emoteListFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, name in ipairs(list) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -6, 0, 30)
        btn.Position = UDim2.new(0, 3, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 16
        btn.Text = name
        btn.Parent = emoteListFrame
        btn.MouseButton1Click:Connect(function()
            selectedEmote = name
            dropdownButton.Text = "Emote: " .. name
            emoteListFrame.Visible = false
        end)
    end
    emoteListFrame.CanvasSize = UDim2.new(0,0,0, #list * 30)
    emoteListFrame.Size = UDim2.new(1,0,0, math.clamp(#list,1,8) * 30)
end
populateDropdown(emoteList)

dropdownButton.MouseButton1Click:Connect(function()
    emoteListFrame.Visible = not emoteListFrame.Visible
    if emoteListFrame.Visible then
        Remote:FireServer("StopEmote", "Animations", "0")
    end
end)

playButton.MouseButton1Click:Connect(function()
    if not selectedEmote then return end
    Remote:FireServer("PlayEmote", "Animations", selectedEmote)
    task.wait(0.001)
    Remote:FireServer("StopEmote", "Animations", selectedEmote)
    task.wait(0.001)
    Remote:FireServer("UseActorAbility", "Clone")
    emoteListFrame.Visible = false
end)

toggleEmoteGuiButton.MouseButton1Click:Connect(function()
    guiVisible = not guiVisible
    emoteGuiMain.Enabled = guiVisible
    if not guiVisible then
        emoteListFrame.Visible = false
    end
end)

--==================== GUI 2 (Dropdown giống GUI 1) ====================--
local emotes2 = getEmoteList()

local screenGui2 = Instance.new("ScreenGui")
screenGui2.DisplayOrder = 999999
screenGui2.Name = "EmoteGUI2"
screenGui2.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
screenGui2.ResetOnSpawn = false
screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Global

-- Bỏ background2, thay bằng Frame trong suốt để chứa dropdown và nút Play
local background2 = Instance.new("Frame")
background2.Size = UDim2.new(0, 260, 0, 100)
background2.Position = UDim2.new(0, 0, 0.203, 0)
background2.BackgroundTransparency = 1 -- trong suốt hẳn luôn
background2.BorderSizePixel = 0
background2.Visible = false
background2.Parent = screenGui2

-- Play button GUI 2
local playButton2 = Instance.new("TextButton")
playButton2.Size = UDim2.new(0, 160, 0, 36)
playButton2.Position = UDim2.new(0, 50, 0, 60)
playButton2.BackgroundColor3 = Color3.fromRGB(80,80,80)
playButton2.TextColor3 = Color3.new(1,1,1)
playButton2.Font = Enum.Font.SourceSans
playButton2.TextSize = 18
playButton2.Text = "Play Emote"
playButton2.Parent = background2

-- Dropdown GUI 2
local dropdownFrame2 = Instance.new("Frame")
dropdownFrame2.Size = UDim2.new(0, 220, 0, 40)
dropdownFrame2.Position = UDim2.new(0, 20, 0, 10)
dropdownFrame2.BackgroundColor3 = Color3.fromRGB(40,40,40)
dropdownFrame2.BorderSizePixel = 0
dropdownFrame2.Parent = background2

local dropdownButton2 = Instance.new("TextButton")
dropdownButton2.Size = UDim2.new(1,0,1,0)
dropdownButton2.BackgroundColor3 = Color3.fromRGB(60,60,60)
dropdownButton2.TextColor3 = Color3.new(1,1,1)
dropdownButton2.Font = Enum.Font.SourceSans
dropdownButton2.TextSize = 18
dropdownButton2.Text = emotes2[1] and ("Emote: "..emotes2[1]) or "Chọn Emote"
dropdownButton2.Parent = dropdownFrame2

local emoteListFrame2 = Instance.new("ScrollingFrame")
emoteListFrame2.Size = UDim2.new(1,0,0, math.clamp(#emotes2,1,8) * 30)
emoteListFrame2.Position = UDim2.new(0,0,1,2)
emoteListFrame2.BackgroundColor3 = Color3.fromRGB(50,50,50)
emoteListFrame2.BorderSizePixel = 0
emoteListFrame2.Visible = false
emoteListFrame2.CanvasSize = UDim2.new(0,0,0, #emotes2 * 30)
emoteListFrame2.ScrollBarThickness = 6
emoteListFrame2.Parent = dropdownFrame2

local listLayout2 = Instance.new("UIListLayout")
listLayout2.FillDirection = Enum.FillDirection.Vertical
listLayout2.SortOrder = Enum.SortOrder.LayoutOrder
listLayout2.Parent = emoteListFrame2

-- Selected emote GUI 2
local selectedEmote2 = emotes2[1]

local function populateDropdown2(list)
	for _, child in ipairs(emoteListFrame2:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, name in ipairs(list) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -6, 0, 30)
		btn.Position = UDim2.new(0, 3, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
		btn.TextColor3 = Color3.new(1,1,1)
		btn.Font = Enum.Font.SourceSans
		btn.TextSize = 16
		btn.Text = name
		btn.Parent = emoteListFrame2
		btn.MouseButton1Click:Connect(function()
			selectedEmote2 = name
			dropdownButton2.Text = "Emote: " .. name
			emoteListFrame2.Visible = false
		end)
	end
	emoteListFrame2.CanvasSize = UDim2.new(0,0,0, #list * 30)
	emoteListFrame2.Size = UDim2.new(1,0,0, math.clamp(#list,1,8) * 30)
end
populateDropdown2(emotes2)

dropdownButton2.MouseButton1Click:Connect(function()
	emoteListFrame2.Visible = not emoteListFrame2.Visible
	if emoteListFrame2.Visible then
		Remote:FireServer("StopEmote", "Animations", "0")
	end
end)

playButton2.MouseButton1Click:Connect(function()
	if not selectedEmote2 then return end
	Remote:FireServer("PlayEmote", "Animations", selectedEmote2)
end)

-- Toggle button GUI 2
local toggleButton2 = Instance.new("ImageButton")
toggleButton2.Size = UDim2.new(0, 60, 0, 60)
toggleButton2.Position = UDim2.new(0.05, 248, 0.05, -47.5)
toggleButton2.AnchorPoint = Vector2.new(0.5, 0.5)
toggleButton2.BackgroundTransparency = 1
toggleButton2.Image = "rbxassetid://87214736647237"
toggleButton2.Parent = screenGui2
toggleButton2.ZIndex = 200010

toggleButton2.MouseButton1Click:Connect(function()
	background2.Visible = not background2.Visible
	if background2.Visible then
		Remote:FireServer("StopEmote", "Animations", "0")
	end
end)


--==================== Auto Update ====================--
-- Auto update cả GUI 2
local function refreshAll()
	local newList = getEmoteList()
	emoteList = newList
	populateDropdown(newList) -- GUI 1
	populateDropdown2(newList) -- GUI 2
	if #newList > 0 then
		selectedEmote = selectedEmote or newList[F1]
		selectedEmote2 = selectedEmote2 or newList[1]
		dropdownButton.Text = "Emote: " .. selectedEmote
		dropdownButton2.Text = "Emote: " .. selectedEmote2
	else
		selectedEmote = nil
		selectedEmote2 = nil
		dropdownButton.Text = "Choose Emote"
		dropdownButton2.Text = "Choose Emote"
	end
end

purchasedEmotesFolder.ChildAdded:Connect(refreshAll)
purchasedEmotesFolder.ChildRemoved:Connect(refreshAll)
Rayfield:LoadConfiguration()