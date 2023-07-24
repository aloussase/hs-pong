module Pong.Systems.CollisionDetection
(
    checkCollisionBallPaddle
  , checkCollisionBallWalls
)
where

import           Control.Monad      (when)

import           Apecs
import           Raylib.Core.Shapes
import           Raylib.Types
import           Raylib.Util.Colors
import           Raylib.Util.Math

import           Pong.Components
import           Pong.Entities
import           Pong.Systems.State
import           Pong.Types

checkCollisionBallWalls :: System' ()
checkCollisionBallWalls = cmapM $
    \(Ball, position@(Position (Vector2 bx by)), Size bw bh, velocity@(Velocity (Vector2 vx vy))) -> do
        ws <- get global
        let wh = windowSizeHeight ws
            ww = windowSizeWidth ws
            topCollision = by <= 0
            bottomCollision = by + fromIntegral bh >= wh
            leftCollision = bx <= 0
            rightCollision = bx + fromIntegral bw >= ww
        if topCollision || bottomCollision
        then return (Velocity $ Vector2 vx (vy * (-1)))
        else if leftCollision || rightCollision
        then transition (StateTransition @Playing @GameOver) >> return velocity
        else return velocity


checkCollisionBallPaddle :: System' ()
checkCollisionBallPaddle =
    cmapM_ $ \(Paddle, Position (Vector2 px py), Size pw ph) ->
        cmapM $ \(Ball, position@(Position (Vector2 bx by)), Size bw bh, velocity@(Velocity (Vector2 vx vy))) -> do
            let br = Rectangle bx by (fromIntegral bw) (fromIntegral bh)
                pr = Rectangle px py (fromIntegral pw) (fromIntegral ph)
            if checkCollisionRecs br pr
               then do
                    let intersect = (py + fromIntegral ph / 2) - by
                        normalizedIntersect = intersect / (fromIntegral ph / 2)
                        angle = normalizedIntersect * pi
                        speed = magnitude $ Vector2 vx vy
                    spawnRandomParticles 50 position white
                    return $ Velocity $ Vector2 (speed * cos angle) (speed * (-(sin angle)))
                else return velocity
