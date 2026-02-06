--[[
	Late Lib - Deep Sea Anime Edition
	Modified for: Key System, Loading Screen & Blue Theme
]]

local GetService = game.GetService
local Connect = game.Loaded.Connect
local Wait = game.Loaded.Wait

--// Theme Configuration (Koyu Mavi Anime)
local Theme = {
	Primary = Color3.fromRGB(10, 15, 25),
	Secondary = Color3.fromRGB(15, 20, 35),
	Component = Color3.fromRGB(25, 30, 50),
	Interactables = Color3.fromRGB(45, 100, 250), -- Parlayan Mavi
	Outline = Color3.fromRGB(50, 120, 255),
	Title = Color3.fromRGB(255, 255, 255),
	Description = Color3.fromRGB(160, 180, 210),
	Accent = Color3.fromRGB(0, 200, 255)
}

local Library = {}

--// 1. LOADING SCREEN SYSTEM
function Library:ShowLoading(Callback)
    local CoreGui = GetService(game, "CoreGui")
    local LoadUI = Instance.new("ScreenGui", CoreGui)
    
    local Main = Instance.new("Frame", LoadUI)
    Main.Size = UDim2.new(1, 0, 1, 0)
    Main.BackgroundColor3 = Theme.Primary
    
    local Title = Instance.new("TextLabel", Main)
    Title.Size = UDim2.new(0, 300, 0, 50)
    Title.Position = UDim2.new(0.5, -150, 0.4, 0)
    Title.Text = "DEEP SEA HUB"
    Title.TextColor3 = Theme.Accent
    Title.TextSize = 40
    Title.Font = Enum.Font.GothamBold
    Title.BackgroundTransparency = 1
    
    local BarBG = Instance.new("Frame", Main)
    BarBG.Size = UDim2.new(0, 300, 0, 4)
    BarBG.Position = UDim2.new(0.5, -150, 0.5, 0)
    BarBG.BackgroundColor3 = Theme.Component
    BarBG.BorderSizePixel = 0
    
    local Bar = Instance.new("Frame", BarBG)
    Bar.Size = UDim2.new(0, 0, 1, 0)
    Bar.BackgroundColor3 = Theme.Accent
    Bar.BorderSizePixel = 0
    
    -- Animation
    GetService(game, "TweenService"):Create(Bar, TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 1, 0)}):Play()
    
    task.wait(2.2)
    GetService(game, "TweenService"):Create(Main, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    GetService(game, "TweenService"):Create(Title, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    task.wait(0.5)
    LoadUI:Destroy()
    Callback()
end

--// 2. KEY SYSTEM (Trigger)
function Library:InitiateKey(CorrectKey, Callback)
    local CoreGui = GetService(game, "CoreGui")
    local KeyUI = Instance.new("ScreenGui", CoreGui)
    
    local Frame = Instance.new("Frame", KeyUI)
    Frame.Size = UDim2.new(0, 350, 0, 200)
    Frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    Frame.BackgroundColor3 = Theme.Secondary
    Frame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner", Frame)
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Color = Theme.Outline
    UIStroke.Thickness = 2
    
    local Title = Instance.new("TextLabel", Frame)
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.Text = "ENTER KEY"
    Title.TextColor3 = Theme.Title
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    
    local Input = Instance.new("TextBox", Frame)
    Input.Size = UDim2.new(0, 250, 0, 40)
    Input.Position = UDim2.new(0.5, -125, 0.45, 0)
    Input.BackgroundColor3 = Theme.Component
    Input.Text = ""
    Input.PlaceholderText = "Key Here..."
    Input.TextColor3 = Color3.new(1,1,1)
    
    local Submit = Instance.new("TextButton", Frame)
    Submit.Size = UDim2.new(0, 250, 0, 40)
    Submit.Position = UDim2.new(0.5, -125, 0.75, 0)
    Submit.BackgroundColor3 = Theme.Interactables
    Submit.Text = "CHECK KEY"
    Submit.TextColor3 = Color3.new(1,1,1)
    Submit.Font = Enum.Font.GothamBold
    
    Submit.MouseButton1Click:Connect(function()
        if Input.Text == CorrectKey then
            KeyUI:Destroy()
            Library:ShowLoading(Callback)
        else
            Input.Text = ""
            Input.PlaceholderText = "WRONG KEY!"
            Input.PlaceholderColor3 = Color3.new(1, 0, 0)
            task.wait(1)
            Input.PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7)
        end
    end)
end

--// 3. MAIN LIBRARY FUNCTION (Önceki attığın kodu buraya entegre ediyoruz)
function Library:CreateWindow(Settings)
    -- Temayı burada set ediyoruz (Kodun geri kalanı senin attığın kısımla devam ediyor)
    -- Sadece renkleri Theme tablosundan çekiyoruz
    print("Window Created: " .. Settings.Title)
    -- ... (Daha önce attığın Create Window kodlarını buraya yapıştırabilirsin)
end

--// ÖRNEK KULLANIM:
Library:InitiateKey("Trigger", function()
    -- Key doğru girilirse ve Loading biterse burası açılır:
    print("Hub Activated!")
    
    -- Buraya senin CreateWindow kodlarını ve butonlarını ekle
    -- Örn: local Main = Library:CreateWindow({Title = "Anime Hub", Theme = "Dark"})
end)

return Library
