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
      resizable = true,
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
  p1_score = 0
  p2_score = 0

  serving = 1

  -- 0: start
  -- 1: play
  game_state = 0
end

function love.resize(w, h)
  push:resize(w, h)
end

function love.update(dt)
  if game_state == 2 then
    ball.dy = math.random(-50, 50)
    if serving == 1 then
      ball.dx = -math.random(100, 150)
    else
      ball.dx = math.random(100, 150)
    end
    game_state = 0
  end

  if game_state == 1 then
    if ball:collides(p1) then
      ball.dx = -ball.dx * RATE
      ball.x = p1.x + PADDLE_WIDTH

      if ball.dy < 0 then
        ball.dy = math.random(10, 150)
      else
        ball.dy = -math.random(10, 150)
      end
    end
    if ball:collides(p2) then
      ball.dx = -ball.dx * RATE
      ball.x = p2.x - BALL_SIZE

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

    if ball.y >= V_HEIGHT - BALL_SIZE then
      ball.y = V_HEIGHT - BALL_SIZE
      ball.dy = -ball.dy
    end
  end

  if ball.x < 0 then
    serving = 1
    p2_score = p2_score + 1
    ball:reset()
    game_state = 2
  end

  if ball.x > V_WIDTH then
    serving = 2
    p1_score = p1_score + 1
    ball:reset()
    game_state = 2
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
    love.graphics.printf("Player " .. tostring(serving) .. " now serving", 0, 20, V_WIDTH, "center")
  end

  p1:render()
  p2:render()

  ball:render()

  displayFPS()

  love.graphics.setColor(0.2, 0.2, 1, 0.7)
  love.graphics.print("P1", V_WIDTH / 2 - 47, V_HEIGHT / 3)
  love.graphics.print("P2", V_WIDTH / 2 + 33, V_HEIGHT / 3)
  love.graphics.setFont(retro_big)
  love.graphics.print(tostring(p1_score), V_WIDTH / 2 - 50, V_HEIGHT / 3 + 10)
  love.graphics.print(tostring(p2_score), V_WIDTH / 2 + 30, V_HEIGHT / 3 + 10)

  -- end rendering at V resolution
  push:apply("end")
end

function displayFPS()
  love.graphics.setFont(retro_small)
  love.graphics.setColor(0.1, 0.8, 0.1, 0.6)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
end
