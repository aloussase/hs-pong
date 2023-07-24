module Pong.Sounds (loadSounds, playSound) where

import           Apecs

import           Raylib.Core.Audio hiding (playSound)
import qualified Raylib.Types      as Rl

import           Pong.Components
import           Pong.Types

loadSounds :: IO [(Sound, Rl.Sound)]
loadSounds = do
    initAudioDevice
    clankSound <- loadSound "assets/clink.wav"
    return [(ClankSound, clankSound)]

playSound :: Sound -> System' ()
playSound sound = newEntity_ (WantsToPlaySound sound)
