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
    HeightOffset = 2,
    CanKill = true,
    KillRange = 40,
    BreakLights = false,
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
	        local sound5 = Instance.new("Sound")
			sound5.PlaybackSpeed = 1
			sound5.Volume = 10
			sound5.SoundId = "rbxassetid://1837829565"
			sound5.Parent = workspace
			sound5:Play()

			local pitch = Instance.new("PitchShiftSoundEffect")
			pitch.Octave = 0
			pitch.Parent = sound5

			local sound51 = Instance.new("Sound")
			sound51.PlaybackSpeed = 1
			sound51.Volume = 10
			sound51.SoundId = "rbxassetid://1318185544"
			sound51.Parent = workspace
			sound51:Play()

			local pitch2 = Instance.new("PitchShiftSoundEffect")
			pitch2.Octave = 0
			pitch2.Parent = sound51

			local pitch23 = Instance.new("PitchShiftSoundEffect")
			pitch23.Octave = 0
			pitch23.Parent = sound51

			local eq = Instance.new("EqualizerSoundEffect")
			eq.LowGain = 0
			eq.MidGain = 0
			eq.Parent = sound51
			wait(3.76)
			sound5:Destroy()
			sound51:Destroy()
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
