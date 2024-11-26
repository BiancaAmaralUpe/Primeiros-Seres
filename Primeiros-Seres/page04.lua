local composer = require("composer")

local scene = composer.newScene()

-- Função para verificar se duas imagens estão sobrepondo
local function isOverlapping(obj1, obj2)
    local bounds1 = obj1.contentBounds
    local bounds2 = obj2.contentBounds

    return bounds1.xMin < bounds2.xMax
        and bounds1.xMax > bounds2.xMin
        and bounds1.yMin < bounds2.yMax
        and bounds1.yMax > bounds2.yMin
end

-- Função para calcular a próxima posição abaixo de CE ou CP
local function getNextPosition(base, itemList, offsetY)
    local count = #itemList
    return base.y + (count + 1) * offsetY
end

-- create()
function scene:create(event)
    local sceneGroup = self.view

    -- Carrega a imagem de fundo
    local imgCapa = display.newImageRect(sceneGroup, "assets/images/page04.png", display.contentWidth, display.contentHeight)
    imgCapa.x = display.contentCenterX
    imgCapa.y = display.contentCenterY

    -- Adiciona a imagem CE.png
    local imgCE = display.newImageRect(sceneGroup, "assets/images/CE.png", 150, 50)
    imgCE.x = 600
    imgCE.y = 650

    -- Adiciona a imagem CP.png
    local imgCP = display.newImageRect(sceneGroup, "assets/images/CP.png", 150, 50)
    imgCP.x = 150
    imgCP.y = 650

    -- Listas para rastrear as posições ocupadas em CE e CP
    local ceItems = {}
    local cpItems = {}

    -- Adiciona as imagens novas
    local images = {
        {file = "euca1.png", x = 300, y = 300, group = "CE"},
        {file = "euca2.png", x = 450, y = 480, group = "CE"},
        {file = "euca3.png", x = 550, y = 320, group = "CE"},
        {file = "proca1.png", x = 340, y = 400, group = "CP"},
        {file = "proca2.png", x = 400, y = 320, group = "CP"},
        {file = "proca3.png", x = 480, y = 390, group = "CP"}
    }

    local draggableImages = {}

    -- Função para manipular o movimento das imagens
    local function startDrag(event)
        local target = event.target

        if event.phase == "began" then
            display.getCurrentStage():setFocus(target)
            target.isFocus = true
            target.markX = target.x
            target.markY = target.y
        elseif event.phase == "moved" and target.isFocus then
            target.x = event.x - (event.xStart - target.markX)
            target.y = event.y - (event.yStart - target.markY)
        elseif event.phase == "ended" or event.phase == "cancelled" then
            display.getCurrentStage():setFocus(nil)
            target.isFocus = false

            -- Verifica se está sobre CE e se pertence ao grupo CE
            if isOverlapping(target, imgCE) and target.group == "CE" then
                target.x = imgCE.x
                target.y = getNextPosition(imgCE, ceItems, 70)
                table.insert(ceItems, target)
            -- Verifica se está sobre CP e se pertence ao grupo CP
            elseif isOverlapping(target, imgCP) and target.group == "CP" then
                target.x = imgCP.x
                target.y = getNextPosition(imgCP, cpItems, 70)
                table.insert(cpItems, target)
            else
                -- Retorna à posição inicial
                target.x = target.markX
                target.y = target.markY
            end
        end

        return true
    end

    -- Cria as imagens e adiciona o evento de arrastar
    for i, imgData in ipairs(images) do
        local img = display.newImageRect(sceneGroup, "assets/images/" .. imgData.file, 100, 100)
        img.x = imgData.x
        img.y = imgData.y
        img.group = imgData.group -- Define o grupo ao qual a imagem pertence (CE ou CP)
        img:addEventListener("touch", startDrag)
        table.insert(draggableImages, img)
    end

    -- Botão para voltar
    local btnVoltar = display.newImageRect(sceneGroup, "assets/images/anterior.png", 141, 50)
    btnVoltar.x = 100
    btnVoltar.y = 963

    function btnVoltar.handle(event)
        composer.gotoScene("page03", {effect = "fromLeft", time = 1000})
    end

    btnVoltar:addEventListener('tap', btnVoltar.handle)

    -- Botão para avançar
    local btnAvancar = display.newImageRect(sceneGroup, "assets/images/proximo.png", 141, 50)
    btnAvancar.x = 662
    btnAvancar.y = 963

    function btnAvancar.handle(event)
        composer.gotoScene("page05", {effect = "fromRight", time = 1000})
    end

    btnAvancar:addEventListener('tap', btnAvancar.handle)
     -- Botão para ligar e desligar o som
     local button = display.newImageRect(sceneGroup, "assets/images/audio_off.png", 110, 110)  
     button.x = 60
     button.y = 60
 
     -- Variável para controlar o estado do som
     local somLigado = false  -- Começa com som desligado
 
     -- Carrega o som da página 02
     local somCapa = audio.loadSound("assets/sounds/page04.mp3")
 
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


-- hide()
function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
        -- Verifica se o som está tocando e o para completamente
        if somChannel then
            audio.stop(somChannel)  -- Para o som
            audio.dispose(somCapa)  -- Libera os recursos do som
        end
    elseif (phase == "did") then
        -- Garantir que o som seja parado na transição
        if somChannel then
            audio.stop(somChannel)  -- Garantir que o som seja interrompido
        end
    end
end

-- destroy()
function scene:destroy(event)
    local sceneGroup = self.view

    -- Remove a música ao destruir a cena
    if somChannel then
        audio.stop(somChannel)
        audio.dispose(somCapa)  -- Libera a memória do som carregado
    end

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
