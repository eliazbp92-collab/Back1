---====== Load spawner ======---
local spawner = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Entity%20Spawner/V2/Source.lua"))()

---====== Create entity ======---
local entity = spawner.Create({
	Entity = {
		Name = "Cease",
		Asset = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_CeaseMoving_1787957919.rbxm",
		HeightOffset = 0
	},
	Lights = {
		Flicker = {
			Enabled = false,
			Duration = 7
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
		Values = {3, 3, 2, 2}
	},
	Movement = {
			Speed = 70,
			SpeedFast = 270,                  
			MoveFastNotEnter = true,            
			Delay = 5,
			Reversed = false,                  
			EndWhenEnterLatestRoom = false,   
			EndDelay = 0,

			ReboundMoving = false,          
			TweenSecond = 1.5,            

			ReboundMoveStyle = false,      
			ReboundStyleTimes = 5,        
			ReboundStyleSound = "rbxassetid://9114221327", 
			ReboundStyleVolume = 5,
			ReboundStyleDelay = 2, 

			ChasePlayerWhenSee = false,
			SpeedWhenChase = 35
	},
	Rebounding = {
		Enabled = false,
		Type = "Ambush",
		Min = 2,
		Max = 2,
		Delay = 0
	},
	Damage = {
			Enabled = true,
			KillOnMove = true,            
			Range = 40,
			Amount = 125,
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
		Hints = {
			"Bạn đã chết bởi Cease.",
			"Khi Cease xuất hiện, đừng di chuyển nếu không bạn sẽ chết."
		},
		Cause = ""
	}
})

---====== Debug entity ======---

entity:SetCallback("OnSpawned", function()
    print("Cease đã xuất hiện")

    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    local Players = game:GetService("Players")

    -- Hiệu ứng ánh sáng khi xuất hiện
    game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(255, 255, 255)
    game.Lighting.MainColorCorrection.Contrast = 10
    TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
    TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5), {TintColor = Color3.fromRGB(69, 72, 255)}):Play()

    -- Đợi để đảm bảo entity đã spawn
    task.wait(0.1)
    local ceaseModel = entity.Model
    if not ceaseModel then
        warn("Không tìm thấy model của Cease!")
        return
    end

    local hitboxRange = 120

    -- Tạo vòng lặp Heartbeat để raycast từ Cease về phía từng người chơi
    local raycastLoop
    raycastLoop = RunService.Heartbeat:Connect(function()
        local origin = ceaseModel:GetPivot().Position

        for _, player in ipairs(Players:GetPlayers()) do
            local chr = player.Character
            if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") then
                local hrp = chr.HumanoidRootPart
                local humanoid = chr.Humanoid

                local direction = (hrp.Position - origin).Unit
                local rayResult = workspace:Raycast(origin, direction * hitboxRange)

                if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(chr) then
                    if humanoid.MoveDirection.Magnitude > 0 then
                        humanoid.Health = 0
                        print(player.Name .. " bị Cease giết vì di chuyển khi bị phát hiện!")

                        -- Ghi lại nguyên nhân cái chết
                        local statsFolder = game.ReplicatedStorage:FindFirstChild("GameStats")
                        if statsFolder then
                            local playerStats = statsFolder:FindFirstChild("Player_" .. player.Name)
                            if playerStats and playerStats:FindFirstChild("Total") and playerStats.Total:FindFirstChild("DeathCause") then
                                playerStats.Total.DeathCause.Value = "Cease"
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Ngắt vòng lặp khi Cease despawn
    entity:SetCallback("OnDespawned", function()
        print("Cease đã biến mất")
        
        if raycastLoop then
            raycastLoop:Disconnect()
        end

        -- Hiệu ứng ánh sáng khi biến mất
        game.Lighting.MainColorCorrection.TintColor = Color3.fromRGB(69, 72, 255)
        game.Lighting.MainColorCorrection.Contrast = 10
        TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(2.5), {Contrast = 0}):Play()
        TweenService:Create(game.Lighting.MainColorCorrection, TweenInfo.new(5), {TintColor = Color3.fromRGB(255, 255, 255)}):Play()

        -- Thành tích khi gặp Cease
        local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/Idk-lol2/a-60aa/refs/heads/main/fix%20bage.txt"))()
        achievementGiver({
            Title = "Get out of the way",
            Desc = "Where is it?",
            Reason = "Encounter Cease",
            Image = "rbxassetid://104367200417966"
        })
    end)
end)

entity:SetCallback("OnDamagePlayer", function(newHealth)
	if newHealth == 0 then
		print("Cease đã giết người chơi")
	else
		print("Cease gây sát thương cho người chơi")
	end
end)

---====== Run entity ======---
entity:Run()
