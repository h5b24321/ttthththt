--[[
    QUANTUM.NZ - PREMIER OCEAN NETWORK (FINAL RECONSTRUCTION)
    - Fix: GroupTransparency -> CanvasGroup logic
    - Fix: PaddingTop -> UDim.new conversion
    - Fix: CoreGui method missing
]]

local Quantum = {
    Themes = {
        Background = Color3.fromRGB(11, 14, 20),
        Sidebar = Color3.fromRGB(15, 20, 28),
        Section = Color3.fromRGB(20, 26, 35),
        Accent = Color3.fromRGB(0, 212, 255),
        Vampire = Color3.fromRGB(170, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 160)
    }
}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do
        -- Fix: Padding properties must be UDim
        if (k == "PaddingTop" or k == "PaddingBottom" or k == "PaddingLeft" or k == "PaddingRight") and typeof(v) == "number" then
            Obj[k] = UDim.new(0, v)
        else
            Obj[k] = v
        end
    end
    return Obj
end

function Quantum:CreateWindow(Config)
    local Screen = New("ScreenGui", {Name = "QuantumFinal", ResetOnSpawn = false})
    pcall(function() Screen.Parent = CoreGui end)
    if not Screen.Parent then Screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    --// INTRO: Blurred & Clean Vampire Flow
    local Blur = New("BlurEffect", {Size = 0, Parent = Lighting})
    local IntroGroup = New("CanvasGroup", { -- Fix: Transparency support
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = Screen
    })
    
    local TextContainer = New("CanvasGroup", {
        Size = UDim2.fromOffset(450, 120),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Parent = IntroGroup
    })
    
    local Title = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = "QUANTUM.NZ",
        Font = Enum.Font.GothamBold,
        TextSize = 70,
        TextColor3 = self.Themes.Accent,
        BackgroundTransparency = 1,
        Parent = TextContainer
    })
    
    local Liquid = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Themes.Vampire,
        BorderSizePixel = 0,
        Parent = TextContainer
    })

    -- Intro Sequence
    task.spawn(function()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 20}):Play()
        task.wait(0.5)
        TweenService:Create(Liquid, TweenInfo.new(1.2, Enum.EasingStyle.Quart), {Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0)}):Play()
        task.wait(1)
        TweenService:Create(IntroGroup, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()
        task.wait(1)
        IntroGroup:Destroy()
        Blur:Destroy()
    end)

    --// MAIN UI: Ocean Network Style
    local Main = New("Frame", {
        Size = UDim2.fromOffset(750, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Themes.Background,
        Visible = false,
        Parent = Screen
    })
    task.delay(2.5, function() Main.Visible = true end)
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    New("UIStroke", {Color = self.Themes.Accent, Thickness = 1.5, Transparency = 0.6, Parent = Main})

    -- Sidebar
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 190, 1, 0),
        BackgroundColor3 = self.Themes.Sidebar,
        Parent = Main
    })
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})

    local NavHolder = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -100),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    New("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = "Center", Parent = NavHolder})

    -- Credit: CostyTR
    local Credit = New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 1, -45),
        Text = "Created by CostyTR",
        TextColor3 = self.Themes.Accent,
        Font = Enum.Font.GothamMedium,
        TextSize = 11,
        BackgroundTransparency = 1,
        Parent = Sidebar
    })

    local Content = New("ScrollingFrame", {
        Size = UDim2.new(1, -220, 1, -20),
        Position = UDim2.new(0, 205, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Themes.Accent,
        Parent = Main
    })
    New("UIListLayout", {Padding = UDim.new(0, 15), Parent = Content})

    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("Frame", {Size = UDim2.fromScale(1, 0), AutomaticSize = "Y", BackgroundTransparency = 1, Visible = false, Parent = Content})
        New("UIListLayout", {Padding = UDim.new(0, 12), Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 170, 0, 38),
            BackgroundColor3 = self.Themes.Accent,
            BackgroundTransparency = 1,
            Text = Name,
            Font = Enum.Font.GothamMedium,
            TextSize = 13,
            TextColor3 = self.Themes.SubText,
            Parent = NavHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Content:GetChildren()) do if p:IsA("Frame") then p.Visible = false end end
            for _, b in pairs(NavHolder:GetChildren()) do if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = self.Themes.SubText}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.85, TextColor3 = self.Themes.Accent}):Play()
        end)

        if not Tabs.First then Tabs.First = true; Page.Visible = true; TabBtn.BackgroundTransparency = 0.85; TabBtn.TextColor3 = self.Themes.Accent end

        return {
            AddSection = function(_, Title)
                local Sect = New("Frame", {Size = UDim2.new(1, -5, 0, 0), AutomaticSize = "Y", BackgroundColor3 = Quantum.Themes.Section, Parent = Page})
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sect})
                New("UIStroke", {Color = Quantum.Themes.Accent, Thickness = 0.8, Transparency = 0.8, Parent = Sect})
                
                local Layout = New("UIListLayout", {Padding = 10, Parent = Sect})
                New("UIPadding", {PaddingTop = 12, PaddingBottom = 12, PaddingLeft = 12, PaddingRight = 12, Parent = Sect})

                New("TextLabel", {Size = UDim2.new(1, 0, 0, 15), Text = Title:upper(), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Quantum.Themes.Accent, BackgroundTransparency = 1, TextXAlignment = "Left", Parent = Sect})

                return {
                    AddButton = function(_, Text, Callback)
                        local B = New("TextButton", {Size = UDim2.new(1, 0, 0, 35), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.97, Text = "  " .. Text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = Quantum.Themes.Text, TextXAlignment = "Left", Parent = Sect})
                        New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = B})
                        B.MouseButton1Click:Connect(Callback)
                    end
                }
            end
        }
    end
    
    return Tabs
end

--// INIT
local MyLib = Quantum:CreateWindow({Title = "OCEAN NETWORK"})
local Tab1 = MyLib:CreateTab("LegitBot")
local Sect1 = Tab1:AddSection("Aimbot Settings")
Sect1:AddButton("Enable LegitBot", function() print("Enabled") end)

return Quantum
