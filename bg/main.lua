function isButtonClicked(mouseX, mouseY, buttonX, buttonY, buttonRadius)
  return (mouseX - buttonX)^2 + (mouseY - buttonY)^2 < buttonRadius^2
end

function randomizePosition(button)
  local width, height = love.graphics.getDimensions()
  button.x = math.random(button.radius, width - button.radius)
  button.y = math.random(button.radius, height - button.radius)
end

function love.load(arg)
  love.math.setRandomSeed(os.time())

  local LEFT_MOUSE_BUTTON = 1
  local GAMEPLAY_TIME = 10
  local BUTTON_DISPLAY_TIME = 2

  love.graphics.setFont(love.graphics.newFont(30))

  button = {}
  button.x = 0
  button.y = 0
  button.radius = 20
  button.color = {255/255, 0, 0, 1}
  button.displayTimeLeft = BUTTON_DISPLAY_TIME

  panel = {}
  panel.points = {}
  panel.timer = {}
  panel.message = "Press any key to start a game"

  panel.points.value = 0
  panel.timer.value = GAMEPLAY_TIME

  panel.draw = function ()
    love.graphics.printf(string.format("Points: %.0f", panel.points.value), 0, 0, 300, "left")
    love.graphics.printf(string.format("Time: %.0f", panel.timer.value), 300, 0, 300, "left")
  end

  gameState = {}
  gameState.state = {}


  menuState = {}
  menuState.update = function (dt)
    if love.mouse.isDown(LEFT_MOUSE_BUTTON) then
      gameState.state = gameplayState
      gameState.state.init()
    end
  end
  menuState.draw = function ()
    panel.draw()

    local width, height = love.graphics.getDimensions()
    love.graphics.printf(panel.message, width/2.0, height/2.0, 300, "center")
  end


  gameplayState = {}
  gameplayState.init = function()
    randomizePosition(button)
  end
  gameplayState.update = function (dt)
    panel.timer.value = panel.timer.value - dt
    if panel.timer.value < 0 then
      panel.timer.value = GAMEPLAY_TIME
      panel.message = string.format("Last game points: %.0f", panel.points.value) .. ". Press any key to start a game"
      panel.points.value = 0

      gameState.state = menuState
    end

    if button.displayTimeLeft <= 0 then
      randomizePosition(button)
      button.displayTimeLeft = BUTTON_DISPLAY_TIME
    else
      button.displayTimeLeft = button.displayTimeLeft - dt
    end

    if love.mouse.isDown(LEFT_MOUSE_BUTTON) then
      if isButtonClicked(love.mouse.getX(), love.mouse.getY(), button.x, button.y, button.radius) then
        panel.points.value = panel.points.value + button.displayTimeLeft * 1000

        randomizePosition(button)
        button.displayTimeLeft = BUTTON_DISPLAY_TIME
      end
    end
  end
  gameplayState.draw = function ()
    panel.draw()

    local r, g, b, a = love.graphics.getColor()
    local transparency = button.displayTimeLeft / BUTTON_DISPLAY_TIME
    love.graphics.setColor(button.color[1], button.color[2], button.color[3], transparency)
    love.graphics.circle("fill", button.x, button.y, button.radius)
    love.graphics.setColor(r, g, b, a)
  end


  gameState.state = menuState
end

function love.update(dt)
  gameState.state.update(dt)
end

function love.draw()
  gameState.state.draw()
end
