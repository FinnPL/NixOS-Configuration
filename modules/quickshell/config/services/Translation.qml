pragma Singleton

import QtQuick
import Quickshell

/**
 * Stub Translation service - just returns original English strings.
 */
Singleton {
    id: root
    property string languageCode: "en_US"

    function tr(text) {
        if (!text) return "";
        return text.toString();
    }
}
