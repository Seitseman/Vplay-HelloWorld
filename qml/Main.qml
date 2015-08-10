import VPlay 2.0
import QtQuick 2.0

GameWindow {
    id: gameWindow

    EntityManager {
        id: entityManager
        entityContainer: scene
    }

    Scene {
        id: scene

        EntityBase {
            entityId: "box1"
            entityType: "box"

            Image {
                source: "../assets/img/box.png"
            }
        }
    }
}

