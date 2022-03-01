#include "installthread.h"
#include "main.h"
#include "language.h"
#include <QSettings>

InstallThread::InstallThread(QString installPath, qint64 num, QObject *parent)
    : QObject(parent)
    , size(0)
    , installPath(installPath)
{
    value = 100.0 / num;
}

void InstallThread::startCopy(QString file)
{    
    QThread::msleep(30); //延时30s
    QString copyFile = file;

    //QString.mid(int):返回一个字符串，该字符串包含n个字符，从指定的位置索引开始。
    /*去掉了前面的cnc::qrcName*/
    if (copyFile.contains(cnc::qrcName)) {
        copyFile = copyFile.mid(cnc::nameSize);
    }
    QFileInfo fileInfo(file);

    //isDir:判断是否为一个文件夹
    //baseName():返回不带路径的文件的基本名称
    if (fileInfo.isDir()) {  //创建该目录
        if (!QDir().mkpath(installPath + "/" + copyFile)) {
            emit signalErrorData(tr("文件安装失败,请重新安装,检查路径是否正确!"));
            return;
        }
    }
    else {//复制文件
        //qDebug() <<file << "-----" << installPath  + copyFile;

        //检测本地路径是否存在,不存在则创建。
        if (!QFileInfo(installPath).exists()) {
            if (!QDir().mkpath(installPath)) {
                emit signalErrorData(tr("文件安装失败,请重新安装,检查路径是否正确!!"));
                return;
            }
        }

        //如果要复制的文件已经存在且目前并不是在升级，则删掉已存在的，后面在重新复制一份
        //if(ifupdate==false){
            if (QFileInfo(installPath + copyFile).exists()) {
                QDir().remove(installPath + copyFile);

            }

            //[static] bool QFile::copy(const QString &fileName, const QString &newName)：复制成功则为true。
            //修改文件权限，文件的所有者可以写入这个文件
            if (QFile().copy(file, installPath + copyFile)) {
                QFile().setPermissions(installPath + copyFile, QFile::WriteOther);
            }
            else {
                emit signalErrorData(tr("文件安装失败,请重新安装,检查路径是否正确,是否有权限!"));
                return;
            }
       /*}
        else{
            if (!(QFileInfo(installPath + copyFile).exists())) {
                if (QFile().copy(file, installPath + copyFile)) {
                    QFile().setPermissions(installPath + copyFile, QFile::WriteOther);
                }
                else {
                    emit signalErrorData(tr("文件安装失败,请重新安装,检查路径是否正确,是否有权限!"));
                    return;
                }
            }
        }*/

    }
    emit signalData(size += value);
}
