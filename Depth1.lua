
---====== Load spawner ======---

local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---

local entity = spawner.Create({
	Entity = {
		Name = "Depth",
		Asset = "https://github.com/eliazbp92-collab/Undeserving-mode/raw/main/Depthy.rbxm",
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
	CameraShake = {
		Enabled = true,
		Range = 100,
		Values = {10, 30, 0.1, 1.2} -- Magnitude, Roughness, FadeIn, FadeOut
	},
	Movement = {
		Speed = 200,
		Delay = 5,
		Reversed = false
	},
	Rebounding = {
		Enabled = true,
		Type = "Ambush", -- "Blitz"
		Min = 5,
		Max = 5,
		Delay = 0
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
		Hints = {"You died to Depth...", "It appears at the next door and has a chance to stay there or run back to the oldest door.", "He will come back many times after his initial spawn", "so hide every next door until it is safe.."},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Entity has spawned")
local TweenService = game:GetService("TweenService")
local Lighting = game.Lighting
local cc = Lighting:WaitForChild("MainColorCorrection")
local CameraShaker = require(game.ReplicatedStorage.CameraShaker)
local cam = workspace.CurrentCamera

-- Tạo CameraShaker
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(cf)
	cam.CFrame = cam.CFrame * cf
end)
camShake:Start()

-- Âm thanh
local cue = Instance.new("Sound")
cue.Parent = workspace
cue.SoundId = "rbxassetid://926058764"
cue.Volume = 10
cue.PlaybackSpeed = 0.89

-- 🔥 Load âm thanh trước
cue.Loaded:Wait()

-- ✅ Đặt TimePosition sau khi load xong
cue.TimePosition = 0

-- Phát cùng lúc lighting
cue:Play()

-- Lighting bắt đầu ngay
cc.TintColor = Color3.fromRGB(0, 135, 255)
cc.Contrast = 1
cc.Saturation = -0.7
TweenService:Create(cc, TweenInfo.new(10), {Contrast = 0}):Play()
TweenService:Create(cc, TweenInfo.new(10), {Saturation = 0}):Play()
wait(1)
	-- Tween fade trắng 8 giây
	TweenService:Create(cc, TweenInfo.new(15), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()

end)

entity:SetCallback("OnStartMoving", function()
    print("Entity has started moving")
end)

entity:SetCallback("OnEnterRoom", function(room, firstTime)
    if firstTime == true then
        print("Entity has entered room: ".. room.Name.. " for the first time")
    else
        print("Entity has entered room: ".. room.Name.. " again")
    end
end)

entity:SetCallback("OnLookAt", function(lineOfSight)
	if lineOfSight == true then
		print("Player is looking at entity")
	else
		print("Player view is obstructed by something")
	end
end)

entity:SetCallback("OnRebounding", function(startOfRebound)
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

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Entity has killed the player")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Tạo sound + effect giống bạn
local sound = Instance.new("Sound", workspace)
sound.SoundId = "rbxassetid://5263560566"
sound. TimePosition = 0
local level = Instance.new("DistortionSoundEffect", sound)
level.Level = 0.97

wait(0.2)

-- Tạo GUI
local screen = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

local background = Instance.new("Frame", screen)
background.AnchorPoint = Vector2.new(0.5, 0.5)
background.Size = UDim2.new(10, 0, 10, 0)
background.Position = UDim2.new(0.5, 0, 0.5, 0)
background.BackgroundColor3 = Color3.fromRGB(0, 157, 255)

local image = Instance.new("ImageLabel", screen)
image.AnchorPoint = Vector2.new(0.5, 0.5)
image.Position = UDim2.new(0.5, 0, 0.5, 0)
image.BackgroundTransparency = 1
image.Size = UDim2.new(0, 5, 0, 5)
image.LayoutOrder = 0
image.BorderSizePixel = 0
image.Image = "http://www.roblox.com/asset/?id=11278229112"
image.Rotation = 0

-- flash màu background như bạn
task.spawn(function()
	while background and background.Parent do
		background.BackgroundColor3 = Color3.fromRGB(0, 17, 255)
		task.wait(0.08)
		if not background or not background.Parent then break end
		background.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		task.wait(0.08)
	end
end)

-- play sound
sound:Play()

-- Tween scale ảnh (giữ nguyên thời gian 35s)
local tween = TweenService:Create(image, TweenInfo.new(75, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 130000, 0, 130000)})
tween:Play()

-- ====== Phần thêm: oscillation (rotation + position jitter) ======
local ROT_AMPLITUDE = 12        -- góc tối đa (deg)
local PERIOD = 0.1              -- chu kỳ đầy đủ (giây) => -12 -> +12 -> -12
local JITTER_X = 60             -- jitter theo pixels ngang (±)
local JITTER_Y = 60              -- jitter theo pixels dọc (±)

-- bắt đầu time
local t0 = tick()
local conn
conn = RunService.RenderStepped:Connect(function()
	-- nếu image đã bị xóa thì ngắt connection
	if not image or not image.Parent then
		if conn then conn:Disconnect() end
		return
	end

	local elapsed = tick() - t0
	-- sinus để quay mượt: sin(2*pi * elapsed / PERIOD) in [-1,1]
	local s = math.sin(2 * math.pi * elapsed / PERIOD)
	image.Rotation = ROT_AMPLITUDE * s

	-- position jitter xung quanh center (UDim2.new(0.5, offsetX, 0.5, offsetY))
	local offsetX = math.sin(2 * math.pi * elapsed / (PERIOD * 1.3)) * JITTER_X -- tỉ lệ khác 1.3 để không hoàn toàn đồng bộ với rotation
	local offsetY = math.cos(2 * math.pi * elapsed / (PERIOD * 1.1)) * JITTER_Y
	image.Position = UDim2.new(0.5, offsetX, 0.5, offsetY)
end)
-- =================================================================

-- Nếu bạn vẫn muốn destroy giống code gốc: (hiện bạn xóa sau 1 giây)
task.wait(1.5)
if sound then sound:Destroy() end
if screen then screen:Destroy() end
if conn then
	pcall(function() conn:Disconnect() end)
end
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
