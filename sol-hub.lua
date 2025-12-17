-- Load WindUI Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

-- Variables
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- State Variables
local flyEnabled = false
local noClipEnabled = false
local espEnabled = false
local fullbrightEnabled = false
local infiniteJumpEnabled = false
local walkSpeed = 16
local jumpPower = 50
local flySpeed = 50

-- Create Main Window
local window = WindUI:CreateWindow({
    Title = "Universal Script Hub",
    Icon = "rbxassetid://10723434711",
    Author = "Script Hub",
    Folder = "WindUIConfig",
    Size = UDim2.fromOffset(580, 460),
    KeySystem = false,
    Transparent = true
})

-- Create Tabs
local mainTab = window:Tab({
    Title = "Main",
    Icon = "home"
})

local playerTab = window:Tab({
    Title = "Player",
    Icon = "user"
})

local visualTab = window:Tab({
    Title = "Visuals",
    Icon = "eye"
})

local miscTab = window:Tab({
    Title = "Misc",
    Icon = "settings"
})

-- Main Tab Sections
local movementSection = mainTab:Section({
    Title = "Movement"
})

-- Fly Toggle
movementSection:Toggle({
    Title = "Fly",
    Description = "Enables flying",
    Default = false,
    Callback = function(v)
        flyEnabled = v
        if not v then
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
})

-- Fly Speed Slider
movementSection:Slider({
    Title = "Fly Speed",
    Description = "Adjust your fly speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Callback = function(v)
        flySpeed = v
    end
})

-- NoClip Toggle
movementSection:Toggle({
    Title = "NoClip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(v)
        noClipEnabled = v
    end
})

-- Player Tab Sections
local statsSection = playerTab:Section({
    Title = "Character Stats"
})

-- WalkSpeed Slider
statsSection:Slider({
    Title = "Walk Speed",
    Description = "Change your walk speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        walkSpeed = v
        if humanoid then
            humanoid.WalkSpeed = v
        end
    end
})

-- JumpPower Slider
statsSection:Slider({
    Title = "Jump Power",
    Description = "Change your jump power",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(v)
        jumpPower = v
        if humanoid then
            humanoid.JumpPower = v
        end
    end
})

-- Infinite Jump Toggle
statsSection:Toggle({
    Title = "Infinite Jump",
    Description = "Jump infinitely",
    Default = false,
    Callback = function(v)
        infiniteJumpEnabled = v
    end
})

-- God Mode Button
statsSection:Button({
    Title = "God Mode",
    Description = "Makes you invincible",
    Callback = function()
        if humanoid then
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
        end
    end
})

-- Reset Character Button
statsSection:Button({
    Title = "Reset Character",
    Description = "Respawns your character",
    Callback = function()
        if character then
            character:BreakJoints()
        end
    end
})

-- Visual Tab Sections
local visualSection = visualTab:Section({
    Title = "Visual Enhancements"
})

-- ESP Toggle
visualSection:Toggle({
    Title = "Player ESP",
    Description = "See players through walls",
    Default = false,
    Callback = function(v)
        espEnabled = v
        if not v then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    for _, part in pairs(p.Character:GetDescendants()) do
                        if part:IsA("Highlight") then
                            part:Destroy()
                        end
                    end
                end
            end
        end
    end
})

-- Fullbright Toggle
visualSection:Toggle({
    Title = "Fullbright",
    Description = "Makes everything bright",
    Default = false,
    Callback = function(v)
        fullbrightEnabled = v
        if v then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end
})

-- Misc Tab Sections
local utilitySection = miscTab:Section({
    Title = "Utilities"
})

-- Remove Textures Button
utilitySection:Button({
    Title = "Remove Textures",
    Description = "Removes all textures for better FPS",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            end
        end
    end
})

-- Rejoin Server Button
utilitySection:Button({
    Title = "Rejoin Server",
    Description = "Rejoins the current server",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
})

-- Server Hop Button
utilitySection:Button({
    Title = "Server Hop",
    Description = "Joins a different server",
    Callback = function()
        local servers = game:GetService("HttpService"):JSONDecode(
            game:HttpGetAsync("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
        )
        if servers and servers.data then
            for _, server in pairs(servers.data) do
                if server.id ~= game.JobId then
                    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, server.id, player)
                    break
                end
            end
        end
    end
})

-- Functions
local function updateFly()
    if flyEnabled and character and character:FindFirstChild("HumanoidRootPart") then
        local cam = workspace.CurrentCamera
        local speed = flySpeed
        local velocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            velocity = velocity + (cam.CFrame.LookVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            velocity = velocity - (cam.CFrame.LookVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            velocity = velocity - (cam.CFrame.RightVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            velocity = velocity + (cam.CFrame.RightVector * speed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            velocity = velocity + Vector3.new(0, speed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            velocity = velocity - Vector3.new(0, speed, 0)
        end
        
        character.HumanoidRootPart.Velocity = velocity
    end
end

local function updateNoClip()
    if noClipEnabled and character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function updateESP()
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and not p.Character:FindFirstChildOfClass("Highlight") then
                local highlight = Instance.new("Highlight")
                highlight.Parent = p.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    end
end

-- Connect Functions
RunService.RenderStepped:Connect(function()
    updateFly()
    updateNoClip()
    updateESP()
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and humanoid then
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- Character Reset Handler
player.CharacterAdded:Connect(function(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
    
    humanoid.WalkSpeed = walkSpeed
    humanoid.JumpPower = jumpPower
end)

print("WindUI Script Loaded Successfully!")
