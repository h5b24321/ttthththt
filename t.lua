--[[
    QUANTUM.NZ - ULTIMATE OCEAN NETWORK (V3)
    Fixes: CoreGui Errors, GroupTransparency Fix, CanvasGroup Masking
    Features: Notification System, Smooth Liquid Intro, Ocean Sections
]]

local Quantum = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

--// Theme
local Theme = {
    MainBG = Color3.fromRGB(5, 10, 15),
    SectionBG = Color3.fromRGB(10, 15, 22),
    Accent = Color3.fromRGB(0, 212, 255),
    VampireRed = Color3.fromRGB(180, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Font = Enum.Font.GothamBold
}

--// Utility
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do Obj[k] = v end
    return Obj
end

--// Notification System
function Quantum:Notify(Data)
    local Notification = New("Frame", {
        Size = UDim2.fromOffset(250, 60),
        Position = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = Theme.MainBG,
        Parent = self.Screen
    })
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notification})
    New("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = Notification})
    
    local T = New("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.fromOffset(10, 0),
        Text = Data.Content or "Notification",
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        BackgroundTransparency = 1,
        Parent = Notification
    })

    TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -260, 1, -70)}):Play()
    task.delay(Data.Time or 3, function()
        TweenService:Create(Notification, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(1, 10, 1, -70)}):Play()
        task.wait(0.5)
        Notification:Destroy()
    end)
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "QUANTUM.NZ"}
    
    local Screen = New("ScreenGui", {Name = "Quantum_Final_V3", ResetOnSpawn = false})
    pcall(function() Screen.Parent = CoreGui end)
    if not Screen.Parent then Screen.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    self.Screen = Screen

    --// 1. INTRO FIX (CanvasGroup ile kırmızı taşma engellendi)
    local Blur = New("BlurEffect", {Size = 0, Parent = Lighting})
    local IntroOverlay = New("CanvasGroup", { -- Frame yerine CanvasGroup (Transparency hatasını çözer)
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1000,
        Parent = Screen
    })

    local TitleContainer = New("CanvasGroup", { -- Sıvının dışarı taşmasını engeller
        Size = UDim2.fromOffset(500, 150),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = IntroOverlay
    })

    local MainTitle = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = "QUANTUM.NZ",
        Font = Theme.Font,
        TextSize = 80,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = TitleContainer
    })

    local Blood = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.VampireRed,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TitleContainer
    })

    -- Intro Anim (Hatasız)
    task.spawn(function()
        TweenService:Create(Blur, TweenInfo.new(1.2), {Size = 25}):Play()
        task.wait(0.5)
        TweenService:Create(Blood, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0)}):Play()
        task.wait(0.8)
        MainTitle.TextColor3 = Theme.Text
        task.wait(1.5)
        TweenService:Create(IntroOverlay, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()
        task.wait(1)
        IntroOverlay:Destroy()
        Blur:Destroy()
    end)

    --// 2. MAIN UI (Ocean Network Style)
    local Main = New("Frame", {
        Size = UDim2.fromOffset(720, 480),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.MainBG,
        Visible = false,
        Parent = Screen
    })
    New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    New("UIStroke", {Color = Theme.Accent, Thickness = 2, Transparency = 0.6, Parent = Main})

    task.delay(3, function() Main.Visible = true end)

    -- Navigation
    local Nav = New("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.95,
        Parent = Main
    })
    New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Nav})

    local TabHolder = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -100),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Nav
    })
    New("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center", Parent = TabHolder})

    -- Anti-Tamper Credit
    local Credit = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 1, -40),
        Text = "Created by CostyTR",
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        BackgroundTransparency = 1,
        Parent = Nav
    })

    local Container = New("ScrollingFrame", {
        Size = UDim2.new(1, -210, 1, -40),
        Position = UDim2.fromOffset(200, 20),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        Parent = Main
    })
    New("UIListLayout", {Padding = UDim.new(0, 15), Parent = Container})

    -- Draggable Logic
    local d, ds, sp
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true ds=i.Position sp=Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("Frame", {Size = UDim2.fromScale(1, 0), AutomaticSize = "Y", BackgroundTransparency = 1, Visible = false, Parent = Container})
        New("UIListLayout", {Padding = UDim.new(0, 12), Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 160, 0, 38),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Text = Name,
            Font = Theme.Font,
            TextSize = 14,
            TextColor3 = Color3.fromRGB(180, 180, 180),
            Parent = TabHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("Frame") then p.Visible = false end end
            for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.85, TextColor3 = Theme.Accent}):Play()
        end)

        if not Tabs.First then
            Tabs.First = true; Page.Visible = true; TabBtn.BackgroundTransparency = 0.85; TabBtn.TextColor3 = Theme.Accent
        end

        return {
            AddSection = function(_, Title)
                local Sect = New("Frame", {Size = UDim2.new(1, -5, 0, 0), AutomaticSize = "Y", BackgroundColor3 = Theme.SectionBG, Parent = Page})
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sect})
                New("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.8, Parent = Sect})
                New("UIListLayout", {Padding = UDim.new(0, 8), Parent = Sect})
                New("UIPadding", {PaddingTop = 12, PaddingBottom = 12, PaddingLeft = 12, PaddingRight = 12, Parent = Sect})

                New("TextLabel", {Size = UDim2.new(1, 0, 0, 15), Text = Title:upper(), Font = Theme.Font, TextSize = 12, TextColor3 = Theme.Accent, BackgroundTransparency = 1, TextXAlignment = "Left", Parent = Sect})

                return {
                    AddButton = function(_, Text, Callback)
                        local B = New("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.96, Text = "  " .. Text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = "Left", Parent = Sect})
                        New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = B})
                        B.MouseButton1Click:Connect(Callback)
                    end
                }
            end
        }
    end
    return Tabs
end

--// BAŞLAT
local Lib = Quantum:CreateWindow({Title = "OCEAN NETWORK"})
local Main = Lib:CreateTab("LegitBot")
local Combat = Main:AddSection("Aimbot")

Combat:AddButton("Test Button", function()
    Quantum:Notify({Content = "Ocean Network Activated!", Time = 4})
end)

return Quantum
