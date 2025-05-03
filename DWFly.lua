local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local humRoot = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

local UIS = game:GetService("UserInputService")
local flying = false
local speed = 0
local maxspeed = 50

-- Tạo lực bay
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)

local bodyVelocity = Instance.new("BodyVelocity")
bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

-- Giao diện nút Fly
local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
screenGui.Name = "MobileFlyGui"

local flyButton = Instance.new("TextButton", screenGui)
flyButton.Size = UDim2.new(0, 100, 0, 50)
flyButton.Position = UDim2.new(1, -110, 1, -60)
flyButton.Text = "Fly"
flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Font = Enum.Font.GothamBold
flyButton.TextSize = 22

-- Hàm bay
function Fly()
	bodyGyro.Parent = humRoot
	bodyVelocity.Parent = humRoot

	while flying do
		local cam = workspace.CurrentCamera
		local moveDir = humanoid.MoveDirection

		-- Bay theo hướng joystick
		if moveDir.Magnitude > 0 then
			speed = math.min(speed + 1, maxspeed)
			bodyVelocity.Velocity = cam.CFrame:VectorToWorldSpace(moveDir.Unit) * speed
		else
			speed = math.max(speed - 1, 0)
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
		end

		bodyGyro.CFrame = cam.CFrame
		task.wait()
	end

	bodyGyro.Parent = nil
	bodyVelocity.Parent = nil
end

-- Bật/tắt bay khi nhấn nút
flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		Fly()
	end
end)

-- Dành cho PC: bật/tắt bay bằng phím X
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.X then
		flying = not flying
		if flying then
			Fly()
		end
	end
end)
