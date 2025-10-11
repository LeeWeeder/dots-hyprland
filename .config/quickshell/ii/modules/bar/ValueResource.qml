import qs
import qs.modules.common
import QtQuick
import QtQuick.Layouts

ResourceView {
  id: root

  required property double value
  required property string unit
  required property double warningValue
  required property double maxValue

  property string sizingHintText: "100°C"

  property bool warning: value >= warningValue

  iconName: root.iconName
  progressValue: maxValue > 0 ? (value / maxValue) : 0
  displayText: `${Math.round(root.value)}${root.unit}`
  progressColor: warning ? Appearance.colors.colError : Appearance.colors.colOnSecondaryContainer
  shown: root.shown
  Layout.leftMargin: root.shown ? 6 : 0
  sizingText: root.sizingHintText
}
