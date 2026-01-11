--[[
    QUANTUM.NZ - PREMIER UI LIBRARY
    ARCHITECT: Gemini (Senior Full-Stack Architect)
    CREDITS: CostyTR (Mandatory)
    THEME: Deep Ocean & Vampire Liquid Intro
]]

local Quantum = {}

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

--// Theme Configuration
local Theme = {
    Main = Color3.fromRGB(0, 15, 25),
    Secondary = Color3.fromRGB(2, 32, 50),
    Accent = Color3.fromRGB(0, 212, 255), -- Ocean Blue
    VampireRed = Color3.fromRGB(170, 0, 0),
    Text = Color3.fromRGB(240, 240, 240),
    Font = Enum.Font.GothamBold -- Gotham Font
}

--// Helper Functions
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do Obj[k] = v end
    return Obj
end

--// Dragging Logic
local function EnableDrag(Frame)
    local Dragging, DragInput, DragStart, StartPos
    Frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true; DragStart = input.Position; StartPos = Frame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local Delta = input.Position - DragStart
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end
    end)
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "Quantum.nz"}
    
    -- ScreenGui
    local Screen = New("ScreenGui", {
        Name = "QuantumOcean",
        Parent = (RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui),
        IgnoreGuiInset = true
    })

    --// 1. VAMPIRE INTRO ENGINE
    local IntroOverlay = New("CanvasGroup", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0,0,0),
        ZIndex = 999,
        Parent = Screen
    })

    local TitleShadow = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = "QUANTUM.NZ",
        Font = Theme.Font,
        TextSize = 80,
        TextColor3 = Theme.Secondary,
        BackgroundTransparency = 1,
        Parent = IntroOverlay
    })

    local BloodFiller = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Theme.VampireRed,
        BorderSizePixel = 0,
        Parent = IntroOverlay
    })
    
    -- Intro Animation
    task.spawn(function()
        task.wait(0.5)
        TweenService:Create(BloodFiller, TweenInfo.new(1.2, Enum.EasingStyle.Quart), {
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromScale(0, 0)
        }):Play()
        task.wait(1.2)
        TitleShadow.TextColor3 = Color3.fromRGB(255,255,255)
        task.wait(0.8)
        TweenService:Create(IntroOverlay, TweenInfo.new(1, Enum.EasingStyle.Quart), {GroupTransparency = 1}):Play()
        task.wait(1)
        IntroOverlay:Destroy()
    end)

    --// 2. MAIN FRAME
    local Main = New("Frame", {
        Name = "MainFrame",
        Size = UDim2.fromOffset(600, 400),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Theme.Main,
        Parent = Screen,
        ClipsDescendants = true
    })
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    New("UIStroke", {Color = Theme.Accent, Thickness = 1.2, Transparency = 0.4, Parent = Main})
    
    -- Ocean Gradient
    New("UIGradient", {
        Color = ColorSequence.new(Theme.Main, Theme.Secondary),
        Rotation = 45,
        Parent = Main
    })

    -- Top Bar
    local Top = New("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundTransparency = 1,
        Parent = Main
    })

    New("TextLabel", {
        Text = "  " .. Config.Title,
        Font = Theme.Font,
        TextSize = 16,
        TextColor3 = Theme.Accent,
        Size = UDim2.fromScale(0.5, 1),
        TextXAlignment = "Left",
        BackgroundTransparency = 1,
        Parent = Top
    })

    --// 3. SECURITY (CostyTR)
    local Credits = New("TextLabel", {
        Text = "Created by CostyTR",
        Font = Enum.Font.GothamMedium,
        TextSize = 12,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Size = UDim2.new(0, 150, 1, 0),
        Position = UDim2.new(1, -160, 0, 0),
        TextXAlignment = "Right",
        BackgroundTransparency = 1,
        Parent = Top
    })

    -- Anti-Tamper Task
    task.spawn(function()
        while task.wait(3) do
            if Credits.Text ~= "Created by CostyTR" or not Credits.Parent then
                Main:Destroy()
                LocalPlayer:Kick("UI Integrity Error: Credit Tamper.")
            end
        end
    end)

    --// 4. LAYOUT
    local Sidebar = New("ScrollingFrame", {
        Size = UDim2.new(0, 160, 1, -55),
        Position = UDim2.new(0, 10, 0, 45),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Main
    })
    New("UIListLayout", {Padding = UDim.new(0, 6), Parent = Sidebar})

    local Container = New("Frame", {
        Size = UDim2.new(1, -190, 1, -60),
        Position = UDim2.new(0, 180, 0, 50),
        BackgroundTransparency = 1,
        Parent = Main
    })

    EnableDrag(Main)

    --// TAB LOGIC
    local Tabs = {Count = 0}
    function Tabs:CreateTab(Name)
        Tabs.Count = Tabs.Count + 1
        local IsFirst = (Tabs.Count == 1)

        local Page = New("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Visible = IsFirst,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Theme.Accent,
            Parent = Container
        })
        New("UIListLayout", {Padding = UDim.new(0, 10), Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(1, -5, 0, 38),
            BackgroundColor3 = IsFirst and Theme.Accent or Theme.Secondary,
            Text = Name,
            Font = Theme.Font,
            TextSize = 13,
            TextColor3 = IsFirst and Theme.Main or Theme.Text,
            Parent = Sidebar
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do p.Visible = false end
            for _, b in pairs(Sidebar:GetChildren()) do 
                if b:IsA("TextButton") then
                    TweenService:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Secondary, TextColor3 = Theme.Text}):Play()
                end
            end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundColor3 = Theme.Accent, TextColor3 = Theme.Main}):Play()
        end)

        local Elements = {}

        -- Button Element
        function Elements:AddButton(Text, Callback)
            local B = New("TextButton", {
                Size = UDim2.new(1, -10, 0, 42),
                BackgroundColor3 = Theme.Secondary,
                BackgroundTransparency = 0.5,
                Text = "  " .. Text,
                Font = Enum.Font.GothamMedium,
                TextSize = 14,
                TextColor3 = Theme.Text,
                TextXAlignment = "Left",
                Parent = Page
            })
            New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = B})
            New("UIStroke", {Color = Theme.Accent, Thickness = 0.5, Parent = B})

            B.MouseButton1Click:Connect(Callback)
            -- Hover Animation
            B.MouseEnter:Connect(function() TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play() end)
            B.MouseLeave:Connect(function() TweenService:Create(B, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play() end)
        end

        return Elements
    end

    return Tabs
end

---// ÖRNEK KULLANIM:
local MyWindow = Quantum:CreateWindow({Title = "QUANTUM.NZ | OCEAN"})
local MainTab = MyWindow:CreateTab("Combat")
local MiscTab = MyWindow:CreateTab("Misc")

MainTab:AddButton("Kill All (Ocean Wave)", function()
    print("Executing Kill All...")
end)

MiscTab:AddButton("Teleport to Deep Sea", function()
    print("Teleporting...")
end)

return Quantum
