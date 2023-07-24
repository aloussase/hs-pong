module Pong.Systems.ClickHandling (handleClicks) where

import           Control.Monad           (when)

import           Apecs
import           Raylib.Core
import           Raylib.Core.Shapes
import           Raylib.Types

import           Pong.Components
import           Pong.Systems.Initialize

handleClicks :: System' ()
handleClicks = cmapM_ $
    \(Position (Vector2 x y), Size width height, clickAction) -> do
        let rect = Rectangle x y (fromIntegral width) (fromIntegral height)
        mousePosition <- liftIO getMousePosition
        clicked <- liftIO $ isMouseButtonReleased MouseButtonLeft
        when (checkCollisionPointRec mousePosition rect && clicked) $ do
            case clickAction of
              WantsToExit      -> set global Done
              WantsToStartGame -> initializeGame


