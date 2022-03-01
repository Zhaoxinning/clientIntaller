#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QWidget>
#include "main.h"

namespace Ui {
class language;
}

class language : public QWidget
{
    Q_OBJECT

public:
    explicit language(QTranslator* translator,QWidget *parent = nullptr);
    ~language();
private slots:
    void buttonOK();
    void buttonCancel();
private:
    //void exeIsStart();
    void isInstall();
private:
    Ui::language *ui;
    QProcess* process;
    QTranslator* translator;
};
int entry(int argc, char *argv[]);
#endif // LANGUAGE_H
