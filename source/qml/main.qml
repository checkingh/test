//![1]
//import QtQuick 2.6
//![1]

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1

import Qt.labs.settings 1.0

import com.comnet.molenet 1.0

import QtCharts 2.2

ApplicationWindow {
    id:window
    visible: true
    minimumWidth: 320
    minimumHeight: 480
    title: qsTr("MoleNet")

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: NodeList {}
    }

    onClosing: {
        if (Qt.platform.os == "android") {
            close.accepted = false;
            if (stackView.depth > 1)
            {stackView.pop() }
            else {Qt.quit() }
        }
    }



}
