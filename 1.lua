--[[
    QUANTUM.NZ - PREMIER OCEAN NETWORK UI
    Architect: Gemini (Full-Stack Senior)
    Credit: CostyTR (Protected & Mandatory)
    Style: Ocean Glass & Vampire Liquid Intro
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

--// Theme Configuration
local Theme = {
    MainBG = Color3.fromRGB(8, 12, 16),
    SectionBG = Color3.fromRGB(12, 18, 24),
    Accent = Color3.fromRGB(0, 212, 255), -- Neon Ocean Blue
    VampireRed = Color3.fromRGB(180, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    SecondaryText = Color3.fromRGB(160, 160, 160),
    Font = Enum.Font.GothamBold
}

--// Helper Functions
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do Obj[k] = v end
    return Obj
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "QUANTUM.NZ"}
    
    -- CoreGui Check (Hata engelleme)
    local Screen = New("ScreenGui", {
        Name = "QuantumOcean_Net",
        ResetOnSpawn = false
    })
    
    local success, err = pcall(function()
        Screen.Parent = CoreGui
    end)
    if not success then Screen.Parent = LocalPlayer:WaitForChild("PlayerGui") end

    --// 1. BLURRED VAMPIRE INTRO (Siyah ekran yok, sadece blur ve kan)
    local BlurEffect = New("BlurEffect", {Size = 0, Parent = Lighting})
    
    local IntroOverlay = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
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
        TextSize = 70,
        TextColor3 = Theme.Accent,
        TextTransparency = 1,
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = TitleContainer
    })

    local BloodFiller = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.VampireRed,
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = TitleContainer
    })

    -- Intro Sequence
    task.spawn(function()
        TweenService:Create(BlurEffect, TweenInfo.new(1), {Size = 24}):Play()
        TweenService:Create(MainTitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
        task.wait(1)
        
        TweenService:Create(BloodFiller, TweenInfo.new(1.2, Enum.EasingStyle.Quart), {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0)
        }):Play()
        
        task.wait(0.6)
        MainTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        task.wait(1.5)
        
        TweenService:Create(BlurEffect, TweenInfo.new(1), {Size = 0}):Play()
        TweenService:Create(IntroOverlay, TweenInfo.new(1), {BackgroundTransparency = 1}):Play()
        TweenService:Create(TitleContainer, TweenInfo.new(0.8), {GroupTransparency = 1}):Play()
        
        task.wait(1)
        BlurEffect:Destroy()
        IntroOverlay:Destroy()
    end)

    --// 2. MAIN WINDOW (Ocean Network Style)
    local Main = New("Frame", {
        Size = UDim2.fromOffset(700, 450),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.MainBG,
        Visible = false,
        Parent = Screen
    })
    
    task.delay(3, function() Main.Visible = true end)
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    New("UIStroke", {Color = Theme.Accent, Thickness = 1.5, Transparency = 0.5, Parent = Main})

    -- Sidebar (Navigation)
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 180, 1, 0),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.92,
        Parent = Main
    })
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})

    local TitleLabel = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 60),
        Text = "QUANTUM.NZ",
        Font = Theme.Font,
        TextSize = 18,
        TextColor3 = Theme.Accent,
        BackgroundTransparency = 1,
        Parent = Sidebar
    })

    local TabHolder = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -120),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    New("UIListLayout", {Padding = UDim.new(0, 4), HorizontalAlignment = "Center", Parent = TabHolder})

    -- Credits (COSTYTR)
    local CreditsBtn = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -40),
        Text = "By CostyTR",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Theme.SecondaryText,
        BackgroundTransparency = 1,
        Parent = Sidebar
    })

    -- Anti-Tamper
    task.spawn(function()
        while task.wait(3) do
            if CreditsBtn.Text ~= "By CostyTR" or not CreditsBtn.Parent then
                Main:Destroy(); LocalPlayer:Kick("Security Check Failed")
            end
        end
    end)

    local Container = New("ScrollingFrame", {
        Size = UDim2.new(1, -200, 1, -20),
        Position = UDim2.new(0, 190, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = Theme.Accent,
        Parent = Main
    })
    New("UIListLayout", {Padding = UDim.new(0, 10), Parent = Container})

    -- Dragging
    local d, ds, sp
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=true ds=i.Position sp=Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if d and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - ds
        Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then d=false end end)

    --// 3. TAB & SECTION SYSTEM
    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("Frame", {
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = "Y",
            BackgroundTransparency = 1,
            Visible = false,
            Parent = Container
        })
        New("UIListLayout", {Padding = UDim.new(0, 12), Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 160, 0, 35),
            BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 1,
            Text = Name,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = Theme.SecondaryText,
            Parent = TabHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("Frame") then p.Visible = false end end
            for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = Theme.SecondaryText}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.8, TextColor3 = Theme.Accent}):Play()
        end)

        if not Tabs.First then
            Tabs.First = true; Page.Visible = true; TabBtn.BackgroundTransparency = 0.8; TabBtn.TextColor3 = Theme.Accent
        end

        local Elements = {}

        function Elements:AddSection(Title)
            local Sect = New("Frame", {
                Size = UDim2.new(1, -10, 0, 0),
                AutomaticSize = "Y",
                BackgroundColor3 = Theme.SectionBG,
                Parent = Page
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sect})
            New("UIStroke", {Color = Theme.Accent, Thickness = 0.8, Transparency = 0.8, Parent = Sect})
            
            local Layout = New("UIListLayout", {Padding = UDim.new(0, 8), Parent = Sect})
            New("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = Sect})
            
            New("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                Text = Title:upper(),
                Font = Theme.Font,
                TextSize = 12,
                TextColor3 = Theme.Accent,
                BackgroundTransparency = 1,
                TextXAlignment = "Left",
                Parent = Sect
            })
            
            return {
                AddButton = function(_, Text, Callback)
                    local B = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 35),
                        BackgroundColor3 = Color3.fromRGB(255,255,255),
                        BackgroundTransparency = 0.97,
                        Text = "  " .. Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = Theme.Text,
                        TextXAlignment = "Left",
                        Parent = Sect
                    })
                    New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = B})
                    B.MouseButton1Click:Connect(Callback)
                end,
                AddToggle = function(_, Text, Default, Callback)
                    local Toggled = Default
                    local B = New("TextButton", {
                        Size = UDim2.new(1, 0, 0, 35),
                        BackgroundTransparency = 1,
                        Text = "  " .. Text,
                        Font = Enum.Font.Gotham,
                        TextSize = 13,
                        TextColor3 = Theme.Text,
                        TextXAlignment = "Left",
                        Parent = Sect
                    })
                    local Ind = New("Frame", {
                        Size = UDim2.fromOffset(30, 16),
                        Position = UDim2.new(1, -35, 0.5, 0),
                        AnchorPoint = Vector2.new(0, 0.5),
                        BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40,40,40),
                        Parent = B
                    })
                    New("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Ind})
                    B.MouseButton1Click:Connect(function()
                        Toggled = not Toggled
                        TweenService:Create(Ind, TweenInfo.new(0.3), {BackgroundColor3 = Toggled and Theme.Accent or Color3.fromRGB(40,40,40)}):Play()
                        Callback(Toggled)
                    end)
                end
            }
        end
        return Elements
    end
    return Tabs
end

--// Örnek Kullanım:
local Lib = Quantum:CreateWindow({Title = "OCEAN NETWORK"})
local MainTab = Lib:CreateTab("LegitBot")

local AimbotSect = MainTab:AddSection("Aimbot Settings")
AimbotSect:AddToggle("Enabled", false, function(v) print("Aimbot:", v) end)
AimbotSect:AddButton("Reset Config", function() print("Reset!") end)

local VisualSect = MainTab:AddSection("Visuals")
VisualSect:AddToggle("Box ESP", true, function(v) end)

return Quantum
