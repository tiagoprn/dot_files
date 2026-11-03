import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var usage: S.Polls.opencode
  readonly property string styled: {
    if (!usage || !usage.text) return "";
    return usage.text.replace(/<span foreground="/g, "<font color=\"").replace(/<\/span>/g, "</font>");
  }
  readonly property bool hasData: styled !== ""

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Rectangle {
    anchors.fill: parent
    radius: S.Palette.radius
    color: S.Palette.opencodeBg
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.hasData ? root.styled : "Go: no data"
    textFormat: Text.StyledText
    color: S.Palette.fg
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.clockSize
  }
}
