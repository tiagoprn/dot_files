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
  property real nowMs: Date.now()

  readonly property string ageText: root.formatAge(S.Polls.opencodeFetchedAt)

  function formatAge(ms): string {
    if (!ms) return "never fetched";
    const seconds = Math.max(0, Math.floor((root.nowMs - ms) / 1000));
    const at = Qt.formatTime(new Date(ms), "HH:mm:ss");
    if (seconds < 60) return "just now, at " + at;
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) {
      return minutes + (minutes === 1 ? " minute ago, at " : " minutes ago, at ") + at;
    }
    const hours = Math.floor(minutes / 60);
    if (hours < 24) {
      return hours + (hours === 1 ? " hour ago, at " : " hours ago, at ") + at;
    }
    const days = Math.floor(hours / 24);
    return days + (days === 1 ? " day ago, at " : " days ago, at ") + at;
  }

  Timer {
    interval: 1000
    running: root.open
    repeat: true
    triggeredOnStart: true
    onTriggered: root.nowMs = Date.now()
  }

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

  TapHandler {
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onTapped: (eventPoint, button) => {
      if (button === Qt.RightButton) S.Polls.cycleOpencode(1);
      else S.State.togglePopup("opencode");
    }
  }

  PopupWindow {
    id: popup

    anchor.window: root.panel
    anchor.rect.x: root.panel ? Math.round((root.panel.width - width) / 2) : 0
    anchor.rect.y: root.panel ? Math.round((root.panel.screen.height - height) / 2) : 0
    visible: root.open || body.opacity > 0.01
    implicitWidth: details.implicitWidth + 24
    implicitHeight: details.implicitHeight + 20
    color: "transparent"

    Rectangle {
      id: body

      anchors.fill: parent
      radius: S.Palette.radius
      color: "#ee2b2b2b"
      opacity: root.open ? 1 : 0
      scale: root.open ? 1 : 0.94
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

        Column {
          spacing: 1

          Text {
            width: details.implicitWidth
            horizontalAlignment: Text.AlignHCenter
            text: S.Polls.opencodeAccount ? S.Polls.opencodeAccount.label : "OpenCode Go key"
            color: S.Palette.opencodeKey
            font.family: S.Palette.fontFamily
            font.weight: Font.Bold
            font.pixelSize: S.Palette.fontSize
          }

          Text {
            width: details.implicitWidth
            horizontalAlignment: Text.AlignHCenter
            text: "(" + (S.Polls.opencodeEntry !== "" ? S.Polls.opencodeEntry : "script default") + ")"
            color: S.Palette.opencodeKey
            font.family: S.Palette.fontFamily
            font.weight: S.Palette.fontWeight
            font.italic: true
            font.pixelSize: S.Palette.fontSize
          }

          Text {
            width: details.implicitWidth
            horizontalAlignment: Text.AlignHCenter
            text: root.ageText
            color: S.Palette.ok
            font.family: S.Palette.fontFamily
            font.weight: S.Palette.fontWeight
            font.pixelSize: S.Palette.fontSize
          }
        }

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
