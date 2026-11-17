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

  property var opencodeAccounts: []

  readonly property string keysFile: "/storage/src/aikt/pi/opencode-go-keys.txt"
  readonly property string opencodeStatePath: Quickshell.env("HOME")
    + "/.local/state/quickshell/opencode-account"

  property string opencodeStoredEntry: ""
  property int opencodeIndex: 0
  property int opencodeGeneration: 0
  property int opencodeRunningGeneration: -1

  readonly property var opencodeAccount: root.opencodeAccounts.length === 0 ? null
    : root.opencodeAccounts[Math.min(root.opencodeIndex, root.opencodeAccounts.length - 1)]
  readonly property string opencodeEntry: root.opencodeAccount ? root.opencodeAccount.entry : ""

  onOpencodeAccountsChanged: root.applyStoredEntry()
  onOpencodeStoredEntryChanged: root.applyStoredEntry()
  onOpencodeEntryChanged: root.requestOpencodeFetch()

  function parseAccounts(raw): var {
    const accounts = [];
    const lines = (raw || "").split("\n");
    for (let index = 0; index < lines.length; index++) {
      const line = lines[index].trim();
      if (line === "" || line.charAt(0) === "#") continue;
      if (line.indexOf("READ") < 0) continue;
      const separator = line.lastIndexOf("|");
      if (separator < 0) continue;
      const entry = line.slice(separator + 1).trim();
      if (entry === "") continue;
      accounts.push({ label: line.slice(0, separator).trim(), entry: entry });
    }
    return accounts;
  }

  function refreshAccounts(): void {
    root.opencodeAccounts = root.parseAccounts(keysView.text());
  }

  function restoreSelection(): void {
    const stored = stateFile.text().trim();
    if (stored !== root.opencodeStoredEntry) root.opencodeStoredEntry = stored;
  }

  function applyStoredEntry(): void {
    const accounts = root.opencodeAccounts;
    if (accounts.length === 0) {
      root.opencodeIndex = 0;
      return;
    }
    for (let index = 0; index < accounts.length; index++) {
      if (accounts[index].entry === root.opencodeStoredEntry) {
        root.opencodeIndex = index;
        return;
      }
    }
    root.opencodeIndex = 0;
  }

  function cycleOpencode(step): void {
    const accounts = root.opencodeAccounts;
    if (accounts.length < 2) {
      root.requestOpencodeFetch();
      return;
    }
    const next = (root.opencodeIndex + step + accounts.length) % accounts.length;
    root.opencodeStoredEntry = accounts[next].entry;
    stateFile.setText(root.opencodeStoredEntry);
  }

  function opencodeCommand(): var {
    const command = [Quickshell.env("HOME") + "/.local/bin/uv", "run",
      Quickshell.env("HOME") + "/scripts/opencode_go_usage.py", "--widget"];
    if (root.opencodeEntry !== "") command.push("--pass-entry", root.opencodeEntry);
    return command;
  }

  function startOpencodeFetch(): void {
    root.opencodeRunningGeneration = root.opencodeGeneration;
    opencodeProc.running = true;
  }

  function requestOpencodeFetch(): void {
    root.opencodeGeneration += 1;
    root.startOpencodeFetch();
  }

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

  FileView {
    id: keysView

    path: root.keysFile
    blockLoading: true
    watchChanges: true

    onLoaded: root.refreshAccounts()
    onTextChanged: root.refreshAccounts()
  }

  FileView {
    id: stateFile

    path: root.opencodeStatePath
    blockLoading: true
    blockWrites: true
    atomicWrites: true

    onLoaded: root.restoreSelection()
    onTextChanged: root.restoreSelection()
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

    command: root.opencodeCommand()

    stdout: StdioCollector {
      onStreamFinished: {
        if (root.opencodeRunningGeneration !== root.opencodeGeneration) {
          root.startOpencodeFetch();
          return;
        }
        root.opencode = root.parseJson(text, {
          text: "",
          class: "idle",
          tooltip: "No data for " + root.opencodeEntry + "."
        });
      }
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
