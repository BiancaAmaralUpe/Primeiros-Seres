local composer = require("composer")

local scene = composer.newScene()

-- Variável global para controlar o som
local somLigado = false  -- Começa com som desligado
local somChannel  -- Variável para o canal de som

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Page02
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page01.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona a imagem "tempo.png"
    local imgTempo = display.newImageRect(sceneGroup, "assets/images/tempo.png", 500, 300)
    imgTempo.x = 400
    imgTempo.y = 780
    imgTempo:setMask(graphics.newMask("assets/images/tempo.png")) 

    -- Função para permitir que a imagem seja arrastada horizontalmente
    local function dragImage(event)
        if event.phase == "began" then
            display.currentStage:setFocus(event.target)
            event.target.touchOffsetX = event.x - event.target.x
        elseif event.phase == "moved" then
            event.target.width = math.min(600, math.max(300, event.x - event.target.x + 300)) -- Atualiza a largura da imagem
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.currentStage:setFocus(nil)
        end
        return true
    end

    -- Adiciona o listener de toque na imagem para arrastar
    imgTempo:addEventListener("touch", dragImage)

    -- Animação inicial para mostrar como interagir
    transition.to(imgTempo, {time = 1000, width = 350, onComplete = function()
        transition.to(imgTempo, {time = 1000, width = 300})
    end})

    -- Botão para voltar para a Capa
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963

    function btnVoltar.handle(event)
        composer.gotoScene("Capa", {effect = "fromLeft", time = 1000})
    end

    btnVoltar:addEventListener('tap', btnVoltar.handle)

    -- Botão para ir para a Page03
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963

    function btnAvancar.handle(event)
        composer.gotoScene("page02", {effect = "fromRight", time = 1000})
    end

    btnAvancar:addEventListener('tap', btnAvancar.handle)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Carrega o som da página 02
    local somCapa = audio.loadSound("assets/sounds/page01.mp3")

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
