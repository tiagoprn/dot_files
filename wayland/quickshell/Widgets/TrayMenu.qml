pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import "../Singleton" as S

// Styled tray menu, rendered as a centred popup on the monitor that owns the
// clicked tray icon. Replaces QsMenuAnchor, which draws a native Qt menu at the
// icon with its own font and colours.
//
// The menu tree comes from QsMenuOpener, which refs the DBusMenu handle and runs
// AboutToShow plus GetLayout(0, -1) on it, so one round trip delivers the whole
// tree, submenus included. Clicking a leaf emits QsMenuEntry::triggered, which
// Quickshell turns into the DBusMenu "clicked" event.
Item {
  id: root

  property var panel: null // the Bar PanelWindow that owns this widget
  property var item: null // SystemTrayItem
  property bool open: false

  property var submenuEntry: null
  property Item hoveredRow: null
  property bool holdOpen: false // keeps the menu handle referenced during the fade-out

  readonly property string menuId: root.item ? "tray:" + root.item.id : ""
  readonly property int rowHeight: 26
  readonly property int labelMaxWidth: 320
  readonly property int hoveredY: root.hoveredRow ? root.hoveredRow.y : 0

  readonly property color disabledFg: "#66ffffff"
  readonly property color hoverBg: "#22ffffff"
  readonly property color separatorFg: "#33ffffff"

  function close(): void {
    if (root.menuId !== "") S.State.closePopup(root.menuId);
  }

  function activateEntry(entry): void {
    if (!entry || entry.isSeparator || !entry.enabled) return;
    if (entry.hasChildren) {
      root.submenuEntry = entry;
      return;
    }
    entry.triggered();
    root.close();
  }

  onOpenChanged: {
    if (root.open) {
      holdTimer.stop();
      root.holdOpen = true;
    } else {
      root.submenuEntry = null;
      root.hoveredRow = null;
      holdTimer.restart();
    }
  }

  Timer {
    id: holdTimer

    interval: S.Palette.motionMs + 40
    repeat: false

    onTriggered: root.holdOpen = false
  }

  // Loaded on demand: the handle is only referenced while the popup is up, so no
  // AboutToShow traffic runs for a menu nobody opened.
  QsMenuOpener {
    id: opener
    menu: (root.open || root.holdOpen) && root.item ? root.item.menu : null
  }

  QsMenuOpener {
    id: subOpener
    menu: root.submenuEntry
  }

  // Fallback for an item that advertises a menu handle but returns no items.
  Timer {
    id: emptyTimer

    interval: 700
    repeat: false
    running: root.open && rootRows.count === 0

    onTriggered: {
      if (!root.open || rootRows.count > 0) return;
      console.warn("TrayMenu: no menu entries for", root.menuId);
      root.close();
      if (root.item) root.item.activate();
    }
  }

  HyprlandFocusGrab {
    active: root.open && popup.visible
    windows: [popup]

    onCleared: root.close()
  }

  Component {
    id: menuRow

    Item {
      id: row

      required property var modelData

      readonly property var entry: row.modelData
      readonly property bool separator: !!row.entry && row.entry.isSeparator
      readonly property bool entryEnabled: !!row.entry && row.entry.enabled
      readonly property bool hasKids: !!row.entry && row.entry.hasChildren
      readonly property bool checked: !!row.entry && row.entry.checkState !== Qt.Unchecked
      readonly property string iconSource: row.entry ? String(row.entry.icon) : ""
      readonly property bool hovered: root.hoveredRow === row

      // Separators carry the cap as well, which gives every row one uniform width.
      implicitWidth: row.separator ? root.labelMaxWidth : rowContent.implicitWidth + 16
      implicitHeight: row.separator ? 9 : root.rowHeight

      Rectangle {
        anchors.fill: parent
        radius: 4
        color: root.hoverBg
        visible: row.hovered && !row.separator
      }

      Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        width: parent.width
        height: 1
        color: root.separatorFg
        visible: row.separator
      }

      Row {
        id: rowContent

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        spacing: 6
        visible: !row.separator

        Image {
          anchors.verticalCenter: parent.verticalCenter
          width: 16
          height: 16
          source: row.iconSource
          sourceSize.width: 16
          sourceSize.height: 16
          visible: row.iconSource.length > 0
        }

        Text {
          // Fixed indicator column keeps every label on the same x.
          anchors.verticalCenter: parent.verticalCenter
          width: 10
          text: row.checked ? "\u25CF" : ""
          color: S.Palette.ok
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
          horizontalAlignment: Text.AlignLeft
        }

        Text {
          anchors.verticalCenter: parent.verticalCenter
          width: Math.min(implicitWidth, root.labelMaxWidth)
          text: row.entry ? String(row.entry.text) : ""
          color: row.entryEnabled ? S.Palette.fg : root.disabledFg
          elide: Text.ElideRight
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
        }

        Text {
          anchors.verticalCenter: parent.verticalCenter
          text: "\u203A"
          color: S.Palette.fg
          visible: row.hasKids
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
        }
      }

      TapHandler {
        onTapped: root.activateEntry(row.entry)
      }
    }
  }

  PopupWindow {
    id: popup

    // Centred on the root column, not on the whole popup, so opening a submenu
    // grows the popup to the right instead of dragging the rows out from under
    // the pointer. With no submenu open the two boxes are identical, which is
    // the case the Captain sees almost always.
    anchor.window: root.panel
    anchor.rect.x: root.panel ? Math.round((root.panel.width - (rootColumn.implicitWidth + 24)) / 2) : 0
    anchor.rect.y: root.panel ? Math.round((root.panel.screen.height - (rootColumn.implicitHeight + 16)) / 2) : 0
    visible: (root.open && rootRows.count > 0) || body.opacity > 0.01
    implicitWidth: columns.implicitWidth + 24
    implicitHeight: columns.implicitHeight + 16
    color: "transparent"

    // The submenu column changes the width. The left edge is pinned by the
    // anchor above, so this slides the new column out instead of a hard cut.
    Behavior on implicitWidth {
      NumberAnimation {
        duration: S.Palette.motionMs
        easing.type: Easing.OutCubic
      }
    }

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

      // Sits behind the rows, so it only sees clicks on the popup padding.
      MouseArea {
        anchors.fill: parent
        onClicked: root.close()
      }

      Row {
        id: columns

        anchors.centerIn: parent
        spacing: 20

        Column {
          id: rootColumn

          spacing: 2

          HoverHandler {
            id: rootHover

            onPointChanged: {
              const row = rootColumn.childAt(point.position.x, point.position.y);
              // The 2 px gaps between rows must not clear the submenu.
              if (!row) return;
              root.hoveredRow = row;
              root.submenuEntry = row.entry && row.entry.hasChildren ? row.entry : null;
            }

            onHoveredChanged: {
              // Leaving the column must not clear the submenu, because the next
              // place the pointer goes is that submenu.
              if (!hovered) root.hoveredRow = null;
            }
          }

          Repeater {
            id: rootRows

            model: opener.children
            delegate: menuRow
          }
        }

        Item {
          id: subWrap

          visible: subRows.count > 0
          implicitWidth: subColumn.implicitWidth
          implicitHeight: subColumn.implicitHeight

          Column {
            id: subColumn

            // Aligned with the parent row like a native submenu, and clamped so
            // the column stays inside the popup box when the parent row sits
            // near the bottom of the root list.
            y: Math.max(0, Math.min(root.hoveredY,
              Math.max(0, rootColumn.implicitHeight - subColumn.implicitHeight)))
            spacing: 2

            Repeater {
              id: subRows

              model: subOpener.children
              delegate: menuRow
            }
          }
        }
      }
    }
  }
}
