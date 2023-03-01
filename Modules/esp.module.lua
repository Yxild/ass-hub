--[[
    Ass Hub Module - ESP Module

    -- -- --

    Credits: Based on Throit's code from V3rmillion

    -- -- --

    Universal Script - Ass Hub
    This script is licenced under the GPL v3.0 licence
    Find out more @ https://github.com/Yxild/ass-hub

    This script is using Linoria Library which is licenced under MIT

    Developed with:
        SirHurt
        Visual Studio Code
]]

getgenv().ESPModule = {
    Boxes = true,
    Chams = false,
    Tracers = false
}

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ESP Module > Boxes

local Boxes = {}
local Faces = {"Front", "Back", "Bottom", "Left", "Right", "Top"}

local function NewBox(cPlayer)
    local NewBox = {
        ["Player"] = cPlayer,
        ["TopLeft"] = nil,
        ["TopRight"] = nil,
        ["BottomRight"] = nil,
        ["BottomLeft"] = nil
    }

    for i, Box in pairs(NewBox) do
        local Line = Drawing.new("Line")

        Line.Color = Color3.fromRGB(255, 255, 255)
        Line.From = Vector2.new(1, 1)
        Line.To = Vector2.new(0, 0)
        Line.Visible = true
        Line.Thickness = 2

        if (Box[i] ~= cPlayer) then
            Box[i] = Line
        end
    end

    table.insert(Boxes, NewBox)
end

local function VisibleBox(Box, Visible)
    for _, cPlayer in ipairs(Box) do
        cPlayer.Visible = Visible
    end
end

local function HasBox(cPlayer)
    for _, v in ipairs(Boxes) do
        if (v["Player"] == cPlayer) then
            return true
        end
    end
end

-- ESP Module > Chams

local function ChamPlayer(cPlayer, Color)
    for _1, Character in ipairs(cPlayer.Character:GetChildren()) do
        for _2, Face in pairs(Faces) do
            local Surface = Instance.new("SurfaceGui")
            Surface.Parent = Character
            Surface.Name = "NewCham"
            Surface.Face = Enum.NormalId[Face]
            Surface.AlwaysOnTop = true

            local MainFrame = Instance.new("Frame")
            MainFrame.Parent = Surface
            MainFrame.BackgroundColor3 = Color
            MainFrame.BorderSizePixel = 0
            MainFrame.BackgroundTransparency = 0.6
            MainFrame.Size = UDim2.new(1, 0, 1, 0)
        end
    end
end

local function ColorCham(cPlayer, Color)
    for _1, Character in ipairs(cPlayer.Character:GetChildren()) do
        for _2, Cham in ipairs(Character:GetChildren()) do
            if (Cham.Name == "NewCham") then
                Cham.Frame.BackgroundColor3 = Color
            end
        end
    end
end

local function VisibleCham(cPlayer, Visible)
    for _1, Character in ipairs(cPlayer.Character:GetChildren()) do
        for _2, Cham in ipairs(Character:GetChildren()) do
            if (Cham.Name == "NewCham") then
                Cham.Frame.Visible = Visible
            end
        end
    end
end

-- ESP Module > ESP Runner

RunService.Heartbeat:Connect(function()
    -- Boxes:
    if (getgenv().ESPModule.Boxes == true) then
        for _, cPlayer in ipairs(Players:GetPlayers()) do
            if (not HasBox(cPlayer) and cPlayer ~= Player) then
                NewBox(cPlayer)
            end
        end

        for _, Box in ipairs(Boxes) do
            local cPlayer = Box["Player"]
            if cPlayer.Character and cPlayer.Character:FindFirstChild("HumanoidRootPart") then

                local TopLeft = Camera:WorldToViewportPoint(cPlayer.Character.HumanoidRootPart.CFrame *
                                                                CFrame.new(-3, 3, 0).Position)
                local TopRight = Camera:WorldToViewportPoint(
                    cPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(3, 3, 0).Position)
                local BottomLeft = Camera:WorldToViewportPoint(
                    cPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(-3, -3, 0).Position)
                local BottomRight = Camera:WorldToViewportPoint(
                    cPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(3, -3, 0).Position)

                Box["TopLeft"].From = Vector2.new(TopLeft.X, TopLeft.Y)
                Box["TopLeft"].To = Vector2.new(BottomLeft.X, BottomLeft.Y)

                Box["TopRight"].To = Vector2.new(TopRight.X, TopRight.Y)
                Box["TopRight"].From = Vector2.new(TopLeft.X, TopLeft.Y)

                Box["BottomRight"].To = Vector2.new(BottomRight.X, BottomRight.Y)
                Box["BottomRight"].From = Vector2.new(TopRight.X, TopRight.Y)

                Box["BottomLeft"].To = Vector2.new(BottomRight.X, BottomRight.Y)
                Box["BottomLeft"].From = Vector2.new(BottomLeft.X, BottomLeft.Y)

                local _, withinScreenBounds = Camera:WorldToScreenPoint(Player.Character.HumanoidRootPart.Position)

                if (withinScreenBounds) then
                    VisibleBox(Box, true)
                else
                    VisibleBox(Box, false)
                end
            else
                VisibleBox(Box, false)
            end
        end
    else
        for _, Box in ipairs(Boxes) do
            VisibleBox(Box, false)
        end
    end

    -- Chams:

    if (getgenv().ESPModule.Chams == true) then
        for _, cPlayer in ipairs(Players:GetPlayers()) do
            if (cPlayer.Name ~= Player.Name) then
                if (cPlayer.Character) then
                    if (cPlayer.Character.Head:FindFirstChild("NewCham")) then
                        ColorCham(cPlayer, cPlayer.TeamColor)
                        VisibleCham(cPlayer, true)
                    else
                        ChamPlayer(cPlayer, Color3.fromRGB(255, 255, 255))
                        ColorCham(cPlayer, cPlayer.TeamColor)
                        VisibleCham(cPlayer, true)
                    end
                end
            end
        end
    else
        for _, cPlayer in ipairs(Players:GetPlayers()) do
            VisibleCham(cPlayer, false)
        end
    end
end)
