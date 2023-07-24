module Pong.Systems
(
    module Pong.Systems.ClickHandling
  , module Pong.Systems.Drawing
  , module Pong.Systems.Hover
  , module Pong.Systems.Initialize
  , module Pong.Systems.UserInput
  , module Pong.Systems.Movement
  , module Pong.Systems.CollisionDetection
  , module Pong.Systems.Particles
  , startScreen
  , playing
)
where

import           Pong.Systems.ClickHandling
import           Pong.Systems.CollisionDetection
import           Pong.Systems.Drawing
import           Pong.Systems.Hover
import           Pong.Systems.Initialize
import           Pong.Systems.Movement
import           Pong.Systems.Particles
import           Pong.Systems.UserInput

import           Pong.Components

startScreen :: System' ()
startScreen = do
    drawStartScreen
    hover
    handleClicks

playing :: System' ()
playing = do
    userInput
    movement
    checkCollisionBallPaddle
    checkCollisionBallWalls
    updateParticles
    drawPlayingState
