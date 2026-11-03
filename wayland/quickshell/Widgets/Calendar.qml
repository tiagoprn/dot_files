import QtQuick
import "../Singleton" as S

Item {
  id: root

  property date anchorDate: new Date()
  property string mode: "year"
  property int monthColumns: 3
  property int scrollStep: 1
  property int leadMonths: 3
  signal monthShifted(delta: int)

  readonly property color monthColor: "#ffead3"
  readonly property color dayColor: "#ecc6d9"
  readonly property color weekColor: "#99ffdd"
  readonly property color weekdayColor: "#ffcc66"
  readonly property color todayColor: "#ff0000"

  readonly property int cellWidth: 26
  readonly property int weekWidth: 34

  readonly property var weekdays: ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"]

  readonly property var months: buildMonths(root.anchorDate,
    root.mode === "year" ? 12 : root.monthColumns)

  implicitWidth: grid.implicitWidth + 24
  implicitHeight: grid.implicitHeight + 24

  function isoWeek(date) {
    const d = new Date(date.getFullYear(), date.getMonth(), date.getDate());
    d.setDate(d.getDate() - (d.getDay() + 6) % 7 + 3);
    const firstThursday = new Date(d.getFullYear(), 0, 4);
    firstThursday.setDate(firstThursday.getDate() - (firstThursday.getDay() + 6) % 7 + 3);
    return 1 + Math.round((d - firstThursday) / 604800000);
  }

  function buildMonths(anchor, count) {
    const now = new Date();
    const out = [];
    for (let i = 0; i < count; i++) {
      const first = new Date(anchor.getFullYear(), anchor.getMonth() + i - root.leadMonths, 1);
      const year = first.getFullYear();
      const month = first.getMonth();
      const lead = (first.getDay() + 6) % 7;
      const length = new Date(year, month + 1, 0).getDate();
      const rows = [];
      for (let row = 0; row < Math.ceil((lead + length) / 7); row++) {
        const monday = new Date(year, month, 1 - lead + row * 7);
        const days = [];
        for (let day = 0; day < 7; day++) {
          const date = new Date(year, month, 1 - lead + row * 7 + day);
          const today = date.getFullYear() === now.getFullYear()
            && date.getMonth() === now.getMonth()
            && date.getDate() === now.getDate();
          days.push({
            text: date.getMonth() === month ? String(date.getDate()) : "",
            color: today ? root.todayColor : root.dayColor,
            today: today,
          });
        }
        rows.push({ week: "W" + isoWeek(monday), days: days });
      }
      out.push({ label: Qt.formatDateTime(first, "MMMM yyyy"), rows: rows });
    }
    return out;
  }

  Grid {
    id: grid

    anchors.centerIn: parent
    columns: root.monthColumns
    columnSpacing: 22
    rowSpacing: 16

    Repeater {
      model: root.months

      Column {
        id: monthBlock

        required property var modelData

        spacing: 3

        Text {
          text: monthBlock.modelData.label
          color: root.monthColor
          font.family: S.Palette.fontFamily
          font.weight: S.Palette.fontWeight
          font.pixelSize: S.Palette.fontSize
          leftPadding: root.weekWidth
        }

        Row {
          Text {
            text: ""
            width: root.weekWidth
          }

          Repeater {
            model: root.weekdays

            Text {
              required property string modelData

              text: modelData
              color: root.weekdayColor
              font.family: S.Palette.fontFamily
              font.weight: S.Palette.fontWeight
              font.pixelSize: S.Palette.fontSize
              width: root.cellWidth
              horizontalAlignment: Text.AlignHCenter
            }
          }
        }

        Repeater {
          model: monthBlock.modelData.rows

          Row {
            id: weekRow

            required property var modelData

            Text {
              text: weekRow.modelData.week
              color: root.weekColor
              font.family: S.Palette.fontFamily
              font.weight: S.Palette.fontWeight
              font.pixelSize: S.Palette.fontSize
              width: root.weekWidth
            }

            Repeater {
              model: weekRow.modelData.days

              Text {
                required property var modelData

                text: modelData.text
                color: modelData.color
                font.family: S.Palette.fontFamily
                font.weight: S.Palette.fontWeight
                font.pixelSize: S.Palette.fontSize
                font.underline: modelData.today
                width: root.cellWidth
                horizontalAlignment: Text.AlignHCenter
              }
            }
          }
        }
      }
    }
  }

  WheelHandler {
    onWheel: function (event) {
      if (event.angleDelta.y === 0) return;
      root.monthShifted(event.angleDelta.y > 0 ? root.scrollStep : -root.scrollStep);
    }
  }
}
