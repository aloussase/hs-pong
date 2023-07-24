module Pong.Systems.Sound where

import           Apecs

import qualified Raylib.Core.Audio as RCA

import           Pong.Components

playSounds :: System' ()
playSounds = cmapM $
    \(WantsToPlaySound sound) -> do
        Sounds sounds <- get global
        case lookup sound sounds of
          Just sound' -> do
              liftIO $ RCA.playSound sound'
              return $ Right (Not @WantsToPlaySound)
          _           -> return $ Left ()
