#include "javahelpers.h"
#include "molenet.h"

#include <QQmlEngine>
#include <QQmlApplicationEngine>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QtAndroidExtras>
#endif

JavaHelpers::JavaHelpers(QObject *parent)
    : QObject(parent)
{

}

JavaHelpers::~JavaHelpers()
{

}

 void JavaHelpers::saveLoginToJava(bool isLoggedIn)
{
    #ifdef Q_OS_ANDROID

  QAndroidJniObject::callStaticMethod<void>("com/comnet/molenet/MainApplication",
                                                                               "saveLogin","(Z)V",isLoggedIn);
    #endif
}


 void JavaHelpers::openUSBConn(bool open)
{

    #ifdef Q_OS_ANDROID

  QAndroidJniObject::callStaticMethod<void>("com/comnet/molenet/MainActivity",
                                                                               "initializeUSB","(Z)V",open);
    #endif
}

#ifdef Q_OS_ANDROID





static void receiveRadioData(JNIEnv* /*env*/ env, jobject obj, jstring data)
{
    Q_UNUSED(obj)
    const char* nativeString = env->GetStringUTFChars(data, 0);

    MoleNet::instance()->sqlModel.insertData(QString(nativeString));
}

static void showMsg(JNIEnv* /*env*/ env, jobject obj, jstring data)
{
    Q_UNUSED(obj)
    const char* nativeString = env->GetStringUTFChars(data, 0);

    MoleNet::instance()->setRadioData(QString(nativeString));
}


// create a vector with all our JNINativeMethod(s)
static JNINativeMethod methods[] = {
    { "sendRadioData", // const char* function name;
        "(Ljava/lang/String;)V",
        (void *)receiveRadioData // function pointer
    },
    { "showMsgFromUno", // const char* function name;
        "(Ljava/lang/String;)V",
        (void *)showMsg // function pointer
    }
};


// this method is called automatically by Java VM
// after the .so file is loaded
JNIEXPORT jint JNI_OnLoad(JavaVM* vm, void* /*reserved*/)
{
    JNIEnv* env;
    // get the JNIEnv pointer.
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6)
           != JNI_OK) {
        return JNI_ERR;
    }

    // search for Java class which declares the native methods
    jclass javaClass = env->FindClass("com/comnet/molenet/JavaNatives");
    if (!javaClass)
        return JNI_ERR;

    // register our native methods
    if (env->RegisterNatives(javaClass, methods,
                            sizeof(methods) / sizeof(methods[0])) < 0) {
        return JNI_ERR;
    }

    return JNI_VERSION_1_6;
}
#endif


