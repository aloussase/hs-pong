module Pong.Systems
(
    module Pong.Systems.ClickHandling
  , module Pong.Systems.Drawing
  , module Pong.Systems.Hover
  , module Pong.Systems.Initialize
  , startScreen
  , playing
)
where

import           Pong.Systems.ClickHandling
import           Pong.Systems.Drawing
import           Pong.Systems.Hover
import           Pong.Systems.Initialize

import           Pong.Components

startScreen :: System' ()
startScreen = do
    drawStartScreen
    hover
    handleClicks

playing :: System' ()
playing = pure ()


