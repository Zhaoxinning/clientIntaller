#include "language.h"
#include "ui_language.h"
#include "introduction.h"
#include "unistd.h"
#include "main.h"

language::language(QTranslator *translator, QWidget *parent) :
    QWidget(parent),
    ui(new Ui::language),
    translator(translator)
{
    ui->setupUi(this);

    this->setWindowIcon(QIcon(":/resourceFile/cnc.ico"));
    //设置窗体，或者窗口标题栏。此处是自定义窗口标题栏，设置只有关闭按钮
    this->setWindowFlags(Qt::CustomizeWindowHint | Qt::WindowCloseButtonHint);
    this->setWindowTitle(tr("安装语言"));

    ui->labelSelectLanguage->setText(tr("请选择语言"));
    ui->labelIco->setPixmap(QPixmap(":/resourceFile/cnc.ico"));
    ui->labelIco->setScaledContents(true); //自适应，缩放来填充所用空间

    ui->pushButtonOK->setText(tr("确定"));
    ui->pushButtonCancel->setText(tr("取消"));
    connect(ui->pushButtonOK, SIGNAL(clicked(bool)), this, SLOT(buttonOK()));
    connect(ui->pushButtonCancel, SIGNAL(clicked(bool)), this, SLOT(buttonCancel()));

    ui->comboBoxLanguage->addItem(tr("简体中文"));
    ui->comboBoxLanguage->addItem(tr("English"));

}

language::~language()
{
    delete ui;
}

void language::buttonCancel()
{
    //按钮在默认情况下，点击后都会退出对话框，无论Yes or NO
    QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                       tr("你确定要退出%1 %2 的安装吗?").arg(cnc::exeName,cnc::versions),
                                       QMessageBox::Yes | QMessageBox::No);

    box->button(QMessageBox::Yes)->setText(tr("是"));
    box->button(QMessageBox::No)->setText(tr("否"));
    box->button(QMessageBox::No)->setFocus(); //设置焦点

    /*
     *非模式对话框：
     *  是和同一个程序中其他窗口无关的对话框。例如：qq的每一个聊天窗口。
     *模式对话框：
     *  阻塞同一应用程序中其他可视窗口的输入的对话框，即用户必须完成这个对话框中的交互操作并且关闭了它之后才能访问应用程序中的其他任何窗口。
     *exec():
     *  将对话框显示为模式对话框，直到用户关闭为止。
     *  如果对话框是应用程序模式，则用户在关闭对话框之前不能与同一应用程序中的任何其他窗口进行交互
     *  如果对话框是窗口模式，则在对话框打开时，仅阻止与父窗口的交互。
     *  默认情况下，对话框是应用模式的。
     *my1.exec()：
     *  执行模式对话框。即显示子窗口，并在这里阻塞住，直到窗口被关闭之后，才能继续向下运行
    */
    int ret = box->exec();//如果没有exec(),不会显示对话框
    if (ret == QMessageBox::Yes) {
        exit(1);
    }
}

void language::buttonOK()
{
    Introduction* introduction;
    QString languageQm;
    /*currentIndex:此属性保存组合框中当前项的索引。
     * 默认情况下，对于空组合框或未设置当前项的组合框，此属性值为-1.
    */
    switch (ui->comboBoxLanguage->currentIndex()) {
    case cnc::simplifiedChinese:
        languageQm = ":/resourceFile/Chinese.qm";
        break;
    case cnc::English:
        languageQm = ":/resourceFile/English.qm";
        break;
    default:
        break;
    }
    translator->load(languageQm);//载入语言包

    isInstall(); //检测是否安装

    introduction = new Introduction();
    QDesktopWidget* desktop = QApplication::desktop();
    //界面将处于屏幕正中央偏上
    introduction->move((desktop->width()- introduction->width() )/2, (desktop->height() - introduction->height())/2-30);
    introduction->show();
    this->hide();
}



/*检测是否安装*/
void language::isInstall()
{
    QSettings* settingsVersions;

    /*HKEY_CLASSES_ROOT:
     *   包含了应用程序运行时的必需的信息。即所有已注册的文件类型等。
     *   比如：在文件和应用程序之间所有的扩展名和关联，所有的驱动程序名称等。
     *QSettings::NativeFormat：
     *   在windows可读写注册表。
     *QSettings:
     *   使用该类可以对注册表进行操作，获取注册表，对其进行读写
    */
    settingsVersions = new QSettings(QString("HKEY_CLASSES_ROOT\\%1Versions").arg(cnc::exeName), QSettings::NativeFormat);

    /*bool QSettings::contains(const QString &key) const:
     *   如果存在名为key的设置，则返回true，否则返回false。
     *value("Versions"):
     *   返回设置键的值。
     *toString():
     *   1，可以转换为字符串；
     *   2，可以将数值转换为不同的进制数的字符串。eg:toString(2)——转化为2进制的字符串。
    */
    if (settingsVersions->contains("Versions")) {
        QString oldVersions = settingsVersions->value("Versions").toString();
        oldVersions.remove('.'); //剔除版本号的特殊字符
        QString newVersions = cnc::versions;
        newVersions.remove('.');

        if (newVersions.toInt() > oldVersions.toInt()) {
            QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                               tr("检测到当前%1的版本较新,\n请问是否替换当前旧版本?").arg(cnc::exeName),
                                               QMessageBox::Yes | QMessageBox::No);

            box->button(QMessageBox::Yes)->setText(tr("是"));
            box->button(QMessageBox::No)->setText(tr("否"));
            box->button(QMessageBox::Yes)->setFocus(); //设置焦点

            int ret = box->exec();
            if (ret == QMessageBox::Yes) {
                return;
            }
            else {
                exit(1);
            }
        }
        if (newVersions.toInt() == oldVersions.toInt()) {
            QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                               tr("检测到当前%1的版本相同,\n请问是否继续安装?").arg(cnc::exeName),
                                               QMessageBox::Yes | QMessageBox::No);

            box->button(QMessageBox::Yes)->setText(tr("是"));
            box->button(QMessageBox::No)->setText(tr("否"));
            box->button(QMessageBox::No)->setFocus(); //设置焦点

            int ret = box->exec();
            if (ret == QMessageBox::Yes) {    
                return;
            }
            else {
                exit(1);
            }
        }
        if (newVersions.toInt() < oldVersions.toInt()) {
            QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                               tr("检测到当前%1的版本较旧,\n请问是否替换当前新版本?").arg(cnc::exeName),
                                               QMessageBox::Yes | QMessageBox::No);

            box->button(QMessageBox::Yes)->setText(tr("是"));
            box->button(QMessageBox::No)->setText(tr("否"));
            box->button(QMessageBox::Yes)->setFocus(); //设置焦点

            int ret = box->exec();
            if (ret == QMessageBox::Yes) {
                return;
            }
            else {
                exit(1);
            }
        }
    }
}

int entry(int argc, char *argv[])
{
    /*QApplication:
     *   管理GUI应用程序控制流和主要程序。代表一个程序。
     *QApplication a(argc, argv):
     *   argc和argv是从命令行传入的参数。例如：cp file.c file1.c  argc=3,argv是上面那行字符串数组。
     *   因为图形编程有时也需要从命令行传递参数给程序，所以才会有argc和argv。
    */
    QApplication a(argc, argv);
    QFile file(":/resourceFile/ui.qss");
    if (file.open(QIODevice::ReadOnly)) {
        //setStyleSheet:此属性保存应用程序样式表
        a.setStyleSheet(file.readAll());
        file.close();
    }

    QTranslator translator;
    a.installTranslator(&translator);

    language* w = new language(&translator);

    w->show();
    //a.exec()是程序进程的开始。
    return a.exec();
}
