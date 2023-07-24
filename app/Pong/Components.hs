{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Pong.Components where

import           Apecs
import           Data.Monoid
import           Data.Semigroup (Semigroup)
import           Data.String    (IsString (..))
import           Raylib.Types   (Color, KeyboardKey, Texture2D, Vector2)
import           Raylib.Util    (WindowResources)

import           Pong.Types


newtype Resources = Resources WindowResources
instance Component Resources where type Storage Resources = Unique Resources

type WindowWidth = Float
type WindowHeight = Float

data WindowSize = WindowSize
    { windowSizeWidth  :: !WindowWidth
    , windowSizeHeight :: !WindowHeight
    }
instance Component WindowSize where type Storage WindowSize = Unique WindowSize

newtype GameState = GameState State deriving Show
instance Component GameState where type Storage GameState = Unique GameState

newtype Image = Image Texture2D deriving Show
instance Component Image where type Storage Image = Map Image

newtype Position = Position Vector2 deriving Show
instance Component Position where type Storage Position = Map Position

data Size = Size Int Int deriving Show
instance Component Size where type Storage Size = Map Size

data ClickAction = WantsToStartGame | WantsToExit deriving Show
instance Component ClickAction where type Storage ClickAction = Map ClickAction

newtype Translatable = Translatable  { originalPosition :: Position } deriving Show
instance Component Translatable where type Storage Translatable = Map Translatable

data Paddle = Paddle deriving Show
instance Component Paddle where type Storage Paddle = Map Paddle

newtype HasUserInput = HasUserInput [(KeyboardKey, Intent)] deriving Show
instance Component HasUserInput where type Storage HasUserInput = Map HasUserInput

data Ball = Ball deriving Show
instance Component Ball where type Storage Ball = Unique Ball

newtype Velocity = Velocity Vector2 deriving Show
instance Component Velocity where type Storage Velocity = Map Velocity

data Particle = Particle deriving Show
instance Component Particle where type Storage Particle = Map Particle

newtype Lifetime = Lifetime Float deriving Show
instance Component Lifetime where type Storage Lifetime = Map Lifetime

newtype HasColor = HasColor Color deriving Show
instance Component HasColor where type Storage HasColor = Map HasColor

data HasTrail = HasTrail deriving Show
instance Component HasTrail where type Storage HasTrail = Map HasTrail

makeWorld "World" [ ''WindowSize, ''GameState, ''Image, ''Position, ''Size
                  , ''Resources, ''ClickAction, ''Translatable, ''Paddle, ''HasUserInput
                  , ''Ball, ''Velocity, ''Particle, ''Lifetime, ''HasColor, ''HasTrail
                  ]

type System' a = System World a
