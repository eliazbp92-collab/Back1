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


		light(2,Color3.fromRGB(255, 0, 0),Color3.fromRGB(255, 0, 0))
		task.spawn(function()
			pcall(function()
				local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
				local camera = game.Workspace.CurrentCamera
				local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
					camera.CFrame = camera.CFrame * shakeCf
				end)
				camShake:Start()
				camShake:ShakeOnce(10, 3, 0.1, 6)
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

		wait(6.771)
local Creator = loadstring(game:HttpGet("https://pastebin.com/raw/0fSnvfGt"))() 
-- Create entity
local entity = Creator.createEntity({
    CustomName = "Ripper", -- Custom name of your entity
    Model = "https://github.com/eliazbp92-collab/Back1/raw/main/OlderRipper.rbxm", -- Can be GitHub file or rbxassetid
    Speed = 120, -- Percentage, 100 = default Rush speed
    DelayTime = 1, -- Time before starting cycles (seconds)
    HeightOffset = 3,
    CanKill = true,
    KillRange = 40,
    BreakLights = true,
    BackwardsMovement = false,
    FlickerLights = {
        false, -- Enabled/Disabled
        1, -- Time (seconds)
    },
    Cycles = {
        Min = 1,
        Max = 1,
        WaitTime = 1,
    },
    CamShake = {
        true, -- Enabled/Disabled
        {3.5, 20, 0.1, 1}, -- Shake values (don't change if you don't know)
        100, -- Shake start distance (from Entity to you)
    },
    Jumpscare = {
        true, -- Enabled/Disabled
        {
            Image1 = "rbxassetid://10483855823", -- Image1 url
            Image2 = "rbxassetid://10483999903", -- Image2 url
            Shake = true,
            Sound1 = {
                10483790459, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Sound2 = {
                10483837590, -- SoundId
                { Volume = 0.5 }, -- Sound properties
            },
            Flashing = {
                true, -- Enabled/Disabled
                Color3.fromRGB(0, 0, 255), -- Color
            },
            Tease = {
                true, -- Enabled/Disabled
                Min = 4,
                Max = 4,
            },
        },
    },
    CustomDialog = {"You died to Rush...", "your balls look dry", "Can I put some lotion on them?"}, -- Custom death message
})
 
-----[[ Advanced ]]-----
entity.Debug.OnEntitySpawned = function(entityTable)
    print("Entity has spawned:", entityTable.Model)
end
 
entity.Debug.OnEntityDespawned = function(entityTable)
    print("Entity has despawned:", entityTable.Model)
end
 
entity.Debug.OnEntityStartMoving = function(entityTable)
    print("Entity has started moving:", entityTable.Model)
end
 
entity.Debug.OnEntityFinishedRebound = function(entityTable)
    print("Entity has finished rebound:", entityTable.Model)
end
 
entity.Debug.OnEntityEnteredRoom = function(entityTable, room)
    print("Entity:", entityTable.Model, "has entered room:", room)
end
 
entity.Debug.OnLookAtEntity = function(entityTable)
    print("Player has looked at entity:", entityTable.Model)
end
 
entity.Debug.OnDeath = function(entityTable)
    warn("Player has died.")
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

						local disto = Instance.new("DistortionSoundEffect")
						disto.Level = 0.75
						disto.Parent = sound

						task.spawn(function()
							local Players = game:GetService("Players")
							local player = Players.LocalPlayer
							local playergui = player:WaitForChild("PlayerGui")

							local screenGui = Instance.new("ScreenGui")
							screenGui.Name = "FlashOverlay"
							screenGui.IgnoreGuiInset = true
							screenGui.Parent = playergui

							local frame = Instance.new("Frame")
							frame.Size = UDim2.new(1, 0, 1, 0)
							frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
							frame.BackgroundTransparency = 0
							frame.BorderSizePixel = 0
							frame.Parent = screenGui

							local originalVolumes = {}


							for i=1 ,7 do
								frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
								wait(0.0005)
								frame.BackgroundColor3 = Color3.fromRGB(132, 0, 0)
								wait(0.0005)
							end
							screenGui:Destroy()
						end)

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
   end
------------------------
 
-- Run the created entity
Creator.runEntity(entity)
