module Pong.Systems.State.Playing (enter, exit) where

import           Apecs
import           Raylib.Types

import           Pong.Components
import           Pong.Entities
import           Pong.Types

enter :: System' ()
enter = do
    ws <- get global

    let ww = windowSizeWidth ws
        wh = windowSizeHeight ws
        pw, ph :: Int
        pw = 10
        ph = 50
        y = wh / 2 - fromIntegral ph / 2
        bw = 5
        bh = 5
        bx = ww / 2 - bw / 2
        by = wh / 2 - bh / 2

    spawnPaddle (Position (Vector2 10 y))
                (Size pw ph)
                (HasUserInput [(KeyW, MoveUp), (KeyS, MoveDown)])

    spawnPaddle (Position (Vector2 (ww - (fromIntegral pw + 10)) y))
                (Size pw ph)
                (HasUserInput [(KeyUp, MoveUp), (KeyDown, MoveDown)])

    spawnBall (Position (Vector2 bx by))
              (Size (round bw) (round bh))
              (Velocity (Vector2 (-300) 0))

    set global $ GameState Playing

exit :: System' ()
exit = do
    cmap $ \Paddle -> Not @PaddleEntity
    cmap $ \Ball -> Not @BallEntity
    cmap $ \Particle -> Not @ParticleEntity
