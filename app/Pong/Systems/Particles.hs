module Pong.Systems.Particles (updateParticles) where

import           Apecs
import           Raylib.Core     (getFrameTime)

import           Pong.Components
import           Pong.Entities

updateParticles :: System' ()
updateParticles = cmapM $ \particle@(Particle, Lifetime lt) -> do
    dt <- liftIO getFrameTime
    if lt <= 0
        then return $ Left $ Not @ParticleEntity
        else return $ Right $ Lifetime (lt - dt)
