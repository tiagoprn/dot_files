import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var caps: S.Polls.caps

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
    text: root.caps ? root.caps.text : ""
    color: root.caps && root.caps.class === "on" ? S.Palette.capsOn : S.Palette.capsOff
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.fontSize
  }
}
