import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import "../Singleton" as S
import "../Widgets"

Item {
  id: root

  property var panel: null

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

        readonly property string popupId: "tray:" + modelData.id
        readonly property bool menuOpen: S.State.openPopup === popupId

        implicitWidth: root.iconSize
        implicitHeight: root.iconSize

        // Left click reaches this only for items that exist purely as a menu.
        // A second click on an open menu closes it.
        function toggleMenu(): void {
          if (!trayItem.modelData.menu) {
            trayItem.modelData.activate();
            return;
          }
          S.State.togglePopup(trayItem.popupId);
        }

        // The item can vanish while its menu is up (Telegram quitting, for
        // example); without this the open popup name stays set in State.
        Component.onDestruction: {
          if (S.State.openPopup === trayItem.popupId) S.State.closePopup(trayItem.popupId);
        }

        IconImage {
          anchors.fill: parent
          source: trayItem.modelData.icon
          implicitSize: root.iconSize
        }

        TapHandler {
          acceptedButtons: Qt.LeftButton

          onTapped: trayItem.modelData.onlyMenu ? trayItem.toggleMenu() : trayItem.modelData.activate()
        }

        TapHandler {
          acceptedButtons: Qt.MiddleButton

          onTapped: trayItem.modelData.secondaryActivate()
        }

        TapHandler {
          acceptedButtons: Qt.RightButton

          onTapped: trayItem.toggleMenu()
        }

        WheelHandler {
          onWheel: function (event) {
            trayItem.modelData.scroll(event.angleDelta.y, false);
          }
        }

        TrayMenu {
          item: trayItem.modelData
          panel: root.panel
          open: trayItem.menuOpen
        }
      }
    }
  }
}
