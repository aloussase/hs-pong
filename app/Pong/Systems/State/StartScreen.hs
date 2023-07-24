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
    Resources wrs <- get global

    image <- liftIO $ loadImage "assets/button.png"
    texture <- liftIO $ loadTextureFromImage image wrs

    let th = texture'height texture
        tw = texture'width texture
        x =  windowSizeWidth ws / 2 - fromIntegral tw / 2
        mid = windowSizeHeight ws / 2

    let labelButton image txt = do
            textWidth <- measureText txt 20
            let x = tw `div` 2 - textWidth `div` 2
                y = th `div` 2 - 10
            imageDrawText image txt x y 20 white

    image1 <- liftIO $ labelButton image "Start"
    image2 <- liftIO $ labelButton image "Exit"

    texture1 <- liftIO $ loadTextureFromImage image1 wrs
    texture2 <- liftIO $ loadTextureFromImage image2 wrs

    liftIO $ unloadTexture texture wrs

    spawnButton (Image texture1)
                (Position $ Vector2  x (mid - fromIntegral th * 0.75))
                (Size tw th)
                WantsToStartGame

    spawnButton (Image texture2)
                (Position $ Vector2  x (mid - fromIntegral th * 0.25))
                (Size tw th)
                WantsToExit

    set global $ GameState StartScreen

exit :: System' ()
exit = cmapM $ \(Image texture) -> do
    Resources wrs <- get global
    liftIO $ unloadTexture texture wrs
    return $ Not @ButtonEntity
