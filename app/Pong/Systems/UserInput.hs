{-# LANGUAGE LambdaCase #-}
module Pong.Systems.UserInput (userInput) where

import           Control.Monad    (filterM, forM, when)

import           Apecs
import           Raylib.Core
import           Raylib.Types
import           Raylib.Util.Math (clamp)

import           Pong.Components
import           Pong.Types


findIntent :: [(KeyboardKey, Intent)] -> IO (Maybe Intent)
findIntent [] = return Nothing
findIntent ((key, intent):xs) = do
    keyDown <- isKeyDown key
    if keyDown
        then return (Just intent)
        else findIntent xs

userInput :: System' ()
userInput = cmapM $
    \(pos@(Position (Vector2 x y)), HasUserInput intents, Size _ height) -> do
        ws <- get global
        let maxY = windowSizeHeight ws - fromIntegral height
        liftIO (findIntent intents) >>= \case
            Just MoveUp   -> return $ Position (Vector2 x (clamp (y - 0.2) 0 maxY))
            Just MoveDown -> return $ Position (Vector2 x (clamp (y + 0.2) 0 maxY))
            _ -> return pos


