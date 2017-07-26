import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1

import com.comnet.molenet 1.0

Page {
    id:page
    property bool sourceLoaded: false
    property string nodeID

    //property var moleNet: MoleNet
    signal refreshRadioData()


    header: ToolBar {
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent

            ToolButton {
                contentItem: Image {
                    fillMode: Image.Pad
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    source: "qrc:/source/images/back.png"
                }
                onClicked: page.StackView.view.pop()
            }

            Label {
                id: titleLabel
                text:  "Node #"+nodeID + " Readings"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }


        }

    }


    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: tabBar.currentIndex
        bottomPadding: 10
        interactive: false;

        Loader{
            id:nodeValuesLoader
            asynchronous: true
            visible: status == Loader.Ready}
        Loader{
            id:plotTempLoader
            asynchronous: true
            visible: status == Loader.Ready}
        Loader{
            id:dielectricLoader
            asynchronous: true
            visible: status == Loader.Ready}

        Component.onCompleted:{
            nodeValuesLoader.setSource("NodeReading.qml",{nodeID:nodeID})//NodeReading.qml
            plotTempLoader.setSource("PlotTemp.qml",{nodeID:nodeID})  //PlotTemp.qml
            dielectricLoader.setSource("PlotDielectric.qml",{nodeID:nodeID})
            // nodeReading.nodeID = nodeID
        }
    }

    Component{
        id: read
        NodeReading{ id: nodeReading  }
    }


    footer:   TabBar {
        id: tabBar
        width: parent.width
        currentIndex: swipeView.currentIndex

        TabButton {
            text: "Data"
        }
        TabButton {
            text: "T-Plot"
        }
        TabButton {
            text: "D-Plot"
        }
    }

    Keys.onReleased: {
        if (event.key === Qt.Key_Back) {
            event.accepted = true

            if (page.StackView.depth > 1) {
                stackView.pop()
                //   listView.currentIndex = -1
            }
            else {
                Qt.quit()
            }

        }
    }

}
