import Quickshell
import QtQuick
import "../Singleton" as S

PanelWindow {
  id: win
  required property var modelData

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
    implicitWidth: contentRow.implicitWidth + 24
    implicitHeight: S.Palette.islandHeight
    radius: S.Palette.radius
    color: S.Palette.bgIsland
    border.width: 0

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
            - rightRow.implicitWidth - 48
        }
      }

      Row {
        id: centerRow

        spacing: 0

        WeekInfo {}

        Clock {}

        FlowStatus {}

        Openrouter {
          visible: S.State.mode === "full"
        }

        OpencodeUsage {}

        CapsLock {}
      }

      Row {
        id: rightRow

        spacing: 0

        PulseAudio {
          visible: S.State.mode === "full"
        }

        Disk {
          visible: S.State.mode === "full"
        }

        Cpu {
          visible: S.State.mode === "full"
        }

        Memory {
          visible: S.State.mode === "full"
        }

        BatteryWdg {
          visible: S.State.mode === "full"
        }

        Tray {
          visible: S.State.mode === "full"
        }
      }
    }
  }
}
