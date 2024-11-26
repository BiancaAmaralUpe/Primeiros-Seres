local composer = require("composer")

local scene = composer.newScene()

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem da Page02
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page05.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona a imagem carne.png
    local carne = display.newImageRect(sceneGroup, "assets/images/carne.png", 150, 150)
    carne.x = 400
    carne.y = 800

    -- Função para iniciar o arraste das moscas
    local function startDrag(event)
        local t = event.target

        if event.phase == "began" then
            display.getCurrentStage():setFocus(t)
            t.isFocus = true

            -- Salva a posição inicial
            t.x0 = event.x - t.x
            t.y0 = event.y - t.y

        elseif event.phase == "moved" and t.isFocus then
            -- Move a mosca
            t.x = event.x - t.x0
            t.y = event.y - t.y0

        elseif event.phase == "ended" or event.phase == "cancelled" then
            if t.isFocus then
                display.getCurrentStage():setFocus(nil)
                t.isFocus = false

                -- Verifica se a mosca está sobre a carne
                local dx = math.abs(t.x - carne.x)
                local dy = math.abs(t.y - carne.y)
                if dx < carne.width / 2 and dy < carne.height / 2 then
                    -- Posiciona a mosca na carne, mas com um deslocamento para evitar sobreposição
                    local offsetX = math.random(-30, 30)
                    local offsetY = math.random(-30, 30)
                    t.x = carne.x + offsetX
                    t.y = carne.y + offsetY
                end
            end
        end
        return true
    end

    -- Adiciona as imagens mosca.png nas coordenadas especificadas
    local moscas = {
        {x = 200, y = 200},
        {x = 200, y = 150},
        {x = 50, y = 280},
        {x = 70, y = 220},
        {x = 120, y = 320},
        {x = 150, y = 380}
    }

    for _, pos in ipairs(moscas) do
        local mosca = display.newImageRect(sceneGroup, "assets/images/mosca.png", 50, 50)
        mosca.x = pos.x
        mosca.y = pos.y
        mosca:addEventListener("touch", startDrag) -- Adiciona o evento de arraste
    end

    -- Botão para voltar para a Capa
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963

    function btnVoltar.handle(event)
        composer.gotoScene("page04", {effect = "fromLeft", time = 1000})
    end

    btnVoltar:addEventListener('tap', btnVoltar.handle)

    -- Botão para ir para a Page03
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963

    function btnAvancar.handle(event)
        composer.gotoScene("page06", {effect = "fromRight", time = 1000})
    end

    btnAvancar:addEventListener('tap', btnAvancar.handle)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)  
    button.x = 60
    button.y = 60

    -- Variável para controlar o estado do som
    local somLigado = false  -- Começa com som desligado

    -- Carrega o som da página 02
    local somCapa = audio.loadSound("assets/sounds/page05.mp3")

    -- Variável para controlar o canal de som
    local somChannel

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            -- Desliga o som
            somLigado = false
            button.fill = { type="image", filename="assets/images/audio_off.png" }  -- Muda a imagem para som desligado
            if somChannel then
                audio.stop(somChannel)  -- Para o som
                somChannel = nil  -- Limpa o canal de som
            end
        else
            -- Liga o som
            somLigado = true
            button.fill = { type="image", filename="assets/images/audio_on.png" }  -- Muda a imagem para som ligado
            somChannel = audio.play(somCapa, { loops = -1 })  -- Toca em loop
        end
    end
    button:addEventListener("tap", toggleSound)
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Quando a cena está prestes a desaparecer, parar o som se estiver tocando
        if somChannel then
            audio.stop(somChannel)  -- Para o som ao mudar de página
            somChannel = nil  -- Limpa a variável do canal de som
        end
    elseif (phase == "did") then
        -- Código para quando a cena já desapareceu
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    
    sceneGroup:removeSelf()
    sceneGroup = nil
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
