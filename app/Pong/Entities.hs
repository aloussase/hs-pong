module  Pong.Entities where

import           Apecs
import           Pong.Components
import           Raylib.Types    (Texture2D)

spawnButton :: Image -> Position -> Size -> ClickAction -> System' ()
spawnButton image position size action =
    newEntity_ (image, position, size, action, Translatable position)

spawnPaddle :: Position -> Size -> HasUserInput -> System' ()
spawnPaddle position size userInput = newEntity_ (Paddle, position, size, userInput)

spawnBall :: Position -> Size -> Velocity -> System' ()
spawnBall position size velocity = newEntity_ (Ball, position, size, velocity)
