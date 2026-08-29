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
				Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_RipperMoving_1787960625.rbxm" -- Magnitude, Roughness, FadeIn, FadeOut
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
				Range = 40,
				Amount = 0.001
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
			task.spawn(function()

				local function GetGitSound(GithubSnd, SoundName)
					local url = GithubSnd
					if not isfile(SoundName .. ".mp3") then
						writefile(SoundName .. ".mp3", game:HttpGet(url))
					end
					local sound = Instance.new("Sound")
					sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
					return sound
				end

				local blueSound = game.Workspace.RipperNotMoving.Ripe.FarStatic

				local gitSoundTemp = GetGitSound("https://github.com/eoyoustme/Hardcore/blob/main/ripper%20static%20final.mp3?raw=true", "Ripper")

				blueSound.SoundId = gitSoundTemp.SoundId
				blueSound.PlaybackSpeed = 0.37
				blueSound.Looped = true
				blueSound.TimePosition = 8.868
				blueSound.Volume = 0.733

				gitSoundTemp:Destroy()

				local function GetGitSound(GithubSnd, SoundName)
					local url = GithubSnd
					if not isfile(SoundName .. ".mp3") then
						writefile(SoundName .. ".mp3", game:HttpGet(url))
					end
					local sound = Instance.new("Sound")
					sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
					return sound
				end

				local ReallyNear = game.Workspace.RipperNotMoving.Ripe.ReallyCloseStatic

				local Github = GetGitSound("https://github.com/eoyoustme/Hardcore/blob/main/ripper%20static%20final.mp3?raw=true", "Ripper")

				ReallyNear.SoundId = Github.SoundId
				ReallyNear.PlaybackSpeed = 0.5
				ReallyNear.Looped = true
				ReallyNear.TimePosition = 6.158
				ReallyNear.Volume = 0.733

				Github:Destroy()

				local function GetGitSound(GithubSnd, SoundName)
					local url = GithubSnd
					if not isfile(SoundName .. ".mp3") then
						writefile(SoundName .. ".mp3", game:HttpGet(url))
					end
					local sound = Instance.new("Sound")
					sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
					return sound
				end

				local Close = game.Workspace.RipperNotMoving.Ripe.CloseStatic

				local cui = GetGitSound("https://github.com/eoyoustme/Hardcore/blob/main/ripper%20sound%20effecrs%20%20new.mp3?raw=true", "lolang")

				Close.SoundId = cui.SoundId
				Close.PlaybackSpeed = 1
				Close.Looped = true
				Close.TimePosition = 12.932
				Close.Volume = 1.51

				cui:Destroy()

			end)
		end)

		local hasTriggered = false
		local destroyedRooms = {}

		entity:SetCallback("OnEnterRoom", function(room: Model, firstTime: boolean)
			if room and not destroyedRooms[room] then
				destroyedRooms[room] = true

				task.spawn(function()
					task.wait(0.05)

					local assetContainer = room:FindFirstChild("Assets") or room

					-- Phát âm thanh vỡ chung của phòng
					local breakSound = Instance.new("Sound")
					breakSound.SoundId = "rbxassetid://9114223171"
					breakSound.Volume = 2.5
					breakSound.Parent = assetContainer
					breakSound:Play()
					breakSound.Ended:Connect(function() breakSound:Destroy() end)

					local breakSounds = {
						"rbxassetid://9125992545",
						"rbxassetid://4004052860",
						"rbxassetid://7142857558",
						"rbxassetid://7142843615",
						"rbxassetid://7142857558",
						"rbxassetid://2612674531",
						"rbxassetid://2174790942"
					}

					local whitelist = {
						"bookcase", "potted_plant"
					}

					local blacklist = {
						"wardrobe", "bed", "rug", "key", "drawer",
						"table", "desk", "dresser", "curtain",
						"floor", "door", "hidingspots", "hidingspot1"
					}

					-- Kiểm tra xem Instance (Part/MeshPart/Model) hoặc cấp Cha của nó có thuộc Whitelist không
					local function isWhitelisted(instance)
						local current = instance
						while current and current ~= assetContainer and current ~= game do
							local lowerName = string.lower(current.Name)
							for _, word in ipairs(whitelist) do
								if string.find(lowerName, string.lower(word), 1, true) then
									return true
								end
							end
							current = current.Parent
						end
						return false
					end

					-- Kiểm tra xem bản thân Part/MeshPart HOẶC Model cha chứa nó có tên trong Blacklist không
					local function isBlacklisted(instance)
						if isWhitelisted(instance) then
							return false
						end

						local current = instance
						while current and current ~= assetContainer and current ~= game do
							local lowerName = string.lower(current.Name)
							for _, word in ipairs(blacklist) do
								if string.find(lowerName, string.lower(word), 1, true) then
									return true
								end
							end
							current = current.Parent
						end
						return false
					end

					local processedModels = {}

					for _, descendant in ipairs(assetContainer:GetDescendants()) do
						-- Duyệt tất cả các loại Part (Part, MeshPart, UnionOperation...)
						if descendant:IsA("BasePart") then
							-- Nếu Part hoặc Model cha của nó thuộc Blacklist -> Bỏ qua toàn bộ Part con
							if not isBlacklisted(descendant) then
								local parentModel = descendant:FindFirstAncestorOfClass("Model")
								local targetGroup = parentModel or descendant

								if targetGroup:IsDescendantOf(assetContainer) and not processedModels[targetGroup] then
									processedModels[targetGroup] = true

									task.spawn(function()
										-- Clone sang Client để lấy physics ownership lập tức
										local clientGroup
										if parentModel then
											clientGroup = parentModel:Clone()
											clientGroup.Parent = assetContainer
											parentModel:Destroy() -- Xóa bản gốc Server ở phía Client
										else
											clientGroup = descendant:Clone()
											clientGroup.Parent = assetContainer
											descendant:Destroy()
										end

										local rootPart
										local partsInGroup = {}

										if clientGroup:IsA("Model") then
											rootPart = clientGroup.PrimaryPart or clientGroup:FindFirstChildWhichIsA("BasePart")
											for _, part in ipairs(clientGroup:GetDescendants()) do
												if part:IsA("BasePart") and not isBlacklisted(part) then
													table.insert(partsInGroup, part)
												end
											end
										elseif clientGroup:IsA("BasePart") then
											rootPart = clientGroup
											table.insert(partsInGroup, clientGroup)
										end

										if not rootPart or #partsInGroup == 0 then return end

										-- 1. Hàn (Weld) tất cả Part vào rootPart
										for _, part in ipairs(partsInGroup) do
											if part ~= rootPart then
												local weld = Instance.new("WeldConstraint")
												weld.Part0 = rootPart
												weld.Part1 = part
												weld.Parent = rootPart
											end
										end

										-- 2. Phát âm thanh vỡ
										local s = Instance.new("Sound")
										s.SoundId = breakSounds[math.random(1, #breakSounds)]
										s.Volume = math.random(12, 24) / 10 
										s.PlaybackSpeed = math.random(85, 115) / 100
										s.RollOffMaxDistance = 100
										s.Parent = rootPart
										s:Play()
										s.Ended:Connect(function() s:Destroy() end)

										-- 3. Bật Physics và Unanchor đồng bộ
										for _, part in ipairs(partsInGroup) do
											part.CanCollide = true
											part.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.5, 1, 1)
											part.CFrame = part.CFrame + Vector3.new(0, 0.05, 0)
											part.Anchored = false
										end

										-- 4. Ép lực nổ (Văng ngay lập tức kể cả khi Player ở xa)
										rootPart.AssemblyLinearVelocity = Vector3.new(
											math.random(-60, 60),
											math.random(20, 50),
											math.random(-60, 60)
										)
										rootPart.AssemblyAngularVelocity = Vector3.new(
											math.random(-25, 25),
											math.random(-25, 25),
											math.random(-25, 25)
										)
									end)
								end
							end
						end
					end
				end)
			end
			-- Kiểm tra tên phòng xem có trùng khớp không
			local latestRoomNum = tostring(game.ReplicatedStorage.GameData.LatestRoom.Value)
			if room.Name ~= latestRoomNum then 
				return 
			end

			if hasTriggered then 
				return 
			end

			local RunService = game:GetService("RunService")
			local TweenService = game:GetService("TweenService")

			local entityModel = workspace:FindFirstChild("RipperNotMoving")
			local entityRoot = entityModel and (entityModel:FindFirstChild("HumanoidRootPart") or entityModel:FindFirstChildWhichIsA("BasePart")) 


			local doorModel = room:FindFirstChild("Door")

			local Exit = room:FindFirstChild("RoomExit")

			local doorPanel = doorModel and doorModel:FindFirstChild("Door")

			if entityModel and entityRoot and doorPanel and doorPanel:IsA("BasePart") then
				hasTriggered = true

				while entityModel and entityModel.Parent and entityRoot and (entityRoot.Position - Exit.Position).Magnitude > 4 do
					task.wait()
				end

				local function fadeSoundslow(duration)
					local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					local sounds = {}

					if entityModel:IsA("Sound") then table.insert(sounds, entityModel) end
					for _, desc in ipairs(entityModel:GetDescendants()) do
						if desc:IsA("Sound") then table.insert(sounds, desc) end
					end

					for _, sound in ipairs(sounds) do
						local originalSpeed = sound.PlaybackSpeed
						TweenService:Create(sound, tweenInfo, {PlaybackSpeed = 0}):Play()

						task.delay(4, function()
							if sound and sound.Parent then
								sound:Stop()
								sound.PlaybackSpeed = originalSpeed
							end
						end)
					end
				end

				local function normalfadeSounds(duration)
					local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
					local sounds = {}

					if entityModel:IsA("Sound") then table.insert(sounds, entityModel) end
					for _, desc in ipairs(entityModel:GetDescendants()) do
						if desc:IsA("Sound") then table.insert(sounds, desc) end
					end

					for _, sound in ipairs(sounds) do
						local originalSpeed = sound.PlaybackSpeed
						TweenService:Create(sound, tweenInfo, {PlaybackSpeed = 1}):Play()

						task.delay(4, function()
							if sound and sound.Parent then
								sound:Stop()
								sound.PlaybackSpeed = originalSpeed
							end
						end)
					end
				end

				local function fadeSounds(duration)
					local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
					local sounds = {}

					if entityModel:IsA("Sound") then table.insert(sounds, entityModel) end
					for _, desc in ipairs(entityModel:GetDescendants()) do
						if desc:IsA("Sound") then table.insert(sounds, desc) end
					end

					for _, sound in ipairs(sounds) do
						local originalSpeed = sound.PlaybackSpeed
						TweenService:Create(sound, tweenInfo, {PlaybackSpeed = 2}):Play()

						task.delay(3, function()
							if sound and sound.Parent then
								sound.PlaybackSpeed = originalSpeed
							end
						end)
					end
				end


				if entityModel and entityModel.Parent and entityRoot then
					local doorFreezePos = entityRoot.CFrame
					local freezeConnection

					freezeConnection = RunService.Heartbeat:Connect(function()
						if entityModel and entityModel.Parent and entityRoot then
							entity:Pause()
						end
					end)

					local chance = math.random(1, 2)

					task.spawn(function()
						local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
						local camera = game.Workspace.CurrentCamera

						local sound, sound5, sound6, sound7

						if chance == 1 then

							local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
								camera.CFrame = camera.CFrame * shakeCf
							end)
							camShake:Start()
							camShake:ShakeOnce(30, 11.5, 0.1, 2, 15, 0.5)

							entityRoot.Despawn1:Play()
							entityRoot.Despawn2:Play()
							entityRoot.Despawn3:Play()
							entityRoot.DoorOpen1:Play()
							entityRoot.DoorOpen2:Play()

							task.wait(1.5)

							local originalCFrame = entityRoot.CFrame
							entityRoot.Orientation = Exit.Orientation

							local tweenForwardInf5o = TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							local tweenForward5 = TweenService:Create(entityRoot, tweenForwardInf5o, {CFrame = originalCFrame * CFrame.new(0, -100, 0)})
							tweenForward5:Play()
							fadeSoundslow(4)
							task.wait(4)

						else


							local originalCFrame = entityRoot.CFrame

							local camShake1 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
								camera.CFrame = camera.CFrame * shakeCf
							end)
							camShake1:Start()
							camShake1:ShakeOnce(10, 3.5, 0.1, 1, 15, 0.5)
							entityRoot.Despawn1:Play()

							wait(1)

							local ambient = entityRoot.StaticAmbient:Clone()
							ambient.Parent = workspace
							local ambient2 = entityRoot.BassStatic:Clone()
							ambient2.Parent = workspace
							local ambient3 = entityRoot.FarStatic:Clone()
							ambient3.Parent = workspace
							local nice = entityRoot.Despawn3:Clone()
							nice.Parent = workspace
							local w = entityRoot.Despawn2:Clone()
							w.Parent = workspace
							local speed = entityRoot.DoorOpen1:Clone()
							speed.Parent = workspace
							wait(0.1)

							for _, descendant in ipairs(entityModel:GetDescendants()) do
								if descendant:IsA("Sound") then
									descendant:Destroy()
								end
							end

							local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							TweenService:Create(ambient, tweenInfo, {PlaybackSpeed = 2}):Play()
							local tweenInfo2 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							TweenService:Create(ambient2, tweenInfo2, {PlaybackSpeed = 1.2}):Play()
							local tweenInfo3 = TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							TweenService:Create(ambient3, tweenInfo3, {PlaybackSpeed = 1}):Play()

							local lookVector = originalCFrame.LookVector
							local flatLook = Vector3.new(lookVector.X, 0, lookVector.Z).Unit

							local targetPosition = originalCFrame.Position - (flatLook * 40)

							local doorPosition = doorPanel:IsA("BasePart") and doorPanel:GetPivot().Position or doorPanel.Position

							local targetLookAt = Vector3.new(doorPosition.X, targetPosition.Y, doorPosition.Z)
							local backCFrame = CFrame.lookAt(targetPosition, targetLookAt)

							local tweenBackInfo = TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							local tweenBack = TweenService:Create(entityRoot, tweenBackInfo, {CFrame = backCFrame})
							tweenBack:Play()
							wait(2.2)

							local tweenForwardInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							local tweenForward = TweenService:Create(entityRoot, tweenForwardInfo, {CFrame = originalCFrame})
							tweenForward:Play()

							local tweenInfo3 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient, tweenInfo3, {PlaybackSpeed = 1}):Play()
							local tweenInfo233 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient2, tweenInfo233, {PlaybackSpeed = 0.37}):Play()
							local tweenInfo333 = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient3, tweenInfo333, {PlaybackSpeed = 0.37}):Play()

							wait(1.2)						
							local tweenInfo33 = TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient, tweenInfo33, {PlaybackSpeed = 0}):Play()
							local tweenInfo23 = TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient2, tweenInfo23, {PlaybackSpeed = 0}):Play()
							local tweenInfo33 = TweenInfo.new(6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
							TweenService:Create(ambient3, tweenInfo33, {PlaybackSpeed = 0}):Play()

							local camShake2 = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
								camera.CFrame = camera.CFrame * shakeCf
							end)
							camShake2:Start()
							camShake2:ShakeOnce(30, 11.5, 0.1, 2, 15, 0.5)
							nice:Play()
							w:Play()
							speed:Play()
							wait(2)


							local tweenForwardInf5o = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
							local tweenForward5 = TweenService:Create(entityRoot, tweenForwardInf5o, {CFrame = originalCFrame * CFrame.new(0, -100, 0)})
							tweenForward5:Play()

							task.wait(3)
							ambient:Destroy()
							ambient2:Destroy()
							ambient3:Destroy()
							nice:Destroy()
							w:Destroy()
							speed:Destroy()
						end

						if entityModel and entityModel.Parent then
							entityModel:Destroy()
						end
						if doorModel then
							local doorpart = doorModel:FindFirstChild("Door")
							local promxy = doorpart.Knob.ProximityPrompt
							-- 1. Chỉnh kích thước Part "Hidden" trong doorModel gốc
							local hiddenPart = doorModel:FindFirstChild("Hidden", true)
							if hiddenPart and hiddenPart:IsA("BasePart") then
								hiddenPart.Size = Vector3.new(3, 8, 4)
							end

							-- 2. Tạo bản sao DoorClone
							local doorClone = doorModel:Clone()
							doorClone.Name = "DoorClone"
							doorClone.Parent = doorModel.Parent

							-- 3. Xử lý riêng cho DoorClone: Unanchor, bật CanCollide & xóa trigger/prompt
							for _, obj in doorClone:GetDescendants() do
								if obj:IsA("BasePart") then
									obj.Anchored = false
									obj.CanCollide = true -- BẮT BUỘC: Giúp cửa không bị rơi lún xuống đất
									doorpart.CanCollide = false
									doorpart.Open.Volume = 0
								end

								if promxy:IsA("ProximityPrompt") then
									promxy:Destroy()
								else
									return
								end

								if obj.Name == "DoorBarrier" or obj.Name == "BarrierTrigger" then
									obj:Destroy()
								end
							end

							-- 💥 HIỆU ỨNG HÚC CỬA NGÃ NẰM SÀN (NHƯ TRONG ẢNH)
							local cloneRoot = doorClone.PrimaryPart or doorClone:FindFirstChildWhichIsA("BasePart")
							if cloneRoot then
								-- Lấy hướng thẳng góc với cánh cửa
								local pushDirection = cloneRoot.CFrame.LookVector

								-- Lực 1: Đẩy văng tới trước + nảy nhẹ lên
								cloneRoot.AssemblyLinearVelocity = (pushDirection * 30) + Vector3.new(0, 3, 0)

								-- Lực 2: Tạo lực xoay làm cánh cửa lật ngửa/sập nằm bẹt xuống sàn
								cloneRoot.AssemblyAngularVelocity = cloneRoot.CFrame.RightVector * -90
							end

							-- 4. Xử lý trên DoorModel gốc: Làm trong suốt toàn bộ & xóa trigger, prompt, Sign
							for _, obj in doorModel:GetDescendants() do
								if obj:IsA("BasePart") then
									obj.Transparency = 1
								end

								if promxy:IsA("ProximityPrompt") then
									promxy:Destroy()
								else
									return
								end

								if obj.Name == "DoorBarrier" or obj.Name == "BarrierTrigger" or obj.Name == "Sign" then
									obj:Destroy()
								end
							end
						end

						local success, achievementGiver = pcall(function()
							return loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
						end)

						if success and achievementGiver then
							achievementGiver({
								Title = "Torn Apart",
								Desc = "Don't Leave too Early",
								Reason = "Encounter and survive RIPPER.",
								Image = "rbxassetid://12231244908"
							})
						end

						task.wait(2)

						hasTriggered = false 
					end)
				end
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
	entity:Run(true)
end
end
