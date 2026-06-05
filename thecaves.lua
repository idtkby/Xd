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
local M105One = Main1o5Group:AddTab("--== Player ==--")

local M205One = Main2o5Group:AddTab("--== Misc ==--")
local M205Two = Main2o5Group:AddTab("--== Load ==--")




















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
local CachedOres = {}

-- Hàm kiểm tra và nạp quặng vào danh sách (Hỗ trợ cả Model lớn và Part quặng nhỏ lẻ rơi ra)
local function CheckAndCache(obj)
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

-- Lắng nghe khi có quặng mới hoặc quặng lẻ rơi ra map
Workspace.DescendantAdded:Connect(function(descendant)
    CheckAndCache(descendant)
end)

-- Hàm tìm Part chính để treo BillboardGui
local function GetPart(obj)
    if obj:IsA("BasePart") then return obj end -- Nếu là cục quặng lẻ rơi ra
    return obj:FindFirstChild("ore") or obj:FindFirstChild("Rock") or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
end

-- Hàm kiểm tra xem quặng đã bị đào/vỡ chưa (Sửa lỗi vẫn hiện ESP khi đào xong)
local function IsMined(obj)
    if not obj or not obj.Parent then return true end
    
    -- Trường hợp 1: Nếu là cục quặng lẻ rơi ra (bản thân nó là BasePart)
    if obj:IsA("BasePart") then
        return obj.Transparency >= 1
    end
    
    -- Trường hợp 2: Kiểm tra các part cốt lõi bên trong Model quặng lớn ("ore" hoặc "Rock")
    local corePart = obj:FindFirstChild("ore") or obj:FindFirstChild("Rock")
    if corePart and corePart:IsA("BasePart") and corePart.Transparency >= 1 then
        return true
    end
    
    -- Trường hợp 3: Quét diện rộng xem tất cả các part hiển thị bên trong có bị tàng hình hết không
    local hasVisiblePart = false
    for _, child in ipairs(obj:GetChildren()) do
        if child:IsA("BasePart") and child.Transparency < 1 then
            hasVisiblePart = true
            break
        end
    end
    
    return not hasVisiblePart -- Nếu không có part nào nhìn thấy được nữa => Đã đào xong
end

--======================================================
-- ORE (ITEM) ESP LOGIC
--======================================================
local function CreateESP(obj)
    local part = GetPart(obj)
    if not part or IsMined(obj) then return end
    if part:FindFirstChild("ESP_Gui") or obj:FindFirstChild("ESP_Outline") then return end

    -- Lấy màu động từ quặng.ore hoặc quặng.Rock hoặc bản thân cục quặng lẻ
    local oreChild = obj:IsA("Model") and (obj:FindFirstChild("ore") or obj:FindFirstChild("Rock")) or nil
    local color = (oreChild and oreChild:IsA("BasePart")) and oreChild.Color or part.Color or Color3.new(1,1,1)

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

-- Vòng lặp cập nhật Quái vật (Cũng áp dụng giới hạn tầm nhìn Slider luôn)
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
    Text = "ESP Ores Master",
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
    Rounding = 0, -- Làm tròn số nguyên (không lấy số thập phân cho gọn)
    Compact = false,
    Callback = function(Value)
        -- LinoriaLib tự động cập nhật giá trị vào Options.ESPDistanceSlider.Value
    end
})
    
Main2Group:AddToggle("ESPEnemyToggle", {
    Text = "ESP Monsters",
    Default = false,
    Callback = function(v)
        _G.ESP_Enemy_Enabled = v
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
    TRACK_NPCS = true;                        -- Bật/Tắt định vị thực thể máy (NPCs)

    --- Radar settings ---
    RADAR_LINES = true; 
    RADAR_LINE_DISTANCE = 50; 
    RADAR_SCALE = .3; 
    RADAR_RADIUS = 80; 
    RADAR_START_POS = Vector2.new(300, 250); -- Tọa độ hiển thị mặc định của tâm Radar
    RADAR_ROTATION = true; 
    SMOOTH_ROT = true; 
    SMOOTH_ROT_AMNT = 30; 
    CARDINAL_DISPLAY = true; 
    
    --- Path Recording Settings (Bản đồ đường đi của bạn) ---
    RECORD_PATH = true;                      -- Bật/Tắt chức năng vẽ lại đường đi cũ của bản thân
    PATH_DISTANCE = 8;                       -- Khoảng cách (studs) giữa mỗi dấu chấm đường đi
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
