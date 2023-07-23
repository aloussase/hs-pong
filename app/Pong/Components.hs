{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeFamilies          #-}
module Pong.Components where

import           Apecs
import           Data.Monoid
import           Data.Semigroup (Semigroup)
import           Data.String    (IsString (..))
import           Raylib.Types   (Texture2D, Vector2)
import           Raylib.Util    (WindowResources)


newtype Resources = Resources WindowResources
instance Component Resources where type Storage Resources = Unique Resources

type WindowWidth = Float
type WindowHeight = Float

data WindowSize = WindowSize
    { windowSizeWidth  :: !WindowWidth
    , windowSizeHeight :: !WindowHeight
    }
instance Component WindowSize where type Storage WindowSize = Unique WindowSize

data GameState = StartScreen | Playing | Done deriving Show
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

type Button = (Image, Position, Size, ClickAction, Translatable)

makeWorld "World" [''WindowSize, ''GameState, ''Image, ''Position, ''Size
                  , ''Resources, ''ClickAction, ''Translatable
                  ]

type System' a = System World a
