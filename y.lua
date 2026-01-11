--[[
    QUANTUM.NZ - PREMIER OCEAN NETWORK
    Hata Düzeltmeleri:
    - GroupTransparency hatası CanvasGroup ile çözüldü.
    - PaddingTop hatası UDim.new ile çözüldü.
    - Accent nil hatası kapsamlı tema tablosuyla çözüldü.
]]

local Quantum = {
    Theme = {
        Main = Color3.fromRGB(11, 14, 20),
        Sidebar = Color3.fromRGB(15, 20, 28),
        Section = Color3.fromRGB(20, 26, 35),
        Accent = Color3.fromRGB(0, 212, 255),
        Vampire = Color3.fromRGB(180, 0, 0),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(160, 160, 160)
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

--// Gelişmiş Nesne Oluşturucu (Hataları Önler)
local function New(Class, Props)
    local Obj = Instance.new(Class)
    for k, v in pairs(Props) do
        -- Padding hatalarını otomatik düzeltir
        if (k:find("Padding") or k:find("Margin")) and typeof(v) == "number" then
            Obj[k] = UDim.new(0, v)
        else
            Obj[k] = v
        end
    end
    return Obj
end

function Quantum:CreateWindow(Config)
    Config = Config or {Title = "QUANTUM.NZ"}
    
    local Screen = New("ScreenGui", {Name = "QuantumOcean", ResetOnSpawn = false})
    pcall(function() Screen.Parent = CoreGui end)
    if not Screen.Parent then Screen.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui") end

    --// 1. PROFESYONEL BİLDİRİM SİSTEMİ
    local NotifContainer = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = Screen
    })

    function Quantum:Notify(Msg, Time)
        local Box = New("Frame", {
            Size = UDim2.fromOffset(250, 50),
            Position = UDim2.new(1, 10, 1, -60),
            BackgroundColor3 = self.Theme.Main,
            Parent = NotifContainer
        })
        New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Box})
        New("UIStroke", {Color = self.Theme.Accent, Thickness = 1.5, Parent = Box})
        
        New("TextLabel", {
            Size = UDim2.fromScale(1, 1),
            Text = "  " .. Msg,
            TextColor3 = self.Theme.Text,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextXAlignment = "Left",
            BackgroundTransparency = 1,
            Parent = Box
        })

        TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.BackOut), {Position = UDim2.new(1, -260, 1, -60)}):Play()
        task.delay(Time or 3, function()
            TweenService:Create(Box, TweenInfo.new(0.5, Enum.EasingStyle.BackIn), {Position = UDim2.new(1, 10, 1, -60)}):Play()
            task.wait(0.5)
            Box:Destroy()
        end)
    end

    --// 2. HATASIZ INTRO (CanvasGroup Kullanıldı)
    local Blur = New("BlurEffect", {Size = 0, Parent = Lighting})
    local Intro = New("CanvasGroup", {
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
        Parent = Intro
    })

    local Title = New("TextLabel", {
        Size = UDim2.fromScale(1, 1),
        Text = Config.Title,
        Font = Enum.Font.GothamBold,
        TextSize = 80,
        TextColor3 = self.Theme.Accent,
        BackgroundTransparency = 1,
        Parent = TitleBox
    })

    local Fill = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = self.Theme.Vampire,
        BorderSizePixel = 0,
        Parent = TitleBox
    })

    -- Intro Animasyonu
    task.spawn(function()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 25}):Play()
        task.wait(0.5)
        TweenService:Create(Fill, TweenInfo.new(1.2, Enum.EasingStyle.Quart), {Size = UDim2.fromScale(1, 1), Position = UDim2.fromScale(0, 0)}):Play()
        task.wait(0.8)
        Title.TextColor3 = self.Theme.Text
        task.wait(1.5)
        TweenService:Create(Intro, TweenInfo.new(1), {GroupTransparency = 1}):Play()
        TweenService:Create(Blur, TweenInfo.new(1), {Size = 0}):Play()
        task.wait(1)
        Intro:Destroy(); Blur:Destroy()
    end)

    --// 3. MAIN UI (REFERANS GÖRSEL STİLİ)
    local Main = New("Frame", {
        Size = UDim2.fromOffset(750, 500),
        Position = UDim2.fromScale(0.5, 0.5),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = self.Theme.Main,
        Visible = false,
        Parent = Screen
    })
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Main})
    New("UIStroke", {Color = self.Theme.Accent, Thickness = 1.2, Transparency = 0.5, Parent = Main})
    
    task.delay(2.5, function() Main.Visible = true end)

    -- Sidebar
    local Sidebar = New("Frame", {
        Size = UDim2.new(0, 190, 1, 0),
        BackgroundColor3 = self.Theme.Sidebar,
        Parent = Main
    })
    New("UICorner", {CornerRadius = UDim.new(0, 10), Parent = Sidebar})

    local TabHolder = New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -100),
        Position = UDim2.new(0, 0, 0, 60),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        Parent = Sidebar
    })
    New("UIListLayout", {Padding = 5, HorizontalAlignment = "Center", Parent = TabHolder})

    -- Content
    local Container = New("ScrollingFrame", {
        Size = UDim2.new(1, -210, 1, -20),
        Position = UDim2.fromOffset(200, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = self.Theme.Accent,
        Parent = Main
    })
    New("UIListLayout", {Padding = 15, Parent = Container})

    -- Draggable
    local dragging, dragStart, startPos
    Main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = i.Position startPos = Main.Position end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = i.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

    local Tabs = {First = nil}
    function Tabs:CreateTab(Name)
        local Page = New("Frame", {Size = UDim2.fromScale(1, 0), AutomaticSize = "Y", BackgroundTransparency = 1, Visible = false, Parent = Container})
        New("UIListLayout", {Padding = 12, Parent = Page})

        local TabBtn = New("TextButton", {
            Size = UDim2.new(0, 170, 0, 40),
            BackgroundColor3 = self.Quantum.Theme.Accent, -- Accent nil fix
            BackgroundTransparency = 1,
            Text = Name,
            Font = Enum.Font.GothamBold,
            TextSize = 14,
            TextColor3 = self.Quantum.Theme.SubText,
            Parent = TabHolder
        })
        New("UICorner", {CornerRadius = UDim.new(0, 6), Parent = TabBtn})

        TabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Container:GetChildren()) do if p:IsA("Frame") then p.Visible = false end end
            for _, b in pairs(TabHolder:GetChildren()) do if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextColor3 = self.Quantum.Theme.SubText}):Play()
            end end
            Page.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.85, TextColor3 = self.Quantum.Theme.Accent}):Play()
        end)

        if not Tabs.First then Tabs.First = true; Page.Visible = true; TabBtn.BackgroundTransparency = 0.85; TabBtn.TextColor3 = self.Quantum.Theme.Accent end

        return {
            AddSection = function(_, Title)
                local Sect = New("Frame", {Size = UDim2.new(1, -5, 0, 0), AutomaticSize = "Y", BackgroundColor3 = self.Quantum.Theme.Section, Parent = Page})
                New("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Sect})
                New("UIStroke", {Color = self.Quantum.Theme.Accent, Thickness = 1, Transparency = 0.8, Parent = Sect})
                New("UIListLayout", {Padding = 10, Parent = Sect})
                New("UIPadding", {PaddingTop = 12, PaddingBottom = 12, PaddingLeft = 12, PaddingRight = 12, Parent = Sect}) -- Padding fix

                New("TextLabel", {Size = UDim2.new(1, 0, 0, 15), Text = Title:upper(), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = self.Quantum.Theme.Accent, BackgroundTransparency = 1, TextXAlignment = "Left", Parent = Sect})

                return {
                    AddButton = function(_, Text, Callback)
                        local B = New("TextButton", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0.97, Text = "  " .. Text, Font = Enum.Font.Gotham, TextSize = 13, TextColor3 = self.Quantum.Theme.Text, TextXAlignment = "Left", Parent = Sect})
                        New("UICorner", {CornerRadius = UDim.new(0, 4), Parent = B})
                        B.MouseButton1Click:Connect(Callback)
                    end
                }
            end
        }
    end
    -- Self-reference for callbacks
    for _, tab in pairs(Tabs) do if type(tab) == "table" then tab.Quantum = self end end
    Tabs.Quantum = self
    return Tabs
end

--// KULLANIM ÖRNEĞİ
local Lib = Quantum:CreateWindow({Title = "QUANTUM.NZ"})
local Main = Lib:CreateTab("LegitBot")
local Combat = Main:AddSection("Aimbot Settings")

Combat:AddButton("Enable LegitBot", function()
    Quantum:Notify("Ocean Network Activated!", 4)
end)

return Quantum
