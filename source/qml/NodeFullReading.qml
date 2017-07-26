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

import com.comnet.molenet 1.0

Page {
    id: page
    objectName: "full_reading"
    anchors.rightMargin: 15

    property string nodeID

    onNodeIDChanged: getList()  // load details



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
                text:  "Reading Details"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }


        }

    }


    ListView {
        id: listView
        anchors.fill: parent
      //  anchors.top: parent.top
        anchors.topMargin: 48
        anchors.bottomMargin: 48
        anchors.leftMargin:10
     //   anchors.rightMargin: 5
        spacing: 15
        //  currentIndex: -1
        width: parent.width
        height: parent.height
        snapMode: ListView.SnapToItem
        boundsBehavior: Flickable.StopAtBounds
        //verticalLayoutDirection: ListView.BottomToTop
        model:  SqlMoleNetNodeReading{}

        delegate:  Column {

            spacing: 10

            Row {
                id: messageRow
                spacing: 10

                Rectangle {
                    width: listView.width - 20
                    height: tempTxt.implicitHeight*10 + 24
                    color: "#EEEEEE"

                    Label {
                        id:sinkId
                        color: "#757575"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        text:"Sink id: "+ model.sink_id
                    }


                    Label {
                        id:tempTxt
                        color: "#757575"
                        anchors.top: sinkId.bottom
                        anchors.left: parent.left
                        text: "Temperature: "+model.temperature }
                    Label {
                        id:dielTxt
                        color: "#757575"
                        anchors.top: tempTxt.bottom
                        anchors.left: parent.left
                        text: "Dielectric: "+model.dielectric }

                    Label {
                        id:epochTxt
                        color: "#757575"
                        anchors.top: dielTxt.bottom
                        anchors.left: parent.left
                        text: "Epoch: "+model.epoch }

                    Label {
                        id:packlostTxt
                        color: "#757575"
                        anchors.top: epochTxt.bottom
                        anchors.left: parent.left
                        text: "Packets lost: "+model.packet_lost }


                    Label {
                        id:rttTxt
                        color: "#757575"
                        anchors.top: packlostTxt.bottom
                        anchors.left: parent.left
                        text: "RTT: "+model.rtt }

                    Label {
                        id:rssiTxt
                        color: "#757575"
                        anchors.top: rttTxt.bottom
                        anchors.left: parent.left
                        text: "RSSI: "+model.rssi }

                    Label {
                        id:sendRetryTxt
                        color: "#757575"
                        anchors.top: rssiTxt.bottom
                        anchors.left: parent.left
                        text: "Sending retries: "+model.sending_retries }

                    Label {
                        id:eepromTxt
                        color: "#757575"
                        anchors.top: sendRetryTxt.bottom
                        anchors.left: parent.left
                        text: "EEPROM Next Page: "+model.eepromNextPage }

                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }

        Component.onCompleted: {
            getList()
        }

    }



    function getList() {
        //console.log(nodeID);

        listView.model.loadSingleReading(nodeID);

    }

}
