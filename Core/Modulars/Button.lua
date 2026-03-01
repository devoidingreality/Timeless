local genv = (getgenv and getgenv()) or shared
local prefix = "[Timeless/Button.lua]:"

local Settings = genv.Settings

local ButtonSpacing = Settings.ButtonSpacing or 0.1

genv.Module = genv.Module or {}
local Module = genv.Module

Module.Button = Module.Button or {}
local Button = Module.Button

local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local TouchGui = PlayerGui:WaitForChild("TouchGui")
local TCF = TouchGui:WaitForChild("TouchControlFrame")
local JumpButton = TCF:WaitForChild("JumpButton")

local Reference = TCF:WaitForChild("JumpButtonReference")
local Space = 1+ButtonSpacing

local getsynasset = getsynasset or getcustomasset or function() end

--|| Functions ||--

function Button.position(name, pos)
	local b = Reference:FindFirstChild(name.."_Frame")
	local x, y = pos[1], pos[2]

	local c = {
		(x or -1) * Space, 
		-1*((y or 0) * Space)
	}

	if b then
		b.Position = UDim2.fromScale(c[1], c[2])
		return c
	else
		warn(prefix, name, "is not a valid Button object")
		return
	end
end

function Button.reset(name)
	local b = Reference:FindFirstChild(name.."_Frame")

	if b then
		b.Position = UDim2.fromScale(0, 0)
	else
		warn(prefix, name, "is not a valid Button object")
	end
end


function Button.new(name, pos, active)
	local off = getsynasset("Timeless/"..name.."_off")
	local on = getsynasset("Timeless/"..name.."_on")
	
	local f = Instance.new("Frame"); do
		f.Name = name.."_Frame"
		f.BackgroundTransparency = 1
		f.Active = false
		f.Size = UDim2.fromScale(1, 1)
		f.Parent = Reference
	end
	
	local b = Instance.new("ImageButton"); do
		b.Name = name
		b.Image = off
		b.PressedImage = on
		b.Active = active
		b.BackgroundTransparency = 1
		b.Size = UDim2.fromScale(1, 1)
		b.Parent = f
	end

	local uc = Instance.new("ImageLabel"); do
		uc.Name = "Unclickable"
		uc.Image = b.Image
		uc.Active = b.Active
		uc.BackgroundTransparency = 1
		uc.ImageTransparency = 0.6
		uc.Size = b.Size
		uc.Visible = false
		uc.Parent = f
	end

	if pos then
		local p = pos or {0, 0}
		local c = Button.position(name, pos)

		if c and p then -- What a dangerous letter combo. It means COD Points I swear
			print(prefix, "Successfully created", name, "\n  ¬ Position:", string.format("on { %f, %f }", pos[1], pos[2]), "\n  ¬ Frame:", f.Name)
		end
	end
	
	return b, uc
end

function Button.destroy(name)
	local b = Reference:FindFirstChild(name.."_Frame")

	if b then
		b:Destroy()
		print(prefix, "Successfully removed", name, "("..name.."_Frame)") 
		return true
	else
		warn(prefix, name, "("..name.."_Frame) is not a valid Button object")
		return false
	end
end
