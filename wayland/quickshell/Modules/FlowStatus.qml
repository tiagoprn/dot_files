import Quickshell
import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var flow: S.Polls.flow
  readonly property real slotWidth: Math.min(label.implicitWidth, S.Palette.flowMaxWidth)

  implicitWidth: root.slotWidth + 20
  implicitHeight: S.Palette.islandHeight

  Rectangle {
    anchors.fill: parent
    radius: S.Palette.radius
    color: root.flow && root.flow.class === "on" ? S.Palette.flowOnBg
      : root.flow && root.flow.class === "off" ? S.Palette.flowOffBg
      : S.Palette.bgWidget
  }

  Item {
    id: slot

    anchors.centerIn: parent
    width: root.slotWidth
    height: label.implicitHeight
    clip: true

    Text {
      id: label

      text: root.flow ? root.flow.text : ""
      color: S.Palette.fg
      font.family: S.Palette.fontFamily
      font.weight: S.Palette.fontWeight
      font.pixelSize: S.Palette.flowSize
    }

    SequentialAnimation {
      running: label.implicitWidth > slot.width
      loops: Animation.Infinite

      PauseAnimation { duration: 1200 }
      NumberAnimation {
        target: label
        property: "x"
        to: slot.width - label.implicitWidth
        duration: Math.max(1667, (label.implicitWidth - slot.width) * 17)
      }
      PauseAnimation { duration: 500 }
      NumberAnimation {
        target: label
        property: "x"
        to: 0
        duration: Math.max(1667, (label.implicitWidth - slot.width) * 17)
      }
    }
  }

  TapHandler {
    onTapped: Quickshell.execDetached(["sh", "-c", "~/scripts/flow-today-waybar.sh"])
  }
}
