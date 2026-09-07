 
function light(tim, color0, color1)
	local tweenservice = game:GetService("TweenService")
	local info = TweenInfo.new(tim, Enum.EasingStyle.Linear)
	for _, lightObj in pairs(game.Workspace.CurrentRooms:GetDescendants()) do
		if lightObj:IsA("Light") or lightObj:IsA("SurfaceLight") or lightObj:IsA("SpotLight") then
			local target = {Color = color1}
			local anim = tweenservice:Create(lightObj, info, target)
			anim:Play()
		end
		if lightObj:IsA("MeshPart") and lightObj.Material == Enum.Material.Neon and lightObj.Name ~= "Skybox" then
			local target1 = {Color = color0}
			local anim2 = tweenservice:Create(lightObj, info, target1)
			anim2:Play()
		end
	end
end
 
-- Hiệu ứng ánh sáng Lighting
game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(61, 171, 98)
game.Lighting.MainColorCorrection.Contrast = 0.2
game.Lighting.MainColorCorrection.Saturation = -0.7
 
local tween = game:GetService("TweenService")
tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5), {Contrast = 0}):Play()
tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5), {Saturation = 0}):Play()
tween:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()
 
-- Âm thanh báo hiệu
local cue1 = Instance.new("Sound")
cue1.Parent = game.Workspace
cue1.Name = "Scream"
cue1.SoundId = "rbxassetid://9114397505"
 
local distort = Instance.new("DistortionSoundEffect", cue1)
distort.Level = 1
local distort2 = Instance.new("DistortionSoundEffect", cue1)
distort2.Level = 1
 
local pitch = Instance.new("PitchShiftSoundEffect", cue1)
pitch.Octave = 0.5
local pitch2 = Instance.new("PitchShiftSoundEffect", cue1)
pitch2.Octave = 0.5
local pitch3 = Instance.new("PitchShiftSoundEffect", cue1)
pitch3.Octave = 0.5
 
cue1.Volume = 2
cue1:Play()
 
local spawnSound = Instance.new("Sound")
spawnSound.Parent = game.Workspace
spawnSound.Name = "Spaw5"
spawnSound.SoundId = "rbxassetid://9114221327"
spawnSound.Volume = 10
spawnSound:Play()
 
-- Rung camera an toàn
pcall(function()
	local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))
	local camera = game.Workspace.CurrentCamera
	local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
		camera.CFrame = camera.CFrame * shakeCf
	end)
	camShake:Start()
	camShake:ShakeOnce(10, 3, 0.1, 6)
end)
 
-- Delay là 1 con số cụ thể (ví dụ: 2 giây) thay vì một bảng
local delayTime = Random.new():NextInteger(0.01 , 2)
task.wait(2.8)

local Creator = loadstring(game:HttpGet("https://pastebin.com/raw/0fSnvfGt"))() 
-- Create entity
local entity = Creator.createEntity({
    CustomName = "Rebound", -- Custom name of your entity
    Model = "11459817091", -- Can be GitHub file or rbxassetid
    Speed = 275, -- Percentage, 100 = default Rush speed
    DelayTime = 1, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = false,
    KillRange = 40,
    BreakLights = true,
    BackwardsMovement = true,
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
end
------------------------

-- Run the created entity
Creator.runEntity(entity)
