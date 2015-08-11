import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow
    onSplashScreenFinished: {
        console.log("#### Splash screen finished")
        physicalWorld.running = true
    }


    EntityManager {
        id: entityManager
        entityContainer: scene
    }

    Scene {
        id: scene

        PhysicsWorld {
            id: physicalWorld
            running: false
            gravity.y: -9.81
//            z:10
            updatesPerSecondForPhysics: 30
            velocityIterations: 5
            positionIterations: 5

            debugDrawVisible: false

        }

        EntityBase {
            entityId: "box1"
            entityType: "box"
            x:scene.x/2

            Image {
                id: boxImage
                source: "../assets/img/box.png"
                anchors.fill: boxCollider
            }

            BoxCollider{
                id: boxCollider
                width: 32
                height: 32
                anchors.centerIn: parent

                fixture.onBeginContact: {
                    collisionSound.play()
                    collisionParticleEffect.start()
                }
            }

            SoundEffectVPlay {
                id: collisionSound
                source: "../assets/snd/boxCollision.wav"
            }

            ParticleVPlay {
                id: collisionParticleEffect
                fileName: "SmokeParticle.json"
            }
        }

        EntityBase {
            entityId: "ground1"
            entityType: "ground"

            height: 20
            anchors {
                bottom: scene.bottom
                right:  scene.right
                left: scene.left
            }

            Rectangle {
                anchors.fill: parent
                color: "blue"
            }

            BoxCollider {
                anchors.fill: parent
                bodyType: Body.Static
            }
        }
    }
}

