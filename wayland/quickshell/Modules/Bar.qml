import Quickshell
import QtQuick
import "../Singleton" as S

PanelWindow {
  id: win

  required property var modelData

  readonly property bool full: S.State.mode === "full"

  screen: modelData

  anchors {
    top: true
    left: true
    right: true
  }

  implicitHeight: S.Palette.windowHeight
  exclusiveZone: S.Palette.stripHeight
  color: "transparent"

  mask: Region {
    item: island
  }

  Rectangle {
    id: island

    anchors.centerIn: parent
    width: contentRow.implicitWidth + 24
    implicitHeight: S.Palette.islandHeight
    radius: S.Palette.radius
    color: S.Palette.bgIsland
    border.width: 0
    clip: true

    Behavior on width {
      NumberAnimation {
        duration: S.Palette.motionMs
        easing.type: Easing.OutCubic
      }
    }

    HoverHandler {
      onHoveredChanged: hovered ? S.State.expand() : S.State.scheduleCollapse()
    }

    Row {
      id: contentRow

      anchors.centerIn: parent
      spacing: 0

      Row {
        id: leftRow

        spacing: 0

        Workspaces {
          id: workspaces

          screen: win.modelData
        }

        WindowTitle {
          screen: win.modelData
          limit: win.width - workspaces.implicitWidth - centerRow.implicitWidth
            - rightSlot.width - 48
        }
      }

      Row {
        id: centerRow

        spacing: 0

        WeekInfo {
          id: weekInfo

          onToggled: clock.toggle()
        }

        Clock {
          id: clock

          panel: win
        }

        FlowStatus {}

        Item {
          id: openrouterSlot

          width: win.full ? openrouter.implicitWidth : 0
          implicitHeight: S.Palette.islandHeight
          opacity: win.full ? 1 : 0
          clip: true

          Behavior on width {
            NumberAnimation {
              duration: S.Palette.motionMs
              easing.type: Easing.OutCubic
            }
          }

          Behavior on opacity {
            NumberAnimation {
              duration: S.Palette.motionMs
              easing.type: Easing.OutCubic
            }
          }

          Openrouter {
            id: openrouter

            anchors.verticalCenter: parent.verticalCenter
          }
        }

        OpencodeUsage {
          panel: win
        }

        CapsLock {}
      }

      Item {
        id: rightSlot

        width: win.full ? rightRow.implicitWidth : 0
        implicitHeight: S.Palette.islandHeight
        opacity: win.full ? 1 : 0
        clip: true

        Behavior on width {
          NumberAnimation {
            duration: S.Palette.motionMs
            easing.type: Easing.OutCubic
          }
        }

        Behavior on opacity {
          NumberAnimation {
            duration: S.Palette.motionMs
            easing.type: Easing.OutCubic
          }
        }

        Row {
          id: rightRow

          anchors.verticalCenter: parent.verticalCenter
          spacing: 0

          PulseAudio {}

          Disk {}

          Cpu {}

          Memory {}

          BatteryWdg {
            panel: win
          }

          Tray {
            panel: win
          }
        }
      }
    }
  }
}
