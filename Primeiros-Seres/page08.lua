local composer = require("composer")

local scene = composer.newScene()

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Page08
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page08.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona planeta.png 
    local planeta = display.newImageRect(sceneGroup, "assets/images/planeta.png", 300, 300)
    planeta.x = 380
    planeta.y = 800

    -- Adiciona os meteoros
    local meteoros = {}
    local meteoroPos = {
        {x = 100, y = 500},
        {x = 200, y = 400},
        {x = 150, y = 450},
        {x = 170, y = 340}
    }

    for i, pos in ipairs(meteoroPos) do
        local meteoro = display.newImageRect(sceneGroup, "assets/images/meteoro.png", 50, 50)
        meteoro.x = pos.x
        meteoro.y = pos.y
        meteoro.id = i
        meteoros[#meteoros + 1] = meteoro
    end

    local meteoroCount = #meteoros -- Contador de meteoros restantes

    -- Função para detectar colisão simples
    local function isColliding(obj1, obj2)
        local dx = obj1.x - obj2.x
        local dy = obj1.y - obj2.y
        local distance = math.sqrt(dx * dx + dy * dy)
        return distance < (obj1.width / 2 + obj2.width / 2)
    end

    -- Função de toque para arrastar meteoros
    local function dragMeteoro(event)
        local meteoro = event.target
        if event.phase == "began" then
            display.getCurrentStage():setFocus(meteoro)
            meteoro.isFocus = true
            meteoro.touchOffsetX = event.x - meteoro.x
            meteoro.touchOffsetY = event.y - meteoro.y
        elseif event.phase == "moved" and meteoro.isFocus then
            meteoro.x = event.x - meteoro.touchOffsetX
            meteoro.y = event.y - meteoro.touchOffsetY
        elseif event.phase == "ended" or event.phase == "cancelled" then
            if meteoro.isFocus then
                display.getCurrentStage():setFocus(nil)
                meteoro.isFocus = false

                -- Verifica colisão com o planeta
                if isColliding(meteoro, planeta) then
                    meteoro:removeSelf() -- Remove o meteoro
                    meteoro = nil
                    meteoroCount = meteoroCount - 1

                    -- Se todos os meteoros forem removidos, muda a imagem do planeta
                    if meteoroCount == 0 then
                        planeta.fill = { type = "image", filename = "assets/images/planeta2.png" }
                    end
                end
            end
        end
        return true
    end

    -- Adiciona listener de toque aos meteoros
    for _, meteoro in ipairs(meteoros) do
        meteoro:addEventListener("touch", dragMeteoro)
    end

    -- Botão para voltar
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963
    btnVoltar:addEventListener('tap', function()
        composer.gotoScene("page07", {effect = "fromLeft", time = 1000})
    end)

    -- Botão para avançar
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963
    btnAvancar:addEventListener('tap', function()
        composer.gotoScene("page09", {effect = "fromRight", time = 1000})
    end)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Variável para controlar o estado do som
    local somLigado = false

    local somCapa = audio.loadSound("assets/sounds/page08.mp3")
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
            composer.setVariable("somChannel", somChannel)  -- Salva o somChannel globalmente
        end
    end
    button:addEventListener("tap", toggleSound)
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Para o áudio quando a cena estiver sendo ocultada (ao mudar de cena)
        local somChannel = composer.getVariable("somChannel")
        if somChannel then
            audio.stop(somChannel)
        end
    elseif (phase == "did") then
        -- Não precisa fazer nada aqui, o áudio já foi parado
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    -- Para o áudio ao destruir a cena
    local somChannel = composer.getVariable("somChannel")
    if somChannel then
        audio.stop(somChannel)
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
