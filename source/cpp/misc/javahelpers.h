#ifndef JAVAHELPERS_H
#define JAVAHELPERS_H

#include <QObject>
#include <QQmlEngine>


class JavaHelpers : public QObject{
    Q_OBJECT

public:
    JavaHelpers(QObject *parent=0);
    ~JavaHelpers();

    static  void saveLoginToJava(bool isLoggedIn);
   static void openUSBConn(bool open);
protected:

};

#endif // JAVAHELPERS_H
