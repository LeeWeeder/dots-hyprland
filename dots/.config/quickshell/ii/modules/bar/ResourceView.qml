import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
  id: root
  property alias iconName: materialSymbol.text
  property alias displayText: percentageText.text
  property alias progressValue: resourceCircProg.value
  property alias progressColor: resourceCircProg.colPrimary

  property alias sizingText: fullPercentageTextMetrics.text

  property bool shown
  clip: true
  visible: width > 0 && height > 0
  implicitWidth: resourceRowLayout.x < 0 ? 0 : resourceRowLayout.implicitWidth
  implicitHeight: Appearance.sizes.barHeight

  RowLayout {
    id: resourceRowLayout
    spacing: 2
    x: root.shown ? 0 : -resourceRowLayout.width
    anchors.verticalCenter: parent.verticalCenter

    Behavior on x { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

    ClippedFilledCircularProgress {
      id: resourceCircProg
      Layout.alignment: Qt.AlignVCenter
      lineWidth: Appearance.rounding.unsharpen
      implicitSize: 20
      accountForLightBleeding: true
      enableAnimation: false

      Item {
        anchors.centerIn: parent
        width: resourceCircProg.implicitSize
        height: resourceCircProg.implicitSize

        MaterialSymbol {
          id: materialSymbol
          anchors.centerIn: parent
          font.weight: Font.DemiBold
          fill: 1
          iconSize: Appearance.font.pixelSize.normal
          color: Appearance.m3colors.m3onSecondaryContainer
        }
      }
    }

    Item {
      Layout.alignment: Qt.AlignVCenter
      implicitWidth: fullPercentageTextMetrics.width
      implicitHeight: percentageText.implicitHeight

      TextMetrics {
        id: fullPercentageTextMetrics
        font.pixelSize: percentageText.font.pixelSize
        font.family: percentageText.font.family
      }

      StyledText {
        id: percentageText
        anchors.centerIn: parent
        color: Appearance.colors.colOnLayer1
        font.pixelSize: Appearance.font.pixelSize.smallie
      }
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    enabled: resourceRowLayout.x >= 0 && root.width > 0 && root.visible
  }

  Behavior on implicitWidth {
    NumberAnimation {
      duration: Appearance.animation.elementMove.duration
      easing.type: Appearance.animation.elementMove.type
      easing.bezierCurve: Appearance.animation.elementMove.bezierCurve
    }
  }
}
