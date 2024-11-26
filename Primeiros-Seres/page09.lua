local composer = require("composer")

local scene = composer.newScene()

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Page08
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page09.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Botão para voltar
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963
    btnVoltar:addEventListener('tap', function()
        composer.gotoScene("page08", {effect = "fromLeft", time = 1000})
    end)

    -- Botão para avançar
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963
    btnAvancar:addEventListener('tap', function()
        composer.gotoScene("Contracapa", {effect = "fromRight", time = 1000})
    end)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Variável para controlar o estado do som
    local somLigado = false

    -- Carrega o som
    local somCapa = audio.loadSound("assets/sounds/referencias.mp3")
    local somChannel

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            somLigado = false
            button.fill = { type = "image", filename = "assets/images/audio_off.png" }
            if somChannel then
                audio.pause(somChannel)
            end
        else
            somLigado = true
            button.fill = { type = "image", filename = "assets/images/audio_on.png" }
            somChannel = audio.play(somCapa, { loops = -1 })
        end
    end
    button:addEventListener("tap", toggleSound)
end

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then

    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then

    elseif (phase == "did") then
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    sceneGroup:removeSelf()
    sceneGroup = nil
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
