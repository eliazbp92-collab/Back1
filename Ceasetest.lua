if workspace:FindFirstChild("IsM") then
	return
else
	getgenv().OgHungerNewSpawner = nil 

	local tw

	local success, Spawner = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/refs/heads/main/OgHungerNewSpawner"))()
	end)

	if not success or not Spawner then
		return
	end

	local entity = Spawner:Create({
		Entity = {
			Name = "CeaseMoving",
			Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_CeaseMoving_1787957919.rbxm",
			HeightOffset = -2
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
		Spawned = {
			ChangeColorWhenSpawn = false, 
			Rainbow = false,              
			Color = Color3.fromRGB(0, 85, 255)
		},
		CameraShake = {
			Enabled = true,
			Range = 100,
			Values = {1.5, 20, 0.1, 1}
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

		Jumpscare = {
			Enabled = false,
			Image1 = "rbxassetid://11253398403", 
			Image2 = "rbxassetid://12293509957",
			Sound1 = "rbxassetid://0", 
			Sound2 = "rbxassetid://109582246349306", 
			Tease = {
				[1] = true,
				Min = 1,
				Max = 1
			},
			Flashing = {
				[1] = true,
				[2] = Color3.fromRGB(255, 255, 255)
			},
			Shake = true
		},
		Rebounding = {
			Enabled = false,
			Type = "Ambush",
			Min = 1,
			Max = 1,
			Delay = 2
		},
		Damage = {
			Enabled = true,
			KillOnMove = true,            
			Range = 40,
			Amount = 125,
			IgnoreHiding = false,

			JumpscareRipper = {
				Enabled = false,
				TargetPartName = "Ripe",
				AttachmentName = "ripe",
				ParticleName = "ParticleEmitter",
				ParticleTexture = "rbxassetid://12737595583",
				SoundUrl = "https://github.com/eoyoustme/back/raw/main/Kill_with_static.mp3",
				SlamSoundId = "rbxassetid://0",
				EndSoundId = "rbxassetid://4988621968",
				Images = {
					"rbxassetid://8482795900",
					"rbxassetid://236542974",
					"rbxassetid://184251462",
					"rbxassetid://236777652"
				},
				FlashDuration = 1.6
			}
		},
		Crucifixion = {
			Enabled = true,
			Range = 40,
			Resist = false,
			Break = true
		},
		Death = {
			Type = "Guiding",
			Hints = {"You Die to Cease", "When the light turn to blue and a flicker light sound appear", "is when he spawn", "Don't Move And Don't stand too near him"},
			Cause = "Cease"
		}
	})

	entity:SetCallback("OnSpawned", function()
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

	entity:SetCallback("OnStartMoving", function()
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

		local gitSoundTemp = GetGitSound("https://github.com/eoyoustme/Pressure-Skid-Gay-/blob/main/cease%20wind.mp3?raw=true", "1111111111111")

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

	end)

	entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)

	end)

	entity:SetCallback("OnNotReachedLatestRoom", function(room: Model, latestRoom: Model)
	end)

	entity:SetCallback("OnReachedLatestRoom", function(room: Model)
		tw:Destroy()
		local hsur = entity.Model:FindFirstChild("HSUR")
		local blueSound = hsur and hsur:FindFirstChild("WindStatic")
		local stoppingSound = entity.Model:FindFirstChild("CeaseStopping")
		stoppingSound:Play()
		blueSound:Stop()
	end)

	entity:SetCallback("OnLeftLatestRoom", function(room: Model)
		local hsur = entity.Model:FindFirstChild("HSUR")
		local blueSound = hsur and hsur:FindFirstChild("WindStatic")
		local stoppingSound = entity.Model:FindFirstChild("CeaseStopping")
		blueSound:Play()

		local TweenService = game:GetService("TweenService")

		local tweenInfo = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		local tw5 = TweenService:Create(blueSound, tweenInfo, {
			PlaybackSpeed = 0.1
		})
		tw5:Play()

	end)

	entity:SetCallback("OnLookAt", function(lineOfSight: boolean)

	end)

	entity:SetCallback("OnRebounding", function(startOfRebound: boolean)

	end)

	entity:SetCallback("PlayerGetSee", function()

	end)

	entity:SetCallback("EndWhenGO", function()

	end)

	entity:SetCallback("OnDespawning", function()
		local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

		achievementGiver({
			Title = "I don't want a Noise",
			Desc = "CeaseStopping",
			Reason = "Survive Cease",
			Image = "rbxassetid://104367200417966"
		})
	end)

	entity:SetCallback("OnDespawned", function()

	end)

	entity:SetCallback("OnDamagePlayer", function(newHealth: number)
		entity.Model.HSUR.Kill:Play()

	end)

	---====== Run Entity ======---

	entity:Run(true)
