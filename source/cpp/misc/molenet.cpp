#include "molenet.h"
#include "javahelpers.h"

#include <QQmlEngine>
#include <QQmlApplicationEngine>


MoleNet::MoleNet(QObject *parent) : QObject(parent)
{
}

MoleNet::~MoleNet()
{

}

QObject* MoleNet::moleNetProvider(QQmlEngine *engine, QJSEngine *scriptEngine){
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)
  return MoleNet::instance();
}

MoleNet* MoleNet::instance()
{
    static MoleNet* facebook = new MoleNet();
        return facebook;
}

void MoleNet::setRadioData(const QString &radData)
{
    m_radioData = radData;
    emit radioDataChanged();
}

void MoleNet::openUSBCon(bool open)
{
    JavaHelpers::openUSBConn(open);
}

void MoleNet::updateRadioData()
{
    radioDataChanged();
}
