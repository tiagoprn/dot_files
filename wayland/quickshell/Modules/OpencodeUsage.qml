import Quickshell
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
  readonly property string tooltipText: usage && usage.tooltip ? usage.tooltip : ""
  readonly property var tooltipLines: tooltipText.split("\n").filter(line => line.trim() !== "")

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  Rectangle {
    id: hitbox

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
    font.pixelSize: S.Palette.fontSize
  }

  property bool detailed: true

  HoverHandler {
    id: pointer

    target: root
  }

  Timer {
    id: openTimer

    interval: 800
    repeat: false

    onTriggered: root.detailed = true
  }

  Connections {
    target: pointer

    function onHoveredChanged() {
      pointer.hovered ? openTimer.restart() : openTimer.stop();
    }
  }

  Timer {
    id: dismissTimer

    interval: 10000
    running: root.detailed

    onTriggered: root.detailed = false
  }

  PopupWindow {
    id: popup

    anchor.item: label
    anchor.margins.top: 2
    visible: root.detailed && root.tooltipText !== "" || body.opacity > 0.01
    implicitWidth: details.implicitWidth + 24
    implicitHeight: details.implicitHeight + 20
    color: "transparent"

    Rectangle {
      id: body

      anchors.fill: parent
      radius: S.Palette.radius
      color: "#ee2b2b2b"
      opacity: root.detailed ? 1 : 0
      scale: root.detailed ? 1 : 0.94
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
        onTapped: root.detailed = false
      }

      Column {
        id: details

        anchors.centerIn: parent
        spacing: 3

        Repeater {
          model: root.tooltipLines

          Text {
            required property string modelData

            text: modelData
            color: S.Palette.fg
            font.family: S.Palette.fontFamily
            font.weight: S.Palette.fontWeight
            font.pixelSize: S.Palette.fontSize
          }
        }
      }
    }
  }
}
