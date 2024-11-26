composer = require("composer")

local scene = composer.newScene()

-- Variáveis globais de som (fora do método create para garantir que sejam acessíveis por toda a cena)
local somChannel
local somCapa
local somLigado = false

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Page07
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page07.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona sopa.png
    local sopa = display.newImageRect(sceneGroup, "assets/images/sopa.png", 120, 120)
    sopa.x = 390
    sopa.y = 750
    sceneGroup:insert(sopa)

    -- Função para verificar colisão
    local function isOverlapping(obj1, obj2)
        local xDiff = math.abs(obj1.x - obj2.x)
        local yDiff = math.abs(obj1.y - obj2.y)
        return xDiff < (obj1.width / 2 + obj2.width / 2) and yDiff < (obj1.height / 2 + obj2.height / 2)
    end

    -- Função para permitir arrastar elementos
    local function makeDraggable(element)
        local function onTouch(event)
            if event.phase == "began" then
                display.currentStage:setFocus(element)
                element.isFocus = true
                element.touchOffsetX = event.x - element.x
                element.touchOffsetY = event.y - element.y
            elseif event.phase == "moved" and element.isFocus then
                element.x = event.x - element.touchOffsetX
                element.y = event.y - element.touchOffsetY
            elseif event.phase == "ended" or event.phase == "cancelled" then
                if element.isFocus then
                    display.currentStage:setFocus(nil)
                    element.isFocus = false

                    -- Verifica se o elemento foi levado até a sopa
                    if isOverlapping(element, sopa) then
                        element:removeSelf() -- Remove o elemento
                    end
                end
            end
            return true
        end

        element:addEventListener("touch", onTouch)
    end

    -- Adiciona calor.png
    local calor = display.newImageRect(sceneGroup, "assets/images/calor.png", 100, 100)
    calor.x = 240
    calor.y = 320
    makeDraggable(calor)

    -- Adiciona raios.png
    local raios = display.newImageRect(sceneGroup, "assets/images/raios.png", 100, 100)
    raios.x = 100
    raios.y = 600
    makeDraggable(raios)

    -- Adiciona agua.png
    local agua = display.newImageRect(sceneGroup, "assets/images/agua.png", 70, 80)
    agua.x = 250
    agua.y = 520
    makeDraggable(agua)

    -- Adiciona molecula.png
    local molecula = display.newImageRect(sceneGroup, "assets/images/molecula.png", 90, 90)
    molecula.x = 80
    molecula.y = 400
    makeDraggable(molecula)

    -- Botão para voltar
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963
    btnVoltar:addEventListener('tap', function()
        composer.gotoScene("page06", {effect = "fromLeft", time = 1000})
    end)

    -- Botão para avançar
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963
    btnAvancar:addEventListener('tap', function()
        composer.gotoScene("page08", {effect = "fromRight", time = 1000})
    end)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Carrega o som
    somCapa = audio.loadSound("assets/sounds/page07.mp3")

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

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Pausa ou para o áudio ao mudar de página
        if somChannel then
            audio.stop(somChannel)
            somChannel = nil  -- Garante que o canal de áudio seja limpo
        end
    elseif (phase == "did") then
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    -- Garantir que o áudio seja interrompido também ao destruir a cena
    if somChannel then
        audio.stop(somChannel)
        somChannel = nil  -- Limpa o canal de áudio
    end

    -- Limpeza de recursos
    if somCapa then
        audio.dispose(somCapa)
        somCapa = nil
    end

    sceneGroup:removeSelf()
    sceneGroup = nil
end

-- Scene event function listeners
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
