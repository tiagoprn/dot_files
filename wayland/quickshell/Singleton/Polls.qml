pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  property var week: ({ text: "" })
  property var flow: ({ text: "", class: "" })
  property var opencode: ({ text: "", class: "idle", tooltip: "" })
  property var caps: ({ text: "", class: "" })
  property var credits: ({ text: "", class: "ok" })

  property real cpuUsage: 0
  property real memUsage: 0
  property real diskUsage: 0

  property var previousStat: null

  function cpuSample(raw) {
    const line = (raw || "").split("\n")[0];
    if (line.indexOf("cpu ") !== 0) return;
    const parts = line.trim().split(/\s+/).slice(1).map(Number);
    const idle = parts[3] + (parts[4] || 0);
    const total = parts.reduce((sum, value) => sum + value, 0);
    if (previousStat !== null) {
      const deltaTotal = total - previousStat.total;
      const deltaIdle = idle - previousStat.idle;
      if (deltaTotal > 0) cpuUsage = Math.max(0, Math.min(100, 100 * (1 - deltaIdle / deltaTotal)));
    }
    previousStat = ({ total: total, idle: idle });
  }

  function memSample(raw) {
    const total = /MemTotal:\s+(\d+)/.exec(raw || "");
    const available = /MemAvailable:\s+(\d+)/.exec(raw || "");
    if (!total || !available) return;
    const size = Number(total[1]);
    if (size <= 0) return;
    memUsage = Math.max(0, Math.min(100, 100 * (1 - Number(available[1]) / size)));
  }

  function parseJson(raw, fallback): var {
    const body = (raw || "").trim();
    if (body === "") return fallback;
    try {
      const parsed = JSON.parse(body);
      return parsed && typeof parsed === "object" ? parsed : fallback;
    } catch (e) {
      return fallback;
    }
  }

  Timer {
    interval: 3600000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: weekProc.running = true
  }

  Process {
    id: weekProc

    command: ["sh", "-c", "~/scripts/week-info.sh"]

    stdout: StdioCollector {
      onStreamFinished: root.week = root.parseJson(text, root.week)
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: flowProc.running = true
  }

  Process {
    id: flowProc

    command: ["sh", "-c", "~/scripts/flow-status-waybar.sh"]

    stdout: StdioCollector {
      onStreamFinished: root.flow = root.parseJson(text, root.flow)
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: opencodeProc.running = true
  }

  Process {
    id: opencodeProc

    command: ["sh", "-c", "$HOME/.local/bin/uv run $HOME/scripts/opencode_go_usage.py --widget"]

    stdout: StdioCollector {
      onStreamFinished: root.opencode = root.parseJson(text, root.opencode)
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: capsProc.running = true
  }

  Process {
    id: capsProc

    command: ["sh", "-c", "~/scripts/caps-lock-waybar.sh"]

    stdout: StdioCollector {
      onStreamFinished: root.caps = root.parseJson(text, root.caps)
    }
  }

  Timer {
    interval: 60000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: creditsProc.running = true
  }

  Process {
    id: creditsProc

    command: ["sh", "-c", "~/scripts/openrouter-credits-balance-waybar.sh"]

    stdout: StdioCollector {
      onStreamFinished: root.credits = root.parseJson(text, root.credits)
    }
  }

  FileView {
    id: statFile

    path: "/proc/stat"

    onTextChanged: root.cpuSample(statFile.text())
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: statFile.reload()
  }

  FileView {
    id: memFile

    path: "/proc/meminfo"

    onTextChanged: root.memSample(memFile.text())
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: memFile.reload()
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: diskProc.running = true
  }

  Process {
    id: diskProc

    command: ["sh", "-c", "df -B1 /"]

    stdout: StdioCollector {
      onStreamFinished: {
        const rows = text.trim().split("\n");
        const fields = (rows[rows.length - 1] || "").trim().split(/\s+/);
        const used = parseInt((fields[4] || "").replace("%", ""), 10);
        if (!isNaN(used)) root.diskUsage = used;
      }
    }
  }
}
