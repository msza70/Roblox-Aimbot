-- Roblox Aimbot Script avec GUI
-- Créé avec amour

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

-- Config
local AimbotEnabled = false
local AimPart = "Head"
local FOV = 90
local TeamCheck = false

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 150, 0, 130)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function createButton(name, y, callback)
    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, -10, 0, 25)
    btn.Position = UDim2.new(0, 5, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Text = name
    btn.MouseButton1Click:Connect(callback)
end

createButton("Toggle Aimbot", 5, function()
    AimbotEnabled = not AimbotEnabled
    Frame.Status.Text = "Aimbot: " .. tostring(AimbotEnabled)
end)

createButton("Switch Part", 35, function()
    AimPart = (AimPart == "Head") and "HumanoidRootPart" or "Head"
    Frame.Part.Text = "Part: " .. AimPart
end)

createButton("Toggle TeamCheck", 65, function()
    TeamCheck = not TeamCheck
end)

local status = Instance.new("TextLabel", Frame)
status.Name = "Status"
status.Position = UDim2.new(0, 5, 0, 95)
status.Size = UDim2.new(1, -10, 0, 15)
status.TextColor3 = Color3.new(1, 1, 1)
status.BackgroundTransparency = 1
status.Text = "Aimbot: false"

local part = Instance.new("TextLabel", Frame)
part.Name = "Part"
part.Position = UDim2.new(0, 5, 0, 110)
part.Size = UDim2.new(1, -10, 0, 15)
part.TextColor3 = Color3.new(1, 1, 1)
part.BackgroundTransparency = 1
part.Text = "Part: Head"

-- Aimbot
local function getClosest()
    local closest, shortest = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPart) and player.Character:FindFirstChild("Humanoid") then
            if player.Character.Humanoid.Health > 0 then
                if TeamCheck and player.Team == LocalPlayer.Team then continue end
                local pos = Camera:WorldToViewportPoint(player.Character[AimPart].Position)
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                if dist < shortest and dist <= FOV then
                    closest = player
                    shortest = dist
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosest()
        if target and target.Character:FindFirstChild(AimPart) then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimPart].Position)
        end
    end
end)
