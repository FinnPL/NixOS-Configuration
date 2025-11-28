import qs.modules.common
import QtQuick

/**
 * Recreation of GTK revealer. Expects one single child.
 */
Item {
    id: root
    property bool reveal
    property bool vertical: false
    property real contentWidth: children.length > 0 ? children[0].implicitWidth : 0
    property real contentHeight: children.length > 0 ? children[0].implicitHeight : 0
    clip: true

    implicitWidth: (reveal || vertical) ? contentWidth : 0
    implicitHeight: (reveal || !vertical) ? contentHeight : 0
    visible: reveal || (width > 0 && height > 0)

    Behavior on implicitWidth {
        enabled: !vertical
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
    Behavior on implicitHeight {
        enabled: vertical
        animation: Appearance.animation.elementMoveEnter.numberAnimation.createObject(this)
    }
}
