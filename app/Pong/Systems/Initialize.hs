module Pong.Systems.Initialize
(
    initialize
  , initializeStartScreen
)
where

import           Apecs

import           Pong.Components
import           Pong.Entities        (spawnButton)
import           Raylib.Core.Text     (measureText)
import           Raylib.Core.Textures (imageDrawText, loadImage, loadTexture,
                                       loadTextureFromImage, unloadTexture)
import           Raylib.Types         (Texture (texture'height, texture'width),
                                       Vector2 (Vector2))
import           Raylib.Util          (WindowResources)
import           Raylib.Util.Colors   (white)

initialize :: WindowResources -> WindowWidth -> WindowHeight -> System' ()
initialize ws ww wh = do
    set global (WindowSize ww wh)
    set global (Resources ws)

initializeStartScreen :: System' ()
initializeStartScreen = do
    ws <- get global
    (Resources wrs) <- get global

    set global StartScreen

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

    spawnButton (Image texture1) (Position $ Vector2  x (mid - fromIntegral th * 0.75)) (Size tw th) WantsToStartGame
    spawnButton (Image texture2) (Position $ Vector2  x (mid - fromIntegral th * 0.25)) (Size tw th) WantsToExit

initializeGame :: System' ()
initializeGame = do
    set global Playing
    return ()