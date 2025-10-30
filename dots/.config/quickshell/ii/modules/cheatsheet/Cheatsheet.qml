import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.synchronizer
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope { // Scope
    id: root

    Loader {
        id: cheatsheetLoader
        active: false

        sourceComponent: PanelWindow { // Window
            id: cheatsheetRoot
	    visible: cheatsheetLoader.active

	    function calculateMinScreenDimension() {
		    var screens = Qt.application.screens;

		if (screens.length === 0) {
			return { width: 1280, height: 720 };
		}

		var minWidth = screens[0].width;
		var minHeight = screens[0].height;

		for (var i = 0; i < screens.length; i++) {
			if (screens[i].width < minWidth) {
				minWidth = screens[i].width;
			}
			
			if (screens[i].height < minHeight) {
				minHeight = screens[i].height;
			}
		}

		return { width: minWidth, height: minHeight };
	}


	onVisibleChanged: {
		if (visible) {
			var dims = calculateMinScreenDimension();
			cheatsheetBackground.width = dims.width * 0.9;
			cheatsheetBackground.height = dims.height * 0.9;
		}
	}
	anchors {
                top: true
                bottom: true
                left: true
                right: true
            }

            function hide() {
                cheatsheetLoader.active = false;
            }
            exclusiveZone: 0
            implicitWidth: cheatsheetBackground.width + Appearance.sizes.elevationMargin * 2
            implicitHeight: cheatsheetBackground.height + Appearance.sizes.elevationMargin * 2
            WlrLayershell.namespace: "quickshell:cheatsheet"
            // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            mask: Region {
                item: cheatsheetBackground
            }

            HyprlandFocusGrab { // Click outside to close
                id: grab
                windows: [cheatsheetRoot]
                active: cheatsheetRoot.visible
                onCleared: () => {
                    if (!active)
                        cheatsheetRoot.hide();
                }
            }

            // Background
            StyledRectangularShadow {
                target: cheatsheetBackground
            }
            Rectangle {
                id: cheatsheetBackground
                anchors.centerIn: parent
                color: Appearance.colors.colLayer0
                border.width: 1
                border.color: Appearance.colors.colLayer0Border
                radius: Appearance.rounding.windowRounding
                property real padding: 30
                width: 1
                height: 1

                Keys.onPressed: event => { // Esc to close
                    if (event.key === Qt.Key_Escape) {
                        cheatsheetRoot.hide();
                    }
                    if (event.modifiers === Qt.ControlModifier) {
                        if (event.key === Qt.Key_PageDown) {
                            cheatsheetRoot.selectedTab = Math.min(cheatsheetRoot.selectedTab + 1, root.tabButtonList.length - 1);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_PageUp) {
                            cheatsheetRoot.selectedTab = Math.max(cheatsheetRoot.selectedTab - 1, 0);
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Tab) {
                            cheatsheetRoot.selectedTab = (cheatsheetRoot.selectedTab + 1) % root.tabButtonList.length;
                            event.accepted = true;
                        } else if (event.key === Qt.Key_Backtab) {
                            cheatsheetRoot.selectedTab = (cheatsheetRoot.selectedTab - 1 + root.tabButtonList.length) % root.tabButtonList.length;
                            event.accepted = true;
                        }
                    }
                }

                RippleButton { // Close button
                    id: closeButton
                    focus: cheatsheetRoot.visible
                    implicitWidth: 40
                    implicitHeight: 40
                    buttonRadius: Appearance.rounding.full
                    anchors {
                        top: parent.top
                        right: parent.right
                        topMargin: 20
                        rightMargin: 20
                    }

                    onClicked: {
                        cheatsheetRoot.hide();
                    }

                    contentItem: MaterialSymbol {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: Appearance.font.pixelSize.title
                        text: "close"
                    }
                }

                ColumnLayout { // Real content
                    id: cheatsheetColumnLayout
		    anchors.centerIn: parent
		    anchors.fill: parent
		    anchors.margins: cheatsheetBackground.padding
            spacing: 20

            StyledText {
                id: cheatsheetTitle
                Layout.alignment: Qt.AlignHCenter
                font.family: Appearance.font.family.title
                font.pixelSize: Appearance.font.pixelSize.title
                text: Translation.tr("Cheat sheet")
            }
            
            ScrollView {
			    Layout.fillWidth: true
			    Layout.fillHeight: true
			    clip: true
			    ScrollBar.vertical.policy: ScrollBar.AsNeeded
			    ScrollBar.horizontal.policy: ScrollBar.AsNeeded

			    CheatsheetKeybinds {}

		    }
                    }
                }
            }
        } 
    IpcHandler {
        target: "cheatsheet"

        function toggle(): void {
            cheatsheetLoader.active = !cheatsheetLoader.active;
        }

        function close(): void {
            cheatsheetLoader.active = false;
        }

        function open(): void {
            cheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "cheatsheetToggle"
        description: "Toggles cheatsheet on press"

        onPressed: {
            cheatsheetLoader.active = !cheatsheetLoader.active;
        }
    }

    GlobalShortcut {
        name: "cheatsheetOpen"
        description: "Opens cheatsheet on press"

        onPressed: {
            cheatsheetLoader.active = true;
        }
    }

    GlobalShortcut {
        name: "cheatsheetClose"
        description: "Closes cheatsheet on press"

        onPressed: {
            cheatsheetLoader.active = false;
        }
    }
}
