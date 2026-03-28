-- Notepad GUI with Scroll TextBox (Delta Compatible)

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "NotepadGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Notepad"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.TextSize = 20
title.Font = Enum.Font.SourceSansBold

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Position = UDim2.new(0, 10, 0, 40)
scroll.Size = UDim2.new(1, -20, 0, 170)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarImageColor3 = Color3.fromRGB(180, 180, 180)
scroll.ScrollBarThickness = 6
scroll.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
scroll.BorderSizePixel = 0
Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 8)

-- TextBox inside Scroll
local box = Instance.new("TextBox", scroll)
box.Size = UDim2.new(1, -5, 0, 170)
box.Position = UDim2.new(0, 5, 0, 5)
box.BackgroundTransparency = 1
box.TextColor3 = Color3.fromRGB(0, 0, 0)
box.Font = Enum.Font.Code
box.TextSize = 16
box.Text = ""
box.PlaceholderText = "Write Message Here.."
box.TextWrapped = true
box.TextYAlignment = Enum.TextYAlignment.Top
box.MultiLine = true
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left

-- Auto Resize Canvas when typing
local function updateCanvas()
    local textSize = game:GetService("TextService"):GetTextSize(
        box.Text,
        box.TextSize,
        box.Font,
        Vector2.new(scroll.AbsoluteSize.X - 10, math.huge)
    )

    box.Size = UDim2.new(1, -10, 0, textSize.Y + 20)
    scroll.CanvasSize = UDim2.new(0, 0, 0, box.AbsoluteSize.Y + 10)
end

box:GetPropertyChangedSignal("Text"):Connect(updateCanvas)

-- Button creator
local function makeButton(name, pos, text)
	local btn = Instance.new("TextButton", frame)
	btn.Name = name
	btn.Size = UDim2.new(0.23, 0, 0, 30)
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(230, 230, 230)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 14
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local saveBtn = makeButton("Save", UDim2.new(0.04, 0, 1, -35), "Save")
local loadBtn = makeButton("Load", UDim2.new(0.27, 0, 1, -35), "Load")
local copyBtn = makeButton("Copy", UDim2.new(0.50, 0, 1, -35), "Copy")
local destroyBtn = makeButton("Destroy", UDim2.new(0.73, 0, 1, -35), "X")
local deleteBtn = makeButton("Delete", UDim2.new(0.04, 0, 1, -70), "Delete")

local fileName = "notepad_save.txt"

-- Functions
saveBtn.MouseButton1Click:Connect(function()
	if writefile then
		writefile(fileName, box.Text)
	end
end)

loadBtn.MouseButton1Click:Connect(function()
	if isfile and isfile(fileName) then
		box.Text = readfile(fileName)
		updateCanvas()
	end
end)

copyBtn.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(box.Text)
	end
end)

deleteBtn.MouseButton1Click:Connect(function()
	box.Text = ""
	updateCanvas()
end)

destroyBtn.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

updateCanvas()
