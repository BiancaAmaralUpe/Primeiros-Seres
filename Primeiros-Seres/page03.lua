local composer = require("composer")

local scene = composer.newScene()

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page03.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona a imagem inicial 'eucarionte.png'
    local imgAtual = display.newImageRect(sceneGroup, "assets/images/eucarionte.png", 250, 250)
    imgAtual.x = 400
    imgAtual.y = 830

    -- Lista de imagens para alternar
    local imagens = {
        "assets/images/eucarionte.png",
        "assets/images/protozoario.png",
        "assets/images/alga.png",
        "assets/images/fungo.png"
    }

    local imagemIndex = 1  -- Índice para rastrear a imagem atual

    -- Função para alternar a imagem ao arrastar para a direita
    local function trocarImagem(event)
        if event.phase == "ended" and event.xStart < event.x then
            imagemIndex = imagemIndex + 1

            -- Se passar do final da lista, reinicia para a primeira imagem
            if imagemIndex > #imagens then
                imagemIndex = 1
            end

            -- Altera a imagem exibida
            imgAtual.fill = { type = "image", filename = imagens[imagemIndex] }
        end
    end

    -- Adiciona o evento de toque para arrastar a imagem
    imgAtual:addEventListener("touch", trocarImagem)

    -- Botão para voltar
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963

    function btnVoltar.handle(event)
        composer.gotoScene("page02", {effect = "fromLeft", time = 1000})
    end

    btnVoltar:addEventListener('tap', btnVoltar.handle)

    -- Botão para avançar
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963

    function btnAvancar.handle(event)
        composer.gotoScene("page04", {effect = "fromRight", time = 1000})
    end

    btnAvancar:addEventListener('tap', btnAvancar.handle)

    -- Botão para ligar e desligar o som
    local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)  
    button.x = 60
    button.y = 60

    -- Variável para controlar o estado do som
    local somLigado = false  -- Começa com som desligado

    -- Carrega o som da página 03
    local somCapa = audio.loadSound("assets/sounds/page03.mp3")

    -- Variável para controlar o canal de som
    local somChannel

    -- Função para ligar e desligar o som
    local function toggleSound()
        if somLigado then
            -- Desliga o som
            somLigado = false
            button.fill = { type="image", filename="assets/images/audio_off.png" }  -- Muda a imagem para som desligado
            if somChannel then
                audio.pause(somChannel)
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

-- show()
function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Aqui podemos verificar se há necessidade de pausar o som, caso ele tenha sido desligado antes
        if somChannel then
            audio.pause(somChannel) -- Pausa o som se ele estiver tocando
        end
    elseif (phase == "did") then
        -- Aqui também podemos verificar se o som deve ser iniciado, dependendo do estado de somLigado
        if somLigado then
            somChannel = audio.play(somCapa, { loops = -1 })
        end
    end
end

-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Quando a cena for ocultada, pausar o som se ele estiver tocando
        if somChannel then
            audio.pause(somChannel)
        end
    elseif (phase == "did") then
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
