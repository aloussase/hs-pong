module Pong.Entities
(
    spawnButton
  , spawnPaddle
  , spawnBall
  , spawnRandomParticle
  , spawnRandomParticles
  , spawnRandomParticleWithAngle
  , spawnRandomParticlesWithAngle
  , type ParticleEntity
  , type ButtonEntity
)
where

import           Apecs
import           Pong.Components
import           Raylib.Types     hiding (Image)
import           Raylib.Util.Math (lerp)
import           System.Random    (randomRIO)

type ButtonEntity = (Image, Position, Size, ClickAction, Translatable)

spawnButton :: Image -> Position -> Size -> ClickAction -> System' ()
spawnButton image position size action =
    newEntity_ (image, position, size, action, Translatable position)

spawnPaddle :: Position -> Size -> HasUserInput -> System' ()
spawnPaddle position size userInput = newEntity_ (Paddle, position, size, userInput)

type BallEntity = (Ball, Position, Size, Velocity, HasTrail)

spawnBall :: Position -> Size -> Velocity -> System' ()
spawnBall position size velocity = newEntity_ (Ball, position, size, velocity, HasTrail)

minParticleSize, maxParticleSize :: Float
minParticleSize = 2
maxParticleSize = 5

minParticleSpeed, maxParticleSpeed :: Float
minParticleSpeed = 50
maxParticleSpeed = 500

minParticleLt, maxParticleLt :: Float
minParticleLt = 0.5
maxParticleLt = 1.2

type ParticleEntity = (Particle, Position, Size, Velocity, HasColor, Lifetime)

spawnRandomParticleWithAngle :: Position -> Color -> Float -> System' ()
spawnRandomParticleWithAngle position color angle = do
    randomSize :: Float <- randomRIO (0, 1)
    let size = lerp minParticleSize maxParticleSize randomSize

    randomSpeed :: Float <- randomRIO (0, 1)
    let speed = lerp minParticleSpeed maxParticleSpeed randomSpeed
        dx = cos angle * speed
        dy = sin angle * speed

    randomLt :: Float <- randomRIO (0, 1)
    let lt = lerp minParticleLt maxParticleLt randomLt

    newEntity_
        ( Particle
        , position
        , Size (round size) (round size)
        , Velocity (Vector2 dx dy)
        , HasColor color
        , Lifetime lt
        )

spawnRandomParticle :: Position -> Color -> System' ()
spawnRandomParticle position color = do
    randomAngle :: Float <- randomRIO (0, 1)
    let angle = lerp 0 (2*pi) randomAngle
    spawnRandomParticleWithAngle position color angle

spawnRandomParticlesWithAngle :: Int -> Position -> Color -> Float -> System' ()
spawnRandomParticlesWithAngle count position color angle =
    mapM_ (\_ -> spawnRandomParticleWithAngle position color angle) [0..count]

spawnRandomParticles :: Int -> Position -> Color -> System' ()
spawnRandomParticles count position color =
    mapM_ (\_ -> spawnRandomParticle position color) [0..count]
