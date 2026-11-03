import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Singleton" as S

Item {
  id: root

  property var screen
  property string remembered: ""
  property real limit: 100000

  readonly property var monitor: {
    const list = Hyprland.monitors.values;
    const name = screen ? screen.name : "";
    for (let i = 0; i < list.length; i++) {
      if (list[i].name === name) return list[i];
    }
    return null;
  }

  readonly property string activeHere: {
    const list = Hyprland.toplevels.values;
    const name = monitor ? monitor.name : "";
    for (let i = 0; i < list.length; i++) {
      const toplevel = list[i];
      if (!toplevel || !toplevel.activated) continue;
      if (toplevel.monitor && toplevel.monitor.name === name) return toplevel.title;
    }
    return "";
  }

  readonly property string seed: {
    const list = Hyprland.toplevels.values;
    const name = monitor ? monitor.name : "";
    let best = null;
    let bestIndex = Infinity;
    for (let i = 0; i < list.length; i++) {
      const toplevel = list[i];
      if (!toplevel || !toplevel.monitor || toplevel.monitor.name !== name) continue;
      const ipc = toplevel.lastIpcObject;
      const index = ipc && ipc.focusHistoryID !== undefined ? ipc.focusHistoryID : Infinity;
      if (index < bestIndex) {
        bestIndex = index;
        best = toplevel;
      }
    }
    return best ? best.title : "";
  }

  readonly property string titleText: activeHere !== "" ? activeHere : (remembered !== "" ? remembered : seed)
  readonly property bool compact: S.State.mode === "compact"

  onActiveHereChanged: {
    if (activeHere !== "") remembered = activeHere;
  }

  readonly property int maxWidth: Math.min(root.compact ? 400 : root.limit,
    S.Palette.titleMaxWidth)
  readonly property real slotWidth: Math.min(title.implicitWidth, root.maxWidth)

  implicitWidth: root.slotWidth + 20
  implicitHeight: title.implicitHeight

  Item {
    id: slot

    anchors.centerIn: parent
    width: root.slotWidth
    height: title.implicitHeight
    clip: true

    Text {
      id: title

      text: root.titleText
      color: S.Palette.fg
      font.family: S.Palette.fontFamily
      font.weight: S.Palette.fontWeight
      font.pixelSize: S.Palette.fontSize
    }

    SequentialAnimation {
      running: title.implicitWidth > slot.width && root.titleText !== ""
      loops: Animation.Infinite

      PauseAnimation { duration: 1500 }
      NumberAnimation {
        target: title
        property: "x"
        to: slot.width - title.implicitWidth
        duration: Math.max(1667, (title.implicitWidth - slot.width) * 17)
      }
      PauseAnimation { duration: 600 }
      NumberAnimation {
        target: title
        property: "x"
        to: 0
        duration: Math.max(1667, (title.implicitWidth - slot.width) * 17)
      }
    }
  }
}
