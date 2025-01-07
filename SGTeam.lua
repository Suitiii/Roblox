--// Serviços
local Players = game:GetService("Players")

--// Obter jogador local
local localPlayer = Players.LocalPlayer

--// Parâmetros de destino e movimento
local targetPosition = Vector3.new(50, 5, 50)  -- Posição que você deseja alcançar
local stepSize = 2                             -- Tamanho do “bloco” em studs (distância de cada teleporte)
local waitTime = 0.1                           -- Tempo de espera entre cada passo (em segundos)

--// Função que move bloco por bloco
local function teleportBlockByBlock(targetPos, step, delayTime)
    -- Garante que o Character já existe
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart") -- Ponto central do personagem

    -- Pega a posição inicial
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude

    -- Se já estiver muito perto do destino
    if distance <= step then
        hrp.CFrame = CFrame.new(targetPos)
        return
    end

    -- Direção unitária (vetor normalizado do ponto atual até o destino)
    local direction = (targetPos - startPos).Unit

    -- Enquanto a distância para o destino for maior que o step...
    while (targetPos - hrp.Position).Magnitude > step do
        -- Calcula a nova posição, somando step na direção
        local newPos = hrp.Position + (direction * step)
        hrp.CFrame = CFrame.new(newPos)

        -- Espera um pouco antes de continuar
        task.wait(delayTime)
    end

    -- Quando estiver a menos de "step" de distância, vai direto ao destino final
    hrp.CFrame = CFrame.new(targetPos)
end

--// Exemplo de uso ao iniciar
teleportBlockByBlock(targetPosition, stepSize, waitTime)
