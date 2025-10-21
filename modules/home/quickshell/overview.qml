import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Quickshell 1.0
import "theme.qml" as Theme

Window {
    id: root
    visible: true
    width: 800
    height: 400
    color: Theme.background
    flags: Qt.FramelessWindowHint | Qt.Tool | Qt.WindowStaysOnTopHint

    property var workspaces: []
    property var clients: []

    Component.onCompleted: updateData()

    function updateData() {
        let proc = Qt.createQmlObject('import Quickshell 1.0; Hyprctl { command: "-j workspaces" }', root)
        proc.finished.connect(function() {
            root.workspaces = JSON.parse(proc.output)
        })
        let proc2 = Qt.createQmlObject('import Quickshell 1.0; Hyprctl { command: "-j clients" }', root)
        proc2.finished.connect(function() {
            root.clients = JSON.parse(proc2.output)
        })
    }

    GridLayout {
        anchors.fill: parent
        rows: 2
        columns: 5
        spacing: 8

        Repeater {
            model: workspaces.length
            delegate: Rectangle {
                width: parent.width / 5 - 10
                height: parent.height / 2 - 10
                radius: 10
                color: Theme.surface 

                property var ws: workspaces[index]
                border.color: ws.focused ? Theme.accent : Theme.border

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    Text {
                        text: "WS " + ws.id
                        color: Theme.text
                        font.bold: true
                    }

                    Repeater {
                        model: root.clients.filter(c => c.workspace.id === ws.id)
                        delegate: Rectangle {
                            width: parent.width
                            height: 24
                            color: Theme.base02
                            radius: 4

                            Text {
                                text: modelData.title || modelData.app_id
                                color: Theme.text
                                font.pointSize: 10
                                elide: Text.ElideRight
                                anchors.centerIn: parent
                            }

                            Drag.active: dragArea.drag.active
                            Drag.hotSpot.x: width / 2
                            Drag.hotSpot.y: height / 2
                            Drag.mimeData: { "window": modelData.address }
                            MouseArea {
                                id: dragArea
                                anchors.fill: parent
                                drag.target: parent
                            }
                        }
                    }

                    DropArea {
                        anchors.fill: parent
                        onDropped: {
                            let addr = drop.mimeData.window
                            let cmd = Qt.createQmlObject('import Quickshell 1.0; Hyprctl { command: "dispatch movetoworkspace ' + ws.id + ' address:' + addr + '" }', root)
                            cmd.run()
                            root.updateData()
                        }
                    }
                }
            }
        }
    }
}
