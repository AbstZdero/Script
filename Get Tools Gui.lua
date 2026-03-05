-- Local Script with all Tools
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")
local toolsFolder = ReplicatedStorage:WaitForChild("Tools")

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GetToolsGui"
ScreenGui.ResetOnSpawn = false

-- Put GUI in CoreGui if using an executor, otherwise PlayerGui
if gethui then
	ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
	syn.protect_gui(ScreenGui)
	ScreenGui.Parent = game:GetService("CoreGui")
else
	ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

---------------------------------------------------------
-- NEW: OPEN / CLOSE TOGGLE BUTTON
---------------------------------------------------------
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "OpenCloseButton"
ToggleButton.Size = UDim2.new(0, 100, 0, 40)
ToggleButton.Position = UDim2.new(0, 15, 0.5, -20) -- Placed on the left side
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.Text = "Close GUI"
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 8)
ToggleCorner.Parent = ToggleButton

-- Make the Toggle Button Draggable
local togDragging, togDragInput, togDragStart, togStartPos
ToggleButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		togDragging = true
		togDragStart = input.Position
		togStartPos = ToggleButton.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				togDragging = false
			end
		end)
	end
end)
ToggleButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		togDragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == togDragInput and togDragging then
		local delta = input.Position - togDragStart
		ToggleButton.Position = UDim2.new(togStartPos.X.Scale, togStartPos.X.Offset + delta.X, togStartPos.Y.Scale, togStartPos.Y.Offset + delta.Y)
	end
end)
---------------------------------------------------------

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Position = UDim2.new(0.5, -125, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
MainFrame.Visible = true -- Starts visible

-- Toggle Button Logic
ToggleButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
	if MainFrame.Visible then
		ToggleButton.Text = "Close GUI"
	else
		ToggleButton.Text = "Open GUI"
	end
end)

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, 0, 0, 40)
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleLabel.BorderSizePixel = 0
TitleLabel.Text = "Get Tools Gui"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.Parent = MainFrame

-- Make the GUI Main Frame draggable
local dragging, dragInput, dragStart, startPos
TitleLabel.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
TitleLabel.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Scrolling Frame for buttons
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = ScrollFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Auto-adjust scrolling frame size based on buttons
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end)

-- UIPadding to keep buttons away from edges
local UIPadding = Instance.new("UIPadding")
UIPadding.PaddingTop = UDim.new(0, 3)
UIPadding.Parent = ScrollFrame

-- Function to create buttons
local function createButton(name, color, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0.9, 0, 0, 30)
	button.BackgroundColor3 = color
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamSemibold
	button.TextSize = 14
	button.Text = name
	button.Parent = ScrollFrame
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 5)
	corner.Parent = button

	button.MouseButton1Click:Connect(callback)
end

-- 1. DELETE ALL TOOLS BUTTON
createButton("❌ Delete All Tools", Color3.fromRGB(180, 40, 40), function()
	-- Delete tools from Backpack
	for _, item in ipairs(player.Backpack:GetChildren()) do
		if item:IsA("Tool") then
			item:Destroy()
		end
	end
	-- Delete currently equipped tool from Character
	if player.Character then
		for _, item in ipairs(player.Character:GetChildren()) do
			if item:IsA("Tool") then
				item:Destroy()
			end
		end
	end
end)

-- Tool List
local toolsList = {
	"WorldCuttingSlash",
	"HollowPurple",
	"SeriousPunch",
	"Smash",
	"MaximumEnergy",
	"ChargedEnergyPunch",
	"EnergyPunchII",
	"EnergyPunch",
	"BlackFlash",
	"ForcingPunch",
	"GroundSlam",
	"HeavyPunch",
	"StrongPunch"
}

-- 2. ADD TOOL BUTTONS
for _, toolName in ipairs(toolsList) do
	createButton(toolName, Color3.fromRGB(60, 60, 60), function()
		local tool = toolsFolder:FindFirstChild(toolName)
		if tool then
			-- Clone the tool and put it in the player's backpack
			local clonedTool = tool:Clone()
			clonedTool.Parent = player.Backpack
		else
			warn("Tool not found in ReplicatedStorage.Tools: " .. toolName)
		end
	end)
end
