game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()

local Reboundcolor = Instance.new("ColorCorrectionEffect",game.Lighting) game.Debris:AddItem(Reboundcolor,24)
Reboundcolor.Name = "Warn"
Reboundcolor.TintColor = Color3.fromRGB(65, 138, 255) Reboundcolor.Saturation = -0.7 Reboundcolor.Contrast = 0.2
game.TweenService:Create(Reboundcolor,TweenInfo.new(15),{TintColor = Color3.fromRGB(255, 255, 255),Saturation = 0, Contrast = 0}):Play()
local TweenService = game:GetService("TweenService")
local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5),{TintColor = Color3.fromRGB(255, 255, 255)})
TW:Play()
local cue1 = Instance.new("Sound")
cue1.Parent = game.Workspace
cue1.Name = "Scream"
cue1.SoundId = "rbxassetid://9114397505"
local distort = Instance.new("DistortionSoundEffect")
distort.Parent = cue1
distort.Level = 1
local distort2 = Instance.new("DistortionSoundEffect")
distort2.Parent = cue1
distort2.Level = 1
local pitch = Instance.new("PitchShiftSoundEffect")
pitch.Parent = cue1
pitch.Octave = 0.5
local pitch2 = Instance.new("PitchShiftSoundEffect")
pitch2.Parent = cue1
pitch2.Octave = 0.5
local pitch3 = Instance.new("PitchShiftSoundEffect")
pitch3.Parent = cue1
pitch3.Octave = 0.5
cue1.Volume = 1
cue1:Play()
local cue2 = Instance.new("Sound")
cue2.Parent = game.Workspace
cue2.Name = "Spawn"
cue2.SoundId = "rbxassetid://9114221327"
cue2.Volume = 200
cue2.TimePosition = 0
cue2.PlaybackSpeed = 1
cue2:Play()
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local camara = game.Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camara.CFrame = camara.CFrame * shakeCf
end)
camShake:Start()
camShake:ShakeOnce(10,3,0.1,6,2,0.5)
wait(2.8)

function GetGitSound(GithubSnd,SoundName)
	local url=GithubSnd
	if not isfile(SoundName..".mp3") then
		writefile(SoundName..".mp3", game:HttpGet(url))
	end
	local sound=Instance.new("Sound")
	sound.SoundId=(getcustomasset or getsynasset)(SoundName..".mp3")
	return sound
end

function GetGitSound2(GithubSnd,SoundName)
	local url=GithubSnd
	if not isfile(SoundName..".mp3") then
		writefile(SoundName..".mp3", game:HttpGet(url))
	end
	local sound=Instance.new("Sound")
	sound.SoundId=(getcustomasset or getsynasset)(SoundName..".mp3")
	return sound
end

local scare = Instance.new("Sound")
scare.Parent = game.Workspace
scare.Name = "MyEarsBurn"
scare.SoundId = "rbxassetid://5567523008"
scare.PlaybackSpeed = 3
scare.Volume = 200

local shift = Instance.new("PitchShiftSoundEffect")
shift.Octave = 0.5
shift.Parent = scare

local distort = Instance.new("DistortionSoundEffect")
distort.Parent = scare
distort.Level = 1

local TweenService = game:GetService("TweenService")
local spookee = TweenService:Create(scare, TweenInfo.new(0.3),{Volume = 0})

---====== Load spawner ======---

local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()

---====== Create entity ======---

local entity = Spawner:Create({
	Entity = {
		Name = "Rebound",
		Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_10959918411_Model_Rebound_1787525198.rbxm",
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
		Delay = 6.5,
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

	local bruh = workspace.Rebound.RushNew
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

	
	wait(2)
	
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
	
	wait(1.8)
	
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
game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()
loadstring(game:HttpGet("https://raw.githubusercontent.com/eliazbp92-collab/Back1/refs/heads/main/Frag1.lua"))()
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
