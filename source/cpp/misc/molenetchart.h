#ifndef MOLENETCHART_H
#define MOLENETCHART_H

#include <QtCharts/QChartView>
   #include <QtCharts/QLineSeries>
   #include <QtCharts/QDateTimeAxis>
   #include <QtCharts/QCategoryAxis>
   #include <QDateTime>
   #include <QtQuick/QQuickPaintedItem>
   #include <QColor>
   #include <QObject>

   QT_CHARTS_USE_NAMESPACE

   class MoleNetChart : public QObject
   {
       Q_OBJECT

   public:
       explicit MoleNetChart(QObject *parent = 0);
       virtual ~MoleNetChart();

       Q_INVOKABLE void setLineSeries(QLineSeries* lineSeries);

   };

#endif // MOLENETCHART_H
