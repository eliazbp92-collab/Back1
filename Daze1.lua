local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local function spawnShocker()
	local shockerModel = game:GetObjects("rbxassetid://102547942245981")[1]
	local camera = Workspace.CurrentCamera

	local rootPart = shockerModel:FindFirstChild("HumanoidRootPart") or shockerModel:FindFirstChildWhichIsA("Part")
	shockerModel.PrimaryPart = rootPart
	shockerModel:SetPrimaryPartCFrame(camera.CFrame * CFrame.new(0, 0, -7))
	shockerModel.Parent = Workspace

	local oogaBoogaaPart = shockerModel:WaitForChild("OOGA BOOGAAAA")
	local horrorScream = oogaBoogaaPart:WaitForChild("jumpscare")

	local lookDuration = 2
	local lookStart = nil
	local hasTriggered = false
	local hasFallen = false

	local function fallToGround()
		if hasFallen then return end
		hasFallen = true

		oogaBoogaaPart.Anchored = false
		oogaBoogaaPart.CanCollide = false

		task.delay(1.2, function()
			if shockerModel then
				shockerModel:Destroy()
			end
		end)
	end

	local connection
	connection = game:GetService("RunService").RenderStepped:Connect(function()
		if not character or not character:FindFirstChild("HumanoidRootPart") then return end
		if hasTriggered then connection:Disconnect() return end

		local directionToShocker = (oogaBoogaaPart.Position - camera.CFrame.Position).Unit
		local playerLookVector = camera.CFrame.LookVector
		local dot = directionToShocker:Dot(playerLookVector)

		if dot > 0.85 then
			-- Đang nhìn
			if not lookStart then
				lookStart = tick()
			elseif tick() - lookStart >= lookDuration then
				hasTriggered = true
				connection:Disconnect()

				horrorScream:Play()
				humanoid:TakeDamage(30)

				-- Tween lao tới player
				local targetPos = character.HumanoidRootPart.Position + Vector3.new(0, 2, 0)
				local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
				local tween = TweenService:Create(oogaBoogaaPart, tweenInfo, {Position = targetPos})
				tween:Play()

				tween.Completed:Connect(function()
					-- Sau khi lao tới thì rơi xuống đất
					fallToGround()
				end)

				-- Death message
				ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Daze"
				firesignal(ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {
					"You died to who you call Daze...",
					"Don't look at it or it stuns you!"
				}, "Blue")
			end
		else
			-- Không nhìn → ngã luôn
			connection:Disconnect()
			fallToGround()
		end
	end)

	-- Dự phòng
	task.delay(5, function()
		if not hasTriggered and not hasFallen then
			fallToGround()
		end
	end)

	-- Achievement
	local achievementGiver = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Doors/Custom%20Achievements/Source.lua"))()
	achievementGiver({
		Title = "Shocking Experience",
		Desc = "Look at me.",
		Reason = "Encounter Shocker.",
		Image = "rbxassetid://17857830685"
	})
end

spawnShocker()
