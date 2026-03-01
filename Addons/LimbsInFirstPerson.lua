local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

local bl = {
	"Head",
	"Torso",
	"UpperTorso",
	"LowerTorso"
}

local function transparencyFix(char)
	for _, v in char:GetChildren() do
		if not v:IsA("BasePart") then
			continue
		end

		if table.find(bl, v.Name) then
			continue
		end

		if v.Parent:IsA("Accessory") then
			local a = v.Parent
			local face = a.AccessoryType == Enum.AccessoryType.Face
			local neck = a.AccessoryType == Enum.AccessoryType.Neck
			local shoulder = a.AccessoryType == Enum.AccessoryType.Shoulder
			local front = a.AccessoryType == Enum.AccessoryType.Front
			local waist = a.AccessoryType == Enum.AccessoryType.Waist
			
			local abl = face or neck or shoulder or front or waist
			
			if abl then
				return
			end
		end

		v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			v.LocalTransparencyModifier = 0
		end)

		v.LocalTransparencyModifier = 0
	end

	char.ChildAdded:Connect(function(v)
		if not v:IsA("BasePart") then
			return
		end

		if table.find(bl, v.Name) then
			return
		end

		if v.Parent:IsA("Accessory") then
			local a = v.Parent
			local face = a.AccessoryType == Enum.AccessoryType.Face
			local neck = a.AccessoryType == Enum.AccessoryType.Neck
			local shoulder = a.AccessoryType == Enum.AccessoryType.Shoulder
			local front = a.AccessoryType == Enum.AccessoryType.Front
			local waist = a.AccessoryType == Enum.AccessoryType.Waist
			
			local abl = face or neck or shoulder or front or waist
			
			if abl then
				return
			end
		end

		v:GetPropertyChangedSignal("LocalTransparencyModifier"):Connect(function()
			v.LocalTransparencyModifier = 0
		end)

		v.LocalTransparencyModifier = 0
	end)
end

if Player.Character then transparencyFix(Player.Character) end
Player.CharacterAdded:Connect(transparencyFix)
