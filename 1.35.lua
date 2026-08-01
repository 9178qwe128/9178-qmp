-- ============================================
-- 武器配置系统 - 横向紧凑界面
-- 版本: v2.1.0
-- 更新: 2026-07-31
-- ============================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

-- ============================================
-- RSPY 抓包数据 (实际武器参数)
-- ============================================
local weaponData = {
    ["M4A1"] = {
        fireRate = 750,        -- 射速 (RPM)
        recoil = 0.35,         -- 后坐力
        spread = 0.08,         -- 散布
        bulletSpeed = 880,     -- 子弹速度 (m/s)
        damage = 33,           -- 伤害
        magSize = 30,          -- 弹匣容量
        reloadTime = 2.1,      -- 换弹时间 (秒)
        aimSpeed = 0.25,       -- 瞄准速度
        autoFire = true,       -- 是否全自动
        burstCount = 3,        -- 连发数
        weight = 3.1,          -- 重量 (kg)
        effectiveRange = 400   -- 有效射程 (m)
    },
    ["AK47"] = {
        fireRate = 600,
        recoil = 0.55,
        spread = 0.12,
        bulletSpeed = 715,
        damage = 42,
        magSize = 30,
        reloadTime = 2.5,
        aimSpeed = 0.30,
        autoFire = true,
        burstCount = 3,
        weight = 3.8,
        effectiveRange = 350
    },
    ["狙击枪"] = {
        fireRate = 60,
        recoil = 1.2,
        spread = 0.01,
        bulletSpeed = 1200,
        damage = 100,
        magSize = 5,
        reloadTime = 3.5,
        aimSpeed = 0.15,
        autoFire = false,
        burstCount = 1,
        weight = 5.2,
        effectiveRange = 800
    },
    ["霰弹枪"] = {
        fireRate = 80,
        recoil = 0.8,
        spread = 0.35,
        bulletSpeed = 400,
        damage = 15,
        magSize = 8,
        reloadTime = 3.0,
        aimSpeed = 0.20,
        autoFire = false,
        burstCount = 1,
        weight = 3.5,
        effectiveRange = 50
    },
    ["冲锋枪"] = {
        fireRate = 900,
        recoil = 0.25,
        spread = 0.15,
        bulletSpeed = 450,
        damage = 22,
        magSize = 32,
        reloadTime = 2.0,
        aimSpeed = 0.18,
        autoFire = true,
        burstCount = 3,
        weight = 2.8,
        effectiveRange = 200
    }
}

-- 当前选中的武器
local currentWeapon = "M4A1"

-- ============================================
-- 创建主 GUI
-- ============================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WeaponConfigGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- 主框架 (小尺寸)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 580, 0, 420)
mainFrame.Position = UDim2.new(0.5, -290, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(45, 45, 55)
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

-- 圆角
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- 阴影效果
local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.Size = UDim2.new(1, 10, 1, 10)
shadow.Position = UDim2.new(0, -5, 0, -5)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.6
shadow.BorderSizePixel = 0
shadow.ZIndex = -1
shadow.Parent = mainFrame

-- ============================================
-- 标题栏
-- ============================================
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(36, 36, 44)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleBar

-- 标题文字
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0.03, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚙ 武器配置系统"
titleLabel.TextColor3 = Color3.fromRGB(225, 225, 235)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 14
titleLabel.Parent = titleBar

-- 版本更新徽标 (显示更新数量)
local badgeFrame = Instance.new("Frame")
badgeFrame.Size = UDim2.new(0, 26, 0, 26)
badgeFrame.Position = UDim2.new(0.22, 0, 0.5, -13)
badgeFrame.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
badgeFrame.BorderSizePixel = 0
badgeFrame.Parent = titleBar

local badgeCorner = Instance.new("UICorner")
badgeCorner.CornerRadius = UDim.new(1, 0)
badgeCorner.Parent = badgeFrame

local badgeLabel = Instance.new("TextLabel")
badgeLabel.Size = UDim2.new(1, 0, 1, 0)
badgeLabel.BackgroundTransparency = 1
badgeLabel.Text = "5"
badgeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
badgeLabel.TextSize = 12
badgeLabel.Font = Enum.Font.GothamBold
badgeLabel.Parent = badgeFrame

-- 版本号
local versionLabel = Instance.new("TextLabel")
versionLabel.Size = UDim2.new(0.2, 0, 1, 0)
versionLabel.Position = UDim2.new(0.28, 0, 0, 0)
versionLabel.BackgroundTransparency = 1
versionLabel.Text = "v2.1.0"
versionLabel.TextColor3 = Color3.fromRGB(150, 150, 175)
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.TextSize = 11
versionLabel.Font = Enum.Font.GothamMedium
versionLabel.Parent = titleBar

-- 最小化按钮
local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeBtn"
minimizeButton.Size = UDim2.new(0, 32, 1, 0)
minimizeButton.Position = UDim2.new(0.88, 0, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "─"
minimizeButton.TextColor3 = Color3.fromRGB(200, 200, 210)
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 18
minimizeButton.Parent = titleBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minimizeButton

-- 关闭按钮
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseBtn"
closeButton.Size = UDim2.new(0, 32, 1, 0)
closeButton.Position = UDim2.new(0.94, 0, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- ============================================
-- 左侧面板 (功能分类)
-- ============================================
local leftPanel = Instance.new("Frame")
leftPanel.Name = "LeftPanel"
leftPanel.Size = UDim2.new(0, 140, 1, -32)
leftPanel.Position = UDim2.new(0, 0, 0, 32)
leftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
leftPanel.BorderSizePixel = 0
leftPanel.Parent = mainFrame

-- 左侧面板内边距
local leftPadding = Instance.new("Frame")
leftPadding.Size = UDim2.new(1, -6, 1, -6)
leftPadding.Position = UDim2.new(0, 3, 0, 3)
leftPadding.BackgroundTransparency = 1
leftPadding.Parent = leftPanel

-- ============================================
-- 右侧面板 (配置内容)
-- ============================================
local rightPanel = Instance.new("Frame")
rightPanel.Name = "RightPanel"
rightPanel.Size = UDim2.new(1, -140, 1, -32)
rightPanel.Position = UDim2.new(0, 140, 0, 32)
rightPanel.BackgroundColor3 = Color3.fromRGB(33, 33, 41)
rightPanel.BorderSizePixel = 0
rightPanel.Parent = mainFrame

-- 分割线
local divider = Instance.new("Frame")
divider.Size = UDim2.new(0, 1, 1, -32)
divider.Position = UDim2.new(0, 140, 0, 32)
divider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
divider.BorderSizePixel = 0
divider.Parent = mainFrame

-- ============================================
-- 分类定义
-- ============================================
local categories = {
    {name = "基础参数", id = "basic", icon = "🔫"},
    {name = "瞄准设置", id = "aim", icon = "🎯"},
    {name = "弹道数据", id = "ballistic", icon = "📊"},
    {name = "射速调节", id = "fireRate", icon = "⚡"},
    {name = "弹药管理", id = "ammo", icon = "📦"},
    {name = "武器选择", id = "weaponSelect", icon = "🔧"},
    {name = "📢 公告", id = "announcement", icon = ""}
}

local categoryButtons = {}
local selectedCategory = nil

-- ============================================
-- 创建分类按钮
-- ============================================
local function createCategoryButton(categoryData, index)
    local btn = Instance.new("TextButton")
    btn.Name = "CatBtn_" .. categoryData.id
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, (index - 1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    btn.BackgroundTransparency = 0.5
    btn.BorderSizePixel = 0
    btn.Text = (categoryData.icon ~= "" and categoryData.icon .. " " or "") .. categoryData.name
    btn.TextColor3 = Color3.fromRGB(175, 175, 190)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = leftPadding
    
    -- 悬停效果
    btn.MouseEnter:Connect(function()
        if selectedCategory ~= categoryData.id then
            btn.BackgroundColor3 = Color3.fromRGB(50, 50, 62)
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if selectedCategory ~= categoryData.id then
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            btn.BackgroundTransparency = 0.5
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        selectCategory(categoryData.id)
    end)
    
    categoryButtons[categoryData.id] = btn
    return btn
end

-- ============================================
-- 选择分类
-- ============================================
function selectCategory(categoryId)
    selectedCategory = categoryId
    
    for id, btn in pairs(categoryButtons) do
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        btn.BackgroundTransparency = 0.5
        btn.TextColor3 = Color3.fromRGB(175, 175, 190)
    end
    
    local selectedBtn = categoryButtons[categoryId]
    if selectedBtn then
        selectedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
        selectedBtn.BackgroundTransparency = 0.1
        selectedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
    
    updateRightPanel(categoryId)
end

-- ============================================
-- 更新右侧面板
-- ============================================
function updateRightPanel(categoryId)
    -- 清除旧内容
    for _, child in pairs(rightPanel:GetChildren()) do
        child:Destroy()
    end
    
    if categoryId == "announcement" then
        createAnnouncementPanel()
    else
        createConfigPanel(categoryId)
    end
end

-- ============================================
-- 创建配置面板
-- ============================================
function createConfigPanel(categoryId)
    local configs = getCategoryConfigs(categoryId)
    
    -- 滚动框
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -10, 1, -10)
    scrollFrame.Position = UDim2.new(0, 5, 0, 5)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #configs * 52 + 10)
    scrollFrame.ScrollBarThickness = 5
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 75)
    scrollFrame.Parent = rightPanel
    
    local canvas = Instance.new("Frame")
    canvas.Size = UDim2.new(1, 0, 0, #configs * 52 + 10)
    canvas.BackgroundTransparency = 1
    canvas.Parent = scrollFrame
    
    -- 创建配置项
    for i, config in ipairs(configs) do
        createConfigItem(canvas, config, i)
    end
end

-- ============================================
-- 获取分类配置
-- ============================================
function getCategoryConfigs(categoryId)
    local weapon = weaponData[currentWeapon] or weaponData["M4A1"]
    
    local configs = {
        basic = {
            {label = "后坐力系数", type = "slider", min = 0, max = 200, default = weapon.recoil * 100, key = "recoil", unit = "%"},
            {label = "散布范围", type = "slider", min = 0, max = 50, default = weapon.spread * 100, key = "spread", unit = "%"},
            {label = "开火模式", type = "dropdown", options = {"单发", "三连发", "全自动"}, default = weapon.autoFire and 3 or 1, key = "fireMode"},
            {label = "枪口上跳", type = "toggle", default = true, key = "muzzleClimb"}
        },
        aim = {
            {label = "辅助瞄准", type = "toggle", default = true, key = "aimAssist"},
            {label = "瞄准速度", type = "slider", min = 1, max = 20, default = weapon.aimSpeed * 40, key = "aimSpeed", unit = "%"},
            {label = "瞄准范围", type = "slider", min = 5, max = 120, default = 30, key = "aimFov", unit = "°"},
            {label = "预判修正", type = "slider", min = 0, max = 100, default = 60, key = "prediction", unit = "%"}
        },
        ballistic = {
            {label = "显示弹道", type = "toggle", default = true, key = "showTrajectory"},
            {label = "曳光弹", type = "toggle", default = true, key = "tracer"},
            {label = "子弹速度", type = "slider", min = 100, max = 1500, default = weapon.bulletSpeed, key = "bulletSpeed", unit = "m/s"},
            {label = "弹道颜色", type = "colorpicker", default = Color3.fromRGB(255, 200, 50), key = "trajectoryColor"}
        },
        fireRate = {
            {label = "射速倍率", type = "slider", min = 0.5, max = 3.0, default = 1.0, step = 0.1, key = "fireRateMult", unit = "x"},
            {label = "连射延迟", type = "slider", min = 0, max = 500, default = 100, key = "burstDelay", unit = "ms"},
            {label = "自动射击", type = "toggle", default = weapon.autoFire, key = "autoFire"},
            {label = "当前射速", type = "display", value = weapon.fireRate .. " RPM", key = "currentRPM"}
        },
        ammo = {
            {label = "无限弹药", type = "toggle", default = false, key = "infiniteAmmo"},
            {label = "弹匣容量", type = "slider", min = 1, max = 100, default = weapon.magSize, key = "magSize"},
            {label = "换弹速度", type = "slider", min = 0.5, max = 3.0, default = 1.0, step = 0.1, key = "reloadSpeed", unit = "x"},
            {label = "备弹数量", type = "number", default = weapon.magSize * 3, key = "reserveAmmo"}
        },
        weaponSelect = {
            {label = "当前武器", type = "dropdown", options = {"M4A1", "AK47", "狙击枪", "霰弹枪", "冲锋枪"}, default = 1, key = "currentWeapon"},
            {label = "武器重量", type = "display", value = weapon.weight .. " kg", key = "weight"},
            {label = "有效射程", type = "display", value = weapon.effectiveRange .. " m", key = "range"},
            {label = "基础伤害", type = "display", value = weapon.damage, key = "damage"}
        }
    }
    return configs[categoryId] or {}
end

-- ============================================
-- 创建配置项
-- ============================================
function createConfigItem(parent, config, index)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, -4, 0, 46)
    itemFrame.Position = UDim2.new(0, 2, 0, (index - 1) * 52 + 3)
    itemFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    itemFrame.BackgroundTransparency = 0.4
    itemFrame.BorderSizePixel = 1
    itemFrame.BorderColor3 = Color3.fromRGB(48, 48, 58)
    itemFrame.Parent = parent
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 4)
    itemCorner.Parent = itemFrame
    
    -- 标签
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.45, 0, 1, 0)
    label.Position = UDim2.new(0.02, 0, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = config.label
    label.TextColor3 = Color3.fromRGB(210, 210, 220)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.Parent = itemFrame
    
    -- 控件容器
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0.5, -5, 1, -6)
    controlFrame.Position = UDim2.new(0.48, 0, 0, 3)
    controlFrame.BackgroundTransparency = 1
    controlFrame.Parent = itemFrame
    
    -- 创建对应控件
    local controlFunctions = {
        slider = createSlider,
        toggle = createToggle,
        dropdown = createDropdown,
        number = createNumberInput,
        colorpicker = createColorPicker,
        display = createDisplay
    }
    
    if controlFunctions[config.type] then
        controlFunctions[config.type](controlFrame, config)
    end
end

-- ============================================
-- 控件: 滑块
-- ============================================
function createSlider(parent, config)
    local value = config.default or 50
    local min = config.min or 0
    local max = config.max or 100
    local step = config.step or 1
    local unit = config.unit or ""
    
    -- 滑块背景
    local slider = Instance.new("Frame")
    slider.Size = UDim2.new(0.65, 0, 0.45, 0)
    slider.Position = UDim2.new(0, 0, 0.27, 0)
    slider.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    slider.BorderSizePixel = 0
    slider.Parent = parent
    
    -- 填充
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(70, 130, 255)
    fill.BorderSizePixel = 0
    fill.Parent = slider
    
    -- 拖拽按钮
    local dragBtn = Instance.new("TextButton")
    dragBtn.Size = UDim2.new(0, 14, 1.8, 0)
    dragBtn.Position = UDim2.new((value - min) / (max - min), -7, -0.4, 0)
    dragBtn.BackgroundColor3 = Color3.fromRGB(100, 160, 255)
    dragBtn.BorderSizePixel = 0
    dragBtn.Text = ""
    dragBtn.Parent = slider
    
    -- 数值显示
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0.3, 0, 1, 0)
    valueLabel.Position = UDim2.new(0.7, 0, 0, 0)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(value) .. unit
    valueLabel.TextColor3 = Color3.fromRGB(200, 200, 210)
    valueLabel.TextSize = 11
    valueLabel.Font = Enum.Font.GothamMedium
    valueLabel.Parent = parent
    
    -- 拖拽逻辑
    local dragging = false
    dragBtn.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    mouse.Move:Connect(function()
        if dragging then
            local absPos = slider.AbsolutePosition
            local absSize = slider.AbsoluteSize
            local x = math.clamp((mouse.X - absPos.X) / absSize.X, 0, 1)
            local newValue = min + (max - min) * x
            newValue = math.round(newValue / step) * step
            newValue = math.clamp(newValue, min, max)
            
            fill.Size = UDim2.new(x, 0, 1, 0)
            dragBtn.Position = UDim2.new(x, -7, -0.4, 0)
            valueLabel.Text = tostring(newValue) .. unit
            
            updateWeaponConfig(config.key, newValue)
        end
    end)
end

-- ============================================
-- 控件: 开关
-- ============================================
function createToggle(parent, config)
    local state = config.default or false
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 44, 0, 24)
    toggleBtn.Position = UDim2.new(0.5, -22, 0.2, 0)
    toggleBtn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 80)
    toggleBtn.BorderSizePixel = 0
    toggleBtn.Text = state and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 10
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = parent
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggleBtn
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(70, 70, 80)
        toggleBtn.Text = state and "ON" or "OFF"
        updateWeaponConfig(config.key, state)
    end)
end

-- ============================================
-- 控件: 下拉菜单
-- ============================================
function createDropdown(parent, config)
    local options = config.options or {"选项1", "选项2"}
    local default = config.default or 1
    local selected = math.clamp(default, 1, #options)
    
    local dropdown = Instance.new("TextButton")
    dropdown.Size = UDim2.new(0.7, 0, 0.55, 0)
    dropdown.Position = UDim2.new(0.15, 0, 0.22, 0)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    dropdown.BorderSizePixel = 1
    dropdown.BorderColor3 = Color3.fromRGB(60, 60, 70)
    dropdown.Text = options[selected]
    dropdown.TextColor3 = Color3.fromRGB(220, 220, 230)
    dropdown.TextSize = 11
    dropdown.Font = Enum.Font.GothamMedium
    dropdown.Parent = parent
    
    local dropCorner = Instance.new("UICorner")
    dropCorner.CornerRadius = UDim.new(0, 3)
    dropCorner.Parent = dropdown
    
    -- 下拉箭头
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -22, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(150, 150, 170)
    arrow.TextSize = 10
    arrow.Font = Enum.Font.GothamMedium
    arrow.Parent = dropdown
    
    local dropdownList = nil
    
    dropdown.MouseButton1Click:Connect(function()
        if dropdownList then
            dropdownList:Destroy()
            dropdownList = nil
            return
        end
        
        dropdownList = Instance.new("Frame")
        dropdownList.Size = UDim2.new(1, 0, 0, #options * 26)
        dropdownList.Position = UDim2.new(0, 0, 1, 2)
        dropdownList.BackgroundColor3 = Color3.fromRGB(42, 42, 50)
        dropdownList.BorderSizePixel = 1
        dropdownList.BorderColor3 = Color3.fromRGB(60, 60, 70)
        dropdownList.ZIndex = 10
        dropdownList.Parent = dropdown
        
        local listCorner = Instance.new("UICorner")
        listCorner.CornerRadius = UDim.new(0, 3)
        listCorner.Parent = dropdownList
        
        for i, option in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 26)
            optBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 26)
            optBtn.BackgroundColor3 = (i == selected) and Color3.fromRGB(60, 80, 140) or Color3.fromRGB(45, 45, 55)
            optBtn.BorderSizePixel = 0
            optBtn.Text = option
            optBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
            optBtn.TextSize = 11
            optBtn.Font = Enum.Font.GothamMedium
            optBtn.Parent = dropdownList
            
            optBtn.MouseButton1Click:Connect(function()
                selected = i
                dropdown.Text = option
                dropdownList:Destroy()
                dropdownList = nil
                
                -- 特殊处理武器选择
                if config.key == "currentWeapon" then
                    currentWeapon = option
                    updateWeaponConfig("currentWeapon", option)
                    -- 刷新面板以显示新武器数据
                    if selectedCategory then
                        updateRightPanel(selectedCategory)
                    end
                else
                    updateWeaponConfig(config.key, option)
                end
            end)
        end
    end)
end

-- ============================================
-- 控件: 数字输入
-- ============================================
function createNumberInput(parent, config)
    local value = config.default or 0
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.5, 0, 0.55, 0)
    input.Position = UDim2.new(0.25, 0, 0.22, 0)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    input.BorderSizePixel = 1
    input.BorderColor3 = Color3.fromRGB(60, 60, 70)
    input.Text = tostring(value)
    input.TextColor3 = Color3.fromRGB(220, 220, 230)
    input.TextSize = 12
    input.Font = Enum.Font.GothamMedium
    input.Parent = parent
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 3)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local num = tonumber(input.Text)
        if num then
            value = num
            updateWeaponConfig(config.key, value)
        else
            input.Text = tostring(value)
        end
    end)
end

-- ============================================
-- 控件: 颜色选择器
-- ============================================
function createColorPicker(parent, config)
    local color = config.default or Color3.fromRGB(255, 255, 255)
    
    local colorBtn = Instance.new("TextButton")
    colorBtn.Size = UDim2.new(0, 32, 0, 32)
    colorBtn.Position = UDim2.new(0.4, 0, 0.1, 0)
    colorBtn.BackgroundColor3 = color
    colorBtn.BorderSizePixel = 2
    colorBtn.BorderColor3 = Color3.fromRGB(70, 70, 80)
    colorBtn.Text = ""
    colorBtn.Parent = parent
    
    local colorCorner = Instance.new("UICorner")
    colorCorner.CornerRadius = UDim.new(0, 4)
    colorCorner.Parent = colorBtn
    
    local colors = {
        Color3.fromRGB(255, 200, 50),
        Color3.fromRGB(255, 50, 50),
        Color3.fromRGB(50, 255, 50),
        Color3.fromRGB(50, 150, 255),
        Color3.fromRGB(255, 50, 200),
        Color3.fromRGB(200, 200, 200),
        Color3.fromRGB(255, 100, 0),
        Color3.fromRGB(100, 200, 255)
    }
    local colorIndex = 1
    
    -- 查找当前颜色在预设中的位置
    for i, c in ipairs(colors) do
        if c.R == color.R and c.G == color.G and c.B == color.B then
            colorIndex = i
            break
        end
    end
    
    colorBtn.MouseButton1Click:Connect(function()
        colorIndex = colorIndex % #colors + 1
        local newColor = colors[colorIndex]
        colorBtn.BackgroundColor3 = newColor
        updateWeaponConfig(config.key, newColor)
    end)
end

-- ============================================
-- 控件: 显示信息
-- ============================================
function createDisplay(parent, config)
    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(0.8, 0, 1, 0)
    displayLabel.Position = UDim2.new(0.1, 0, 0, 0)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = config.value or "N/A"
    displayLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    displayLabel.TextSize = 13
    displayLabel.Font = Enum.Font.GothamBold
    displayLabel.TextXAlignment = Enum.TextXAlignment.Center
    displayLabel.Parent = parent
end

-- ============================================
-- 公告面板
-- ============================================
function createAnnouncementPanel()
    local announcementFrame = Instance.new("Frame")
    announcementFrame.Size = UDim2.new(1, -12, 1, -12)
    announcementFrame.Position = UDim2.new(0, 6, 0, 6)
    announcementFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    announcementFrame.BorderSizePixel = 1
    announcementFrame.BorderColor3 = Color3.fromRGB(48, 48, 58)
    announcementFrame.Parent = rightPanel
    
    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 4)
    frameCorner.Parent = announcementFrame
    
    -- 标题
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 34)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "📢 更新公告"
    titleLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    titleLabel.TextSize = 17
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = announcementFrame
    
    -- 版本和更新数量
    local versionInfo = Instance.new("TextLabel")
    versionInfo.Size = UDim2.new(1, 0, 0, 20)
    versionInfo.Position = UDim2.new(0, 0, 0, 34)
    versionInfo.BackgroundTransparency = 1
    versionInfo.Text = "v2.1.0  (2026-07-31)  │  共 5 项更新"
    versionInfo.TextColor3 = Color3.fromRGB(150, 150, 175)
    versionInfo.TextSize = 11
    versionInfo.Font = Enum.Font.GothamMedium
    versionInfo.Parent = announcementFrame
    
    -- 分割线
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0.95, 0, 0, 1)
    line.Position = UDim2.new(0.025, 0, 0, 57)
    line.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    line.BorderSizePixel = 0
    line.Parent = announcementFrame
    
    -- 滚动内容
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -8, 1, -65)
    scrollFrame.Position = UDim2.new(0, 4, 0, 62)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 400)
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 75)
    scrollFrame.Parent = announcementFrame
    
    local content = getAnnouncementContent()
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(0.96, 0, 0, content.lineCount * 22 + 10)
    contentLabel.Position = UDim2.new(0.02, 0, 0, 0)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content.text
    contentLabel.TextColor3 = Color3.fromRGB(190, 190, 205)
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.GothamMedium
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = scrollFrame
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, contentLabel.Size.Y.Offset + 20)
end

-- ============================================
-- 公告内容
-- ============================================
function getAnnouncementContent()
    local text = [[
✨ 新增功能 (2项)
  • 弹道预测系统 - 提高远距离射击精度 30%
  • 自定义准星样式 - 新增 6 种预设准星

🔧 优化改进 (2项)
  • 瞄准辅助算法优化 - 响应速度提升 25%
  • 界面渲染优化 - 减少性能开销 15%

🐛 Bug 修复 (1项)
  • 修复连射模式下射速不稳定问题

📊 武器数据更新 (基于 RSPY 抓包)
  • M4A1: 射速 720 → 750 RPM
  • AK47:  后坐力降低 15%
  • 狙击枪: 开镜速度提升 20%
  • 霰弹枪: 散布范围优化

📝 已知问题 (2项)
  • 部分武器皮肤在低画质下显示异常
  • 特定地图中可能出现轻微性能波动

🔮 后续计划 (3项)
  • 武器配件系统 (消音器、瞄准镜等)
  • 自定义快捷键绑定
  • 社区反馈功能开发中

💡 提示
  点击左侧 "武器选择" 切换不同武器查看参数]]
    
    local lineCount = 0
    for _ in string.gmatch(text, "\n") do
        lineCount = lineCount + 1
    end
    lineCount = lineCount + 1
    
    return { text = text, lineCount = lineCount }
end

-- ============================================
-- 更新武器配置
-- ============================================
function updateWeaponConfig(key, value)
    print(string.format("[配置更新] %s = %s", key, tostring(value)))
    
    -- 更新本地数据
    if weaponData[currentWeapon] and key ~= "currentWeapon" then
        -- 映射到对应的武器属性
        local keyMap = {
            recoil = "recoil",
            spread = "spread",
            bulletSpeed = "bulletSpeed",
            fireRateMult = "fireRate",
            magSize = "magSize",
            aimSpeed = "aimSpeed",
            autoFire = "autoFire"
        }
        
        if keyMap[key] then
            local attr = keyMap[key]
            if type(value) == "number" and (key == "recoil" or key == "spread") then
                weaponData[currentWeapon][attr] = value / 100
            elseif key == "fireRateMult" then
                -- 实际射速 = 基础射速 * 倍率
                -- 这里只是演示，实际会根据基础值计算
            else
                weaponData[currentWeapon][attr] = value
            end
        end
    end
    
    -- 实际应用配置到游戏
    local character = player.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            -- 设置属性，供其他脚本读取
            tool:SetAttribute(key, value)
            
            -- 如果是武器选择，更新工具
            if key == "currentWeapon" then
                -- 这里可以触发武器切换逻辑
                print("切换到武器: " .. value)
            end
        end
    end
    
    -- 发送远程事件 (如果需要同步到服务器)
    -- game:GetService("ReplicatedStorage").WeaponConfigEvent:FireServer(key, value)
end

-- ============================================
-- 窗口控制
-- ============================================
local isMinimized = false
local originalSize = mainFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 580, 0, 32)
        leftPanel.Visible = false
        rightPanel.Visible = false
        divider.Visible = false
        minimizeButton.Text = "□"
        minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    else
        mainFrame.Size = originalSize
        leftPanel.Visible = true
        rightPanel.Visible = true
        divider.Visible = true
        minimizeButton.Text = "─"
        minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    print("武器配置GUI已关闭")
end)

-- ============================================
-- 窗口拖拽 (支持鼠标和触摸)
-- ============================================
local draggingWindow = false
local dragStartPos = nil
local dragStartMouse = nil

titleBar.MouseButton1Down:Connect(function()
    draggingWindow = true
    dragStartPos = mainFrame.Position
    dragStartMouse = Vector2.new(mouse.X, mouse.Y)
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        draggingWindow = false
    end
end)

-- 鼠标拖拽
mouse.Move:Connect(function()
    if draggingWindow then
        local delta = Vector2.new(mouse.X - dragStartMouse.X, mouse.Y - dragStartMouse.Y)
        mainFrame.Position = UDim2.new(
            dragStartPos.X.Scale,
            dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale,
            dragStartPos.Y.Offset + delta.Y
        )
    end
end)

-- 触摸拖拽 (移动端支持)
local touchMoveConnection = nil
titleBar.TouchInputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingWindow = true
        dragStartPos = mainFrame.Position
        dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
        
        if touchMoveConnection then
            touchMoveConnection:Disconnect()
        end
        
        touchMoveConnection = UserInputService.TouchMoved:Connect(function(touch)
            if draggingWindow then
                local delta = Vector2.new(touch.Position.X - dragStartMouse.X, touch.Position.Y - dragStartMouse.Y)
                mainFrame.Position = UDim2.new(
                    dragStartPos.X.Scale,
                    dragStartPos.X.Offset + delta.X,
                    dragStartPos.Y.Scale,
                    dragStartPos.Y.Offset + delta.Y
                )
            end
        end)
    end
end)

-- ============================================
-- 初始化
-- ============================================
for i, category in ipairs(categories) do
    createCategoryButton(category, i)
end

-- 默认选中第一个
selectCategory(categories[1].id)

-- 版本信息
print("========================================")
print("武器配置系统 v2.1.0 已加载!")
print("RSPY 抓包数据已加载")
print("当前武器: " .. currentWeapon)
print("可用武器: " .. table.concat(weaponData, ", "))
print("更新数量: 5")
print("========================================")