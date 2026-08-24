game.ReplicatedStorage.GameData.LatestRoom.Changed:Wait()

-- Load Entity Spawner V2
local spawner = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"
	))()

local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- ====== Spawn effect ban đầu (giữ nguyên của bạn) ======
local cue = Instance.new("Sound")
cue.Parent = workspace
cue.Name = "Spawn1"
cue.SoundId = "rbxassetid://9125713308"
cue.Volume = 5
cue:Play()

task.wait(1)

local cue2 = Instance.new("Sound")
cue2.Parent = workspace
cue2.Name = "Spawn2"
cue2.SoundId = "rbxassetid://9125712561"
cue2.Volume = 5
cue2:Play()

-- Đèn chuyển đỏ
local redtweeninfo = TweenInfo.new(3)
local redinfo = {Color = Color3.new(1, 0, 0)}

for _, v in pairs(workspace.CurrentRooms:GetDescendants()) do
	if v:IsA("Light") then
		TweenService:Create(v, redtweeninfo, redinfo):Play()
		if v.Parent.Name == "LightFixture" then
			TweenService:Create(v.Parent, redtweeninfo, redinfo):Play()
		end
	end
end

-- Camera shake
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(Cf)
	workspace.CurrentCamera.CFrame *= Cf
end)
camShake:Start()
camShake:Shake(CameraShaker.Presets.Earthquake)

task.wait(11)

-- ====== Tạo thực thể V2 ======
local entity = spawner.Create({
	Entity = {
		Name = "Hungered",
		Asset = "rbxassetid://96360347693213",
		HeightOffset = 0
	},

	Lights = {
		Flicker = {Enabled = false, Duration = 5},
		Shatter = true,
		Repair = false
	},

	Movement = {
		Speed = 300,
		Delay = 2,
		Reversed = false
	},

	Damage = {
		Enabled = true,
		Range = 45,
		Amount = 200
	},

	Crucifixion = {
		Enabled = true,
		Range = 25,
		Resist = false,
		Break = true
	},

	Rebounding = {
		Enabled = true,
		Type = "Ambush", -- "Blitz"
		Min = 5,
		Max = 5,
		Delay = 0
	},

	Death = {
		Type = "Guiding",
		Hints = {"Bạn đã bị Hunger tấn công!", "Âm thanh là cảnh báo duy nhất!", "Ẩn nấp ngay khi thấy đèn đỏ!"},
		Cause = "Hunger"
	}
})

-- Callback khi spawn (giữ print của bạn + achievement)
entity:SetCallback("OnSpawned", function()
	print("Hunger đã spawn")
end)

entity:SetCallback("OnDespawning", function()
	print("Hunger đã despawning")
	local TweenService = game:GetService("TweenService")

	-- Tạo âm thanh
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://9125712561"
	sound.Volume = 10
	sound.PlaybackSpeed = 0.4
	sound.Looped = false
	sound.Parent = workspace

	-- Load âm thanh trước
	sound.Loaded:Wait()

	-- Phát âm thanh ngay
	sound:Play()

	-- Chờ 2.5 giây trước khi bắt đầu fade
	task.delay(2, function()
		-- Tween giảm volume từ 10 xuống 0 trong 2 giây
		local tween = TweenService:Create(sound, TweenInfo.new(5), {Volume = 0})
		tween:Play()

		-- Khi tween kết thúc → destroy âm thanh
		tween.Completed:Connect(function()
			sound:Destroy()
		end)
	end)
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
		local player = game.Players.LocalPlayer
		local playerGui = player:WaitForChild("PlayerGui")
		local character = player.Character or player.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local camera = workspace.CurrentCamera

		-- Bắt đầu Jumpscare nếu player chết
		if newHealth <= 0 then
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

			-- Hiệu ứng âm thanh
			Instance.new("FlangeSoundEffect", killSound).Rate = 0.2
			Instance.new("TremoloSoundEffect", killSound).Frequency = 1
			Instance.new("PitchShiftSoundEffect", killSound).Octave = 1
			Instance.new("DistortionSoundEffect", killSound).Level = 0.2

			-- UI
			local background = Instance.new("ImageLabel", screenGui)
			background.Size = UDim2.new(1, 0, 1, 0)
			background.Image = "rbxassetid://1712510813"
			background.ImageTransparency = 0.5
			background.BackgroundColor3 = Color3.new(0, 0, 0)
			background.BackgroundTransparency = 0

			local face = Instance.new("ImageLabel", screenGui)
			face.AnchorPoint = Vector2.new(0.5, 0.5)
			face.Position = UDim2.new(0.5, 0, 0.589, 0)
			face.Size = UDim2.new(0, 1, 0, 1)
			face.Image = "rbxassetid://12078778205"
			face.BackgroundTransparency = 1

			local text = Instance.new("ImageLabel", screenGui)
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
			game:GetService("TweenService"):Create(camera, TweenInfo.new(zoomDuration), {FieldOfView = zoomFov}):Play()

			game:GetService("TweenService"):Create(face, TweenInfo.new(zoomDuration), {
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
					face.Image = "rbxassetid://12078778205"
					task.wait(0)
					face.Rotation = -10
					task.wait(0)
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

			-- Đợi và fade out
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

			task.wait(0.4)
			camera.CameraType = Enum.CameraType.Custom
			camera.FieldOfView = startFov
	end
end)

entity:Run()
