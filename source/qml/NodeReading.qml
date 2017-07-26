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

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import com.comnet.molenet 1.0

Page {
    id: page
    objectName: "active_chat_list"

    property string nodeID
    property int currIndexTop:-1

    onNodeIDChanged: getList()  // load details

    signal loadActiveList()
    onLoadActiveList: getList()


    ListView {
        id: listView
        anchors.fill: parent
      //  anchors.top: parent.top
        anchors.topMargin: 48
        anchors.bottomMargin: 48
        anchors.leftMargin:10
     //   anchors.rightMargin: 5
        spacing: 15
       // height: parent.height
        model:  SqlMoleNetNodeReading{

            onDataChanged: listView.positionViewAtIndex(currIndexTop,ListView.Contain)

        }

        delegate:  Column {

            spacing: 6

            Row {
                id: messageRow
                spacing: 6

                Rectangle {
                    width: listView.width - 20
                    height: tempTxt.implicitHeight + dielTxt.implicitHeight + timeTxt.implicitHeight + 24
                    color: "#EEEEEE"

                    Label {
                        id:sinkL
                        color: "#757575"
                        anchors.top: parent.top
                        anchors.left: parent.left
                        text:"Reading #: "+ readingCount(index)
                    }


                    Label {
                        id:tempTxt
                        color: "#757575"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        text: "Temperature" }

                    Label {
                        id:tempVal
                        color: "#212121"
                        anchors.top: tempTxt.bottom
                        anchors.left: tempTxt.left
                        text:model.temperature  }

                    Label {
                        id: timeTxt
                        color: "#757575"
                        anchors.bottom:  timeVal.top
                        anchors.left: parent.left
                        text:"Time:"
                    }

                    Label {
                        id: timeVal
                        color: "#212121"
                        anchors.bottom:  parent.bottom
                        anchors.left: parent.left
                        text:model.time
                        wrapMode: Label.Wrap
                    }
                    Label {
                        id:dielTxt
                        color: "#757575"
                        anchors.bottom: dielVal.top
                        anchors.left: tempTxt.left
                        text: "Dielectric" }
                    Label {
                        id:dielVal
                        color: "#212121"
                        anchors.bottom: parent.bottom
                        anchors.left: dielTxt.left
                        text: model.dielectric }


                    MouseArea {
                        id: mouse_area1
                        z: 1
                        hoverEnabled: true
                        anchors.fill: parent
                        onClicked: stackView.push("qrc:/source/qml/NodeFullReading.qml",{nodeID:model.id})
                    }
                }
            }
        }

        ScrollIndicator.vertical: ScrollIndicator { }

        Component.onCompleted: {
            getList()
        }

        onContentYChanged: {
                    currIndexTop = indexAt(1, contentY)
                  //  var CurrentPropFromModel = UsersModel.get(CurrentIndexAtTop).Name
                }



    }

    Timer {
        interval: 20000; running: true; repeat: true
        onTriggered:
        {
          //  console.log(currIndexTop)
            getList()

            if(currIndexTop >= 0)
            {
          //  listView.positionViewAtIndex(currIndexTop,ListView.Contain)
            }
        }
    }

    function readingCount(indexx)
    {
        return indexx + 1;
    }

    function getList() {
       // var currIndex = listView.indexAt(0,0)
        listView.model.loadSingleNode(nodeID);
    }

}
