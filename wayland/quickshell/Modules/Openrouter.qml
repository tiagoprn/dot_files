import Quickshell
import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var credits: S.Polls.credits

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Rectangle {
    anchors.fill: parent
    radius: S.Palette.radius
    color: S.Palette.bgWidget
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.credits ? root.credits.text : ""
    color: root.credits && root.credits.class === "critical" ? S.Palette.critical
      : root.credits && root.credits.class === "warning" ? S.Palette.warning
      : S.Palette.ok
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.clockSize
  }

  TapHandler {
    onTapped: Quickshell.execDetached(["firefox", "https://openrouter.ai/settings/credits"])
  }
}
