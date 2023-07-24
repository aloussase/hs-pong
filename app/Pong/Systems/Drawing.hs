module Pong.Systems.Drawing
(
    drawStartScreen
  , drawPlayingState
  , drawGameOverScreen
)
where


import           Apecs
import           Raylib.Core
import           Raylib.Core.Shapes
import           Raylib.Core.Text
import           Raylib.Core.Textures
import           Raylib.Types
import           Raylib.Util.Colors

import           Pong.Components
import           Pong.Types

drawPlayingState :: System' ()
drawPlayingState = do
    liftIO $ clearBackground black
    drawPaddles
    drawBall
    drawParticles

drawStartScreen :: System' ()
drawStartScreen = do
    liftIO $ clearBackground black
    drawButtons

drawGameOverScreen :: System' ()
drawGameOverScreen = do
    liftIO $ clearBackground black

    let gameOverText = "Game Over"
        fontSize = 30

    ws <- get global
    textWidth <- liftIO $ measureText gameOverText fontSize

    liftIO $ drawText gameOverText
                     (round (windowSizeWidth ws) `div` 2 - textWidth `div` 2)
                     50
                     fontSize
                     white

    drawButtons

drawPaddles :: System' ()
drawPaddles = cmapM_ $
    \(Paddle, Position (Vector2 x y), Size width height) ->
        liftIO $ drawRectangle (round x) (round y) width height white

drawParticles :: System' ()
drawParticles =
    cmapM_ $ \(Particle, Position (Vector2 x y), Size width _, Lifetime lt, HasColor color) -> do
        liftIO $ drawCircle (round x) (round y) (fromIntegral width) (fade color lt)

drawBall :: System' ()
drawBall = cmapM_ $
    \(Ball, Position (Vector2 x y), Size width _) ->
        liftIO $ drawCircle (round x) (round y) (fromIntegral width) yellow

drawButtons :: System' ()
drawButtons = cmapM_ $
    \(Button, Position (Vector2 x y), Size width height, Label label, HasColor color) -> do
        let r = Rectangle x y (fromIntegral width) (fromIntegral height)
        liftIO $ drawRectangleRounded r 0.2 (-1) color
        let fontSize = 30
        textWidth <- liftIO $ measureText label fontSize
        liftIO $ drawText label
                          (round x + width `div` 2 - textWidth `div` 2)
                          (round y + height `div` 2 - 10)
                          fontSize
                          white
