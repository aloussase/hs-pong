module Pong.Systems.Hover (hover) where

import           Control.Monad        (when)

import           Apecs
import           Raylib.Core
import           Raylib.Core.Shapes
import           Raylib.Core.Textures
import           Raylib.Types
import           Raylib.Util.Colors

import           Pong.Components

hover :: System' ()
hover = cmapM $
    \(Size width height, Translatable originalPosition) -> do
        let (Position (Vector2 x y)) = originalPosition
            rect = Rectangle x y (fromIntegral width) (fromIntegral height)
        mousePosition <- liftIO getMousePosition
        if checkCollisionPointRec mousePosition rect
            then return $ Position (Vector2 x (y + 2))
            else return originalPosition
