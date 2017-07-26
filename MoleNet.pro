TEMPLATE = app
QT +=qml quick quickcontrols2 sql charts

android{
    QT += androidextras
}

CONFIG += c++11

SOURCES += source/cpp/main.cpp \
    source/cpp/misc/javahelpers.cpp \
    source/cpp/misc/molenet.cpp \
    source/cpp/misc/sqlmolenetmodel.cpp \
    source/cpp/misc/datasource.cpp \
    source/cpp/misc/molenetchart.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# The following define makes your compiler emit warnings if you use
# any feature of Qt which as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target


android{
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    ################# adapt that accordingly #######################
    ANDROID_JAVA_SOURCES.path = /src/com/comnet/molenet
    ################################################################

    ANDROID_JAVA_SOURCES.files = $$files($$PWD/source/java/*.java)
    INSTALLS += ANDROID_JAVA_SOURCES
}

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/res/values/strings.xml \
    android/libs/usbserial.jar \
    source/java/MoleNetService.java \
    android/res/values/apptheme.xml

HEADERS += \
    source/cpp/misc/javahelpers.h \
    source/cpp/misc/molenet.h \
    source/cpp/misc/sqlmolenetmodel.h \
    source/cpp/misc/datasource.h \
    source/cpp/misc/molenetchart.h
