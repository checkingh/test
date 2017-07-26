/****************************************************************************
**
** Copyright (C) 2015 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1

import QtQuick.Window 2.0

import com.comnet.molenet 1.0

Page {

    signal loadActiveList()
    onLoadActiveList: getList()




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
                    source: stackView.depth > 1 ? "qrc:/source/images/back.png" : "qrc:/source/images/drawer.png"
                }
                onClicked: {
                    if (stackView.depth > 1) {
                        stackView.pop()
                        listView.currentIndex = -1
                    } else {
                        drawer.open()
                    }
                }
            }

            Label {
                id: titleLabel
                text:  "List of Nodes"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

        }

    }

    Drawer {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height
        interactive: stackView.depth === 1
        spacing: 20


        ListView {
            id: listViewDrawer
            anchors.fill: parent
            anchors.topMargin: 15
            headerPositioning: ListView.OverlayHeader
            header: Pane {
                id: header
                z: 2
                width: parent.width

                contentHeight: logo.height

                Image {
                    id: logo
                    width: parent.width
                    source: "qrc:/source/images/molenet_512.png"
                    fillMode: implicitWidth > width ? Image.PreserveAspectFit : Image.Pad
                }

                MenuSeparator {
                    parent: header
                    width: parent.width
                    anchors.verticalCenter: parent.bottom
                    visible: !listView.atYBeginning
                }
            }

            footer: ItemDelegate {
                id: footer
                text: qsTr("")
                width: parent.width

                MenuSeparator {
                    parent: footer
                    width: parent.width
                    anchors.verticalCenter: parent.top
                }
            }

            model: 1
            delegate: ItemDelegate {
                id:itemDel
                width: parent.width

                MenuSeparator {
                    parent: itemDel
                    width: parent.width
                    anchors.verticalCenter: parent.top
                }

                RowLayout{
                    Image {
                        fillMode: Image.Pad
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        source: "qrc:/source/images/delete.png"

                    }
                    Text{
                        text: "Delete Stored Data"
                    }

                }

                MouseArea {
                    id: mouse_area2
                    z: 1
                    hoverEnabled: true
                    anchors.fill: parent
                    onClicked: {
                        drawer.close()
                        deleteDialog.open()
                    }
                }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }



    Dialog {
        id: deleteDialog
        modal: Qt.WindowModal
        //  visible: true
        title: "Confirm Delete"
        standardButtons: Dialog.Yes | Dialog.No

        contentItem: Rectangle {
           // color: "lightskyblue"
            Text {
                text: "Do you want to delete all node readings?"
                anchors.centerIn: parent
            }
        }

        onAccepted: {
            dataSourceTemp.clearMoleNetTable()
        }

    }


    ListView {
        id: listView
        anchors.top: parent.top
        topMargin:10
        leftMargin:5
        rightMargin: 5
        spacing: 20
        //  currentIndex: -1
        width: parent.width
        height: parent.height


        model:  SqlMoleNetModel{}

        headerPositioning: ListView.OverlayHeader
        header: Pane {
            id: head
            z: 2
            width: parent.width

            contentHeight:listH.implicitHeight

            Label {
                id: listH
                text:  "Tap a node to open readings"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignLeft
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            MenuSeparator {
                parent: header
                width: parent.width
                anchors.verticalCenter: parent.bottom
                visible: !listView.atYBeginning
            }
        }

        delegate: Column {

            spacing: 6

            Row {
                id: messageRow
                spacing: 6

                Rectangle {
                    width: listView.width - 20
                    height: messageText.implicitHeight + 24
                    color: "#757575"

                    Label {
                        id: messageText
                        text: qsTr("Node #: ")+ model.source_id
                        color: "#FAFAFA"
                        anchors.fill: parent
                        anchors.margins: 12
                        wrapMode: Label.Wrap
                    }

                    MouseArea {
                        id: mouse_area1
                        z: 1
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: stackView.push("qrc:/source/qml/NodeReadingTabs.qml",{nodeID:model.source_id})
                    }
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }

        Component.onCompleted: {
            getList()
        }
    }

    Timer {
        interval: 5000; running: true; repeat: true
        onTriggered: getList()
    }


    function getList() {
        //listView.model.se
        listView.model.loadNodeIDs();
    }

}
