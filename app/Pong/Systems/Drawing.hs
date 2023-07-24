module Pong.Systems.Drawing
(
    drawStartScreen
  , drawPlayingState
)
where


import           Apecs
import           Raylib.Types         (Texture (texture'height, texture'width),
                                       Vector2 (..))

import           Pong.Components
import           Raylib.Core          (beginTextureMode, clearBackground,
                                       endTextureMode)
import           Raylib.Core.Shapes   (drawCircle, drawRectangle)
import           Raylib.Core.Textures (drawTexture, loadRenderTexture,
                                       loadTextureFromImage)
import           Raylib.Util.Colors   (black, white, yellow)

drawPlayingState :: System' ()
drawPlayingState = do
    liftIO $ clearBackground black
    drawPaddles
    drawBall

drawPaddles :: System' ()
drawPaddles = cmapM_ $
    \(Paddle, Position (Vector2 x y), Size width height) ->
        liftIO $ drawRectangle (round x) (round y) width height white

drawBall :: System' ()
drawBall = cmapM_ $
    \(Ball, Position (Vector2 x y), Size width _) ->
        liftIO $ drawCircle (round x) (round y) (fromIntegral width) yellow

drawStartScreen :: System' ()
drawStartScreen = do
    liftIO $ clearBackground black
    drawButtons

drawButtons :: System' ()
drawButtons = cmapM_ $
    \( Image texture, Position (Vector2 x y) ) ->
        liftIO $ drawTexture texture (round x) (round y) white
