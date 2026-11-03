import Quickshell
import QtQuick
import "../Singleton" as S
import "../Widgets"

Item {
  id: root

  property var panel: null
  property date now: new Date()
  property date calendarDate: new Date()

  readonly property bool open: S.State.openPopup === "calendar"

  readonly property bool shown: root.open && S.State.mode === "full"

  readonly property string formatted: Qt.formatDateTime(root.now, "ddd MMM dd - HH:mm:ss")

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  function toggle(): void {
    if (!root.open) root.calendarDate = new Date();
    S.State.togglePopup("calendar");
  }

  function shiftMonth(delta) {
    root.calendarDate = new Date(root.calendarDate.getFullYear(),
      root.calendarDate.getMonth() + delta, 1);
  }

  Rectangle {
    anchors.fill: parent
    radius: S.Palette.radius
    color: S.Palette.bgWidget
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.formatted
    color: S.Palette.clockText
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.fontSize
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.now = new Date()
  }

  PopupWindow {
    id: popup

    anchor.window: root.panel
    anchor.rect.x: root.panel ? Math.round((root.panel.width - width) / 2) : 0
    anchor.rect.y: root.panel ? Math.round((root.panel.screen.height - height) / 2) : 0
    visible: root.shown || body.opacity > 0.01
    implicitWidth: calendar.implicitWidth
    implicitHeight: calendar.implicitHeight
    color: "transparent"

    Rectangle {
      id: body

      anchors.fill: parent
      radius: S.Palette.radius
      color: S.Palette.bgIsland
      opacity: root.shown ? 1 : 0
      scale: root.shown ? 1 : 0.94
      transformOrigin: Item.Top

      Behavior on opacity {
        NumberAnimation {
          duration: S.Palette.motionMs
          easing.type: Easing.OutCubic
        }
      }

      Behavior on scale {
        NumberAnimation {
          duration: S.Palette.motionMs
          easing.type: Easing.OutCubic
        }
      }

      TapHandler {
        onTapped: S.State.closePopup("calendar")
      }

      Calendar {
        id: calendar

        anchors.fill: parent
        anchorDate: root.calendarDate

        onMonthShifted: function (delta) {
          root.shiftMonth(delta);
        }
      }
    }
  }
}
