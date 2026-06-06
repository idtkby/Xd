-- Kiểm tra ID game
if game.PlaceId ~= 107206090336891 then
    return warn("Script only works in the specified game (ID: 107206090336891){The Caves - Game}")
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
    Title = "The Caves",
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
local M105One = Main1o5Group:AddTab("--== Locations ==--")
local M105Two = Main1o5Group:AddTab("--== Ore ==--")

local M205One = Main2o5Group:AddTab("--== Misc ==--")
local M205Two = Main2o5Group:AddTab("--== Load ==--")










-- Tạo tiêu đề phân khu (Thay thế cho CreateSection của Rayfield)
M105One:AddDivider()

-- Danh sách vị trí (Đã để sẵn form để bạn tiện copy/thêm tọa độ mới)
local locations = {
    {Name = "Sell Ore 💰", Position = Vector3.new(-80.87, 93.84, 59.07)}, 
    {Name = "Item Shop 💸", Position = Vector3.new(-57.96, 93.92, 13.34)},
    {Name = "Premium Shop 💸💸💸", Position = Vector3.new(-6.41, 93.83, 55.31)},
    {Name = "Cave Gate ⛩️", Position = Vector3.new(-73.75, 93.28, 95.39)},
}

-- Vòng lặp tự động tạo nút bấm theo chuẩn Obsidian Lib
for _, loc in ipairs(locations) do
    M105One:AddButton({
        Text = "Go to: " .. loc.Name,
        Func = function()
            local player = game:GetService("Players").LocalPlayer
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(loc.Position)
            end
        end,
        DoubleClick = false, -- Click 1 phát bay luôn, không cần click đúp
        Tooltip = "Dịch chuyển đến " .. loc.Name
    })
end


M105One:AddDivider()
-- Biến lưu vị trí gốc (Để bên ngoài để lưu dữ liệu xuyên suốt)
local originalPos = nil

-- Nút 1: Lưu vị trí hiện tại
M105One:AddButton({
    Text = "Save current location",
    DoubleClick = false,
    Tooltip = "Lưu lại tọa độ hiện tại nhân vật đang đứng",
    Func = function()
        local character = game:GetService("Players").LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            originalPos = hrp.CFrame
            
            -- Đổi Rayfield:Notify thành Library:Notify của Obsidian
            Library:Notify({
                Title = "Original location",
                Description = "Current location saved",
                Time = 2
            })
        end
    end
})

-- Nút 2: Quay lại vị trí đã lưu
M105One:AddButton({
    Text = "Return to original position",
    DoubleClick = false,
    Tooltip = "Dịch chuyển về tọa độ đã lưu trước đó",
    Func = function()
        local character = game:GetService("Players").LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if hrp then
            if originalPos then
                hrp.CFrame = originalPos
                
                Library:Notify({
                    Title = "Teleport",
                    Description = "Teleported to saved location",
                    Time = 2
                })
            else
                -- Thêm thông báo báo lỗi nếu lỡ bấm mà chưa save vị trí
                Library:Notify({
                    Title = "ERROR",
                    Description = "Bro, you didn't save a damn thing and now you want a TP?",
                    Time = 3
                })
            end
        end
    end
})








Main1Group:AddDivider()









_G.ESP_Items_Enabled = false
_G.ESP_Enemy_Enabled = false
_G.ShadowMan_Color = Color3.fromRGB(255, 0, 0)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local OreList = {"Nickel", "Cobalt", "Coal", "Tin", "Copper", "Minerals", "Iron", "Diamond", "Lead", "Silver", "Gold"}

-- Bộ nhớ đệm lưu trữ quặng (Tránh GetDescendants liên tục gây lag)
-- Bộ nhớ đệm lưu trữ quặng
local CachedOres = {}

-- Hàm kiểm tra và nạp quặng (Đã thêm bộ lọc chống rác)
local function CheckAndCache(obj)
    -- NẾU LÀ TOOL (Quặng lẻ) HOẶC ĐANG NẰM TRONG NGƯỜI CHƠI -> BỎ QUA NGAY
    if obj:IsA("Tool") or obj:FindFirstAncestorOfClass("Model") and Players:GetPlayerFromCharacter(obj:FindFirstAncestorOfClass("Model")) then 
        return 
    end

    if (obj:IsA("Model") or obj:IsA("BasePart")) and table.find(OreList, obj.Name) then
        if not table.find(CachedOres, obj) then
            table.insert(CachedOres, obj)
        end
    end
end

-- Quét ban đầu khi mở script
for _, obj in ipairs(Workspace:GetDescendants()) do
    CheckAndCache(obj)
end

-- Lắng nghe khi có quặng mới rơi ra map
Workspace.DescendantAdded:Connect(function(descendant)
    CheckAndCache(descendant)
end)

local function GetPart(obj)
    if obj:IsA("BasePart") then return obj end
    return obj:FindFirstChild("ore") or obj:FindFirstChild("Ore") or obj:FindFirstChild("Rock") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
end

-- Hàm check quặng đào (Cập nhật siêu chuẩn)
local function IsMined(obj)
    if not obj or not obj.Parent then return true end
    
    -- 1. Nếu nó trở thành Tool (Quặng rớt ra để nhặt) hoặc bị cầm trên tay -> Đã đào xong
    if obj:IsA("Tool") or obj:IsDescendantOf(LocalPlayer.Character) then return true end
    
    -- 2. Nếu là cục lẻ BasePart
    if obj:IsA("BasePart") then
        -- Nếu nó bị tàng hình HOẶC nó không bị đóng băng (Anchored = false tức là đang lăn lóc trên đất)
        if obj.Transparency >= 1 or not obj.Anchored then return true end
        return false
    end
    
    -- 3. Kiểm tra Model lớn (Rock + Ore)
    local corePart = obj:FindFirstChild("ore") or obj:FindFirstChild("Ore")
    if corePart and corePart:IsA("BasePart") then
        if corePart.Transparency >= 1 then return true end
    end
    
    -- 4. Quét dự phòng mảnh quặng màu
    local hasValidOre = false
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("BasePart") and child.Name ~= "Rock" and child.Name ~= "Stone" then
            -- Mảnh quặng phải hiển thị VÀ PHẢI ĐÓNG BĂNG trên tường (Anchored = true)
            if child.Transparency < 1 and child.Anchored then
                hasValidOre = true
                break
            end
        end
    end
    
    return not hasValidOre
end



--======================================================
-- ORE (ITEM) ESP LOGIC
--======================================================
local function CreateESP(obj)
    local part = GetPart(obj)
    if not part or IsMined(obj) then return end
    if part:FindFirstChild("ESP_Gui") or obj:FindFirstChild("ESP_Outline") then return end

    -- LẤY MÀU CHUẨN: Ưu tiên tuyệt đối cục "ore"/"Ore", bỏ qua hoàn toàn "Rock" màu xám
    local color = Color3.new(1, 1, 1) -- Màu mặc định nếu không quét được
    
    if obj:IsA("BasePart") then
        color = obj.Color
    else
        -- Kiểm tra xem Model có chứa mảnh quặng màu (ore/Ore) không
        local oreChild = obj:FindFirstChild("ore") or obj:FindFirstChild("Ore")
        if oreChild and oreChild:IsA("BasePart") then
            color = oreChild.Color
        else
            -- Vòng lặp quét dự phòng: Lấy màu của part bất kỳ KHÔNG PHẢI là đá (Rock/Stone)
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("BasePart") and child.Name ~= "Rock" and child.Name ~= "Stone" then
                    color = child.Color
                    break
                end
            end
        end
    end

    -- Billboard UI
    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP_Gui"
    gui.Adornee = part
    gui.Size = UDim2.new(0,100,0,40)
    gui.StudsOffset = Vector3.new(0,2,0)
    gui.AlwaysOnTop = true
    gui.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Name = "MainLabel"
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Text = obj.Name.."\nDist: 0.0"
    lbl.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0,0,0)
    stroke.Thickness = 1.5
    stroke.Parent = lbl

    -- Outline Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Outline"
    hl.Adornee = obj
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.OutlineColor = color
    hl.Parent = obj
end

local function ClearESP(obj)
    local part = GetPart(obj)
    if part and part:FindFirstChild("ESP_Gui") then part.ESP_Gui:Destroy() end
    if obj:FindFirstChild("ESP_Outline") then obj.ESP_Outline:Destroy() end
end

-- Vòng lặp cập nhật Quặng
task.spawn(function()
    while true do
        task.wait(0.3) -- Tốc độ quét 0.3s mượt mà hơn để check khoảng cách Slider
        
        -- Dọn dẹp quặng đã biến mất hoàn toàn khỏi map ra khỏi bộ nhớ đệm
        for i = #CachedOres, 1, -1 do
            if not CachedOres[i] or not CachedOres[i].Parent then
                table.remove(CachedOres, i)
            end
        end
        
        -- Lấy giá trị khoảng cách tối đa từ Slider UI (Mặc định 1000 nếu không tìm thấy slider)
        local maxDist = Options.ESPDistanceSlider and Options.ESPDistanceSlider.Value or 1000
        
        if _G.ESP_Items_Enabled and Options.ESPOresDropdown then
            local selectedOres = Options.ESPOresDropdown.Value
            
            for _, obj in ipairs(CachedOres) do
                -- Điều kiện: Quặng được chọn trong danh sách VÀ chưa bị đào xong
                if selectedOres[obj.Name] and not IsMined(obj) then
                    local part = GetPart(obj)
                    if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local dist = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        
                        -- KIỂM TRA KHOẢNG CÁCH SLIDER
                        if dist <= maxDist then
                            CreateESP(obj)
                            local gui = part:FindFirstChild("ESP_Gui")
                            if gui and gui:FindFirstChild("MainLabel") then
                                gui.MaxDistance = maxDist -- Giới hạn tầm nhìn phần cứng của Roblox
                                gui.MainLabel.Text = obj.Name..string.format("\nDist: %.1f", dist)
                            end
                        else
                            ClearESP(obj) -- Quá xa thì xóa tạm thời cho đỡ rối mắt
                        end
                    end
                else
                    ClearESP(obj) -- Bỏ chọn hoặc quặng đã vỡ hoàn toàn thì xóa ESP
                end
            end
        else
            -- Tắt nút chính tắt hết
            for _, obj in ipairs(CachedOres) do
                ClearESP(obj)
            end
        end
    end
end)

--======================================================
-- ENEMY (MONSTERS FOLDER) ESP LOGIC
--======================================================
local function CreateEnemyESP(obj)
    if obj:FindFirstChild("ESP_Gui") or obj:FindFirstChild("ESP_Outline") then return end
    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    local color = _G.ShadowMan_Color or Color3.new(1,0,0)
    local hum = obj:FindFirstChildOfClass("Humanoid")
    local hp = hum and math.floor(hum.Health) or "?"

    local gui = Instance.new("BillboardGui")
    gui.Name = "ESP_Gui"
    gui.Adornee = part
    gui.Size = UDim2.new(0,120,0,50)
    gui.StudsOffset = Vector3.new(0,2,0)
    gui.AlwaysOnTop = true
    gui.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Name = "MainLabel"
    lbl.Size = UDim2.new(1,0,1,0)
    lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 14
    lbl.TextColor3 = color
    lbl.TextStrokeTransparency = 0
    lbl.Text = obj.Name.."\nHP: "..hp.."\nDist: 0.0"
    lbl.Parent = gui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.new(0,0,0)
    stroke.Thickness = 1.5
    stroke.Parent = lbl

    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Outline"
    hl.Adornee = obj
    hl.FillTransparency = 1
    hl.OutlineTransparency = 0
    hl.OutlineColor = color
    hl.Parent = obj
end

local function ClearEnemyESP(obj)
    local part = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    if part and part:FindFirstChild("ESP_Gui") then part.ESP_Gui:Destroy() end
    if obj:FindFirstChild("ESP_Outline") then obj.ESP_Outline:Destroy() end
end

-- Vòng lặp cập nhật Quái vật
task.spawn(function()
    local trackedEnemies = {}

    while true do
        task.wait(0.3)
        local maxDist = Options.ESPDistanceSlider and Options.ESPDistanceSlider.Value or 1000
        
        if _G.ESP_Enemy_Enabled then
            local MonstersFolder = Workspace:FindFirstChild("Monsters") or Workspace:FindFirstChild("monsters")
            
            if MonstersFolder then
                for _, enemy in ipairs(MonstersFolder:GetChildren()) do
                    if enemy:IsA("Model") then
                        local part = enemy.PrimaryPart or enemy:FindFirstChildWhichIsA("BasePart")
                        if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local dist = (part.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            
                            if dist <= maxDist then
                                CreateEnemyESP(enemy)
                                trackedEnemies[enemy] = true

                                local gui = part:FindFirstChild("ESP_Gui")
                                local lbl = gui and gui:FindFirstChild("MainLabel")
                                local hum = enemy:FindFirstChildOfClass("Humanoid")
                                local hp = hum and math.floor(hum.Health) or "?"
                                
                                if lbl then
                                    gui.MaxDistance = maxDist
                                    lbl.Text = enemy.Name.."\nHP: "..hp..string.format("\nDist: %.1f", dist)
                                end
                            else
                                ClearEnemyESP(enemy)
                            end
                        end
                    end
                end
            end
            
            for enemy, _ in pairs(trackedEnemies) do
                local currentFolder = Workspace:FindFirstChild("Monsters") or Workspace:FindFirstChild("monsters")
                if not enemy or not enemy.Parent or (currentFolder and not enemy:IsDescendantOf(currentFolder)) then
                    ClearEnemyESP(enemy)
                    trackedEnemies[enemy] = nil
                end
            end
        else
            for enemy, _ in pairs(trackedEnemies) do
                if enemy and enemy.Parent then ClearEnemyESP(enemy) end
            end
            table.clear(trackedEnemies)
        end
    end
end)

--======================================================    
--  UI CONFIGURATION (Main2Group - LinoriaLib)    
--======================================================    
Main2Group:AddToggle("ESPItemsToggle", {
    Text = "ESP Ores",
    Default = false,
    Callback = function(v)
        _G.ESP_Items_Enabled = v
    end
})

Main2Group:AddDropdown("ESPOresDropdown", {
    Values = OreList,
    Default = 1, 
    Multi = true, 
    Text = "Select Ores to Show",
    Tooltip = "Chọn quặng muốn hiển thị",
    Callback = function(Value) end,
})

-- SLIDER ĐIỀU CHỈNH KHOẢNG CÁCH (100 -> 2000)
Main2Group:AddSlider("ESPDistanceSlider", {
    Text = "Max ESP Distance",
    Default = 1000,
    Min = 100,
    Max = 2000,
    Rounding = 0,
    Compact = false,
    Callback = function(Value) end
})
    
Main2Group:AddToggle("ESPEnemyToggle", {
    Text = "ESP Monsters",
    Default = false,
    Callback = function(v)
        _G.ESP_Enemy_Enabled = v
    end
})



















--======================================================    
--  AUTO MINE LOGIC (Tích hợp vào Main1Group)    
--======================================================    

Main1Group:AddToggle("AutoMineToggle", {
    Text = "Auto Mine Ore",
    Default = false,
    Tooltip = "Tự động đào cứt khi đang cầm Pickaxe",
})

-- Hàm tìm ProximityPrompt của quặng
local function GetClosestOrePrompt()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPart = character.HumanoidRootPart
    local closestPrompt = nil
    local shortestDistance = math.huge

    for _, ore in ipairs(CachedOres) do
        -- Chỉ quét quặng CHƯA BỊ ĐÀO (Đã chặn quặng lẻ rớt đất thông qua IsMined)
        if ore and ore.Parent and not IsMined(ore) then
            local prompt = ore:FindFirstChildOfClass("ProximityPrompt") or ore:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            -- CHỐNG VỨT ĐỒ: Đảm bảo prompt KHÔNG nằm trong một Tool (quặng lẻ đang cầm)
            if prompt and prompt.Enabled and not prompt:FindFirstAncestorOfClass("Tool") then
                local parentPart = prompt.Parent
                if parentPart and parentPart:IsA("BasePart") then
                    local distance = (parentPart.Position - rootPart.Position).Magnitude
                    
                    if distance <= prompt.MaxActivationDistance and distance < shortestDistance then
                        shortestDistance = distance
                        closestPrompt = prompt
                    end
                end
            end
        end
    end
    return closestPrompt
end

task.spawn(function()
    while true do
        task.wait(0.1)
        
        -- Gọi thông qua Options/Toggles của Obsidian Lib
        if Toggles.AutoMineToggle and Toggles.AutoMineToggle.Value then
            local character = LocalPlayer.Character
            if character then
                local equippedTool = character:FindFirstChild("Pickaxe")
                
                -- Chỉ đào khi ĐANG CẦM ĐÚNG PICKAXE
                if equippedTool and equippedTool:IsA("Tool") then
                    local targetPrompt = GetClosestOrePrompt()
                    if targetPrompt then
                        fireproximityprompt(targetPrompt)
                    end
                end
            end
        end
    end
end)











--======================================================    
--  LOGIC AUTO BOX & FENCE (Tối ưu hóa Cache)    
--======================================================    
local CachedBoxes = {}
local CachedFences = {}

-- Hàm nạp dữ liệu môi trường vào bộ nhớ đệm ẩn
local function CacheInteractions(obj)
    if obj.Name == "WoodBox" then
        if not table.find(CachedBoxes, obj) then table.insert(CachedBoxes, obj) end
    elseif obj.Name == "Fence" then
        if not table.find(CachedFences, obj) then table.insert(CachedFences, obj) end
    end
end

-- Tự động quét map ban đầu (Kết nối thẳng vào vòng lặp có sẵn của bạn)
for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
    CacheInteractions(obj)
end
game:GetService("Workspace").DescendantAdded:Connect(CacheInteractions)

-- Hàm tìm kiếm Prompt gần nhất từ danh sách bộ nhớ đệm
local function GetClosestPromptFromCache(cacheList)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPart = character.HumanoidRootPart
    local closestPrompt = nil
    local shortestDistance = math.huge

    for _, obj in ipairs(cacheList) do
        if obj and obj.Parent then
            -- Tìm ProximityPrompt bên trong đối tượng
            local prompt = obj:FindFirstChildOfClass("ProximityPrompt") or obj:FindFirstChildWhichIsA("ProximityPrompt", true)
            
            if prompt and prompt.Enabled then
                -- Định vị Part vật lý để tính khoảng cách chuẩn xác
                local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
                if part then
                    local distance = (part.Position - rootPart.Position).Magnitude
                    -- Kiểm tra nếu người chơi đứng đủ gần phạm vi kích hoạt của vật thể
                    if distance <= prompt.MaxActivationDistance and distance < shortestDistance then
                        shortestDistance = distance
                        closestPrompt = prompt
                    end
                end
            end
        end
    end
    return closestPrompt
end

-- Vòng lặp Core xử lý Auto tương tác (Tốc độ phản hồi 0.1s)
task.spawn(function()
    while true do
        task.wait(0.1)
        local character = LocalPlayer.Character
        if not character then continue end

        -- CHỨC NĂNG 1: Auto Mở Thùng (WoodBox)
        if Toggles.AutoOpenBoxToggle and Toggles.AutoOpenBoxToggle.Value then
            local crowbar = character:FindFirstChild("Crowbar")
            if crowbar and crowbar:IsA("Tool") then
                -- Dọn dẹp các thùng đã bị phá hủy hoàn toàn khỏi bộ nhớ
                for i = #CachedBoxes, 1, -1 do
                    if not CachedBoxes[i] or not CachedBoxes[i].Parent then table.remove(CachedBoxes, i) end
                end
                
                local targetPrompt = GetClosestPromptFromCache(CachedBoxes)
                if targetPrompt then
                    fireproximityprompt(targetPrompt)
                end
            end
        end

        -- CHỨC NĂNG 2: Auto Chặt Vật Chắn (Fence)
        if Toggles.AutoChopFenceToggle and Toggles.AutoChopFenceToggle.Value then
            local axe = character:FindFirstChild("Axe")
            if axe and axe:IsA("Tool") then
                -- Dọn dẹp hàng rào đã bị phá hủy khỏi bộ nhớ
                for i = #CachedFences, 1, -1 do
                    if not CachedFences[i] or not CachedFences[i].Parent then table.remove(CachedFences, i) end
                end
                
                local targetPrompt = GetClosestPromptFromCache(CachedFences)
                if targetPrompt then
                    fireproximityprompt(targetPrompt)
                end
            end
        end
    end
end)


--======================================================    
--  UI TOGGLES (Thêm vào Main1Group)    
--======================================================    
Main1Group:AddToggle("AutoOpenBoxToggle", {
    Text = "Auto Open Box (Crowbar)",
    Default = false,
    Tooltip = "Tự động mở Hộp mù khi đang cầm Crowbar",
})

Main1Group:AddToggle("AutoChopFenceToggle", {
    Text = "Auto fence breaking (Axe)",
    Default = false,
    Tooltip = "Tự động phá hủy Thanh Gỗ khi đang cầm Axe",
})








--======================================================    
--  ORE TELEPORT UI (Đã sửa lỗi nhận diện quặng rỗng)    
--======================================================    
M105Two:AddDropdown("TeleportOreDropdown", {
    Values = OreList,
    Default = 1, 
    Multi = false, 
    Text = "Select Ore to Teleport",
    Tooltip = "Chọn loại quặng bạn muốn dịch chuyển tới",
})

M105Two:AddButton({
    Text = "Teleport to Closest Ore",
    DoubleClick = false,
    Tooltip = "Tp đến cục quặng gần nhất mà mày đã chọn (Chưa đào)",
    Func = function()
        local selectedOreName = Options.TeleportOreDropdown and Options.TeleportOreDropdown.Value
        if not selectedOreName then 
            Library:Notify({ Title = "ERROR", Description = "Bro, you didn't even choose anything and you're already pressing TP?", Time = 3 })
            return 
        end

        local character = LocalPlayer.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local closestOrePart = nil
        local shortestDistance = math.huge

        -- Quét danh sách bộ nhớ đệm quặng
        for _, obj in ipairs(CachedOres) do
            -- Ép điều kiện lọc cực gắt: Phải đúng tên VÀ hàm IsMined phải xác nhận là CHƯA ĐÀO
            if obj and obj.Name == selectedOreName and not IsMined(obj) then
                local part = GetPart(obj)
                -- Đảm bảo part này không phải là cục đá rỗng bị bỏ lại
                if part and part.Name ~= "Rock" and part.Name ~= "Stone" or (part and part.Transparency < 1) then
                    local distance = (part.Position - hrp.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestOrePart = part
                    end
                end
            end
        end

        -- Thực hiện dịch chuyển
        if closestOrePart then
            hrp.CFrame = CFrame.new(closestOrePart.Position + Vector3.new(0, 3, 0))
            Library:Notify({
                Title = "Teleport Success",
                Description = "Goto nearest " .. selectedOreName .. " Ore",
                Time = 3
            })
        else
            Library:Notify({
                Title = "Faild",
                Description = "Bro, you've already mined every ore " .. selectedOreName .. " What more do you want?",
                Time = 4
            })
        end
    end
})
















M205One:AddDivider()

local Lighting = game:GetService("Lighting")

-- Khởi tạo các bảng lưu trữ ngoài để tránh rò rỉ bộ nhớ khi nhấn bật/tắt nhiều lần
local originalLightingProps = {}
local originalEffects = {}
local fbConnections = {}

M205One:AddToggle("FullBright", {
    Text = "Full Bright",
    Default = false,
    Callback = function(Value)
        _G.FullBright = Value

        -- Hàm áp dụng các thông số FullBright một cách tối ưu
        local function applyFullBright()
            -- Tạm thời ngắt kết nối Event đổi thuộc tính để tránh vòng lặp vô hạn (Infinite Loop)
            if fbConnections.LightingChanged then 
                fbConnections.LightingChanged:Disconnect() 
                fbConnections.LightingChanged = nil 
            end

            Lighting.Brightness = 2
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.FogEnd = 100000
            Lighting.FogStart = 0
            Lighting.GlobalShadows = false

            -- Kết nối lại Event sau khi đã đổi xong xuôi
            fbConnections.LightingChanged = Lighting.Changed:Connect(applyFullBright)
        end

        -- Hàm ẩn/vô hiệu hóa hiệu ứng thay vì xóa (Destroy)
        local function handleEffect(v)
            if v:IsA("Atmosphere") then
                if not originalEffects[v] then
                    originalEffects[v] = {Property = "Parent", Value = v.Parent}
                end
                v.Parent = nil -- Chỉ tạm ẩn (giúp khôi phục sương mù gốc của game sau này)
            elseif v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                if not originalEffects[v] then
                    originalEffects[v] = {Property = "Enabled", Value = v.Enabled}
                end
                v.Enabled = false -- Tắt kích hoạt đi chứ không xóa
            end
        end

        if _G.FullBright then
            -- 1. Lưu lại cấu hình ánh sáng hiện tại của server (Mỗi lần bật sẽ tự cập nhật theo map mới)
            originalLightingProps.Brightness = Lighting.Brightness
            originalLightingProps.Ambient = Lighting.Ambient
            originalLightingProps.OutdoorAmbient = Lighting.OutdoorAmbient
            originalLightingProps.FogEnd = Lighting.FogEnd
            originalLightingProps.FogStart = Lighting.FogStart
            originalLightingProps.GlobalShadows = Lighting.GlobalShadows

            -- 2. Xử lý các hiệu ứng đang có sẵn trong Lighting
            for _, v in ipairs(Lighting:GetChildren()) do
                handleEffect(v)
            end

            -- 3. Kích hoạt ánh sáng sáng lên ngay lập tức
            applyFullBright()

            -- 4. Dùng Event lắng nghe thay thế cho vòng lặp (Triệt tiêu hiện tượng lag CPU)
            -- Nếu game tự tạo ra hiệu ứng tối mới, lập tức ẩn nó đi
            fbConnections.ChildAdded = Lighting.ChildAdded:Connect(function(v)
                if _G.FullBright then
                    handleEffect(v)
                end
            end)
        else
            -- ======================================================
            -- TẮT FULLBRIGHT: TRẢ MỌI THỨ VỀ NGUYÊN BẢN (FIX FOG)
            -- ======================================================
            
            -- Ngắt toàn bộ các cổng kết nối Event lắng nghe để giải phóng CPU
            for k, conn in pairs(fbConnections) do
                if conn then conn:Disconnect() end
            end
            table.clear(fbConnections)

            -- Khôi phục các thuộc tính cơ bản của Lighting
            if originalLightingProps.Brightness then
                Lighting.Brightness = originalLightingProps.Brightness
                Lighting.Ambient = originalLightingProps.Ambient
                Lighting.OutdoorAmbient = originalLightingProps.OutdoorAmbient
                Lighting.FogEnd = originalLightingProps.FogEnd
                Lighting.FogStart = originalLightingProps.FogStart
                Lighting.GlobalShadows = originalLightingProps.GlobalShadows
            end

            -- Khôi phục toàn bộ các Atmosphere & Hiệu ứng về vị trí cũ
            for effect, data in pairs(originalEffects) do
                if effect then
                    if data.Property == "Parent" then
                        effect.Parent = data.Value
                    elseif data.Property == "Enabled" then
                        effect.Enabled = data.Value
                    end
                end
            end
            table.clear(originalEffects)
        end
    end
})

local ProximityPromptService = game:GetService("ProximityPromptService")
local PromptConnection

M205One:AddToggle("InstantPrompt", {
    Text = "Instant Prompt",
    Default = false,
    Callback = function(Value)
        if PromptConnection then
            PromptConnection:Disconnect()
            PromptConnection = nil
        end

        if Value then
            PromptConnection = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
                fireproximityprompt(prompt)
            end)
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
M205One:AddButton("Third Person", function()

    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Đợi character & humanoid load
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.CharacterAdded:Wait()
    end

    -- Set zoom xa tối đa
    LocalPlayer.CameraMaxZoomDistance = 300
    LocalPlayer.CameraMinZoomDistance = 0.5 -- giữ góc nhìn third

    -- Set camera thành Third Person
    LocalPlayer.CameraMode = Enum.CameraMode.Classic

    Library:Notify("Camera unlocked", 3)

end)




M205Two:AddDivider()

M205Two:AddButton("Load InfYield Edit", function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/idtkby/Xd/refs/heads/main/infedit"))()  
				
			end)
M205Two:AddButton("Load Radar", function()
			--- Bản vẽ Radar người chơi
--- Được làm bởi topit

_G.RadarSettings3 = {
    --- Mục tiêu định vị ---
    TRACK_PLAYERS = true;                     -- Bật/Tắt định vị Người chơi (Players)
    TRACK_NPCS = false;                        -- Bật/Tắt định vị thực thể máy (NPCs)

    --- Radar settings ---
    RADAR_LINES = true; 
    RADAR_LINE_DISTANCE = 50; 
    RADAR_SCALE = .5; 
    RADAR_RADIUS = 62.; 
    RADAR_START_POS = Vector2.new(300, 250); -- Tọa độ hiển thị mặc định của tâm Radar
    RADAR_ROTATION = true; 
    SMOOTH_ROT = true; 
    SMOOTH_ROT_AMNT = 30; 
    CARDINAL_DISPLAY = true; 
    
    --- Path Recording Settings (Bản đồ đường đi của bạn) ---
    RECORD_PATH = true;                      -- Bật/Tắt chức năng vẽ lại đường đi cũ của bản thân
    PATH_DISTANCE = 30;                       -- Khoảng cách (studs) giữa mỗi dấu chấm đường đi
    PATH_MAX_POINTS = 500;                   -- Giới hạn số điểm tối đa để bảo vệ FPS
    PATH_COLOR = Color3.fromRGB(0, 225, 255);-- Màu của đường đi cũ (Xanh Cyan)
    
    --- Marker settings ---
    DISPLAY_OFFSCREEN = true; 
    DISPLAY_TEAMMATES = true; 
    DISPLAY_TEAM_COLORS = true; 
    DISPLAY_FRIEND_COLORS = true; 
    DISPLAY_RGB_COLORS = false; 
    MARKER_SCALE_BASE = 1.25; 
    MARKER_SCALE_MAX = 1.25; 
    MARKER_SCALE_MIN = 0.75; 
    MARKER_FALLOFF = true; 
    MARKER_FALLOFF_AMNT = 125; 
    OFFSCREEN_TRANSPARENCY = 0.3; 
    USE_FALLBACK = false; 
    USE_QUADS = true; 
    USE_TEAM_COLORS = false; 
    VISIBLITY_CHECK = false; 
    
    --- Theme Màu Sắc ---
    RADAR_THEME = {
        Outline = Color3.fromRGB(35, 35, 45); 
        Background = Color3.fromRGB(25, 25, 35); 
        DragHandle = Color3.fromRGB(50, 50, 255); 
        Cardinal_Lines = Color3.fromRGB(110, 110, 120); 
        Distance_Lines = Color3.fromRGB(65, 65, 75); 
        Generic_Marker = Color3.fromRGB(255, 25, 115); 
        Team_Marker = Color3.fromRGB(25, 115, 255); 
        Friend_Marker = Color3.fromRGB(25, 255, 115); 
        
        Local_Marker = Color3.fromRGB(115, 25, 255); -- Tím gốc của LocalPlayer
        NPC_Marker = Color3.fromRGB(255,0,0);  -- Màu giống LocalPlayer nhưng SÁNG HƠN (Neon Violet)
    };
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/idtkby/NowGeta/main/Full%20Function%20Radar'))()

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
