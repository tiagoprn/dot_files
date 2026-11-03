import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property real usage: S.Polls.diskUsage

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Text {
    id: label

    anchors.centerIn: parent
    text: "\uF1C0 D  " + Math.round(root.usage) + "%"
    color: S.Palette.fg
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.rightSize
  }
}
