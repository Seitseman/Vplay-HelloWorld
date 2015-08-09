import QtQuick 2.0

import VPlay 2.0

EntityBase {
    id: entity
    entityType: "rocket"

    Component.onCompleted: {
        console.debug("Rocket.onCompleted, width:", width);
        applyForwardImpulse();
    }

    BoxCollider {
        id: boxCollider

        // the image and the physics will use this size; this is important as it specifies the mass of the body! it is in respect to the world size
        width: 50
        height: 20

        anchors.centerIn: parent

        density: 3
        friction: 0.4
        restitution: 0.5
        body.bullet: true
        // we prevent the physics engine from applying rotation to the rocket, because we will do it ourselves
        body.fixedRotation: true

        fixture.onBeginContact: {
            // get the entityType of the colliding entity
            var fixture = other;
            var body = other.parent;
            var component = other.parent.parent;

            var collidingType = component.owningEntity.entityType;

            if(collidingType === "car" ||
                    collidingType === "rocket") {
                entity.removeEntity();
                return;
            }

            // normalX and normalY will indicate the direction the rocket was flying when colliding with a wall
            // keep in mind that the positive y axis is pointing downwards
            var normalX = contactNormal.x;
            var normalY = contactNormal.y;

            var localForward = boxCollider.body.linearVelocity;
            var newAngle = 0.0;

            if((normalX === 1) || (normalX === -1) ) {

                // ATTENTION: atan2 requires arguments y, x and NOT x,y!
                // perform mirroring and calculate the new angle
                localForward.x*=-1.0;

                newAngle = Math.atan2(localForward.y, localForward.x);

            }
            else if((normalY === -1 ) || (normalY === 1) ) {
                // perform mirroring and calculate the new angle
                localForward.y*=-1.0;

                newAngle = Math.atan2(localForward.y, localForward.x);

            } else {
                // a non-normal collision took place (e.g. with a car), so do nothing
                return;
            }

            // convert from rad to deg
            newAngle *= 180/Math.PI;

            // manually set the entity rotation, because it is the target and its rotation will be used for the physics body
            entity.rotation = newAngle;
            // it also must be set to the body, because otherwise the calculation by setting the linearVelocity and impulse below would not be done with the updated rotation value!
            boxCollider.body.rotation = newAngle;


            // it's important to clear the old velocity before applying the impulse, otherwise the rocket would get faster every time it collides with a wall!
            boxCollider.body.linearVelocity = Qt.point(0,0);

            applyForwardImpulse();

        }
    }

    Image {
        id: image
        source: "../../assets/img/rocket_green.png"
        anchors.centerIn: parent
        width: boxCollider.width
        height: boxCollider.height
    }

    function applyForwardImpulse() {
        var localForward = boxCollider.body.getWorldVector(Qt.point(1500,0));
        boxCollider.body.applyLinearImpulse(localForward, boxCollider.body.getWorldCenter());
    }
}

