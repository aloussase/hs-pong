module Pong.Types where

data State
    = StartScreen
    | Playing
    | GameOver
    | Done
    deriving Show


data Navigation
    = ToStartScreen
    | ToGame
    | ToExit
    deriving Show

data Intent
    = MoveUp
    | MoveDown
    | Navigate Navigation
    deriving Show
