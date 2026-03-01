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

local btn = "SitButton"
local pos = Settings.Buttons.Sit.Position

local off = Asset.get("Timeless/" .. btn .. "_off.png")
local on = Asset.get("Timeless/" .. btn .. "_on.png")

local button, uc = Button.new(btn, pos, true); do
	button.Image = off
	button.PressedImage = on

	uc.Image = off
end

button.MouseButton1Click:Connect(function()
	Humanoid.Sit = not Humanoid.Sit
end)

RunService.RenderStepped:Connect(function()
	if not Character or not Humanoid then return end

	local dead = Humanoid.Health <= 0
	
	button.Image = Humanoid.Sit and on or off
	button.PressedImage = Humanoid.Sit and off or on

	button.Visible = not Humanoid.PlatformStand
	uc.Visible = not button.Visible
	button.Parent.Visible = not dead
end)
