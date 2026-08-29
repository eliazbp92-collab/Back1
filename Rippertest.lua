if workspace:FindFirstChild("IsM") then
	return
else
if workspace:FindFirstChild("RipperPrime") then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Extremely/refs/heads/main/Prime%20Ripper"))()
else
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local localPlayer = Players.LocalPlayer

	function light(tim,color0,color1)
		local tweenservice = game:GetService("TweenService")
		local info = TweenInfo.new(tim,Enum.EasingStyle.Linear)
		for _ , light in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
			if light:IsA("Light") or light:IsA("SurfaceLight") or light:IsA("SpotLight") then
				local target = {Color = color1}
				local anim = tweenservice:Create(light,info,target)
				anim:Play()
			end
			if light:IsA("MeshPart") and light.Material == Enum.Material.Neon  and light.Name ~= "Skybox" then
				local target1 = {Color = color0}
				local anim2 = tweenservice:Create(light,info,target1)
				anim2:Play()
			end
		end
	end


	light(2,Color3.fromRGB(85, 0, 0),Color3.fromRGB(255, 0, 0))
	task.spawn(function()
		pcall(function()
			local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
			local camera = game.Workspace.CurrentCamera
			local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
				camera.CFrame = camera.CFrame * shakeCf
			end)
			camShake:Start()
			camShake:ShakeOnce(20, 3, 0.1, 6)
		end)

		local sound5 = Instance.new("Sound")
		sound5.PlaybackSpeed = 0.6
		sound5.Volume = 10
		sound5.SoundId = "rbxassetid://9125713501"
		sound5.Parent = workspace
		sound5:Play()

		local pitch = Instance.new("PitchShiftSoundEffect")
		pitch.Octave = 0.875
		pitch.Parent = sound5

		local sound51 = Instance.new("Sound")
		sound51.PlaybackSpeed = 1
		sound51.Volume = 10
		sound51.SoundId = "rbxassetid://1318185544"
		sound51.Parent = workspace
		sound51:Play()

		local pitch2 = Instance.new("PitchShiftSoundEffect")
		pitch2.Octave = 0.8
		pitch2.Parent = sound51

		local pitch23 = Instance.new("PitchShiftSoundEffect")
		pitch23.Octave = 0.5
		pitch23.Parent = sound51

		local eq = Instance.new("EqualizerSoundEffect")
		eq.LowGain = -20
		eq.MidGain = -10
		eq.Parent = sound51
		wait(6.771)
		sound5:Destroy()
		sound51:Destroy()
	end)

	local Reboundcolor = Instance.new("ColorCorrectionEffect",game.Lighting) game.Debris:AddItem(Reboundcolor,24)
	Reboundcolor.Name = "Warn"
	Reboundcolor.TintColor = Color3.fromRGB(255, 0, 0) Reboundcolor.Saturation = 0 Reboundcolor.Contrast = 0.2
	game.TweenService:Create(Reboundcolor,TweenInfo.new(15),{TintColor = Color3.fromRGB(255, 255, 255),Saturation = 0, Contrast = 0}):Play()
	local TweenService = game:GetService("TweenService")
	local TW = TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(7),{TintColor = Color3.fromRGB(255, 255, 255)})
	TW:Play()

	wait(6.771)

	---====== Load spawner ======---

	local Spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Extremely/refs/heads/main/Ripper%20Spawner"))()

	---====== Create entity ======---

	local entity = Spawner:Create({
		Entity = {
			Name = "RipperNotMoving",
			Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_RipperMoving_1787960625.rbxm",
			HeightOffset = 4
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
			Values = {10, 27, 0.1, 0.4} -- Magnitude, Roughness, FadeIn, FadeOut
		},
		Movement = {
			Speed = 175,
			Delay = 0,
			Reversed = false
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
			Range = 0,
			Amount = 0.01
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
			Cause = "Ripper"
		}
	})

	---====== Debug entity ======---
	local isCeased = false
	

	entity:SetCallback("OnSpawned", function()
		print("Entity has spawned")
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

					ceasePauseThread = task.delay(0.65, function()
						if isCeased and entity and typeof(entity.Pause) == "function" then
							entity:Pause()
						end
					end)
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
				end
			end)

			-- 2. Bắt sự kiện khi CeaseMoving bị xóa khỏi Workspace
			workspace.ChildRemoved:Connect(function(child)
				if child.Name == "CeaseMoving" and not workspace:FindFirstChild("CeaseMoving") then
					setCeaseState(false)
				end
			end)

			if workspace:FindFirstChild("CeaseMoving") then
				setCeaseState(true)
			end
		end)
		
	end)

	entity:SetCallback("OnStartMoving", function()
		print("Entity has started moving")
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

	local TweenService = game:GetService("TweenService")
	local Players = game:GetService("Players")
	local workspace = game:GetService("Workspace")
	local RunService = game:GetService("RunService")
	local UserInputService = game:GetService("UserInputService")

	entity:SetCallback("OnDamagePlayer", function(newHealth)
		if newHealth == 0 then
			print("Entity has killed the player")
		else
			print("Entity has damaged the player")

			if not game.Players.LocalPlayer.Character:GetAttribute("Hiding") then
				task.spawn(function()
					local player = Players.LocalPlayer
					local character = player.Character or player.CharacterAdded:Wait()
					local humanoid = character:WaitForChild("Humanoid", 5)
					local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
					local camera = workspace.CurrentCamera

					local entityModel = workspace:WaitForChild("RipperNotMoving")
					local primaryPart = entityModel:FindFirstChild("Ripe")

					if not (entityModel and humanoid and humanoidRootPart and primaryPart and camera) then return end

					-- ?? Khóa di chuy?n
					local originalWalkSpeed = humanoid.WalkSpeed
					local originalJumpPower = humanoid.JumpPower
					humanoid.WalkSpeed = 0
					humanoid.JumpPower = 0

					-- ?? Khóa di?u khi?n chu?t (camera)
					local controlsModule = require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")):GetControls()
					controlsModule:Disable()

					local function SetAllParticlesTimeScale(model, timescale)
						for _, descendant in ipairs(model:GetDescendants()) do
							if descendant:IsA("ParticleEmitter") then
								descendant.TimeScale = timescale
								print("Set TimeScale = "..timescale.." cho ParticleEmitter:", descendant.Name)
							end
						end
					end


					-- Tắt tất cả particle trên entity lúc jumpscare bắt đầu
					SetAllParticlesTimeScale(entityModel, 1)


					local to = true
					task.spawn(function()
						while to and primaryPart.Parent and humanoidRootPart.Parent do
							local targetCFrame = humanoidRootPart.CFrame
							local tween = TweenService:Create(primaryPart, TweenInfo.new(2000000000000, Enum.EasingStyle.Quad), {CFrame = targetCFrame})
							tween:Play()
							tween.Completed:Wait()
						end
					end)

					local ripeAttachment = primaryPart:FindFirstChild("Attachment", true)
					if ripeAttachment then
						local emitter = ripeAttachment:FindFirstChild("Face1")
						if emitter then
							emitter.Texture = "rbxassetid://12737595583"
							emitter.Size = NumberSequence.new(10)
							emitter.Squash = NumberSequence.new(0)
							emitter.Enabled = true
							emitter:Emit(20)
							task.wait(0.1)
							emitter.TimeScale = 0
						end
					end


					camera.CameraType = Enum.CameraType.Scriptable

					local lockConnection
					lockConnection = RunService.RenderStepped:Connect(function()
						if not primaryPart or not primaryPart.Parent then
							if lockConnection then lockConnection:Disconnect() end
							return
						end
						camera.CFrame = CFrame.lookAt(camera.CFrame.Position, primaryPart.Position)
					end)

					wait(0.35)
					camera.CFrame = CFrame.lookAt(camera.CFrame.Position, primaryPart.Position)

					SetAllParticlesTimeScale(entityModel, 0)

					local function GetGitSound(GithubSnd, SoundName)
						local url = GithubSnd
						if not isfile(SoundName .. ".mp3") then
							writefile(SoundName .. ".mp3", game:HttpGet(url))
						end
						local sound = Instance.new("Sound")
						sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
						return sound
					end
					-- Lấy âm thanh từ GitHub
					local Jumpscare = GetGitSound("https://github.com/eoyoustme/back/raw/main/Kill_with_static.mp3","Kill")
					Jumpscare.Parent = workspace
					Jumpscare.Volume = 1
					Jumpscare.PlaybackSpeed = 1

					-- 🔇 TẮT TẤT CẢ ÂM THANH TRONG ENTITY MODEL VÀ PART
					for _, descendant in ipairs(entityModel:GetDescendants()) do
						if descendant:IsA("Sound") then
							descendant.Playing = false
							descendant.Volume = 0
						end
					end

					-- 🎧 Phát âm thanh jumpscare
					Jumpscare:Play()

					wait(1)

					-- ????? UI Jumpscare
					local TweenService = game:GetService("TweenService")

					local screenGui = Instance.new("ScreenGui")
					screenGui.Name = "JumpscareOverlay"
					screenGui.IgnoreGuiInset = true
					screenGui.DisplayOrder = 999999
					screenGui.Parent = player:WaitForChild("PlayerGui")

					local imageLabel = Instance.new("ImageLabel")
					imageLabel.BackgroundTransparency = 1
					imageLabel.BorderSizePixel = 0
					imageLabel.Position = UDim2.new(0, 0, 0, 0)
					imageLabel.Size = UDim2.new(1, 0, 1, 0)
					imageLabel.ScaleType = Enum.ScaleType.Stretch
					imageLabel.ImageTransparency = 1
					imageLabel.Visible = true
					imageLabel.Parent = screenGui

					local jumpscareImage1 = "rbxassetid://15813725670"		
					local jumpscareImage2 = "rbxassetid://15813727511"
					local jumpscareImage3 = "rbxassetid://15813727319"
					local jumpscareImage4 = "rbxassetid://15813727319"
					local jumpscareImage5 = "rbxassetid://15813726972"		
					local jumpscareImage6 = "rbxassetid://15813726866"
					local jumpscareImage7 = "rbxassetid://15813726700"
					local jumpscareImage8 = "rbxassetid://15813726584"
					local jumpscareImage9 = "rbxassetid://15813726463"		
					local jumpscareImage10 = "rbxassetid://15813726313"
					local jumpscareImage11 = "rbxassetid://15813726068"
					local jumpscareImage12 = "rbxassetid://15813725870"


					local flashDuration = 1.6

					----------------------------------------------------
					-- 1) FADE-IN (1 lần duy nhất, 1 → 0)
					----------------------------------------------------
					imageLabel.Image = jumpscareImage1 -- hình xuất hiện đầu tiên
					local tweenIn = TweenInfo.new(0.8, Enum.EasingStyle.Linear)
					TweenService:Create(imageLabel, tweenIn, {ImageTransparency = 0}):Play()

					----------------------------------------------------
					-- 2) FLASH (không tween)
					----------------------------------------------------
					local start = tick()

					while tick() - start < flashDuration do
						imageLabel.Image = jumpscareImage1
						task.wait()
						imageLabel.Image = jumpscareImage2
						task.wait()
						imageLabel.Image = jumpscareImage3
						task.wait()
						imageLabel.Image = jumpscareImage4
						task.wait()
						imageLabel.Image = jumpscareImage5
						task.wait()
						imageLabel.Image = jumpscareImage6
						task.wait()
						imageLabel.Image = jumpscareImage7
						task.wait()
						imageLabel.Image = jumpscareImage8
						task.wait()
						imageLabel.Image = jumpscareImage9
						task.wait()
						imageLabel.Image = jumpscareImage10
						task.wait()
						imageLabel.Image = jumpscareImage11
						task.wait()
						imageLabel.Image = jumpscareImage12
						task.wait()
					end

					----------------------------------------------------
					-- 3) KẾT THÚC (không fade-out, giữ nguyên)
					----------------------------------------------------
					imageLabel.ImageTransparency = 1
					task.wait(0)

					to = false

					-- ?? Gi?t ngu?i choi
					if humanoid then humanoid.Health = 0 end

					firesignal(ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {
						"You died to who you call Ripper",
						" A red light and an earthquake will begin announcing his presence. To survive run towards him"
					}, "Blue")

					ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Ripper"

					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://4988621968"
					sound.Volume = 10
					sound.PlaybackSpeed = 0.7
					sound.Parent = workspace
					sound:Play()

					-- ?? Cleanup
					if entityModel and entityModel.Parent then
						entityModel:Destroy()
					end

					if lockConnection then
						lockConnection:Disconnect()
					end

					camera.CameraType = Enum.CameraType.Custom

					if screenGui and screenGui.Parent then
						screenGui:Destroy()
					end

					-- ?? Khôi ph?c di?u khi?n (ch? n?u nhân v?t chua ch?t s?m)
					if humanoid and humanoid.Health > 0 then
						humanoid.WalkSpeed = originalWalkSpeed
						humanoid.JumpPower = originalJumpPower
						controlsModule:Enable()
					end
				end)
			end
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
end
end
