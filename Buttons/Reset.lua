local genv = (getgenv and getgenv()) or shared

local Settings = genv.Settings
local Module = genv.Module

local Button = Module.Button
local Positioner = Module.Positioner
local Asset = Module.Asset


local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Player.CharacterAdded:Connect(function(new)
	Character = new
	Humanoid = Character:WaitForChild("Humanoid")
end)

local btn = "ResetButton"
local pos = Settings.Buttons.Reset.Position

local off = Asset.get("Timeless/" .. btn .. "_off.png")
local on = Asset.get("Timeless/" .. btn .. "_on.png")

local button, uc = Button.new(btn, pos, true); do
	button.Image = off
	button.PressedImage = on

	uc.Image = off
end

RunService.RenderStepped:Connect(function()
	button.Visible = Humanoid.Health > 0
end) 

button.MouseButton1Click:Connect(function()
	Humanoid.Health = 0
end)
