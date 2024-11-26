local composer = require("composer")

local scene = composer.newScene()

-- Variáveis globais para os botões e imagem de fundo
local imgCapa, button, btnVoltar, btnAvancar

-- Variáveis para o controle do som
local somLigado = false  -- Começa com som desligado
local somChannel -- Variável para controlar o canal de som

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    imgCapa = display.newImageRect(sceneGroup, "assets/images/page06.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona a imagem do cientista
    local cientista = display.newImageRect(sceneGroup, "assets/images/cientista.png", 90, 100)
    cientista.x = 90
    cientista.y = 350

    -- Função para alterar o fundo quando o cientista for clicado
    local function mudarFundo()
        -- Verifica se imgCapa existe e remove a imagem de fundo anterior
        if imgCapa then
            imgCapa:removeSelf()  -- Remove a imagem de fundo antiga
            imgCapa = nil
        end
        imgCapa = display.newImageRect(sceneGroup, "assets/images/fundo1.png", display.contentWidth, display.contentHeight)  -- Carrega a nova imagem de fundo
        imgCapa.x = display.contentCenterX
        imgCapa.y = display.contentCenterY

        local igual = display.newImageRect(sceneGroup, "assets/images/igual.png", 20, 20)
        igual.x = 660
        igual.y = 600

        -- Função para exibir a imagem inicio.png ao clicar em igual.png
        local function mostrarInicio()
            local inicio = display.newImageRect(sceneGroup, "assets/images/inicio.png", 180, 180)
            inicio.x = 400
            inicio.y = 800
        end

        -- Adiciona o evento de toque na imagem igual
        igual:addEventListener("tap", mostrarInicio)

        -- Reposicionar os botões após a troca do fundo
        button.x = 60
        button.y = 60

        btnAvancar.x = 662
        btnAvancar.y = 963

        btnVoltar.x = 100
        btnVoltar.y = 963

        -- Adiciona novamente os botões ao grupo da cena para garantir que eles apareçam
        sceneGroup:insert(button)
        sceneGroup:insert(btnAvancar)
        sceneGroup:insert(btnVoltar)
    end

    -- Adiciona o evento de clique para o cientista
    cientista:addEventListener('tap', mudarFundo)

    -- Botão para voltar
    btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963

    function btnVoltar.handle(event)
        composer.gotoScene("page05", {effect = "fromLeft", time = 1000})
    end

    btnVoltar:addEventListener('tap', btnVoltar.handle)

    -- Botão para avançar
    btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963

    function btnAvancar.handle(event)
        composer.gotoScene("page07", {effect = "fromRight", time = 1000})
    end

    btnAvancar:addEventListener('tap', btnAvancar.handle)

    -- Botão para ligar e desligar o som
    button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)
    button.x = 60
    button.y = 60

    -- Carrega o som da página 02
    local somCapa = audio.loadSound("assets/sounds/page06.mp3")

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

    -- Adiciona o evento de clique para o botão de som
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
        end
    elseif (phase == "did") then
        -- Código para quando a cena já desapareceu
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view
    -- Limpeza de objetos e variáveis da cena
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
