function love.load(arg)
  love.math.setRandomSeed(os.time())

  local LEFT_MOUSE_BUTTON = 1
  local GAMEPLAY_TIME = 10

  love.graphics.setFont(love.graphics.newFont(30))

  button = {}
  button.x = 0
  button.y = 0
  button.radius = 20
  button.color = {255/255, 0, 0, 1}

  panel = {}
  panel.points = {}
  panel.timer = {}

  panel.points.value = 0
  panel.timer.value = GAMEPLAY_TIME

  panel.draw = function ()
    love.graphics.printf("Points: " .. panel.points.value, 0, 0, 150, "left")
    love.graphics.printf("Time: " .. math.floor(panel.timer.value), 150, 0, 300, "left")
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
    love.graphics.printf("Press any key to start a game", width/2.0, height/2.0, 300, "center")
  end


  gameplayState = {}
  gameplayState.init = function()
    local width, height = love.graphics.getDimensions()
    button.x = math.random(button.radius, width - button.radius)
    button.y = math.random(button.radius, height - button.radius)
  end
  gameplayState.update = function (dt)
    panel.timer.value = panel.timer.value - dt
    if love.mouse.isDown(LEFT_MOUSE_BUTTON) then

    end
  end
  gameplayState.draw = function ()
    panel.draw()

    local r, g, b, a = love.graphics.getColor()
    love.graphics.setColor(button.color[1], button.color[2], button.color[3])
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
