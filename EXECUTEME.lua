local genv = (getgenv and getgenv()) or shared
genv.Settings = {
	["ButtonSpacing"] = 0.1, -- How far out the buttons should be. Recommended 0.08-0.15.
	["AlwaysRedownloadAssets"] = false, -- This will always re-download assets for the repo. Useful for updating but may waste resources.
	
	["Buttons"] = {
		["Dash"] = {
			["Enabled"] = true,
			["Position"] = { -2, 1 }
		},
		
		["Drop"] = { -- Lets you drop an item if it is droppable.
			["Enabled"] = true,
			["Position"] = { -3, 1 },

			["DroppableRequired"] = true
		},
		
		["Faint"] = { -- Disables your own Humanoid physics when on.
			["Enabled"] = true,
			["Position"] = { -2, 0 }
		},
		
		["Reset"] = { -- Kills your character on press.
			["Enabled"] = true,
			["Position"] = { -3, 0 }
		},
		
		["Sit"] = { -- Makes your Character sit.
			["Enabled"] = true,
			["Position"] = { -1, 0 }
		},

		["ShiftLock"] = {
			["Enabled"] = true,
			["Position"] = { 0, 1 }
		},
		
		["Sprint"] = { -- Multiplies your FOV and WalkSpeed by a constant value.
			["Enabled"] = true,
			["Position"] = { -1, 1 },

			["Toggled"] = false,
			["IsTweened"] = true, 

			["Multipliers"] = {
				["WalkSpeed"] = 1.5,
				["FieldOfView"] = 1.15
			}
		}
	},

	["Addons"] = {
		["FakeR6"] = {
			["Enabled"] = true
		},
		["LimbsInFirstPerson"] = {
			["Enabled"] = true,

			--[[["Arms"] = true,
			["Legs"] = true,
			["Torso"] = false,
			["Accessories"] = false]] 
		}, -- Show your limbs in first-person view.
	}
}

loadstring(game:HttpGet("https://raw.githubusercontent.com/devoidingreality/Timeless/refs/heads/main/Core/Main.lua"))()
