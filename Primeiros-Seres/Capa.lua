local composer = require("composer")

local scene = composer.newScene()

-- Variável global para controlar o som
local somLigado = false  -- Começa com som desligado
local somChannel  -- Variável para o canal de som

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Capa
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/Capa.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Botão para ir para a Page01
    local Avancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 150, 50)
    Avancar.x = 640
    Avancar.y = 930

    -- Adiciona um listener para o botão Avancar
    Avancar:addEventListener('tap', function()
        composer.gotoScene("page01", {effect = "fromRight", time = 1000})
    end)
    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Carrega o som da página 02
    local somCapa = audio.loadSound("assets/sounds/capa.mp3")

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            -- Desliga o som
            somLigado = false
            button.fill = { type = "image", filename = "assets/images/audio_off.png" } -- Muda a imagem para som desligado
            if somChannel then
                audio.pause(somChannel)
            end
        else
            -- Liga o som
            somLigado = true
            button.fill = { type = "image", filename = "assets/images/audio_on.png" } -- Muda a imagem para som ligado
            somChannel = audio.play(somCapa, { loops = -1 }) -- Toca em loop
        end
    end

    button:addEventListener("tap", toggleSound)

end


-- show()
function scene:show(event)
    local phase = event.phase

    if (phase == "will") then
        -- Nada aqui por enquanto
    elseif (phase == "did") then
        -- Nada aqui por enquanto
    end
end

-- hide()
function scene:hide(event)
    local phase = event.phase

    if (phase == "will") then
        -- Se o som estiver ligado, desliga ao sair da cena
        if somLigado then
            somLigado = false
            if somChannel then
                audio.stop(somChannel)
            end
        end
    elseif (phase == "did") then
        -- Nada aqui por enquanto
    end
end

-- destroy()
function scene:destroy(event)
    -- Remove o som e libera memória ao destruir a cena
    if somChannel then
        audio.stop(somChannel)
    end
    audio.dispose(somChannel)
    somChannel = nil
end
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
