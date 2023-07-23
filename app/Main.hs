module Main where

import           Apecs
import           Raylib.Core
import           Raylib.Util     (WindowResources, drawing)

import           Pong.Components
import qualified Pong.Systems    as Systems

windowWidth :: Float
windowWidth = 800

windowHeight :: Float
windowHeight = 500

gameLoop :: System' ()
gameLoop = do
    shouldClose <- liftIO windowShouldClose
    (Resources wrs) <- get global
    state <- get global
    if shouldClose
       then liftIO (closeWindow wrs)
       else case state of
                StartScreen -> drawing Systems.startScreen >> gameLoop
                Playing     -> drawing Systems.playing >> gameLoop
                Done        -> liftIO (closeWindow wrs)

main :: IO ()
main = do
    ws <- initWindow (round windowWidth) (round windowHeight) "HS Pong"
    w <- initWorld
    runWith w $ do
        Systems.initialize ws windowWidth windowHeight
        Systems.initializeStartScreen
        gameLoop
