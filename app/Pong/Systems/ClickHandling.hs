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
    clickables :: [(Position, Size, ClickAction, Entity)] <- collect Just
    forM_ clickables $ \(Position (Vector2 x y), Size width height, clickAction, ety) -> do
        let rect = Rectangle x y (fromIntegral width) (fromIntegral height)
        mousePosition <- liftIO getMousePosition
        clicked <- liftIO $ isMouseButtonReleased MouseButtonLeft
        GameState state <- get global
        when (checkCollisionPointRec mousePosition rect && clicked) $ do
            case (state, clickAction) of
              (StartScreen, WantsToStartGame) -> transition $ StateTransition @StartScreen @Playing
              (StartScreen, WantsToExit) -> transition $ StateTransition @StartScreen @Done
              _ -> return ()

