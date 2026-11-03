pragma Singleton
import Quickshell
import QtQuick

Singleton {
  readonly property color bgIsland: "#bf000000"
  readonly property color bgWidget: "#000000"
  readonly property color opencodeBg: "#2a2a2a"

  readonly property color fg: "#FFFFFF"
  readonly property color clockText: "#FFFF00"
  readonly property color weekText: "#FFFF00"

  readonly property color wsText: "#FFFFFF"
  readonly property color wsActive: "#00FF00"
  readonly property color wsHover: "#009900"
  readonly property color wsUrgent: "#eb4d4b"

  readonly property color ok: "#00FF00"
  readonly property color warning: "#FFA500"
  readonly property color critical: "#FF0000"

  readonly property color capsOn: "green"
  readonly property color capsOff: "red"

  readonly property color flowOnBg: "green"
  readonly property color flowOffBg: "red"

  readonly property color batteryOk: "#00FF00"
  readonly property color batteryChargingFg: "#ffffff"
  readonly property color batteryChargingBg: "#26A65B"
  readonly property color batteryCriticalBg: "#f53c3c"

  readonly property int radius: 10
  readonly property int windowHeight: 40
  readonly property int islandHeight: 36
  readonly property int stripHeight: 43

  readonly property int fontSize: 14
  readonly property int clockSize: 20
  readonly property int flowSize: 16
  readonly property int rightSize: 16

  readonly property int titleMaxWidth: 180
  readonly property int flowMaxWidth: 180

  readonly property string fontFamily: "Fira Sans"
  readonly property int fontWeight: Font.DemiBold
}
