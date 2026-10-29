import qs
import qs.services
import qs.modules.common
import QtQuick
import Quickshell.Io
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property int sidebarWidth: Appearance.sizes.sidebarWidth

    // Records the focused monitor so the sidebar opens where it was triggered.
    function captureMonitor() {
        GlobalStates.sidebarRightMonitor = Hyprland.focusedMonitor?.name ?? "";
    }

    Variants {
        // One window per monitor; only the captured one slides into view.
        model: Quickshell.screens
        PanelWindow {
            id: sidebarRoot
            required property var modelData
            screen: modelData
            // This instance is the active one when its monitor matches the captured monitor.
            readonly property bool shouldShow: GlobalStates.sidebarRightOpen
                && (GlobalStates.sidebarRightMonitor === modelData.name)
            visible: true // Always visible to avoid window mapping delay

            // Use margins to slide off-screen when closed / not the active monitor
            WlrLayershell.margins.right: shouldShow ? 0 : -sidebarWidth

            function hide() {
                GlobalStates.sidebarRightOpen = false
            }

            exclusiveZone: 0
            implicitWidth: sidebarWidth
            WlrLayershell.namespace: "quickshell:sidebarRight"
            // Hyprland 0.49: Focus is always exclusive and setting this breaks mouse focus grab
            // WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            anchors {
                top: true
                right: true
                bottom: true
            }

            HyprlandFocusGrab {
                id: grab
                windows: [ sidebarRoot ]
                active: sidebarRoot.shouldShow
                onCleared: () => {
                    if (!active) sidebarRoot.hide()
                }
            }

            Loader {
                id: sidebarContentLoader
                active: sidebarRoot.shouldShow || Config?.options.sidebar.keepRightSidebarLoaded
                anchors {
                    fill: parent
                    margins: Appearance.sizes.hyprlandGapsOut
                    leftMargin: Appearance.sizes.elevationMargin
                }
                width: sidebarWidth - Appearance.sizes.hyprlandGapsOut - Appearance.sizes.elevationMargin
                height: parent.height - Appearance.sizes.hyprlandGapsOut * 2

                focus: sidebarRoot.shouldShow
                Keys.onPressed: (event) => {
                    if (event.key === Qt.Key_Escape) {
                        sidebarRoot.hide();
                    }
                }

                sourceComponent: SidebarRightContent {}
            }


        }
    }

    IpcHandler {
        target: "sidebarRight"

        function toggle(): void {
            if (!GlobalStates.sidebarRightOpen) root.captureMonitor();
            GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen;
        }

        function close(): void {
            GlobalStates.sidebarRightOpen = false;
        }

        function open(): void {
            root.captureMonitor();
            GlobalStates.sidebarRightOpen = true;
        }
    }

    GlobalShortcut {
        name: "sidebarRightToggle"
        description: "Toggles right sidebar on press"

        onPressed: {
            if (!GlobalStates.sidebarRightOpen) root.captureMonitor();
            GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen;
        }
    }
    GlobalShortcut {
        name: "sidebarRightOpen"
        description: "Opens right sidebar on press"

        onPressed: {
            root.captureMonitor();
            GlobalStates.sidebarRightOpen = true;
        }
    }
    GlobalShortcut {
        name: "sidebarRightClose"
        description: "Closes right sidebar on press"

        onPressed: {
            GlobalStates.sidebarRightOpen = false;
        }
    }

}
