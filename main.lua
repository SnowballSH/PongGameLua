--[[
  Pong Game
]]
-----------------
---- IMPORTS ----
-----------------

-- Push library from https://github.com/Ulydev/push
push = require "push"

Class = require "class"

require "Ball"
require "Paddle"

-------------------
---- CONSTANTS ----
-------------------

WIN_WIDTH = 1066
WIN_HEIGHT = 600

V_WIDTH = 360
V_HEIGHT = 202

PADDLE_PADDING_X = 10
PADDLE_PADDING_Y = 30
PADDLE_SPEED = 200

PADDLE_HEIGHT = 20
PADDLE_WIDTH = 5

BALL_SIZE = 4
RATE = 1.05

------------------------
---- Game Functions ----
------------------------

function love.load()
  math.randomseed(os.time())

  love.graphics.setDefaultFilter("nearest", "nearest")

  love.window.setTitle("Pong")

  retro_small = love.graphics.newFont("retro.ttf", 8)
  retro_big = love.graphics.newFont("retro.ttf", 32)

  love.graphics.setFont(retro_small)

  push:setupScreen(
    V_WIDTH,
    V_HEIGHT,
    WIN_WIDTH,
    WIN_HEIGHT,
    {
      fullscreen = false,
      resizable = false,
      vsync = true
    }
  )

  p1 =
    Paddle(
    PADDLE_PADDING_X, -- paddles
    PADDLE_PADDING_Y,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
  )
  p2 =
    Paddle(
    V_WIDTH - PADDLE_PADDING_X - PADDLE_WIDTH,
    V_HEIGHT - PADDLE_PADDING_Y - PADDLE_HEIGHT,
    PADDLE_WIDTH,
    PADDLE_HEIGHT
  )

  ball = Ball(V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, BALL_SIZE, BALL_SIZE)

  ------------------------
  ---- Initialization ----
  ------------------------

  -- 0: start
  -- 1: play
  game_state = 0
end

function love.update(dt)
  if game_state == 1 then
    if ball:collides(p1) then
      ball.dx = -ball.dx * RATE
      ball.x = p1.x + 5

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end
    if ball:collides(p2) then
      ball.dx = -ball.dx * RATE
      ball.x = p2.x - 4

      if ball.dy < 0 then
        ball.dy = -math.random(10, 150)
      else
        ball.dy = math.random(10, 150)
      end
    end

    if ball.y <= 0 then
      ball.y = 0
      ball.dy = -ball.dy
    end

    if ball.y >= V_HEIGHT - 4 then
      ball.y = V_HEIGHT - 4
      ball.dy = -ball.dy
    end
  end

  if love.keyboard.isDown("w") then
    p1.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown("s") then
    p1.dy = PADDLE_SPEED
  else
    p1.dy = 0
  end

  if love.keyboard.isDown("up") then
    p2.dy = -PADDLE_SPEED
  elseif love.keyboard.isDown("down") then
    p2.dy = PADDLE_SPEED
  else
    p2.dy = 0
  end

  if game_state == 1 then
    ball:update(dt)
  end

  p1:update(dt)
  p2:update(dt)
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif key == "enter" or key == "return" then
    if game_state == 0 then
      game_state = 1
    else
      game_state = 0
      ball:reset()
    end
  end
end

function love.draw()
  -- begin rendering at V resolution
  push:apply("start")

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

  love.graphics.setFont(retro_small)
  if game_state == 0 then
    love.graphics.printf("Hello Start State!", 0, 20, V_WIDTH, "center")
  else
    love.graphics.printf("Hello Play State!", 0, 20, V_WIDTH, "center")
  end

  p1:render()
  p2:render()

  ball:render()

  displayFPS()

  -- end rendering at V resolution
  push:apply("end")
end

function displayFPS()
  love.graphics.setFont(retro_small)
  love.graphics.setColor(0, 0.8, 0, 0.6)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
