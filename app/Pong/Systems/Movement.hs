module Pong.Systems.Movement (movement) where

import           Apecs
import           Raylib.Core      (getFrameTime)
import           Raylib.Types
import           Raylib.Util.Math (clamp)

import           Pong.Components

movement :: System' ()
movement = cmapM $
    \(Position (Vector2 x y), Velocity (Vector2 vx vy), Size width height) -> do
        ws <- get global
        dt <- liftIO getFrameTime
        let ww = windowSizeWidth ws
            wh = windowSizeHeight ws
            nx = if x + vx * dt + fromIntegral width >= ww
                 then ww - fromIntegral width
                 else max 0 (x + vx * dt)
            ny = if y + vy * dt + fromIntegral height >= wh
                 then wh - fromIntegral height
                 else max 0 (y + vy * dt)
        return $ Position (Vector2 nx ny)
