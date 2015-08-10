import VPlay 2.0
import QtQuick 2.0

GameWindow {
    Rectangle {
        color: "black"
        anchors.fill: parent
    }
    Scene {
        id: scene

        property int pressCount: 0

        Text {
            text: "Press count: " + scene.pressCount
            color: "#ffffff"
        }

        Image {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
            }

            source: "vplay-logo.png"
            visible: scene.pressCount > 5
        }

        Rectangle {
            id: button
            color: "lightgrey"
            x: 100
            y: 50
            width: 100
            height: 40

            onXChanged: {
                console.log("x channged to: ", x)
            }

            Text {
                id: buttonText
                text: "Press me"
                color: "black"
                anchors.centerIn: parent
            }

            MouseArea {
                id: buttonMouseArea
                anchors.fill: parent
                drag.target: button

                onPressed: {
                    button.color = "blue"
                    buttonText.text = "Pressed"

                    scene.pressCount++
                }

                onReleased: {
                    button.color = "lightgrey"
                    buttonText.text = "Press me"
                }
            }
        }
    }
}

