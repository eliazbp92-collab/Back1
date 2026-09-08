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

local Creator = loadstring(game:HttpGet("https://pastebin.com/raw/0fSnvfGt"))() 
-- Create entity
local entity = Creator.createEntity({
    CustomName = "Cease", -- Custom name of your entity
    Model = "13197667688", -- Can be GitHub file or rbxassetid
    Speed = 65, -- Percentage, 100 = default Rush speed
    DelayTime = 3, -- Time before starting cycles (seconds)
    HeightOffset = 0,
    CanKill = false,
    KillRange = 60,
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
                Color3.fromRGB(116, 135, 255), -- Color
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
		light(2, Color3.fromRGB(116, 135, 255), Color3.fromRGB(116, 135, 255))
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
