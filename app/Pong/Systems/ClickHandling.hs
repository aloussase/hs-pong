module Pong.Systems.ClickHandling (handleClicks) where

import           Control.Monad      (forM_, when)

import           Apecs
import           Raylib.Core
import           Raylib.Core.Shapes
import           Raylib.Types

import           Pong.Components
import           Pong.Systems.State
import           Pong.Types

handleClicks :: System' ()
handleClicks = do
    clickables :: [(Position, Size, HasAction)] <- collect Just
    forM_ clickables $ \(Position (Vector2 x y), Size width height, HasAction intent) -> do
        let rect = Rectangle x y (fromIntegral width) (fromIntegral height)
        mousePosition <- liftIO getMousePosition
        clicked <- liftIO $ isMouseButtonReleased MouseButtonLeft
        GameState state <- get global
        when (checkCollisionPointRec mousePosition rect && clicked) $ do
            case (state, intent) of
              (StartScreen, Navigate ToGame) -> transition $ StateTransition @StartScreen @Playing
              (StartScreen, Navigate ToExit) -> transition $ StateTransition @StartScreen @Done
              (GameOver, Navigate ToStartScreen) -> transition $ StateTransition @GameOver @StartScreen
              (GameOver, Navigate ToExit) -> transition $ StateTransition @GameOver @Done
              (GameOver, Navigate ToGame) -> transition $ StateTransition @GameOver @Playing
              _ -> return ()

