module Pong.Systems.State.StartScreen (enter, exit) where

import           Apecs
import           Raylib.Core
import           Raylib.Core.Text
import           Raylib.Core.Textures
import           Raylib.Types         hiding (Image)
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

    spawnButton "Start"
                (Position $ Vector2  x (mid - (fromIntegral height + 10)))
                (Size width height)
                green
                (Navigate ToGame)

    spawnButton "Exit"
                (Position $ Vector2  x (mid + 10))
                (Size width height)
                red
                (Navigate ToExit)

    set global $ GameState StartScreen

exit :: System' ()
exit = cmap $ \Button -> Not @ButtonEntity
