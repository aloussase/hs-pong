module Pong.Systems.Drawing
(   drawStartScreen
)
where


import           Apecs
import           Raylib.Types         (Texture (texture'height, texture'width),
                                       Vector2 (..))

import           Pong.Components
import           Raylib.Core          (beginTextureMode, clearBackground,
                                       endTextureMode)
import           Raylib.Core.Textures (drawTexture, loadRenderTexture,
                                       loadTextureFromImage)
import           Raylib.Util.Colors   (black, white)

drawStartScreen :: System' ()
drawStartScreen = do
    liftIO $ clearBackground black
    drawButtons

drawButtons :: System' ()
drawButtons = cmapM_ $
    \( Image texture, Position (Vector2 x y) ) -> do
        liftIO $ drawTexture texture (round x) (round y) white
