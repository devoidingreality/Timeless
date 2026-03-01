local genv = (getgenv and getgenv()) or shared  
  
local Settings = genv.Settings -- This should get your Settings! If you executed it with them.  
local Module = genv.Module -- Module will just keep appearing! Of course, these aren't actually ModuleScripts, but they're genv emulations of them.  
local playingTweens = genv.playingTweens  
  
local Button = Module.Button  
local Asset = Module.Asset  
  
local Toggled = Settings.Buttons.Sprint.Toggled -- This will determine whether or not the button will be Held or Toggled. Default is Held/false, if you didn't know already!  
local IsTweened = Settings.Buttons.Sprint.IsTweened -- Of course, this is mostly visual. But it looks smooth! Kind of? I don't know, she was just copying from Minecraft.  
-- hey, i was not copying from minecraft  
-- But you told me you were? :0  
  
local m = Settings.Buttons.Sprint.Multipliers or {} -- Yes, your Base WalkSpeed/Field of View will be multiplied by these values.  
local WSm = m.WalkSpeed or 1.5  
local FOVm = m.FieldOfView or 1.15  
  
local Players = game:GetService("Players")  
local ReplicatedStorage = game:GetService("ReplicatedStorage")  
local RunService = game:GetService("RunService")  
local TweenService = game:GetService("TweenService")  
  
local infoIn = TweenInfo.new(  
	0.75,  
	Enum.EasingStyle.Quad,  
	Enum.EasingDirection.InOut  
)  
local infoOut = TweenInfo.new(  
	0.5,  
	Enum.EasingStyle.Exponential, -- If you're familiar with mathematics, you would naturally understand this.  
	Enum.EasingDirection.Out -- It's like.. Think of an Expo In. It gradually gets faster until you reach the end. Now this one is backwards! Instead of getting faster, it starts really fast, then gets slower and slower. Sorry, I'm talking too much. Sorry...  
)  
  
local Player = Players.LocalPlayer -- Hi You!! („>ᵕ🌟„)  
  
local BaseWS, BaseFOV  
  
local sprinting = false  
local dead = false  
local Died, RStepped  
  
local tweening = false  
  
local btn = "SprintButton"  
local pos = Settings.Buttons.Sprint.Position  
  
local off = Asset.get("Timeless/" .. btn .. "_off.png")  
local on = Asset.get("Timeless/" .. btn .. "_on.png")  
  
local button, uc = Button.new(btn, pos, true); do  
	button.Image = off  
	button.PressedImage = on

	uc.Image = off
end
  
local function PlayTween(tween, group)  
	playingTweens[group] += 1  
	tween:Play()  
  
	tween.Completed:Connect(function() playingTweens[group] -= 1 end)  
end  
  
local function ButtonDown(hum, cam)  
	local Tween_1 = TweenService:Create(hum, infoIn, { WalkSpeed = BaseWS * WSm })  
	local Tween_2 = TweenService:Create(cam, infoIn, { FieldOfView = BaseFOV * FOVm })  
  
	if IsTweened then  
		PlayTween(Tween_1, "WalkSpeed")  
		PlayTween(Tween_2, "FieldOfView")  
	else  
		hum.WalkSpeed = BaseWS * WSm  
		cam.FieldOfView = BaseFOV * FOVm  
	end  
end  
  
local function ButtonUp(hum, cam)  
	local Tween_1 = TweenService:Create(hum, infoOut, { WalkSpeed = BaseWS })  
	local Tween_2 = TweenService:Create(cam, infoOut, { FieldOfView = BaseFOV })  
  
	if IsTweened then  
		PlayTween(Tween_1, "WalkSpeed")  
		PlayTween(Tween_2, "FieldOfView")  
	else  
		hum.WalkSpeed = BaseWS  
		cam.FieldOfView = BaseFOV  
	end  
end  
  
local Character, Humanoid, Camera  
local function SetupChar(char)  
	if RStepped then RStepped:Disconnect() end  
	  
	Character = char  
	Humanoid = Character:WaitForChild("Humanoid")  
	Camera = workspace.CurrentCamera  
  
	RStepped = RunService.RenderStepped:Connect(function()  
		tweening = playingTweens.FieldOfView > 0 or playingTweens.WalkSpeed > 0  
		dead = Humanoid.Health <= 0  
			  
		button.Visible = Humanoid.MoveDirection.Magnitude > 0 and not Humanoid.Sit and not Humanoid.PlatformStand
		uc.Visible = not button.Visible
		button.Parent.Visible = not dead
		  
		if Toggled then  
			button.Image = sprinting and on or off  
			button.PressedImage = sprinting and off or on  
		end
		  
		--|| Safety net: If the button magically disappears mid run, then disable sprinting manually  
		if Humanoid.MoveDirection.Magnitude <= 0 and sprinting then  
			ButtonUp(Humanoid, Camera) -- Because Roblox is wack, if a Button becomes invisible before you can MouseButton1Up it, it'll never fire until you do it once it's visible again. Of course, we'll have to work with just calling sprintStop again... (⁠╥⁠﹏⁠💫⁠)  
			sprinting = false  
		end  
		  
		Camera = workspace.CurrentCamera  
		if not sprinting and not tweening and Humanoid and Camera then  
			BaseWS = Humanoid.WalkSpeed  
			BaseFOV = Camera.FieldOfView  
		end  
	end)  
  
	if Toggled then  
		button.MouseButton1Click:Connect(function()  
			if not Humanoid or not Camera then return end  
		  
			sprinting = not sprinting  
			if sprinting then  
				ButtonDown(Humanoid, Camera)  
			else  
				ButtonUp(Humanoid, Camera)  
			end  
		end)  
	else  
		button.MouseButton1Down:Connect(function()  
			if not Humanoid or not Camera then return end  
		  
			sprinting = true  
			ButtonDown(Humanoid, Camera)  
		end)  
  
		button.MouseButton1Up:Connect(function() -- MouseButton1Up is kind of... er, terrible, sometimes. Unfortunately, Ms. relojac can't really do much about it.  
			if not Humanoid or not Camera then return end  
		  
			sprinting = false  
			ButtonUp(Humanoid, Camera)  
		end)   
	end  
end  
  
if Player.Character then SetupChar(Player.Character) end  
Player.CharacterAdded:Connect(SetupChar)  
