import Quickshell
import QtQuick
import "../Singleton" as S
import "../Widgets"

Item {
  id: root

  property bool alt: false
  property date now: new Date()
  property date calendarDate: new Date()
  property bool open: false
  property bool trigger: false

  readonly property bool shown: root.open && S.State.mode === "full"

  readonly property string formatted: root.alt
    ? Qt.formatDateTime(root.now, "yyyy-MM-dd")
    : Qt.formatDateTime(root.now, "ddd MMM dd - HH:mm:ss")

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

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

  TapHandler {
    onTapped: root.alt = !root.alt
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.now = new Date()
  }

  onTriggerChanged: trigger ? openTimer.start() : openTimer.stop()

  Timer {
    id: openTimer

    interval: 2000

    onTriggered: {
      root.calendarDate = new Date();
      root.open = true;
    }
  }

  Timer {
    id: dismissTimer

    interval: 10000
    running: root.shown

    onTriggered: root.open = false
  }

  PopupWindow {
    id: popup

    anchor.item: label
    anchor.margins.top: 4
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
        onTapped: root.open = false
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
