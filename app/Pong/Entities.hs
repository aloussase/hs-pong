module  Pong.Entities where

import           Apecs
import           Pong.Components
import           Raylib.Types    (Texture2D)

spawnButton :: Image -> Position -> Size -> ClickAction -> System' ()
spawnButton image position size action =
    newEntity_ (image, position, size, action, Translatable position)
