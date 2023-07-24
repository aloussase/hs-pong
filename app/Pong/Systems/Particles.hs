module Pong.Systems.Particles (updateParticles, updateTrails) where

import           Control.Monad      (when)

import           Apecs
import           Raylib.Core        (getFrameTime)
import           Raylib.Types
import           Raylib.Util.Colors (yellow)
import           Raylib.Util.Math
import           System.Random      (randomRIO)

import           Pong.Components
import           Pong.Entities

-- TODO: Come up with a better way to spawn less particles.
--       Might have to calculate better particle lifetime.
updateTrails :: System' ()
updateTrails = cmapM_ $ \(position, Velocity (Vector2 vx vy), HasTrail) -> do
    let xs = True : replicate 69 False
    i <- randomRIO (0, length xs - 1)
    when (xs !! i) $
        spawnRandomParticlesWithAngle 1 position yellow (atan2 vy vx)

updateParticles :: System' ()
updateParticles = cmapM $ \particle@(Particle, Lifetime lt, Velocity v) -> do
    dt <- liftIO getFrameTime
    if lt <= 0
        then return $ Left $ Not @ParticleEntity
        else return $ Right (Lifetime (lt - dt), Velocity (v |* 0.98))
