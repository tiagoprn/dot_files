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

  property var panel: null

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

  readonly property bool open: S.State.openPopup === "opencode"

  readonly property bool shown: root.open && S.State.mode === "full"

  TapHandler {
    onTapped: S.State.togglePopup("opencode")
  }

  PopupWindow {
    id: popup

    anchor.window: root.panel
    anchor.rect.x: root.panel ? Math.round((root.panel.width - width) / 2) : 0
    anchor.rect.y: root.panel ? Math.round((root.panel.screen.height - height) / 2) : 0
    visible: root.shown || body.opacity > 0.01
    implicitWidth: details.implicitWidth + 24
    implicitHeight: details.implicitHeight + 20
    color: "transparent"

    Rectangle {
      id: body

      anchors.fill: parent
      radius: S.Palette.radius
      color: "#ee2b2b2b"
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
        onTapped: S.State.closePopup("opencode")
      }

      Column {
        id: details

        anchors.centerIn: parent
        spacing: 3

        Repeater {
          model: root.tooltipLines.length ? root.tooltipLines : ["usage unavailable"]

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
