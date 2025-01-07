--// LocalScript em StarterPlayerScripts ou StarterCharacterScripts

-- Serviços
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")

-- Referências
local localPlayer = Players.LocalPlayer
local camera      = Workspace.CurrentCamera

-- GUI principal (ScreenGui) para acomodar os "nomes dos itens"
local mainGui = Instance.new("ScreenGui")
mainGui.Name = "ItemsNameGUI"
mainGui.ResetOnSpawn = false  -- Garante que a GUI não seja recriada ao respawnar
mainGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Pastas conforme o enunciado
local folder1 = Workspace:WaitForChild("Item_Spawns")
local folder2 = folder1:WaitForChild("Items") -- Pasta que contém os itens

-- Dicionário (tabela) para mapear Item -> TextLabel
local itemLabels = {}

-- Cria um TextLabel na tela para um "BasePart"
local function createLabelForPart(part: BasePart)
    local label = Instance.new("TextLabel")
    label.Name = "ItemNameLabel"
    label.Size = UDim2.new(0, 100, 0, 20)
    label.BackgroundTransparency = 0.4
    label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    label.BorderSizePixel = 0
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.SourceSansBold
    label.TextScaled = true
    label.Text = part.Name

    label.Parent = mainGui
    itemLabels[part] = label
end

-- Remove o TextLabel correspondente a um Part
local function removeLabelForPart(part: BasePart)
    local label = itemLabels[part]
    if label then
        label:Destroy()
        itemLabels[part] = nil
    end
end

-- Quando um "objeto" (item) é adicionado à pasta Items
local function onItemAdded(item: Instance)
    -- Se for uma peça (BasePart), criamos a label diretamente
    if item:IsA("BasePart") then
        createLabelForPart(item)

    -- Caso seja um Model, tentamos pegar a PrimaryPart (ou outra BasePart)
    elseif item:IsA("Model") then
        local primary = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
        if primary then
            createLabelForPart(primary)
        end
    end
end

-- Quando um "objeto" (item) é removido da pasta Items
local function onItemRemoved(item: Instance)
    -- Se for peça, removemos a label
    if item:IsA("BasePart") then
        removeLabelForPart(item)
    elseif item:IsA("Model") then
        local primary = item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")
        if primary then
            removeLabelForPart(primary)
        end
    end
end

-- Conectando eventos de ChildAdded e ChildRemoved na pasta Items
folder2.ChildAdded:Connect(onItemAdded)
folder2.ChildRemoved:Connect(onItemRemoved)

-- Para itens que já estão na pasta no momento em que o script inicia
for _, child in pairs(folder2:GetChildren()) do
    onItemAdded(child)
end

-- A cada frame, atualizamos a posição dos TextLabels na tela
RunService.RenderStepped:Connect(function()
    for part, label in pairs(itemLabels) do
        -- Checa se a part ainda existe e está no jogo
        if part and part.Parent then
            -- Converte posição 3D para posição 2D na tela
            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)

            if onScreen then
                -- Centraliza o label ligeiramente acima do objeto (y - 20)
                label.Visible = true
                label.Position = UDim2.new(0, screenPos.X - (label.AbsoluteSize.X / 2), 
                                           0, screenPos.Y - 20)
            else
                -- Se estiver fora da tela ou atrás do jogador, some
                label.Visible = false
            end
        else
            -- Se part já não está presente, some para evitar erro
            label.Visible = false
        end
    end
end)
