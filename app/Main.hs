module Main where

import           Apecs
import           Raylib.Core
import           Raylib.Util     (WindowResources, drawing)

import           Pong.Components
import           Pong.Systems    (StateTransition (..), transition)
import qualified Pong.Systems    as Systems
import           Pong.Types

windowWidth :: Float
windowWidth = 800

windowHeight :: Float
windowHeight = 500

gameLoop :: System' ()
gameLoop = do
    shouldClose <- liftIO windowShouldClose
    Resources wrs <- get global
    GameState state <- get global
    case (shouldClose, state) of
      (True, _)        -> liftIO (closeWindow wrs)
      (_, Done)        -> liftIO (closeWindow wrs)
      (_, StartScreen) -> drawing Systems.startScreen >> gameLoop
      (_, Playing)     -> drawing Systems.playing >> gameLoop
      (_, GameOver)    -> drawing Systems.gameOver >> gameLoop

main :: IO ()
main = do
    ws <- initWindow (round windowWidth) (round windowHeight) "HS Pong"
    w <- initWorld
    runWith w $ do
        set global (WindowSize windowWidth windowHeight)
        set global (Resources ws)
        set global (GameState StartScreen)
        transition $ StateTransition @Done @StartScreen
        gameLoop
