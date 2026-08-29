local rng = Random.new()
local ai = rng:NextInteger(35, 45)

---====== Load spawner ======---
 
local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/DOORS-Entity-Spawner-V2/main/init.luau"))()
 
---====== Create entity ======---
 
local entity = Spawner:Create({
	Entity = {
		Name = "Rebound",
		Asset = "https://github.com/eliazbp92-collab/Back1/blob/main/Place_131351567799504_Model_Rebound_1787965761.rbxm?raw=true",
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
		Speed = 45,
		Delay = 3,
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
 
	light(2, Color3.fromRGB(85, 170, 255), Color3.fromRGB(65, 138, 255))
 
	-- Tìm Rebound an toàn bằng WaitForChild để tránh lỗi nil
	local reboundModel = game.Workspace:WaitForChild("Rebound", 5)
	local reboundRoot = reboundModel and reboundModel:WaitForChild("Root", 3)
 
	local spawnSound = Instance.new("Sound")
	spawnSound.Parent = game.Workspace
	spawnSound.Name = "Spawn"
	spawnSound.SoundId = "rbxassetid://9114221327"
	spawnSound.Volume = 7
	spawnSound:Play()
 
	local function GetGitSound(GithubSnd, SoundName)
		local filePath = SoundName .. ".mp3"
		if not isfile(filePath) then
			writefile(filePath, game:HttpGet(GithubSnd))
		end
		local sound = Instance.new("Sound")
		sound.SoundId = (getcustomasset or getsynasset)(filePath)
		return sound
	end
 
	pcall(function()
		local Jumpscare = GetGitSound("https://github.com/check78/worldcuuuup/blob/main/DoomBegin.mp3?raw=true", "Riririririiriri")
		Jumpscare.Parent = reboundRoot or reboundModel or game.Workspace
		Jumpscare.Volume = 2
		Jumpscare.RollOffMinDistance = 100
		Jumpscare.RollOffMaxDistance = 200
		Jumpscare.Name = "am"
		Jumpscare.PlaybackSpeed = 1
		Jumpscare:Play()
	end)
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
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Fragmentend-Reiginited/refs/heads/main/Rebound%20Jumpscare"))()
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
 
entity:Run()
