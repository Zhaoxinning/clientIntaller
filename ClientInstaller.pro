QT += core gui network
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = ClientInstaller
TEMPLATE = app
#在qt中使用.rc文件的方法
RC_FILE = main.rc
CONFIG += resources_big


# The following define makes your compiler emit warnings if you use
# any feature of Qt which has been marked as deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS
TRANSLATIONS += resourceFile/English.ts \
                resourceFile/Chinese.ts

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        main.cpp \
        language.cpp \
        introduction.cpp \
        targetdirectory.cpp \
        licensecheck.cpp \
        performinstallation.cpp \
        installationcomplete.cpp \
        installthread.cpp

HEADERS += \
        language.h \
        introduction.h \
        targetdirectory.h \
        licensecheck.h \
        performinstallation.h \
        installationcomplete.h \
        main.h \
        installthread.h

FORMS += \
        language.ui \
        introduction.ui \
        targetdirectory.ui \
        licensecheck.ui \
        performinstallation.ui \
        installationcomplete.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

RESOURCES += \
    file.qrc
RC_ICONS = cnc.ico
