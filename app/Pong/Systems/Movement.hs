module Pong.Systems.Movement (movement) where

import           Apecs
import           Raylib.Types
import           Raylib.Util.Math (clamp)

import           Pong.Components

movement :: System' ()
movement = cmapM $
    \(Position (Vector2 x y), Velocity (Vector2 vx vy), Size width height) -> do
        ws <- get global
        let ww = windowSizeWidth ws
            wh = windowSizeHeight ws
            nx = if x + vx + fromIntegral width >= ww
                 then ww - fromIntegral width
                 else max 0 (x + vx)
            ny = if y + vy + fromIntegral height >= wh
                 then wh - fromIntegral height
                 else max 0 (y + vy)
        return $ Position (Vector2 nx ny)
