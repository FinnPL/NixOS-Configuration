import qs.modules.common
import qs.modules.common.functions
import Qt5Compat.GraphicalEffects
import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.Notifications

MaterialShape { // App icon
    id: root
    property var appIcon: ""
    property var summary: ""
    property var urgency: NotificationUrgency.Normal
    property bool isUrgent: urgency === NotificationUrgency.Critical
    property var image: ""
    property real materialIconScale: 0.57
    property real appIconScale: 0.8
    property real smallAppIconScale: 0.49
    property real materialIconSize: implicitSize * materialIconScale
    property real appIconSize: implicitSize * appIconScale
    property real smallAppIconSize: implicitSize * smallAppIconScale

    // Cache initial values to prevent icon changes during delete animations
    property string cachedAppIcon: ""
    property string cachedImage: ""
    property string cachedSummary: ""
    Component.onCompleted: {
        cachedAppIcon = appIcon ?? ""
        cachedImage = image ?? ""
        cachedSummary = summary ?? ""
    }

    implicitSize: 38 * scale
    property list<var> urgentShapes: [
        MaterialShape.Shape.VerySunny,
        MaterialShape.Shape.SoftBurst,
    ]
    shape: isUrgent ? urgentShapes[Math.floor(Math.random() * urgentShapes.length)] : MaterialShape.Shape.Circle

    color: isUrgent ? Appearance.colors.colPrimaryContainer : Appearance.colors.colSecondaryContainer
    Loader {
        id: materialSymbolLoader
        active: root.cachedAppIcon == ""
        anchors.fill: parent
        sourceComponent: MaterialSymbol {
            text: {
                const defaultIcon = NotificationUtils.findSuitableMaterialSymbol("")
                const guessedIcon = NotificationUtils.findSuitableMaterialSymbol(root.cachedSummary)
                return (root.urgency == NotificationUrgency.Critical && guessedIcon === defaultIcon) ?
                    "priority_high" : guessedIcon
            }
            anchors.fill: parent
            color: isUrgent ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnSecondaryContainer
            iconSize: root.materialIconSize
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Loader {
        id: appIconLoader
        active: root.cachedImage == "" && root.cachedAppIcon != ""
        anchors.centerIn: parent
        sourceComponent: Item {
            implicitWidth: root.appIconSize
            implicitHeight: root.appIconSize
            // Use check=true to return empty string if icon doesn't exist
            property string iconSource: Quickshell.iconPath(root.cachedAppIcon, true)
            property bool iconValid: iconSource != ""
            Image {
                id: appIconImage
                anchors.fill: parent
                asynchronous: true
                source: parent.iconSource
                sourceSize.width: root.appIconSize
                sourceSize.height: root.appIconSize
                visible: parent.iconValid
            }
            // Fallback when icon doesn't exist
            MaterialSymbol {
                anchors.fill: parent
                visible: !parent.iconValid
                text: NotificationUtils.findSuitableMaterialSymbol(root.cachedSummary)
                color: isUrgent ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnSecondaryContainer
                iconSize: root.materialIconSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }
    Loader {
        id: notifImageLoader
        active: root.cachedImage != ""
        anchors.fill: parent
        sourceComponent: Item {
            anchors.fill: parent
            Image {
                id: notifImage
                anchors.fill: parent
                readonly property int size: parent.width

                source: root.cachedImage
                fillMode: Image.PreserveAspectCrop
                cache: false
                antialiasing: true
                asynchronous: true
                visible: status === Image.Ready

                width: size
                height: size
                sourceSize.width: size
                sourceSize.height: size

                layer.enabled: status === Image.Ready
                layer.effect: OpacityMask {
                    maskSource: Rectangle {
                        width: notifImage.size
                        height: notifImage.size
                        radius: Appearance.rounding.full
                    }
                }
            }
            // Fallback icon when image fails to load
            Loader {
                active: notifImage.status !== Image.Ready
                anchors.fill: parent
                sourceComponent: MaterialSymbol {
                    text: NotificationUtils.findSuitableMaterialSymbol(root.cachedSummary)
                    anchors.fill: parent
                    color: isUrgent ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnSecondaryContainer
                    iconSize: root.materialIconSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
            Loader {
                id: notifImageAppIconLoader
                // Only show if icon exists and image loaded successfully
                active: root.cachedAppIcon != "" && notifImage.status === Image.Ready && Quickshell.iconPath(root.cachedAppIcon, true) != ""
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                sourceComponent: Image {
                    width: root.smallAppIconSize
                    height: root.smallAppIconSize
                    asynchronous: true
                    source: Quickshell.iconPath(root.cachedAppIcon, true)
                    sourceSize.width: root.smallAppIconSize
                    sourceSize.height: root.smallAppIconSize
                }
            }
        }
    }
}