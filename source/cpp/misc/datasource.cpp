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

#include "datasource.h"
#include <QtCharts/QXYSeries>
#include <QtCharts/QAreaSeries>
#include <QtQuick/QQuickView>
#include <QtQuick/QQuickItem>
#include <QtCore/QDebug>
#include <QtCore/QtMath>

QT_CHARTS_USE_NAMESPACE

Q_DECLARE_METATYPE(QAbstractSeries *)
Q_DECLARE_METATYPE(QAbstractAxis *)

DataSource::DataSource(QQmlEngine *appEngine, QObject *parent) :
    QObject(parent),
    m_appEngine(appEngine),
    m_index(-1),
    m_seriesCounter(0)

{
    qRegisterMetaType<QAbstractSeries*>();
    qRegisterMetaType<QAbstractAxis*>();
    sqlMoleNetModel = new SqlMoleNetModel();
    //  generateData();
}

void DataSource::update(QAbstractSeries *series,const QString& node_id,int seriesCount,const QString& type)
{
    if (series) {
        generateData(node_id,type);

        if(m_data.count() > 0){
            // m_data.append( points);
            //     qDebug() <<"m_data " << m_data.count();
            QXYSeries *xySeries = static_cast<QXYSeries *>(series);

            // m_index = 0;
            m_index < 0 ? m_index++:m_index;

            if (m_index < m_data.count() )
            {

                QVector<QPointF> points = m_data.at(m_index);
                // Use replace instead of clear + append, it's optimized for performance
                foreach (QPointF row, points)
                    xySeries->append(seriesCount+1,row.y());
                m_index++;
            }

            else{
                //m_index = m_data.count();
            }
      //      qDebug() << "M-index: " << m_index;
      //      qDebug() << "M-data: " << m_data.count();

        }

    }
}

void DataSource::clearM_data()
{
    m_data.clear();
    sqlMoleNetModel->m_last_row = 0;
    m_index = -1;

}

void DataSource::clearMoleNetTable()
{
    sqlMoleNetModel->clearTables();

}

void DataSource::generateData(const QString& node_id,const QString& type)
{
       sqlMoleNetModel->plotData(&m_data,node_id,type);

}

