import Quickshell
import Quickshell.Services.Pipewire
import QtQuick
import "../Singleton" as S

Item {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property bool hasSink: sink !== null && sink !== undefined && sink.ready && sink.audio !== null
  readonly property real volume: hasSink ? Math.max(0, Math.min(1, sink.audio.volume)) : 0
  readonly property bool muted: hasSink ? sink.audio.muted : false
  readonly property int percent: Math.round(volume * 100)
  readonly property string icon: muted ? "\uF6A9" : percent > 33 ? "\uF028" : "\uF026"

  implicitWidth: label.implicitWidth + 20
  implicitHeight: S.Palette.islandHeight

  PwObjectTracker {
    objects: root.sink ? [root.sink] : []
  }

  Text {
    id: label

    anchors.centerIn: parent
    text: root.hasSink ? (root.muted ? root.icon : root.icon + "  " + root.percent + "%") : ""
    color: S.Palette.fg
    font.family: S.Palette.fontFamily
    font.weight: S.Palette.fontWeight
    font.pixelSize: S.Palette.fontSize
  }

  WheelHandler {
    onWheel: function (event) {
      if (!root.hasSink || event.angleDelta.y === 0) return;
      const step = event.angleDelta.y > 0 ? 0.05 : -0.05;
      root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + step));
    }
  }
}
