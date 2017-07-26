/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt Charts module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:GPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1

import QtCharts 2.2

import com.comnet.molenet 1.0

Page {
    id:chartPage
    property string nodeID

ChartView {
    id:chartView
    title: "Temperature Plot"
    anchors.fill: parent
    antialiasing: true
    anchors.topMargin:10
    legend.visible:false

   // anchors.bottomMargin: 48


    MouseArea {
        anchors.fill: parent
        property int lastX: 0
        property int lastY: 0
        onPressed: {
            lastX = mouse.x
            lastY = mouse.y
        }

        onPositionChanged: {
            if (lastX !== mouse.x) {
                chartView.scrollRight(lastX - mouse.x)
                lastX = mouse.x
            }
            if (lastY !== mouse.y) {
                chartView.scrollDown(lastY - mouse.y)
                lastY = mouse.y
            }
        }
    }

    DateTimeAxis {
        id:xTime
        format: "dd MM' HH:mm"
        tickCount: 5
        onRangeChanged: {}

    }

    ValueAxis {
        id:yValues
        min: 600
        max: 650
        titleText: "Temperature"

    }

    ValueAxis {
        id:xValues
        min: 0
        max: 10
        titleText: "Sensor Reading"
    }

    LineSeries{
        objectName: "temSeries"
        id:mySeries
        axisX: xTime
        axisY:yValues

        // Please note that month in JavaScript months are zero based, so 2 means March
        //       XYPoint { x: toMsecsSinceEpoch(new Date(1950, 02, 15)); y: 5 }
        //        XYPoint { x: toMsecsSinceEpoch(new Date(1970, 0, 1)); y: 50 }
        //        XYPoint { x: toMsecsSinceEpoch(new Date(1987, 12, 31)); y: 102 }
        //        XYPoint { x: toMsecsSinceEpoch(new Date(1998, 07, 1)); y: 100 }
        //       XYPoint { x: toMsecsSinceEpoch(new Date(2012, 08, 2)); y: 110 }
    }

    Component.onCompleted:{

    }



    Component.onDestruction: {
        dataSourceTemp.clearM_data()
        }

    Timer {
        id: refreshTimer
        interval:  500 //1 / 60 * 1000 // 60 Hz
        running: true
        repeat: true
        onTriggered: {
            var currCount = mySeries.count
            //console.log(mySeries.count);
            if (mySeries.count === 0) {
                xValues.min = 0;
            }
            //        xValues.min += 1
            //       xValues.max +=1  // xValues.min + mySeries.count

            // console.log(now.getTime())
            //     mySeries.append(now.getTime(), Math.random() * 10)
            dataSourceTemp.update(chartView.series(0),nodeID,mySeries.count,"temperature")

            if(mySeries.count > currCount) {
            xValues.min = mySeries.count - 8
                xValues.max = mySeries.count + 2
            }

        }
    }




    function toMsecsSinceEpoch(date) {
        var msecs = date.getTime();
        console.log(msecs);
        return msecs;
    }

}

}

//![1]
