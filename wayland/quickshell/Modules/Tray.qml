import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property int iconSize: 16

  implicitWidth: icons.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Row {
    id: icons

    anchors.centerIn: parent
    spacing: 10

    Repeater {
      model: SystemTray.items

      Item {
        id: trayItem

        required property var modelData

        implicitWidth: root.iconSize
        implicitHeight: root.iconSize

        IconImage {
          anchors.fill: parent
          source: trayItem.modelData.icon
          implicitSize: root.iconSize
        }

        QsMenuAnchor {
          id: menuAnchor

          anchor.item: trayItem
          menu: trayItem.modelData.menu
        }

        TapHandler {
          acceptedButtons: Qt.LeftButton

          onTapped: trayItem.modelData.onlyMenu ? menuAnchor.open() : trayItem.modelData.activate()
        }

        TapHandler {
          acceptedButtons: Qt.MiddleButton

          onTapped: trayItem.modelData.secondaryActivate()
        }

        TapHandler {
          acceptedButtons: Qt.RightButton

          onTapped: menuAnchor.open()
        }

        WheelHandler {
          onWheel: function (event) {
            trayItem.modelData.scroll(event.angleDelta.y, false);
          }
        }
      }
    }
  }
}
