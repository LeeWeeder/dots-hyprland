import qs
import qs.modules.common
import QtQuick
import QtQuick.Layouts

ResourceView {
    id: root
    required property double percentage
    property int warningThreshold: 100
    property bool warning: percentage * 100 >= warningThreshold

    iconName: root.iconName
    progressValue: root.percentage
    displayText: `${Math.round(root.percentage * 100)}%`
    progressColor: warning ? Appearance.colors.colError : Appearance.colors.colOnSecondaryContainer
    shown: root.shown
    Layout.leftMargin: root.shown ? 6 : 0
    sizingText: "100%"
}
