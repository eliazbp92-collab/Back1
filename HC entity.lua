local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Paritvle = "https://github.com/eliazbp92-collab/Back1/raw/main/Place_131351567799504_Model_Model_1788016110.rbxm"
local cachedAttachmentTemplate = nil -- Lưu trữ model tạm thời vào bộ nhớ

-- Hàm tải model từ GitHub và cache lại
local function loadAndCacheModel(url)
	if not (writefile and getcustomasset and request) then return nil end
	local fileName = string.match(url, "([^/]+)$") or "temp_model.rbxm"
	
	-- Thử tải tối đa 3 lần nếu mạng chập chờn
	for attempt = 1, 3 do
		local success, response = pcall(function()
			return request({Url = url, Method = "GET"})
		end)
		
		if success and response and response.StatusCode == 200 then
			writefile(fileName, response.Body)
			local assetId = getcustomasset(fileName)
			local objSuccess, result = pcall(function() return game:GetObjects(assetId)[1] end)
			if objSuccess and result then
				return result
			end
		end
		task.wait(1)
	end
	return nil
end

-- Tiến hành tải trước Model ngay khi chạy script
task.spawn(function()
	cachedAttachmentTemplate = loadAndCacheModel(Paritvle)
	if cachedAttachmentTemplate then
		print("[Mod Script] Tải Model ParticleRush thành công!")
	else
		warn("[Mod Script] Không thể tải Model từ GitHub!")
	end
end)

local function setupUI()
	local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
	if not playerGui then return end

	local mainUI = playerGui:FindFirstChild("MainUI")
	if not mainUI then return end

	local jumpscareRush = mainUI:FindFirstChild("Jumpscare") and mainUI.Jumpscare:FindFirstChild("Jumpscare_Rush")
	if not jumpscareRush then return end

	local imageLabel = jumpscareRush:FindFirstChild("ImageLabel")
	local imageLabelBig = jumpscareRush:FindFirstChild("ImageLabelBig")

	if imageLabel then
		imageLabel.ImageColor3 = Color3.fromRGB(54, 29, 117)
		imageLabel.Image = "rbxassetid://16444302226"
	end

	pcall(function()
		mainUI.Initiator.Main_Game.RemoteListener.Jumpscares.Rush.Jumpscare_Rush2.PlaybackSpeed = 0.8
	end)

	if imageLabelBig then
		imageLabelBig.ImageColor3 = Color3.fromRGB(54, 29, 117)
		imageLabelBig.Image = "rbxassetid://16444316349"
	end

	if imageLabel then
		task.spawn(function()
			local origin = imageLabel.Position
			local frames = {
				"rbxassetid://16444302226",
				"rbxassetid://16444316349",
				"rbxassetid://16444302226",
				"rbxassetid://16444310736",
				"rbxassetid://16447907727"
			}
			local delayTime = 0.05

			while imageLabel and imageLabel.Parent do
				imageLabel.Position = origin + UDim2.new(0, math.random(-10, 10), 0, math.random(-10, 10))
				for _, assetId in ipairs(frames) do
					if not imageLabel or not imageLabel.Parent then break end
					imageLabel.Image = assetId
					task.wait(delayTime)
				end
			end
		end)
	end
end

local function processEntity(child)
	task.spawn(function()
		-- Xử lý AmbushMoving
		if child.Name == "AmbushMoving" then
			local rushNew = child:WaitForChild("RushNew", 10)
			if not rushNew then return end

			local attachment = rushNew:WaitForChild("Attachment", 10)
			if not attachment then return end

			local particle = attachment:WaitForChild("ParticleEmitter", 10)
			if particle then
				particle.Texture = "rbxassetid://122475073711766"
			end

		-- Xử lý RushMoving
		elseif child.Name == "RushMoving" then
			local rushNew = child:WaitForChild("RushNew", 10)
			if not rushNew then return end
			local attachment = rushNew:WaitForChild("Attachment", 3)
			local playSound = rushNew:WaitForChild("PlaySound", 3)

			if attachment then
				local particle = attachment:WaitForChild("ParticleEmitter", 3)
					
			if particle then
					particle.Texture = "rbxassetid://95186741213094"
					particle.Rate = 55
					particle.Brightness = 1
					particle.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
				end
			end
			
			local playSound = rushNew:WaitForChild("PlaySound", 5)
			local footsteps = rushNew:WaitForChild("Footsteps", 5)

			if playSound then
				playSound.PlaybackSpeed = 0.0605
			end
			if footsteps then
				footsteps.PlaybackSpeed = 0.17
			end

			-- Đợi tối đa 5 giây xem Model đã tải xong chưa (nếu vừa bật script)
			local waitTime = 0
			while not cachedAttachmentTemplate and waitTime < 5 do
				task.wait(0.2)
				waitTime = waitTime + 0.2
			end

			-- Thay thế Attachment
			if cachedAttachmentTemplate then
				local oldAttachment = rushNew:WaitForChild("Attachment", 5)
				
				local newAttachment = cachedAttachmentTemplate:Clone()
				newAttachment.Parent = rushNew
				
				if oldAttachment then
					oldAttachment:Destroy()
				end
			else
				warn("[Mod Script] Bỏ qua thay thế Attachment vì Model chưa tải được.")
			end
		end
	end)
end

-- Chạy UI
setupUI()

-- Kiểm tra các Entity đã có sẵn trong Workspace
for _, child in ipairs(workspace:GetChildren()) do
	processEntity(child)
end

-- Lắng nghe liên tục khi Rush/Ambush xuất hiện mới
workspace.ChildAdded:Connect(processEntity)
