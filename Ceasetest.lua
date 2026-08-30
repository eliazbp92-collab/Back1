---====== Load spawner ======---
local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---
local entity = spawner.Create({
	Entity = {
		Name = "Cease",
		Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_CeaseMoving_1787957919.rbxm",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 7
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
		Values = {3, 3, 2, 2}
	},
	Movement = {
			Speed = 70,
			SpeedFast = 270,                  
			MoveFastNotEnter = true,            
			Delay = 5,
			Reversed = false,                  
			EndWhenEnterLatestRoom = false,   
			EndDelay = 0,

			ReboundMoving = false,          
			TweenSecond = 1.5,            

			ReboundMoveStyle = false,      
			ReboundStyleTimes = 5,        
			ReboundStyleSound = "rbxassetid://9114221327", 
			ReboundStyleVolume = 5,
			ReboundStyleDelay = 2, 

			ChasePlayerWhenSee = false,
			SpeedWhenChase = 35
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush",
		Min = 2,
		Max = 2,
		Delay = 0
	},
	Damage = {
			Enabled = true,
			KillOnMove = true,            
			Range = 40,
			Amount = 125,
			IgnoreHiding = false,
	},
	Crucifixion = {
		Enabled = true,
		Range = 40,
		Resist = false,
		Break = true
	},
	Death = {
		Type = "Guiding",
		Hints = {
			"Bạn đã chết bởi Cease.",
			"Khi Cease xuất hiện, đừng di chuyển nếu không bạn sẽ chết."
		},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Cease đã xuất hiện")
		local function GetGitSound(GithubSnd, SoundName)
			local url = GithubSnd
			if not isfile(SoundName .. ".mp3") then
				writefile(SoundName .. ".mp3", game:HttpGet(url))
			end
			local sound = Instance.new("Sound")
			sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
			return sound
		end

		local blueSound = entity.Model.HSUR.WindStatic

		local gitSoundTemp = GetGitSound("https://github.com/eliazbp92-collab/Back1/raw/main/Ceasespawn.mp3", "1")

		blueSound.SoundId = gitSoundTemp.SoundId

		blueSound.Volume = 4

		gitSoundTemp:Destroy()

		blueSound:Play()

		local TweenService = game:GetService("TweenService")

		local tweenInfo = TweenInfo.new(10, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		tw = TweenService:Create(blueSound, tweenInfo, {
			PlaybackSpeed = 2
		})
		tw:Play()
		
		local hiding = game.Players.LocalPlayer.Character
		local ishiding = hiding:GetAttributes("Hiding")
		local function light(tim, color0, color1)
			local Tweenservice = game:GetService("TweenService")
			local info = TweenInfo.new(tim, Enum.EasingStyle.Linear)
			local currentRooms = workspace.CurrentRooms
			if not currentRooms then return end

			for _, instance in ipairs(currentRooms:GetDescendants()) do
				if instance:IsA("Light") or instance:IsA("SurfaceLight") or instance:IsA("SpotLight") then
					Tweenservice:Create(instance, info, {Color = color1}):Play()
				elseif instance:IsA("MeshPart") and instance.Material == Enum.Material.Neon and instance.Name ~= "Skybox" then
					Tweenservice:Create(instance, info, {Color = color0}):Play()
				end
			end
		end
		light(2, Color3.fromRGB(127, 249, 255), Color3.fromRGB(0, 45, 185))

		task.spawn(function()
			while true do
				task.wait(0.3)

				local player = game.Players.LocalPlayer
				local char = player.Character
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local hrp = char and char:FindFirstChild("HumanoidRootPart")

				if hum and hrp and (hrp.Position - entity.Model.HSUR.Position).Magnitude <= 6 then
					game.Players.LocalPlayer.Character.Humanoid.Health -= 1500
					entity.Model.HSUR.Kill:Play()
					game:GetService("ReplicatedStorage").GameStats["Player_".. game.Players.LocalPlayer.Name].Total.DeathCause.Value = "Cease"
				end
			end
		end)
	end)

    -- Ngắt vòng lặp khi Cease despawn
    entity:SetCallback("OnDespawned", function()
        print("Cease đã biến mất")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Cease đã giết người chơi")
	else
		print("Cease gây sát thương cho người chơi")
	end
end)

---====== Run entity ======---
entity:Run()
