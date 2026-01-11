--[[
    QUANTUM.NZ - ELITE OCEAN NETWORK
    Architect: Gemini (Full-Stack Senior)
    Credit: by CostyTR (Hard-coded & Mandatory)
]]

local Quantum = {}

--// Theme & Config
local Theme = {
    Main = Color3.fromRGB(11, 14, 20),
    Sidebar = Color3.fromRGB(15, 20, 28),
    Section = Color3.fromRGB(20, 26, 35),
    Accent = Color3.fromRGB(0, 212, 255),
    Vampire = Color3.fromRGB(180, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(160, 160, 160)
}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

--// Helper: Safely Create Instances
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do
        if (k:find("Padding") or k:find("Margin")) and typeof(v) == "number" then
            Obj[k] = UDim.new(0, v)
        else
            Obj[k] = v
        end
    end
    return Obj
end

--// Notification System
function Quantum:Notify(Msg, Time)
    local Box = New("Frame", {
        Name = "QuantumNotif",
        Size = UDim2.fromOffset(280, 60),
        Position = UDim2.new(1, 10, 1, -70),
        BackgroundColor3 = Theme.Main,
        Parent = self.Screen
    })
    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Box})
    New("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Parent = Box})
    
    local T = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = "  " .. Msg,
        TextColor3 = Theme.Text,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        Parent = Box
    })

    TweenService:Create(Box, TweenInfo.new(0.6, Enum.EasingStyle.BackOut), {Position = UDim2.new(1, -290, 1, -70)}):Play()
    task.delay(Time or 3, function()
        if Box then
            TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.BackIn), {Position = UDim2.new(1, 10, 1, -70)}):Play()
            task.wait(0.5)
            Box:Destroy()
        end
    end)
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "QUANTUM.NZ"}
    
    -- Main Screen
    local Screen = New("ScreenGui", {Name = "QuantumOcean", ResetOnSpawn = false})
    pcall(function() Screen.Parent = CoreGui end)
    if not Screen.Parent then Screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end
    self.Screen = Screen

    --// 1. INTRO (No Black Screen, Just Blur & Liquid)
    local Blur = New("BlurEffect", {Size = 0, Parent = Lighting})
    local IntroOverlay = New("CanvasGroup", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 1000,
        Parent = Screen
    })

    local TitleBox = New("CanvasGroup", {
        Size = UDim2.fromOffset(500, 150),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = IntroOverlay
    })

    local TitleText = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = Config.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 80,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Parent = TitleBox
    })

    local Blood = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.Vampire,
        BorderSizePixel = 0,
        Parent = TitleBox
    })

    -- Intro Animation
    task.spawn(function()
        TweenService:Create(Blur, TweenInfo.new(1.2), {Size = 24}):Play()
        task.wait(0.5)
        TweenService:Create(Blood, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0)}):Play()
        task.wait(1)
        TitleText.TextColor3 = Theme.Text
        task.wait(1.5)
        TweenService:Create(IntroOverlay, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()
        task.wait(1)
        IntroOverlay:Destroy(); Blur:Destroy()
    end)

    --// 2. MAIN UI (Ocean Network Reconstruction)
    local Main = New("Frame", {
        Size = UDim2.fromOffset(720, 480),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Main,
        Visible = false,
        Parent = Screen
    })
    New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Main})
    New("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.6, Parent = Main})
    
    task.delay(2.8, function() Main.Visible = true end)

    -- Sidebar
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Theme.Sidebar,
        Parent = Main
    })
    New("UICorner", {CornerRadius = UDim.new(0, 12), Parent = Sidebar})

    -- SIDEBAR CREDIT (COSTYTR)
    local CreditLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -45),
        Text = "by CostyTR", -- BURASI SABİTLENDİ
        TextColor3 = Theme.Accent,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = Sidebar
    })

    local NavHolder = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -120),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    New("UIListLayout", {Padding = 6, HorizontalAlignment = "Center", Parent = NavHolder})

    -- Container
    local Content = New("ScrollingFrame", {
        Size = UDim2.new(1, -210, 1, -30),
        Position = UDim2.fromOffset(200, 15),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        Parent = Main
    })
    New("UIListLayout", {Padding = 15, Parent = Content})

    -- Dragging
    local d, ds, sp
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true ds=i.Position sp=Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("Frame", {Size = UDim2.fromScale(1, 0), AutomaticSize = "Y", BackgroundTransparency = 1, Visible = false, Parent = Content})
        New("UIListLayout", {Padding = 12, Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 160, 0, 40),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Text = Name,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = Theme.SubText,
            Parent = NavHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("Frame") then p.Visible = false end end
            for _, b in pairs(NavHolder:GetChildren()) do if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.SubText}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.85, TextColor3 = Theme.Accent}):Play()
        end)

        if not Tabs.First then Tabs.First = true; Page.Visible = true; TabBtn.BackgroundTransparency = 0.85; TabBtn.TextColor3 = Theme.Accent end

        return {
            AddSection = function(_, Title)
                local Sect = New("Frame", {Size = UDim2.new(1, -5, 0, 0), AutomaticSize = "Y", BackgroundColor3 = Theme.Section, Parent = Page})
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sect})
                New("UIStroke", {Color = Theme.Accent, Thickness = 1, Transparency = 0.8, Parent = Sect})
                New("UIListLayout", {Padding = 10, Parent = Sect})
                New("UIPadding", {PaddingTop = 12, PaddingBottom = 12, PaddingLeft = 12, PaddingRight = 12, Parent = Sect})

                New("TextLabel", {Size = UDim2.new(1, 0, 0, 18), Text = Title:upper(), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, BackgroundTransparency = 1, TextXAlignment = "Left", Parent = Sect})

                return {
                    AddButton = function(_, Text, Callback)
                        local B = New("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.97, Text = "  " .. Text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Theme.Text, TextXAlignment = "Left", Parent = Sect})
                        New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = B})
                        B.MouseButton1Click:Connect(Callback)
                    end
                }
            end
        }
    end
    return Tabs
end

--// BAŞLATMA ÖRNEĞİ
local Lib = Quantum:CreateWindow({Title = "OCEAN NETWORK"})
local MainTab = Lib:CreateTab("LegitBot")
local Sect = MainTab:AddSection("Aimbot")

Sect:AddButton("Test Notification", function()
    Quantum:Notify("Quantum.nz by CostyTR Loaded!", 4)
end)

return Quantum
