pragma Singleton
import Quickshell
import QtQuick

Singleton {
  id: root

  property string mode: "compact"
  property string openPopup: ""
  readonly property int collapseDelayMs: 400

  function expand(): void {
    cancelCollapse();
    if (mode !== "full") mode = "full";
  }

  function scheduleCollapse(): void {
    if (mode === "full") collapseTimer.restart();
  }

  function cancelCollapse(): void {
    collapseTimer.stop();
  }

  function setMode(next: string): void {
    if (next !== "full" && next !== "compact") return;
    cancelCollapse();
    mode = next;
  }

  function toggleMode(): void {
    setMode(mode === "full" ? "compact" : "full");
  }

  function togglePopup(name: string): void {
    openPopup = openPopup === name ? "" : name;
  }

  function closePopup(name: string): void {
    if (openPopup === name) openPopup = "";
  }

  Timer {
    id: collapseTimer
    interval: root.collapseDelayMs
    repeat: false
    onTriggered: {
      root.mode = "compact";
      root.openPopup = "";
    }
  }
}
