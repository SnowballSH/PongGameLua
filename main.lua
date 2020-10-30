--[[
  Pong Game
]]
-----------------
---- IMPORTS ----
-----------------

-- Push library from https://github.com/Ulydev/push
push = require "push"

-------------------
---- CONSTANTS ----
-------------------

WIN_WIDTH = 1066
WIN_HEIGHT = 600

V_WIDTH = 360
V_HEIGHT = 202

PADDLE_PADDING_X = 10
PADDLE_PADDING_Y = 10

PADDLE_W = 5
PADDLE_H = 20

BALL_SIZE = 4

------------------------
---- Game Functions ----
------------------------

function love.load()
  love.graphics.setDefaultFilter("nearest", "nearest")

  retro_small = love.graphics.newFont("retro.ttf", 8)

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
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  end
end

function love.draw()
  -- begin rendering at virtual resolution
  push:apply("start")

  love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 1)

  love.graphics.printf("Hello Pong!", 0, 20, V_WIDTH, "center")

  love.graphics.rectangle(
    "fill", --Fill--
    PADDLE_PADDING_X,
    PADDLE_PADDING_Y,
    PADDLE_W,
    PADDLE_H
  )
  love.graphics.rectangle(
    "fill",
    V_WIDTH - PADDLE_PADDING_X,
    V_HEIGHT - PADDLE_H - PADDLE_PADDING_Y,
    PADDLE_W,
    PADDLE_H
  )

  love.graphics.rectangle("fill", V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, BALL_SIZE, BALL_SIZE)

  -- end rendering at virtual resolution
  push:apply("end")
end
