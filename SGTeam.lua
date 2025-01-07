-- Obtém o serviço de HTTP do Roblox
local HttpService = game:GetService("HttpService")

-- URL do seu site que retorna o echo
local siteURL = "https://swetsu.com/Downloader.php"

-- Dados que vamos enviar no POST
local dataToSend = {
    mensagem = "Olá do Roblox!"
}

-- Transformar os dados em JSON
local jsonData = HttpService:JSONEncode(dataToSend)

-- Realiza a requisição POST
local sucesso, resposta = pcall(function()
    return HttpService:PostAsync(siteURL, jsonData, Enum.HttpContentType.ApplicationJson)
end)

-- Verifica se houve sucesso
if sucesso then
    print("Resposta do servidor:", resposta)
else
    warn("Falha ao realizar a requisição:", resposta)
end
