import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Singleton" as S

Item {
  id: root

  property var screen

  readonly property var monitor: {
    const list = Hyprland.monitors.values;
    const name = screen ? screen.name : "";
    for (let i = 0; i < list.length; i++) {
      if (list[i].name === name) return list[i];
    }
    return null;
  }

  readonly property var activeWorkspace: monitor ? monitor.activeWorkspace : null

  readonly property var icons: ({
    "1": "\uF120",
    "2": "\uF268",
    "3": "\uF121",
    "4": "\uF1BC",
    "5": "\uF075"
  })

  readonly property var shown: {
    const mine = monitor ? monitor.name : "";
    return Hyprland.workspaces.values.filter(w => w.monitor ? w.monitor.name === mine : false);
  }

  implicitWidth: row.implicitWidth
  implicitHeight: S.Palette.islandHeight

  function focusRelative(delta: int): void {
    const step = delta > 0 ? "e+1" : "e-1";
    Hyprland.dispatch(Hyprland.usingLua ? `hl.dsp.focus({ workspace = "${step}" })` : `workspace ${step}`);
  }

  function activateWorkspace(workspace): void {
    if (!workspace) return;
    workspace.activate();
  }

  Row {
    id: row

    anchors.verticalCenter: parent.verticalCenter
    Repeater {
      model: root.shown

      delegate: Rectangle {
        id: pill

        required property var modelData

        readonly property string workspaceName: modelData ? modelData.name : ""
        readonly property bool workspaceActive: modelData ? modelData.active : false
        readonly property bool workspaceUrgent: modelData ? modelData.urgent : false

        implicitWidth: label.implicitWidth + 20
        implicitHeight: label.implicitHeight
        radius: S.Palette.radius
        color: workspaceUrgent ? S.Palette.wsUrgent : "transparent"

        Text {
          id: label

          anchors.centerIn: parent
          text: pill.workspaceName + ": " + (pill.workspaceActive ? "\uF192" : (root.icons[pill.workspaceName] || "\uF111"))
          color: pillHover.hovered ? S.Palette.wsHover : (pill.workspaceActive ? S.Palette.wsActive : S.Palette.wsText)
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
        }

        HoverHandler {
          id: pillHover
        }

        TapHandler {
          onTapped: {
            if (S.State.mode === "compact") S.State.expand();
            else root.activateWorkspace(pill.modelData);
          }
        }
      }
    }
  }

  WheelHandler {
    onWheel: function (event) {
      if (event.angleDelta.y !== 0) root.focusRelative(event.angleDelta.y > 0 ? 1 : -1);
    }
  }
}
