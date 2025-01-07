--// LocalScript em StarterPlayerScripts

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Obter o jogador local
local localPlayer = Players.LocalPlayer

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PositionDisplay"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Criar TextLabel
local textLabel = Instance.new("TextLabel")
textLabel.Name = "PositionLabel"
textLabel.Size = UDim2.new(0, 200, 0, 40)
textLabel.Position = UDim2.new(0, 10, 0, 10)  -- Canto superior esquerdo
textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
textLabel.BackgroundTransparency = 0.3
textLabel.BorderSizePixel = 0
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.TextScaled = true
textLabel.Font = Enum.Font.SourceSansBold
textLabel.Text = "Pos: 0, 0, 0"  -- Inicial
textLabel.Parent = screenGui

-- Função para atualizar texto com a posição
local function updatePosition()
    local character = localPlayer.Character
    if not character then return end

    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local pos = hrp.Position
    textLabel.Text = string.format("Pos: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
end

-- Atualiza a cada frame
RunService.RenderStepped:Connect(updatePosition)
