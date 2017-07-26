#include "molenetchart.h"

#include <QtCharts/QChartView>

    QT_CHARTS_USE_NAMESPACE

    Q_DECLARE_METATYPE(QAbstractSeries *)
    Q_DECLARE_METATYPE(QAbstractAxis *)

    MoleNetChart::MoleNetChart(QObject *parent)
        : QObject(parent)
    {
        qRegisterMetaType<QAbstractSeries*>();
        qRegisterMetaType<QAbstractAxis*>();
    }

    MoleNetChart::~MoleNetChart()
    {

    }

   void MoleNetChart::setLineSeries(QLineSeries* lineSeries)
    {
       // QLineSeries *bloodSugarSeries = new QLineSeries();

        QPen penBloodSugar;
        penBloodSugar.setColor(QColor(34, 102, 102));
        penBloodSugar.setWidth(5);
        QDateTime xValue;
        xValue.setDate(QDate(2016,7,3));
        xValue.setTime(QTime(0,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 192.6);
        xValue.setTime(QTime(7,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 89);
        xValue.setTime(QTime(9,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 100);
        xValue.setTime(QTime(12,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 50);
        xValue.setTime(QTime(14,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 250);
        xValue.setTime(QTime(18,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 140);
        xValue.setTime(QTime(21,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 80);
        xValue.setTime(QTime(23,30));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 200);
        xValue.setDate(QDate(2016,7,4));
        xValue.setTime(QTime(0,0));
        lineSeries->append(xValue.toMSecsSinceEpoch(), 192.6);
        lineSeries->setPen(penBloodSugar);

    }
