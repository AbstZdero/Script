-- Walkspeed Hub
-- With +1 / -1 Buttons
-- No while true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

local TARGET_SPEED = 30
local ENABLED = false
local LOOP_ENABLED = false
local loopConnection

local character
local humanoid

-- ===== Character Setup =====
local function setupCharacter(char)
	character = char
	humanoid = char:WaitForChild("Humanoid")

	if ENABLED and humanoid then
		humanoid.WalkSpeed = TARGET_SPEED
	end
end

if player.Character then
	setupCharacter(player.Character)
end

player.CharacterAdded:Connect(setupCharacter)

-- ===== GUI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WalkSpeedGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Open Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 120, 0, 40)
openBtn.Position = UDim2.new(0, 20, 0.5, -20)
openBtn.Text = "WalkSpeed"
openBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Parent = screenGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 270, 0, 220)
frame.Position = UDim2.new(0.5, -135, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Walkspeed Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = frame

-- Toggle Button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 35)
toggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
toggleBtn.Text = "WalkSpeed: OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Parent = frame

-- Loop Button
local loopBtn = Instance.new("TextButton")
loopBtn.Size = UDim2.new(0.8, 0, 0, 35)
loopBtn.Position = UDim2.new(0.1, 0, 0.45, 0)
loopBtn.Text = "Loop WalkSpeed: OFF"
loopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
loopBtn.TextColor3 = Color3.new(1,1,1)
loopBtn.Parent = frame

-- Speed Input Box
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.5, 0, 0, 30)
speedBox.Position = UDim2.new(0.25, 0, 0.7, 0)
speedBox.Text = tostring(TARGET_SPEED)
speedBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
speedBox.TextColor3 = Color3.new(1,1,1)
speedBox.Parent = frame

-- + Button
local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0, 40, 0, 30)
plusBtn.Position = UDim2.new(0.8, 0, 0.7, 0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
plusBtn.TextColor3 = Color3.new(1,1,1)
plusBtn.Parent = frame

-- - Button
local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0, 40, 0, 30)
minusBtn.Position = UDim2.new(0.05, 0, 0.7, 0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
minusBtn.TextColor3 = Color3.new(1,1,1)
minusBtn.Parent = frame

-- ===== Functions =====

local function updateSpeed()
	speedBox.Text = tostring(TARGET_SPEED)
	if humanoid then
		humanoid.WalkSpeed = TARGET_SPEED
	end
end

-- Open / Close
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Toggle
toggleBtn.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	
	if ENABLED then
		toggleBtn.Text = "WalkSpeed: ON"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
		updateSpeed()
	else
		toggleBtn.Text = "WalkSpeed: OFF"
		toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
		if humanoid then
			humanoid.WalkSpeed = 16
		end
	end
end)

-- Loop Toggle
loopBtn.MouseButton1Click:Connect(function()
	LOOP_ENABLED = not LOOP_ENABLED
	
	if LOOP_ENABLED then
		loopBtn.Text = "Loop WalkSpeed: ON"
		loopBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
		
		loopConnection = RunService.Heartbeat:Connect(function()
			if humanoid then
				humanoid.WalkSpeed = TARGET_SPEED
			end
		end)
	else
		loopBtn.Text = "Loop WalkSpeed: OFF"
		loopBtn.BackgroundColor3 = Color3.fromRGB(120,0,0)
		
		if loopConnection then
			loopConnection:Disconnect()
			loopConnection = nil
		end
	end
end)

-- Enter to Set Speed
speedBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		local num = tonumber(speedBox.Text)
		if num then
			TARGET_SPEED = math.clamp(num, 1, 200)
			updateSpeed()
		end
	end
end)

-- +1 Speed
plusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED + 1, 1, 200)
	updateSpeed()
end)

-- -1 Speed
minusBtn.MouseButton1Click:Connect(function()
	TARGET_SPEED = math.clamp(TARGET_SPEED - 1, 1, 200)
	updateSpeed()
end)
