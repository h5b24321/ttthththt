--[[
    QUANTUM.NZ - PREMIER OCEAN ARCHITECT
    Architect: Gemini (Full-Stack Senior)
    Credit: CostyTR (Protected)
    Vampire Intro & Deep Sea UI
]]

local Quantum = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// Theme Configuration (Ocean & Vampire)
local Theme = {
    Primary = Color3.fromRGB(0, 15, 25),      -- Derin Deniz Mavisi
    Secondary = Color3.fromRGB(2, 35, 55),    -- Panel Rengi
    Accent = Color3.fromRGB(0, 212, 255),     -- Neon Ocean Blue
    VampireRed = Color3.fromRGB(160, 0, 0),   -- Intro Sıvı Rengi
    Text = Color3.fromRGB(240, 240, 240),
    Border = Color3.fromRGB(0, 85, 115),
    Font = Enum.Font.GothamBold
}

--// Utility Functions
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do Obj[k] = v end
    return Obj
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "QUANTUM.NZ"}
    
    local Screen = New("ScreenGui", {
        Name = "QuantumOcean_Ultimate",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui),
        IgnoreGuiInset = true
    })

    --// 1. ADVANCED VAMPIRE INTRO (Sıvı Dolma Efekti)
    local IntroOverlay = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 5, 10),
        ZIndex = 1000,
        Parent = Screen
    })

    local TitleContainer = New("Frame", {
        Size = UDim2.fromOffset(500, 120),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = IntroOverlay
    })

    local MainTitle = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = "QUANTUM.NZ",
        Font = Theme.Font,
        TextSize = 75,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = TitleContainer
    })

    local BloodFiller = New("Frame", {
        Size = UDim2.new(1.2, 0, 0, 0), -- Dışarı taşan sıvı
        Position = UDim2.new(-0.1, 0, 1, 0),
        BackgroundColor3 = Theme.VampireRed,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TitleContainer
    })
    New("UICorner", {CornerRadius = UDim.new(0.5, 0), Parent = BloodFiller}) -- Sıvı dalga ucu

    -- Intro Animation
    task.spawn(function()
        task.wait(0.5)
        -- Yazı belirir
        TweenService:Create(MainTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.wait(1)
        
        -- Kan/Sıvı doluşu
        TweenService:Create(BloodFiller, TweenInfo.new(1.5, Enum.EasingStyle.Quart), {
            Size = UDim2.new(1.2, 0, 1.5, 0),
            Position = UDim2.new(-0.1, 0, -0.25, 0)
        }):Play()
        
        task.wait(0.6)
        MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        task.wait(1)
        -- Dağılma
        TweenService:Create(IntroOverlay, TweenInfo.new(1, Enum.EasingStyle.ExponentialIn), {BackgroundTransparency = 1}):Play()
        TweenService:Create(TitleContainer, TweenInfo.new(0.8), {GroupTransparency = 1}):Play()
        
        task.wait(1)
        IntroOverlay:Destroy()
    end)

    --// 2. MAIN INTERFACE (Orijinal Lib Yapını Koruyan Modern Panel)
    local Main = New("Frame", {
        Size = UDim2.fromOffset(620, 420),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Primary,
        Visible = false,
        Parent = Screen
    })
    
    task.delay(3, function() Main.Visible = true end)

    New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Main})
    local Stroke = New("UIStroke", {Color = Theme.Border, Thickness = 1.5, Parent = Main})
    
    -- Okyanus Parlaması
    local Grad = New("UIGradient", {
        Color = ColorSequence.new(Theme.Primary, Theme.Secondary),
        Rotation = 45,
        Parent = Main
    })

    -- Sidebar (Eski libinin stilini koruyan sol menü)
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 170, 1, -45),
        Position = UDim2.new(0, 0, 0, 45),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        Parent = Main
    })

    local TabHolder = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    New("UIListLayout", {Padding = UDim.new(0, 5), HorizontalAlignment = "Center", Parent = TabHolder})
    New("UIPadding", {PaddingTop = UDim.new(0, 10), Parent = TabHolder})

    -- Container (İçerik Alanı)
    local Container = New("Frame", {
        Size = UDim2.new(1, -180, 1, -55),
        Position = UDim2.new(0, 175, 0, 50),
        BackgroundTransparency = 1,
        Parent = Main
    })

    -- TopBar
    local TopBar = New("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local Title = New("TextLabel", {
        Text = "  " .. Config.Title,
        Font = Theme.Font,
        TextSize = 16,
        TextColor3 = Theme.Accent,
        Size = UDim2.fromScale(0.5, 1),
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    --// 3. MANDATORY CREDIT (COSTYTR)
    local Credit = New("TextLabel", {
        Text = "Created by CostyTR  ",
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        TextColor3 = Color3.fromRGB(120, 120, 120),
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -150, 0, 0),
        TextXAlignment = "Right",
        BackgroundTransparency = 1,
        Parent = TopBar
    })

    -- Security Loop
    task.spawn(function()
        while task.wait(5) do
            if Credit.Text ~= "Created by CostyTR  " or not Credit.Parent then
                Screen:Destroy()
                LocalPlayer:Kick("UI Integrity Error: Unauthorized Credit Removal.")
            end
        end
    end)

    -- Dragging
    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    --// 4. TAB & ELEMENT SYSTEM
    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Visible = false,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            Parent = Container
        })
        New("UIListLayout", {Padding = UDim.new(0, 8), Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 150, 0, 35),
            BackgroundColor3 = Theme.Secondary,
            BackgroundTransparency = 0.5,
            Text = Name,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Parent = TabHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
            for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then 
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Secondary, BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0, TextColor3 = Theme.Primary}):Play()
        end)

        if not Tabs.First then
            Tabs.First = true
            Page.Visible = true
            TabBtn.BackgroundColor3 = Theme.Accent
            TabBtn.BackgroundTransparency = 0
            TabBtn.TextColor3 = Theme.Primary
        end

        local Elements = {}

        function Elements:AddButton(Text, Callback)
            local B = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.96,
                Text = "  " .. Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = "Left",
                Parent = Page
            })
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = B})
            New("UIStroke", {Color = Theme.Border, Thickness = 0.5, Parent = B})

            B.MouseButton1Click:Connect(Callback)
            B.MouseEnter:Connect(function() TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, TextColor3 = Theme.Accent}):Play() end)
            B.MouseLeave:Connect(function() TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 0.96, TextColor3 = Theme.Text}):Play() end)
        end

        function Elements:AddToggle(Text, Default, Callback)
            local Toggled = Default
            local TFrame = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 40),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.96,
                Text = "  " .. Text,
                Font = Enum.Font.Gotham,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = "Left",
                Parent = Page
            })
            New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TFrame})
            
            local Indicator = New("Frame", {
                Size = UDim2.fromOffset(34, 18),
                Position = UDim2.new(1, -45, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40, 40, 40),
                Parent = TFrame
            })
            New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Indicator})

            TFrame.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40, 40, 40)}):Play()
                Callback(Toggled)
            end)
        end

        return Elements
    end

    return Tabs
end

--// Örnek Başlatma
local Library = Quantum:CreateWindow({Title = "QUANTUM.NZ | OCEAN"})
local MainTab = Library:CreateTab("Main")
local MiscTab = Library:CreateTab("Miscellaneous")

MainTab:AddButton("Execute Sea Script", function()
    print("Okyanus gücü adına!")
end)

MainTab:AddToggle("Infinite Bubbles", false, function(v)
    print("Toggle:", v)
end)

return Quantum
