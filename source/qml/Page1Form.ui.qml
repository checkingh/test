import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import com.comnet.molenet 1.0

Item {
    property alias textField1: textField1
    property alias button1: button1
    property alias textArea: textArea

    RowLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 20
        anchors.top: parent.top

        TextField {
            id: textField1
            placeholderText: qsTr("Text Field")
        }

        Button {
            id: button1
            text: qsTr("Press Me")
        }
    }

    ColumnLayout {
        id: columnLayout
        x: 210
        y: 74
        width: 213
        height: 100

        Label {
            id: textArea
            text: MoleNet.radioData
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
