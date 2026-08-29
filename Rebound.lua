if workspace:FindFirstChild("IsM") then
	return
else
if workspace:FindFirstChild("NightmareRebound") then
	getgenv().OgHungerNewSpawner = nil 

	function light(tim,color0,color1)
		local tweenservice = game:GetService("TweenService")
		local info = TweenInfo.new(tim,Enum.EasingStyle.Linear)
		for _ , light in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
			if light:IsA("Light") or light:IsA("SurfaceLight") or light:IsA("SpotLight") then
				local target = {Color = color1}
				local anim = tweenservice:Create(light,info,target)
				anim:Play()
			end
			if light:IsA("MeshPart") and light.Material == Enum.Material.Neon and light.Name ~= "Skybox" then
				local target1 = {Color = color0}
				local anim2 = tweenservice:Create(light,info,target1)
				anim2:Play()
			end
		end
	end

	local Reboundcolor = Instance.new("ColorCorrectionEffect",game.Lighting) 
	game.Debris:AddItem(Reboundcolor,24)
	Reboundcolor.Name = "Warn"
	Reboundcolor.TintColor = Color3.fromRGB(255, 0, 0) 
	Reboundcolor.Saturation = -0.7 
	Reboundcolor.Contrast = 0.2

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
	cue1.PlaybackSpeed = 0.85
	cue1:Play()

	local cue2 = Instance.new("Sound")
	cue2.Parent = game.Workspace
	cue2.Name = "Spawn"
	cue2.SoundId = "rbxassetid://9114221327"
	cue2.Volume = 6
	cue2.TimePosition = 0
	cue2.PlaybackSpeed = 1
	cue2.PlaybackSpeed = 0.85
	cue2:Play()

	local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
	local camara = game.Workspace.CurrentCamera
	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		camara.CFrame = camara.CFrame * shakeCf
	end)
	camShake:Start()
	camShake:ShakeOnce(20,6,0.1,6,2,0.5)
	task.wait(2.8)

	local success, Spawner = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/refs/heads/main/OgHungerNewSpawner"))()
	end)

	if not success or not Spawner then
		return
	end

	local entity = Spawner:Create({
		Entity = {
			Name = "NightMare Rebound",
			Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_Rebound_1787965761.rbxm",
			HeightOffset = -1
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
			Values = {3, 30, 0.1, 1}
		},

		Movement = {
			Speed = 90,
			SpeedFast = 270,                  
			MoveFastNotEnter = false,            
			Delay = 3,
			Reversed = true,                  
			EndWhenEnterLatestRoom = false,   
			EndDelay = 0,

			ReboundMoving = false,          
			TweenSecond = 1.5,   

			ReboundMoveStyle = true,      
			ReboundStyleTimes = 5,        
			ReboundStyleSound = "rbxassetid://123981238948", 
			ReboundStyleVolume = 5,
			ReboundStyleDelay = 2, 

			FasterAndFaster = 1.2,

			Fakeout = {
				Enabled = false,
				RandomFakeout = true,
				EndSound = "rbxassetid://130994177179386",
				EndDelay = 1,
				SpeedMultiplier = 1 
			},

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
			KillOnMove = false,            
			Range = 40,
			Cooldown = 0.2,
			Amount = 10,
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
			Hints = {"You Die to NightMare Rebound", "When the light turn to blue and A Scream", "is when he spawn", "he Is Very Dangerous because he can appear again."},
			Cause = "NightMare Rebound"
		}
	})

	-- \\ Callbacks // --

	entity:SetCallback("OnSpawned", function()
		light(2, Color3.fromRGB(85, 0, 0),Color3.fromRGB(255, 0, 0))
	end)

	entity:SetCallback("OnStartMoving", function()

	end)

	entity:SetCallback("OnReachNode", function(node: BasePart)

	end)

	entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)

	end)

	entity:SetCallback("OnNotReachedLatestRoom", function(room: Model, latestRoom: Model)

	end)

	entity:SetCallback("OnReachedLatestRoom", function(room: Model)

	end)

	entity:SetCallback("OnLeftLatestRoom", function(room: Model)

	end)

	entity:SetCallback("OnLookAt", function(lineOfSight: boolean)

	end)

	entity:SetCallback("OnRebounding", function(startOfRebound: boolean)

	end)

	entity:SetCallback("OnReboundStyle", function(newCloneEntity: any)
		task.spawn(function()
			local player = game.Players.LocalPlayer
			if player and player:FindFirstChild("PlayerGui") then
				wait(0.25)
				local flashGui = Instance.new("ScreenGui")
				flashGui.Name = "ReboundDoorFlash"
				flashGui.IgnoreGuiInset = true
				flashGui.DisplayOrder = 999998
				flashGui.Parent = player.PlayerGui

				local flashFrame = Instance.new("Frame")
				flashFrame.Size = UDim2.new(1, 0, 1, 0)
				flashFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0) 
				flashFrame.BackgroundTransparency = 0 
				flashFrame.BorderSizePixel = 0
				flashFrame.Parent = flashGui

				local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
				local fadeTween = game:GetService("TweenService"):Create(flashFrame, tweenInfo, {BackgroundTransparency = 1})
				fadeTween:Play()

				fadeTween.Completed:Wait()
				flashGui:Destroy()
			end
		end)

	end)

	entity:SetCallback("OnFakeoutStart", function()

	end)

	entity:SetCallback("OnFakeoutEnd", function()

	end)

	entity:SetCallback("PlayerGetSee", function()

	end)

	entity:SetCallback("EndWhenGO", function()

	end)

	entity:SetCallback("OnDespawning", function()

	end)

	entity:SetCallback("OnDespawned", function()

	end)

	entity:SetCallback("OnDamagePlayer", function(newHealth: number)
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")

		local entityModel = workspace:FindFirstChild("NightMare Rebound")
		local entityRoot = entityModel and (entityModel:FindFirstChild("HumanoidRootPart") or entityModel:FindFirstChildWhichIsA("BasePart")) 

		if entityRoot then
			local freezeConnection
			local doorFreezePos = entityRoot.CFrame

			freezeConnection = RunService.Heartbeat:Connect(function()
				if entityModel and entityModel.Parent and entityRoot then
					entityRoot.Anchored = true
					entityRoot.CFrame = doorFreezePos
					entityRoot.AssemblyLinearVelocity = Vector3.zero
					entityRoot.AssemblyAngularVelocity = Vector3.zero
				end
			end)

			local function GetGitSound(GithubSnd, SoundName)
				local url = GithubSnd
				if not isfile(SoundName .. ".mp3") then
					writefile(SoundName .. ".mp3", game:HttpGet(url))
				end
				local sound = Instance.new("Sound")
				sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
				return sound
			end
			local Jumpscare = GetGitSound("https://github.com/eoyoustme/Impossible/blob/main/rebound%20jumpscare.mp3?raw=true","Mc")
			Jumpscare.Parent = workspace
			Jumpscare.Volume = 10
			Jumpscare.PlaybackSpeed = 1
			Jumpscare:Play()

			local Players = game:GetService("Players")
			local TweenService = game:GetService("TweenService")

			local player = Players.LocalPlayer
			local playerGui = player:WaitForChild("PlayerGui")

			task.spawn(function()
				local screenGui = Instance.new("ScreenGui")
				screenGui.Name = "JumpscareOverlay"
				screenGui.IgnoreGuiInset = true
				screenGui.DisplayOrder = 999999
				screenGui.Parent = playerGui

				local imageLabel = Instance.new("ImageLabel")
				imageLabel.BackgroundTransparency = 1
				imageLabel.BorderSizePixel = 0
				imageLabel.Position = UDim2.new(0, 0, 0, 0)
				imageLabel.Size = UDim2.new(1, 0, 1, 0)
				imageLabel.ScaleType = Enum.ScaleType.Stretch
				imageLabel.ImageTransparency = 0.25 
				imageLabel.Visible = true
				imageLabel.Parent = screenGui
				imageLabel.ImageColor3 = Color3.fromRGB(255, 0, 0)

				local jumpscareImages = {
					"rbxassetid://134346506410955",
					"rbxassetid://7578853379",
					"rbxassetid://103846711769666",
					"rbxassetid://78199392475572"
				}

				local duration = 0.3
				local start = os.clock()
				local imageIndex = 1

				local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				local tween = TweenService:Create(imageLabel, info, {ImageTransparency = 1})

				tween:Play()

				while os.clock() - start < duration do
					imageLabel.Image = jumpscareImages[imageIndex]
					imageIndex = (imageIndex % #jumpscareImages) + 1
					task.wait(0.03) 
				end

				wait(0.2)
				Jumpscare:Stop()

				if freezeConnection then
					freezeConnection:Disconnect()
				end

				screenGui:Destroy()
			end)
		end
	end)

	entity:SetCallback("OnKillPlayer", function()

	end)

	---====== Run Entity ======---

	entity:Run(true)
else
	getgenv().OgHungerNewSpawner = nil 

	function light(tim,color0,color1)
		local tweenservice = game:GetService("TweenService")
		local info = TweenInfo.new(tim,Enum.EasingStyle.Linear)
		for _ , light in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
			if light:IsA("Light") or light:IsA("SurfaceLight") or light:IsA("SpotLight") then
				local target = {Color = color1}
				local anim = tweenservice:Create(light,info,target)
				anim:Play()
			end
			if light:IsA("MeshPart") and light.Material == Enum.Material.Neon and light.Name ~= "Skybox" then
				local target1 = {Color = color0}
				local anim2 = tweenservice:Create(light,info,target1)
				anim2:Play()
			end
		end
	end

	local Reboundcolor = Instance.new("ColorCorrectionEffect",game.Lighting) 
	game.Debris:AddItem(Reboundcolor,24)
	Reboundcolor.Name = "Warn"
	Reboundcolor.TintColor = Color3.fromRGB(65, 138, 255) 
	Reboundcolor.Saturation = -0.7 
	Reboundcolor.Contrast = 0.2

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
	cue2.Volume = 6
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
	task.wait(2.8)

	local success, Spawner = pcall(function()
		return loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Mayhem-Remake/refs/heads/main/OgHungerNewSpawner"))()
	end)

	if not success or not Spawner then
		return
	end

	local entity = Spawner:Create({
		Entity = {
			Name = "Rebound",
			Asset = "https://github.com/eoyoustme/Hardcore/blob/main/Rebound1.rbxm?raw=true",
			HeightOffset = -1
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
			Values = {3, 30, 0.1, 1}
		},

		Movement = {
			Speed = 35,
			SpeedFast = 270,                  
			MoveFastNotEnter = false,            
			Delay = 3,
			Reversed = true,                  
			EndWhenEnterLatestRoom = false,   
			EndDelay = 0,

			ReboundMoving = false,          
			TweenSecond = 1.5,   

			ReboundMoveStyle = true,      
			ReboundStyleTimes = 5,        
			ReboundStyleSound = "rbxassetid://123981238948", 
			ReboundStyleVolume = 5,
			ReboundStyleDelay = 2, 

			FasterAndFaster = 1.2,

			Fakeout = {
				Enabled = false,
				RandomFakeout = true,
				EndSound = "rbxassetid://130994177179386",
				EndDelay = 1,
				SpeedMultiplier = 1 
			},

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
			KillOnMove = false,            
			Range = 40,
			Cooldown = 0.2,
			Amount = 10,
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
			Hints = {"You Die to Rebound", "When the light turn to blue and A Scream", "is when he spawn", "he Is Very Dangerous because he can appear again."},
			Cause = "Rebound"
		}
	})

	-- \\ Callbacks // --
	
	task.spawn(function()
		local originalSoundSpeeds = {}
		local originalParticleScales = {}

		local ceasePauseThread = nil
		local ceaseResumeThread = nil
		local isCeased = false

		local function cacheEntityProperties()
			if not entity or not entity.Model then return end

			local targets = entity.Model:GetDescendants()
			if entity.Model:IsA("Sound") or entity.Model:IsA("ParticleEmitter") then
				table.insert(targets, entity.Model)
			end

			for _, obj in ipairs(targets) do
				if obj:IsA("Sound") and originalSoundSpeeds[obj] == nil then
					originalSoundSpeeds[obj] = obj.PlaybackSpeed
				elseif obj:IsA("ParticleEmitter") and originalParticleScales[obj] == nil then
					originalParticleScales[obj] = obj.TimeScale
				end
			end
		end

		local function setCeaseState(newState)
			if newState == isCeased then return end
			isCeased = newState
			cacheEntityProperties()

			if ceasePauseThread then task.cancel(ceasePauseThread); ceasePauseThread = nil end
			if ceaseResumeThread then task.cancel(ceaseResumeThread); ceaseResumeThread = nil end

			if isCeased then

				if entity and typeof(entity.Pause) == "function" then
					entity:Pause()
				end

	
				local ceaseTweenInfo = TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

				for sound in pairs(originalSoundSpeeds) do
					if sound and sound.Parent then
						TweenService:Create(sound, ceaseTweenInfo, {PlaybackSpeed = 0}):Play()
					end
				end

				for particle in pairs(originalParticleScales) do
					if particle and particle.Parent then
						TweenService:Create(particle, ceaseTweenInfo, {TimeScale = 0}):Play()
					end
				end
			else
		
				local unceaseTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

				for sound, origSpeed in pairs(originalSoundSpeeds) do
					if sound and sound.Parent then
						TweenService:Create(sound, unceaseTweenInfo, {PlaybackSpeed = origSpeed}):Play()
					end
				end

				for particle, origScale in pairs(originalParticleScales) do
					if particle and particle.Parent then
						TweenService:Create(particle, unceaseTweenInfo, {TimeScale = origScale}):Play()
					end
				end

		
				ceaseResumeThread = task.delay(2, function()
					if not isCeased and entity and typeof(entity.Resume) == "function" then
						entity:Resume()
					end
				end)
			end
		end

		workspace.ChildAdded:Connect(function(child)
			if child.Name == "CeaseMoving" then
				setCeaseState(true)
			else
				local nameConn
				nameConn = child:GetPropertyChangedSignal("Name"):Connect(function()
					if child.Name == "CeaseMoving" then
						setCeaseState(true)
						nameConn:Disconnect()
					end
				end)
			end
		end)

		workspace.ChildRemoved:Connect(function(child)
			if child.Name == "CeaseMoving" then
				task.defer(function()
					if not workspace:FindFirstChild("CeaseMoving") then
						setCeaseState(false)
					end
				end)
			end
		end)

		if workspace:FindFirstChild("CeaseMoving") then
			setCeaseState(true)
		end
	end)

	entity:SetCallback("OnSpawned", function()
		light(2, Color3.fromRGB(127, 249, 255),Color3.fromRGB(65, 138, 255))
	end)

	entity:SetCallback("OnStartMoving", function()

	end)

	entity:SetCallback("OnReachNode", function(node: BasePart)

	end)

	entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)

	end)

	entity:SetCallback("OnNotReachedLatestRoom", function(room: Model, latestRoom: Model)

	end)

	entity:SetCallback("OnReachedLatestRoom", function(room: Model)

	end)

	entity:SetCallback("OnLeftLatestRoom", function(room: Model)

	end)

	entity:SetCallback("OnLookAt", function(lineOfSight: boolean)

	end)

	entity:SetCallback("OnRebounding", function(startOfRebound: boolean)

	end)

	entity:SetCallback("OnReboundStyle", function(newCloneEntity: any)
		task.spawn(function()
			local originalSoundSpeeds = {}
			local originalParticleScales = {}

			local ceasePauseThread = nil
			local ceaseResumeThread = nil
			local isCeased = false

			local function cacheEntityProperties()
				if not entity or not entity.Model then return end

				local targets = entity.Model:GetDescendants()
				if entity.Model:IsA("Sound") or entity.Model:IsA("ParticleEmitter") then
					table.insert(targets, entity.Model)
				end

				for _, obj in ipairs(targets) do
					if obj:IsA("Sound") and originalSoundSpeeds[obj] == nil then
						originalSoundSpeeds[obj] = obj.PlaybackSpeed
					elseif obj:IsA("ParticleEmitter") and originalParticleScales[obj] == nil then
						originalParticleScales[obj] = obj.TimeScale
					end
				end
			end

			local function setCeaseState(newState)
				if newState == isCeased then return end
				isCeased = newState
				cacheEntityProperties()

				if ceasePauseThread then task.cancel(ceasePauseThread); ceasePauseThread = nil end
				if ceaseResumeThread then task.cancel(ceaseResumeThread); ceaseResumeThread = nil end

				if isCeased then

					if entity and typeof(entity.Pause) == "function" then
						entity:Pause()
					end


					local ceaseTweenInfo = TweenInfo.new(0.65, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

					for sound in pairs(originalSoundSpeeds) do
						if sound and sound.Parent then
							TweenService:Create(sound, ceaseTweenInfo, {PlaybackSpeed = 0}):Play()
						end
					end

					for particle in pairs(originalParticleScales) do
						if particle and particle.Parent then
							TweenService:Create(particle, ceaseTweenInfo, {TimeScale = 0}):Play()
						end
					end
				else

					local unceaseTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

					for sound, origSpeed in pairs(originalSoundSpeeds) do
						if sound and sound.Parent then
							TweenService:Create(sound, unceaseTweenInfo, {PlaybackSpeed = origSpeed}):Play()
						end
					end

					for particle, origScale in pairs(originalParticleScales) do
						if particle and particle.Parent then
							TweenService:Create(particle, unceaseTweenInfo, {TimeScale = origScale}):Play()
						end
					end


					ceaseResumeThread = task.delay(2, function()
						if not isCeased and entity and typeof(entity.Resume) == "function" then
							entity:Resume()
						end
					end)
				end
			end

			workspace.ChildAdded:Connect(function(child)
				if child.Name == "CeaseMoving" then
					setCeaseState(true)
				else
					local nameConn
					nameConn = child:GetPropertyChangedSignal("Name"):Connect(function()
						if child.Name == "CeaseMoving" then
							setCeaseState(true)
							nameConn:Disconnect()
						end
					end)
				end
			end)

			workspace.ChildRemoved:Connect(function(child)
				if child.Name == "CeaseMoving" then
					task.defer(function()
						if not workspace:FindFirstChild("CeaseMoving") then
							setCeaseState(false)
						end
					end)
				end
			end)

			if workspace:FindFirstChild("CeaseMoving") then
				setCeaseState(true)
			end
		end)

		task.spawn(function()
			local player = game.Players.LocalPlayer
			if player and player:FindFirstChild("PlayerGui") then
				wait(0.25)
				local flashGui = Instance.new("ScreenGui")
				flashGui.Name = "ReboundDoorFlash"
				flashGui.IgnoreGuiInset = true
				flashGui.DisplayOrder = 999998
				flashGui.Parent = player.PlayerGui

				local flashFrame = Instance.new("Frame")
				flashFrame.Size = UDim2.new(1, 0, 1, 0)
				flashFrame.BackgroundColor3 = Color3.fromRGB(0, 102, 255) 
				flashFrame.BackgroundTransparency = 0 
				flashFrame.BorderSizePixel = 0
				flashFrame.Parent = flashGui

				local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
				local fadeTween = game:GetService("TweenService"):Create(flashFrame, tweenInfo, {BackgroundTransparency = 1})
				fadeTween:Play()

				fadeTween.Completed:Wait()
				flashGui:Destroy()
			end
		end)
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

	end)

	entity:SetCallback("OnFakeoutStart", function()

	end)

	entity:SetCallback("OnFakeoutEnd", function()

	end)

	entity:SetCallback("PlayerGetSee", function()

	end)

	entity:SetCallback("EndWhenGO", function()

	end)

	entity:SetCallback("OnDespawning", function()
		entity.Movement.Speed = 35

	end)

	entity:SetCallback("OnDespawned", function()

	end)

	entity:SetCallback("OnDamagePlayer", function(newHealth: number)
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")

		local entityModel = workspace:FindFirstChild("Rebound")
		local entityRoot = entityModel and (entityModel:FindFirstChild("HumanoidRootPart") or entityModel:FindFirstChildWhichIsA("BasePart")) 

		if entityRoot then
			local freezeConnection
			local doorFreezePos = entityRoot.CFrame

			freezeConnection = RunService.Heartbeat:Connect(function()
				if entityModel and entityModel.Parent and entityRoot then
					entityRoot.Anchored = true
					entityRoot.CFrame = doorFreezePos
					entityRoot.AssemblyLinearVelocity = Vector3.zero
					entityRoot.AssemblyAngularVelocity = Vector3.zero
				end
			end)

			local function GetGitSound(GithubSnd, SoundName)
				local url = GithubSnd
				if not isfile(SoundName .. ".mp3") then
					writefile(SoundName .. ".mp3", game:HttpGet(url))
				end
				local sound = Instance.new("Sound")
				sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
				return sound
			end
			local Jumpscare = GetGitSound("https://github.com/eoyoustme/Impossible/blob/main/rebound%20jumpscare.mp3?raw=true","Mc")
			Jumpscare.Parent = workspace
			Jumpscare.Volume = 10
			Jumpscare.PlaybackSpeed = 1
			Jumpscare:Play()

			local Players = game:GetService("Players")
			local TweenService = game:GetService("TweenService")

			local player = Players.LocalPlayer
			local playerGui = player:WaitForChild("PlayerGui")

			task.spawn(function()
				local screenGui = Instance.new("ScreenGui")
				screenGui.Name = "JumpscareOverlay"
				screenGui.IgnoreGuiInset = true
				screenGui.DisplayOrder = 999999
				screenGui.Parent = playerGui

				local imageLabel = Instance.new("ImageLabel")
				imageLabel.BackgroundTransparency = 1
				imageLabel.BorderSizePixel = 0
				imageLabel.Position = UDim2.new(0, 0, 0, 0)
				imageLabel.Size = UDim2.new(1, 0, 1, 0)
				imageLabel.ScaleType = Enum.ScaleType.Stretch
				imageLabel.ImageTransparency = 0.25 
				imageLabel.Visible = true
				imageLabel.Parent = screenGui
				imageLabel.ImageColor3 = Color3.fromRGB(85, 170, 255)

				local jumpscareImages = {
					"rbxassetid://134346506410955",
					"rbxassetid://7578853379",
					"rbxassetid://103846711769666",
					"rbxassetid://78199392475572"
				}

				local duration = 0.3
				local start = os.clock()
				local imageIndex = 1

				local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
				local tween = TweenService:Create(imageLabel, info, {ImageTransparency = 1})

				tween:Play()

				while os.clock() - start < duration do
					imageLabel.Image = jumpscareImages[imageIndex]
					imageIndex = (imageIndex % #jumpscareImages) + 1
					task.wait(0.03) 
				end

				wait(0.2)
				Jumpscare:Stop()

				if freezeConnection then
					freezeConnection:Disconnect()
				end

				screenGui:Destroy()
			end)
		end
	end)

	entity:SetCallback("OnKillPlayer", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Hardcore/refs/heads/main/Rebound%20Jumpscare"))()

	end)

	---====== Run Entity ======---

	entity:Run(true)
end
end
