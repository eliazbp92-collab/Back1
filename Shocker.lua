local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

local Shocker = "game:GetObjects(rbxassetid://90250291645240)[1]"

function getgithubmodeL(url)
	if not (writefile and getcustomasset and request) then return nil end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	local response = request({Url = url, Method = "GET"})
	if response.StatusCode ~= 200 then return nil end
	writefile(fileName, response.Body)
	local assetId = getcustomasset(fileName)
	local success, result = pcall(function() return game:GetObjects(assetId)[1] end)
	return success and result or nil
end

local function spawnShocker()
	local shockerModel = getgithubmodeL(Shocker)
	local camera = Workspace.CurrentCamera

	local rootPart = shockerModel:FindFirstChild("HumanoidRootPart") or shockerModel:FindFirstChildWhichIsA("Part")
	shockerModel.PrimaryPart = rootPart
	shockerModel:SetPrimaryPartCFrame(camera.CFrame * CFrame.new(0, -1, -11))
	shockerModel.Parent = Workspace

	local oogaBoogaaPart = shockerModel:WaitForChild("OOGA BOOGAAAA")
	local horrorScream = oogaBoogaaPart:WaitForChild("HORROR SCREAM 15")

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


		if dot > 0.05 then
			-- –ang nhÏn
			if not lookStart then
				lookStart = tick()
			elseif tick() - lookStart >= lookDuration then
				hasTriggered = true
				connection:Disconnect()

				horrorScream:Play()
				humanoid:TakeDamage(30)

				-- Tween lao t?i player
				local targetPos = character.HumanoidRootPart.Position + Vector3.new(0, 0, 0)
				local tweenInfo = TweenInfo.new(1.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
				local tween = TweenService:Create(oogaBoogaaPart, tweenInfo, {Position = targetPos})
				tween:Play()

				tween.Completed:Connect(function()
					wait(1)
					fallToGround()
				end)

				-- Death message
				ReplicatedStorage.GameStats["Player_".. player.Name].Total.DeathCause.Value = "Shocker"
				firesignal(ReplicatedStorage.RemotesFolder.DeathHint.OnClientEvent, {
					"You died to who you call Shocker...",
					"Don't look at it or it stuns you!"
				}, "Blue")
			end
		else
			-- KhÙng nhÏn ? ng„ luÙn
			connection:Disconnect()
			fallToGround()
		end
	end)

	-- D? phÚng
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
 
