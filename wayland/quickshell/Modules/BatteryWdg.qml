import Quickshell
import Quickshell.Services.UPower
import QtQuick
import "../Singleton" as S

Item {
  id: root

  property bool open: false

  readonly property var battery: UPower.displayDevice
  readonly property bool ready: battery !== null && battery !== undefined && battery.ready
  readonly property int capacity: ready ? Math.round(battery.percentage * 100) : 0
  readonly property bool charging: ready && battery.state === UPowerDeviceState.Charging
  readonly property bool plugged: ready && (battery.state === UPowerDeviceState.FullyCharged
    || battery.state === UPowerDeviceState.PendingCharge)
  readonly property bool critical: ready && !charging && capacity <= 15

  readonly property bool shown: root.open && S.State.mode === "full"

  readonly property string stateText: !root.ready ? ""
    : root.charging ? "charging"
    : root.plugged ? "plugged in"
    : root.battery.state === UPowerDeviceState.Discharging ? root.durationText(root.battery.timeToEmpty) + " left"
    : "on battery"

  readonly property string icon: {
    const icons = ["\uF244", "\uF243", "\uF242", "\uF241", "\uF240"];
    return icons[Math.min(4, Math.floor(capacity / 20))];
  }
  readonly property string text: !ready ? ""
    : charging ? capacity + "% \uF5E7"
    : plugged ? capacity + "% \uF1E6"
    : capacity + "% " + icon

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  function durationText(seconds) {
    if (!seconds || seconds <= 0) return "unknown time";
    const hours = Math.floor(seconds / 3600);
    const minutes = Math.round((seconds % 3600) / 60);
    return hours > 0 ? hours + "h " + minutes + "m" : minutes + "m";
  }

  Rectangle {
    id: box

    anchors.fill: parent
    radius: S.Palette.radius
    color: root.charging || root.plugged ? S.Palette.batteryChargingBg
      : root.critical ? S.Palette.batteryCriticalBg
      : "transparent"

    SequentialAnimation on opacity {
      running: root.critical
      loops: Animation.Infinite

      NumberAnimation { to: 0.4; duration: 250 }
      NumberAnimation { to: 1; duration: 250 }
    }
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.text
    color: root.charging || root.plugged ? S.Palette.batteryChargingFg
      : root.critical ? S.Palette.batteryChargingFg
      : S.Palette.batteryOk
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.rightSize
  }

  HoverHandler {
    onHoveredChanged: {
      if (hovered) {
        openTimer.start();
      } else {
        openTimer.stop();
        closeTimer.start();
      }
    }
  }

  Timer {
    id: openTimer

    interval: 250

    onTriggered: root.open = true
  }

  Timer {
    id: closeTimer

    interval: 150

    onTriggered: root.open = false
  }

  PopupWindow {
    anchor.item: label
    anchor.margins.top: 4
    visible: root.shown
    implicitWidth: details.implicitWidth + 24
    implicitHeight: details.implicitHeight + 20
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      radius: S.Palette.radius
      color: S.Palette.bgIsland
    }

    Column {
      id: details

      anchors.centerIn: parent
      spacing: 4

      Text {
        text: root.capacity + "%"
        color: S.Palette.fg
        font.family: S.Palette.fontFamily
        font.weight: S.Palette.fontWeight
        font.pixelSize: S.Palette.clockSize
      }

      Text {
        text: root.stateText
        color: S.Palette.ok
        font.family: S.Palette.fontFamily
        font.weight: S.Palette.fontWeight
        font.pixelSize: S.Palette.fontSize
      }
    }

    HoverHandler {
      onHoveredChanged: {
        if (hovered) {
          closeTimer.stop();
        } else {
          closeTimer.start();
        }
      }
    }
  }
}
