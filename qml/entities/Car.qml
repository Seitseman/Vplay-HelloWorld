import QtQuick 2.0
import VPlay 2.0

EntityBase {
    id: car
    // the enityId should be set by the level file!
    entityType: "car"

    property alias inputActionsToKeyCode: twoAxisController.inputActionsToKeyCode
    property alias image: image

    // gets accessed to insert the input when touching the HUDController
    property alias controller: twoAxisController


    Component.onCompleted: {
        console.debug("car.onCompleted()")
        console.debug("car.x:", x)
        var mapped = mapToItem(world, x, y)
        console.debug("car.x world:", mapped.x)
    }

    Image {
        id: image
        source: "../../assets/img/car_red.png"

        anchors.centerIn: parent
        width: boxCollider.width
        height: boxCollider.height

        property list<Item> imagePoints: [
            // this imagePoint can be used for creation of the rocket
            // it must be far enough in front of the car that they don't collide upon creation
            // the +30 might have to be adapted if the size of the rocket is changed
            Item {x: image.width/2+30}
        ]

    }

    // this is used as input for the BoxCollider force & torque properties
    TwoAxisController {
        id: twoAxisController

        // call the logic function when an input press (possibly the fire event) is received
        onInputActionPressed: handleInputAction(actionName)
    }

    BoxCollider {
        id: boxCollider

        // the image and the physics will use this size; this is important as it specifies the mass of the body! it is in respect to the world size
        width: 60
        height: 40

        anchors.centerIn: parent

        density: 20
        friction: 0.4
        restitution: 0.5
        body.bullet: true
        body.linearDamping: 10
        body.angularDamping: 15

        // this is applied every physics update tick
        force: Qt.point(twoAxisController.yAxis*8000, 0)
        torque: twoAxisController.xAxis*2000

        Component.onCompleted: {
            console.debug("car.physics.x:", x)
            var mapped = mapToItem(world, x, y)
            console.debug("car.physics.x world:", mapped.x)
        }

        fixture.onBeginContact: {
            var fixture = other
            var body = other.parent
            var component = other.parent.parent
            var collidingType = component.owningEntity.entityType

            //var
            console.debug("car contact with: ", other, other.parent, other.parent.parent)
            console.debug("car collided entity type:", collidingType)

            console.debug("car contactNormal:", contactNormal, "x:", contactNormal.x, "y:", contactNormal.y)

        }
    }

    function handleInputAction(action) {
        if( action === "fire") {
            // x&y of this component are 0..
            console.debug("creating weapon at current position x", car.x, "y", car.y)
            console.debug("image.imagePoints[0].x:", image.imagePoints[0].x, ", image.imagePoints[0].y:", image.imagePoints[0].y)

            // this is the point that we defined in Car.qml for the rocket to spawn
            var imagePointInWorldCoordinates = mapToItem(level,image.imagePoints[0].x, image.imagePoints[0].y)
            console.debug("imagePointInWorldCoordinates x", imagePointInWorldCoordinates.x, " y:", imagePointInWorldCoordinates.y)

            // create the rocket at the specified position with the rotation of the car that fires it
            entityManager.createEntityFromUrlWithProperties(Qt.resolvedUrl("Rocket.qml"), {"x": imagePointInWorldCoordinates.x, "y": imagePointInWorldCoordinates.y, "rotation": car.rotation})

        }
    }
}

