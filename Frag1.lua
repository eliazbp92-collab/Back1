function GetGitSound(GithubSnd,SoundName)
	local url=GithubSnd
	if not isfile(SoundName..".mp3") then
		writefile(SoundName..".mp3", game:HttpGet(url))
	end
	local sound=Instance.new("Sound")
	sound.SoundId=(getcustomasset or getsynasset)(SoundName..".mp3")
	return sound
end

---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

---====== Create entity ======---

local entity = Spawner:Create({
	Entity = {
		Name = "Rebound1",
		Asset = "https://github.com/eliazbp92-collab/Back1/blob/main/Place_10959918411_Model_Rebound_1787525198.rbxm?raw=true",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 1
		},
		Shatter = false,
		Repair = false
	},
	Earthquake = {
		Enabled = false
	},
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {7.5, 15, 0.1, 2} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 200,
		Delay = 7,
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
		Range = 40,
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

	local bruh = workspace.Rebound1.RushNew
	local TweenService = game:GetService("TweenService")
	
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://6734393210"
	sound.Volume = 3
	sound.Parent = workspace
	sound:Play()

	local ids = Instance.new("DistortionSoundEffect")
	ids.Level = 0.65
	ids.Parent = sound

	local revers = Instance.new("ReverbSoundEffect")
	revers.DecayTime = 1.5
	revers.Density = 1
	revers.Diffusion = 1
	revers.DryLevel = -6
	revers.Parent = sound

	local sound1 = Instance.new("Sound")
	sound1.SoundId = "rbxassetid://5246103002"
	sound1.Volume = 3
	sound1.Parent = workspace
	sound1:Play()

	local ids1 = Instance.new("DistortionSoundEffect")
	ids1.Level = 0.65
	ids1.Parent = sound1

	local revers1 = Instance.new("ReverbSoundEffect")
	revers1.DecayTime = 1.5
	revers1.Density = 1
	revers1.Diffusion = 1
	revers1.DryLevel = -6
	revers1.Parent = sound1

	local pitch = Instance.new("PitchShiftSoundEffect")
	pitch.Octave = 0.5
	pitch.Parent = sound1


	wait(2.5)

	local sound3 = Instance.new("Sound")
	sound3.SoundId = "rbxassetid://139319051979882"
	sound3.Volume = 5
	sound3.Parent = workspace
	sound3:Play()

	local revers = Instance.new("ReverbSoundEffect")
	revers.DecayTime = 1.5
	revers.Density = 1
	revers.Diffusion = 1
	revers.DryLevel = -6
	revers.Parent = sound
	
	wait(0.8)

	local move = GetGitSound("https://github.com/check78/worldcuuuup/blob/main/DoomBegin.mp3?raw=true","Reboun")
	move.Parent = bruh
	move.Name = "ReboundMoving"
	move.Volume = 0
	move.Looped = true
	local vroom = TweenService:Create(move, TweenInfo.new(2),{Volume = 0.2})
	local distort = Instance.new("DistortionSoundEffect")
	distort.Level = 0.75
	distort.Parent = move
	move.RollOffMaxDistance = 200
	move.RollOffMinDistance = 100
	local tree = Instance.new("TremoloSoundEffect")
	tree.Depth = 1
	tree.Duty = 1
	tree.Frequency = 5
	tree.Parent = move
	local eq = Instance.new("EqualizerSoundEffect")
	eq.HighGain = -60
	eq.MidGain = 10
	eq.LowGain = 10
	eq.Parent = move
	wait(1)
	vroom:Play()
	move:Play()
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
end)

entity:SetCallback("OnDespawned", function()
	print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth: number)
	if newHealth <= 0 then
		print("Entity has killed the player")
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/ohh/refs/heads/main/Rebound%20jumpscare"))()
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

game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
loadstring(game:HttpGet("https://raw.githubusercontent.com/eliazbp92-collab/Back1/refs/heads/main/Frag2.lua"))()
