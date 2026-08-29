
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

local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local camara = game.Workspace.CurrentCamera
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	camara.CFrame = camara.CFrame * shakeCf
end)
camShake:Start()
camShake:ShakeOnce(25,7.5,0.1,2,2,0.1)

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
		Name = "Rebound2",
		Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_Rebound_1787965761.rbxm",
		HeightOffset = 3
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
		Speed = 380,
		Delay = 8,
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
		Amount = 55
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
	light(2,Color3.fromRGB(127, 249, 255),Color3.fromRGB(65, 138, 255))
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

	wait(6)

	local function GetGitSound(GithubSnd, SoundName)
		local url = GithubSnd
		if not isfile(SoundName .. ".mp3") then
			writefile(SoundName .. ".mp3", game:HttpGet(url))
		end
		local sound = Instance.new("Sound")
		sound.SoundId = (getcustomasset or getsynasset)(SoundName .. ".mp3")
		return sound
	end

	local ReallyNear = game.Workspace.Rebound2.Fakeout

	local Github = GetGitSound("https://github.com/eoyoustme/Impossible/blob/main/rebound%20fakeout.mp3?raw=true", "fakeout")

	ReallyNear.SoundId = Github.SoundId
	ReallyNear.PlaybackSpeed = 1
	ReallyNear.TimePosition = 0
	ReallyNear.Volume = 10
	ReallyNear:Play()

	Github:Destroy()
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
	loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Hardcore/refs/heads/main/Reboundl"))()
end)

entity:SetCallback("OnDespawned", function()
	print("Entity has despawned")
end)

entity:SetCallback("OnDamagePlayer", function(newHealth: number)
	if newHealth <= 0 then
		print("Entity has killed the player")
		replicatesignal(game.Players.LocalPlayer.Kill)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/eoyoustme/Hardcore/refs/heads/main/Rebound%20Jumpscare"))()
	else
		print("Entity has damaged the player")
		local RunService = game:GetService("RunService")
		local TweenService = game:GetService("TweenService")

		local entityModel = workspace:FindFirstChild("Rebound2")
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
			-- 1. Tạo ScreenGui và ImageLabel
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
			imageLabel.ImageTransparency = 0.25 -- Bắt đầu từ độ mờ 0.25
			imageLabel.Visible = true
			imageLabel.Parent = screenGui
			imageLabel.ImageColor3 = Color3.fromRGB(85, 170, 255)

			-- Danh sách ảnh jumpscare nhấp nháy
			local jumpscareImages = {
				"rbxassetid://134346506410955",
				"rbxassetid://7578853379",
				"rbxassetid://103846711769666",
				"rbxassetid://78199392475572"
			}

			local duration = 1.5 -- Thời gian diễn ra hiệu ứng (3 giây)
			local start = os.clock()
			local imageIndex = 1

			-- 2. Khởi tạo Tween mờ dần (từ 0.25 về 1 trong vòng 3 giây)
			local info = TweenInfo.new(duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
			local tween = TweenService:Create(imageLabel, info, {ImageTransparency = 1})

			-- 3. CHẠY TWEEN NGAY TẠI ĐÂY (Tween sẽ chạy ngầm song song)
			tween:Play()

			-- 4. Vòng lặp đổi ảnh chạy đồng thời với Tween
			while os.clock() - start < duration do
				imageLabel.Image = jumpscareImages[imageIndex]
				imageIndex = (imageIndex % #jumpscareImages) + 1
				task.wait(0.03) -- Tốc độ chớp ảnh
			end

			-- 5. Đợi Tween hoàn thành 100% rồi dọn dẹp GUI
wait(1)
			
				if freezeConnection then
					freezeConnection:Disconnect()
				end
				
			screenGui:Destroy()
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
