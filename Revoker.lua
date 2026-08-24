---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

---====== Create entity ======---

local entity = Spawner:Create({
	Entity = {
		Name = "Revoker",
		Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_10959918411_Model_Revoker_1787523394.rbxm",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 1
		},
		Shatter = true,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {1.5, 20, 0.1, 1} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 60,
		Delay = 5,
		Reversed = true
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush", -- "Blitz"
		Min = 1,
		Max = 1,
		Delay = 2
	},
	Damage = {
		Enabled = true,
		Range = 40,
		Amount = 125
	},
	Crucifixion = {
		Enabled = true,
		Range = 50,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding", -- "Curious"
		Hints = {"Death", "Hints", "Go", "Here"},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
	print("Entity has spawned")
	local cue = Instance.new("Sound")
	cue.Parent = workspace
	cue.SoundId = "rbxassetid://4288784832"
	cue.Volume = 4
	cue.PlaybackSpeed = 1
	cue:Play()

	game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
	game.Lighting.MainColorCorrection.Contrast = 0.3
	local tween = game:GetService("TweenService")
	tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
	local TweenService = game:GetService("TweenService")
	local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5),{TintColor = Color3.fromRGB(3, 98, 252)})
	TW:Play()
end)

entity:SetCallback("OnStartMoving", function()
	print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)
	if firstTime == true then
		print("Entity has entered room: ".. room.Name.. " for the first time")
	else
		print("Entity has entered room: ".. room.Name.. " again")
	end
end)

entity:SetCallback("OnLookAt", function(lineOfSight: boolean)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound: boolean)
	if startOfRebound == true then
		print("Entity has started rebounding")
	else
		print("Entity has finished rebounding")
	end
end)

entity:SetCallback("OnDespawning", function()
	print("Entity is despawning")
	wait(0.4)

	game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(3, 98, 252)
	game.Lighting.MainColorCorrection.Contrast = 0.3
	local tween = game:GetService("TweenService")
	tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
	local TweenService = game:GetService("TweenService")
	local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5),{TintColor = Color3.fromRGB(255,255,255)})
	TW:Play()
end)

entity:SetCallback("OnDespawned", function()
	print("Entity has despawned")
end)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = workspace.CurrentCamera

local function playJumpscare()
	local character = player.Character or player.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")

	local screenGui = Instance.new("ScreenGui")
	screenGui.Parent = playerGui
	screenGui.Name = "ScreenGui"
	screenGui.IgnoreGuiInset = true

	local stopEffects = false
	local doneFading = false

	-- Âm thanh jumpscare
	local killSound = Instance.new("Sound")
	killSound.Parent = workspace
	killSound.PlaybackSpeed = 1
	killSound.SoundId = "rbxassetid://18459521002"
	killSound.Name = "Dear god death sound chat"
	killSound.Volume = 10
	killSound.Looped = true

	Instance.new("FlangeSoundEffect", killSound).Rate = 0.2
	Instance.new("TremoloSoundEffect", killSound).Frequency = 1
	Instance.new("PitchShiftSoundEffect", killSound).Octave = 1
	Instance.new("DistortionSoundEffect", killSound).Level = 0.2

	-- UI
	local background = Instance.new("ImageLabel")
	background.Parent = screenGui
	background.Size = UDim2.new(1, 0, 1, 0)
	background.Image = "rbxassetid://1712510813"
	background.ImageTransparency = 0.5
	background.BackgroundColor3 = Color3.new(0, 0, 0)
	background.BackgroundTransparency = 0

	local face = Instance.new("ImageLabel")
	face.Parent = screenGui
	face.AnchorPoint = Vector2.new(0.5, 0.5)
	face.Position = UDim2.new(0.5, 0, 0.589, 0)
	face.Size = UDim2.new(0, 1, 0, 1)
	face.Image = "rbxassetid://14101161259"
	face.BackgroundTransparency = 1

	local text = Instance.new("ImageLabel")
	text.Parent = screenGui
	text.AnchorPoint = Vector2.new(0.5, 0.5)
	text.Position = UDim2.new(0.5, 0, 0.5, 0)
	text.Size = UDim2.new(0, 150, 0, 150)
	text.Image = "rbxassetid://99132041298170"
	text.BackgroundTransparency = 1

	killSound:Play()

	-- Camera zoom
	local startFov = camera.FieldOfView
	local zoomFov = 60
	local zoomDuration = 1.1

	camera.CameraType = Enum.CameraType.Scriptable
	TweenService:Create(camera, TweenInfo.new(zoomDuration), { FieldOfView = zoomFov }):Play()

	TweenService:Create(face, TweenInfo.new(zoomDuration), {
		Size = UDim2.new(0, 1200, 0, 1200),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()

	-- Jumpscare Effects
	task.spawn(function()
		while not stopEffects do
			background.ImageTransparency = 0.3
			background.BackgroundTransparency = 0
			task.wait(0.1)
			background.ImageTransparency = 0
			background.BackgroundTransparency = 0.3
			task.wait(0.1)
		end
	end)

	task.spawn(function()
		while not stopEffects do
			background.Image = "rbxassetid://131073231978514"
			task.wait(0.0589)
			background.Image = "rbxassetid://105841646930424"
			task.wait(0.0589)
		end
	end)

	task.spawn(function()
		while not stopEffects do
			face.Rotation = 10
			face.Image = "rbxassetid://14101161259"
			task.wait()
			face.Rotation = -10
			task.wait()
		end
	end)

	task.spawn(function()
		while not stopEffects do
			text.Image = "rbxassetid://88490592395124"
			task.wait(0.0589)
			text.Image = "rbxassetid://99132041298170"
			task.wait(0.0589)
		end
	end)

	task.spawn(function()
		while not stopEffects do
			text.Position = UDim2.new(math.random(), 0, math.random(), 0)
			task.wait(0.05)
		end
	end)

	task.spawn(function()
		while not stopEffects do
			text.ImageTransparency = 0
			task.wait(0.1)
			text.ImageTransparency = 1
			task.wait(0.1)
		end
	end)

	task.wait(zoomDuration)
	stopEffects = true
	killSound:Stop()

	task.spawn(function()
		while not doneFading do
			face.ImageTransparency = math.min(face.ImageTransparency + 0.1, 1)
			text.ImageTransparency = math.min(text.ImageTransparency + 0.1, 1)
			background.ImageTransparency = math.min(background.ImageTransparency + 0.1, 1)
			background.BackgroundTransparency = math.min(background.BackgroundTransparency + 0.1, 1)

			if face.ImageTransparency >= 1 then
				doneFading = true
			end

			task.wait(0.05)
		end

		screenGui:Destroy()
	end)

	task.wait(0.6)
	camera.CameraType = Enum.CameraType.Custom
	camera.FieldOfView = startFov
end

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

humanoid.HealthChanged:Connect(function(newHealth)
	if newHealth <= 0 then
		playJumpscare()
	else
		print("Entity has damaged the player")
	end
end)

--[[

DEVELOPER NOTE:
By overwriting 'CrucifixionOverwrite' the default crucifixion callback will be replaced with your custom callback.

entity:SetCallback("CrucifixionOverwrite", function()
    print("Custom crucifixion callback")
end)

]]--

---====== Run entity ======---

entity:Run(true)
