module Pong.Systems.State.GameOver (enter, exit) where

import           Apecs
import           Raylib.Types
import           Raylib.Util.Colors

import           Pong.Components
import           Pong.Entities
import           Pong.Types

enter :: System' ()
enter = do
    ws <- get global

    let width = 300
        height = 80
        x =  windowSizeWidth ws / 2 - fromIntegral width / 2
        mid = windowSizeHeight ws / 2

    spawnButton "Start Screen"
                (Position $ Vector2  x (mid - fromIntegral height / 2 - fromIntegral height - 10))
                (Size width height)
                blue
                (Navigate ToStartScreen)

    spawnButton "Play Again"
                (Position $ Vector2 x (mid - fromIntegral height / 2))
                (Size width height)
                green
                (Navigate ToGame)

    spawnButton "Exit"
                (Position $ Vector2  x (mid + fromIntegral height / 2 + 10))
                (Size width height)
                red
                (Navigate ToExit)

    set global (GameState GameOver)

exit :: System' ()
exit = cmap $ \Button -> Not @ButtonEntity
