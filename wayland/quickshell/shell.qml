import Quickshell
import Quickshell.Io
import QtQuick
import "Modules"
import "Singleton" as S

Scope {
  readonly property var polls: S.Polls

  Variants {
    model: Quickshell.screens

    delegate: Component {
      Bar {}
    }
  }

  IpcHandler {
    target: "island"

    function setMode(mode: string): void {
      S.State.setMode(mode);
    }

    function toggleMode(): void {
      S.State.toggleMode();
    }

    function reload(): void {
      Quickshell.reload(false);
    }
  }
}
