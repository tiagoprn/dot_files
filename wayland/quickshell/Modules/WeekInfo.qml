import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var week: S.Polls.week
  readonly property alias hovered: pointer.hovered

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Rectangle {
    id: hitbox

    anchors.fill: parent
    radius: S.Palette.radius
    color: S.Palette.bgWidget
  }

  HoverHandler {
    id: pointer

    target: root
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.week ? root.week.text : ""
    color: S.Palette.weekText
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.fontSize
  }
}
