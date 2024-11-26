local composer = require("composer")

local scene = composer.newScene()

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
