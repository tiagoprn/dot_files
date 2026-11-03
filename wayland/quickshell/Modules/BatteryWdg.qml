import Quickshell
import Quickshell.Services.UPower
import QtQuick
import "../Singleton" as S

Item {
  id: root

  property var panel: null

  readonly property bool open: S.State.openPopup === "battery"

  readonly property var battery: UPower.displayDevice
  readonly property bool ready: battery !== null && battery !== undefined && battery.ready
  readonly property int capacity: ready ? Math.round(battery.percentage * 100) : 0
  readonly property bool charging: ready && battery.state === UPowerDeviceState.Charging
  readonly property bool plugged: ready && (battery.state === UPowerDeviceState.FullyCharged
    || battery.state === UPowerDeviceState.PendingCharge)
  readonly property bool critical: ready && !charging && capacity <= 15
  readonly property bool warning: ready && !charging && !plugged && !critical
    && capacity <= 30

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
      : root.warning ? S.Palette.warning
      : S.Palette.batteryOk
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.fontSize
  }

  TapHandler {
    onTapped: S.State.togglePopup("battery")
  }

  PopupWindow {
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
      color: S.Palette.bgIsland
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
        onTapped: S.State.closePopup("battery")
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
          font.pixelSize: S.Palette.fontSize
        }

        Text {
          text: root.stateText
          color: S.Palette.ok
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
        }
      }
    }
  }
}
