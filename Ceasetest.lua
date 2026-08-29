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
		Speed = 60,
		Delay = 5,
		Reversed = false
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
	
	light(2,Color3.fromRGB(127, 249, 255),Color3.fromRGB(0, 45, 185))

	-- === BẮT ĐẦU KIỂM TRA DI CHUYỂN CHUẨN XÁC === --
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")

	-- đảm bảo Cease chính xác có model
	repeat task.wait() until entity.Model
	local ceaseModel = entity.Model

	local hitboxRange = 120

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Blacklist
	params.FilterDescendantsInstances = {ceaseModel}

	local raycastLoop
	raycastLoop = RunService.Heartbeat:Connect(function()
		local origin = ceaseModel:GetPivot().Position

		for _, player in ipairs(Players:GetPlayers()) do
			local chr = player.Character
			if chr and chr:FindFirstChild("HumanoidRootPart") and chr:FindFirstChild("Humanoid") then

				local hrp = chr.HumanoidRootPart
				local humanoid = chr.Humanoid

				-- Raycast
				local direction = (hrp.Position - origin).Unit
				local rayResult = workspace:Raycast(origin, direction * hitboxRange, params)

				if rayResult and rayResult.Instance and rayResult.Instance:IsDescendantOf(chr) then

					-- KIỂM TRA DI CHUYỂN CHUẨN
					local isMovingByInput = humanoid.MoveDirection.Magnitude > 0.1
					local isMovingByVelocity = hrp.AssemblyLinearVelocity.Magnitude > 2

					-- Chỉ giết khi cả hai đều đúng
					if isMovingByInput and isMovingByVelocity and humanoid.Health > 0  then
						humanoid.Health = 0
						local sound = Instance.new("Sound")
						sound.SoundId = "rbxassetid://4988621968"
						sound.Volume = 10
						sound.PlaybackSpeed = 0.7
						sound.Parent = workspace
						sound:Play()

						print(player.Name .. " bị Cease giết vì di chuyển!")

						-- đánh dấu nguyên nhân chết
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
		local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()

		achievementGiver({
			Title = "I don't want a Noise",
			Desc = "CeaseStopping",
			Reason = "Survive Cease",
			Image = "rbxassetid://104367200417966"
		})
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
