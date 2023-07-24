module Pong.Systems.State
(
    HasGameState (..)
  , StateTransition (..)
  , HasTransition (..)
)
where

import           Apecs
import           Raylib.Core.Text
import           Raylib.Core.Textures
import           Raylib.Types                   hiding (Image)
import           Raylib.Util.Colors


import           Pong.Components
import           Pong.Entities
import qualified Pong.Systems.State.Playing     as Playing
import qualified Pong.Systems.State.StartScreen as StartScreen
import           Pong.Types

class HasGameState (state :: State) where
    enter :: Proxy state -> System' ()
    exit :: Proxy state -> System' ()

instance HasGameState StartScreen where
    enter _ = StartScreen.enter
    exit _ = StartScreen.exit

instance HasGameState Playing where
    enter _ = Playing.enter
    exit _ = Playing.exit

instance HasGameState Done where
    enter _ = set global (GameState Done)
    exit _ = return ()

data StateTransition (from :: State) (to :: State) = StateTransition

class HasTransition f (from :: State) (to :: State) where
    transition :: (HasGameState from, HasGameState to) => f (from :: State) (to :: State) -> System' ()
    transition _ = exit (Proxy @from) >> enter (Proxy @to)

instance HasTransition StateTransition StartScreen Playing
instance HasTransition StateTransition StartScreen Done
instance HasTransition StateTransition Done StartScreen
