module Pong.Entities
(
    spawnButton
  , spawnPaddle
  , spawnBall
  , spawnRandomParticle
  , spawnRandomParticles
  , type ParticleEntity
)
where

import           Apecs
import           Pong.Components
import           Raylib.Types     hiding (Image)
import           Raylib.Util.Math (lerp)
import           System.Random    (randomRIO)

spawnButton :: Image -> Position -> Size -> ClickAction -> System' ()
spawnButton image position size action =
    newEntity_ (image, position, size, action, Translatable position)

spawnPaddle :: Position -> Size -> HasUserInput -> System' ()
spawnPaddle position size userInput = newEntity_ (Paddle, position, size, userInput)

spawnBall :: Position -> Size -> Velocity -> System' ()
spawnBall position size velocity = newEntity_ (Ball, position, size, velocity)

minParticleSize, maxParticleSize :: Float
minParticleSize = 5
maxParticleSize = 10

minParticleSpeed, maxParticleSpeed :: Float
minParticleSpeed = 50
maxParticleSpeed = 500

minParticleLt, maxParticleLt :: Float
minParticleLt = 0.5
maxParticleLt = 1.2

type ParticleEntity = (Particle, Position, Size, Velocity, HasColor, Lifetime)

spawnRandomParticle :: Position -> Color -> System' ()
spawnRandomParticle position color = do
    randomSize :: Float <- randomRIO (0, 1)
    let size = lerp minParticleSize maxParticleSize randomSize

    randomAngle :: Float <- randomRIO (0, 1)
    let angle = lerp 0 (2*pi) randomAngle

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

spawnRandomParticles :: Int -> Position -> Color -> System' ()
spawnRandomParticles count position color =
    mapM_ (\_ -> spawnRandomParticle position color) [0..count]
