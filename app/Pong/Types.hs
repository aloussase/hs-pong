module Pong.Types where

data State
    = StartScreen
    | Playing
    | GameOver
    | Done
    deriving Show


data Intent
    = MoveUp
    | MoveDown
    deriving Show
