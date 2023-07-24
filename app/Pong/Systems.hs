module Pong.Systems
(
    module Pong.Systems.ClickHandling
  , module Pong.Systems.Drawing
  , module Pong.Systems.Hover
  , module Pong.Systems.UserInput
  , module Pong.Systems.Movement
  , module Pong.Systems.CollisionDetection
  , module Pong.Systems.Particles
  , module Pong.Systems.State
  , startScreen
  , playing
  , gameOver
)
where

import           Apecs

import           Control.Monad.IO.Class          (liftIO)

import           Pong.Components
import           Pong.Systems.ClickHandling
import           Pong.Systems.CollisionDetection
import           Pong.Systems.Drawing
import           Pong.Systems.Hover
import           Pong.Systems.Movement
import           Pong.Systems.Particles
import           Pong.Systems.State
import           Pong.Systems.UserInput

startScreen :: System' ()
startScreen = do
    drawStartScreen
    translateOnHover
    handleClicks

playing :: System' ()
playing = do
    userInput
    movement
    checkCollisionBallPaddle
    checkCollisionBallWalls
    updateParticles
    updateTrails
    drawPlayingState

gameOver :: System' ()
gameOver = do
    translateOnHover
    handleClicks
    drawGameOverScreen
