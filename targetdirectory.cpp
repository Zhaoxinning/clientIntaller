#include "targetdirectory.h"
#include "ui_targetdirectory.h"

TargetDirectory::TargetDirectory(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::TargetDirectory),
    performInstallation(nullptr),
    installPath(""),
    filesSize(0)
{
    ui->setupUi(this);

    this->setWindowIcon(QIcon(":/resourceFile/cnc.ico"));
    this->setWindowTitle(tr("%1 %2 安装").arg(cnc::exeName,cnc::versions));

    ui->labelIco->setPixmap(QPixmap(":/resourceFile/cnc.ico"));
    ui->labelIco->setScaledContents(true); //自适应

    ui->labelSelectInstall->setText(tr("选择安装位置"));
    ui->labelSelectInstall->setFont(QFont("Times", 10, QFont::Bold));
    ui->labelSelectDir->setText(tr(" 选择 \"%1 %2 \"的安装文件夹.").arg(cnc::exeName,cnc::versions));

    ui->labelTxt1->setText(tr("安装程序将把 %1 %2 安装在下面的文件夹中.").arg(cnc::exeName,cnc::versions));

    ui->labelTxt2->setWordWrap(true); //自动换行
    ui->labelTxt2->setText(tr("继续安装,请点击 [安装]. 如果需要安装到其他的目录,请单击 [浏览]"));



    ui->groupBoxDestinationFolder->setTitle(tr("目标文件夹"));

    ui->pushButtonBrowse->setText(tr("浏览(B)"));
    ui->pushButtonBrowse->setShortcut(Qt::Key_B);
    ui->pushButtonInstall->setText(tr("安装(I)"));
    ui->pushButtonBrowse->setShortcut(Qt::Key_I);
    ui->pushButtonCancel->setText(tr("取消(C)"));
    ui->pushButtonBrowse->setShortcut(Qt::Key_C);
    ui->pushButtonLastStep->setText(tr("< 上一步(B)"));
    ui->pushButtonBrowse->setShortcut(Qt::Key_B);

    connect(ui->pushButtonBrowse, SIGNAL(clicked(bool)), this, SLOT(buttonBrowse()));
    connect(ui->pushButtonInstall, SIGNAL(clicked(bool)), this, SLOT(buttonInstall()));
    connect(ui->pushButtonCancel, SIGNAL(clicked(bool)), this, SLOT(buttonCancel()));
    connect(ui->pushButtonLastStep, SIGNAL(clicked(bool)), this, SLOT(buttonLastStep()));

    connect(ui->lineEditDir, SIGNAL(textChanged(QString)), this, SLOT(textChanged(QString)));

    filesSize = getFilesSize(cnc::qrcName);
    initTargetDirectory();
}

TargetDirectory::~TargetDirectory()
{
    delete ui;
}

void TargetDirectory::setMoveWindows(QPoint point)
{
    this->move(point);
}


//qin64:long long int的typedef.一般为64位
qint64 TargetDirectory::getFilesSize(QString path)
{
    if (!path.endsWith('/')) {
        path.append('/');
    }
    //QDir:提供对目录结构及其内容的访问
    //构造一个QDir对象，它是directory dir的QDir对象的副本
    QDir dir(path);
    qint64 size = 0;

    //QDir::NoDotAndDotDot:不要列出特殊条目'.'和'..'
    //QDir::AllEntries":列出目录、文件、驱动器和符号链接。
    //entryList:返回目录中所有文件和目录的名称列表。
    foreach (QString name, dir.entryList(QDir::AllEntries | QDir::NoDotAndDotDot)) {
        QString newPath = path + name;
        if (!QFileInfo(newPath).isSymLink() && QFileInfo(newPath).isDir()) {
            getFilesSize(newPath);
        }
        size += QFileInfo(newPath).size();
    }
    return size;
}

void TargetDirectory::initTargetDirectory()
{

    QDir dir("D:\\");
    if (dir.exists()) {
        ui->lineEditDir->setText("D:\\" + cnc::exeName + "\\");
        installPath = "D:\\";

        //选中所有文本(即高亮显示),并将光标移至末尾。
        ui->lineEditDir->selectAll();

        //将此QStorageInfo对象设置为路径所在的文件系统。为了计算可用空间。
        storage.setPath(installPath);
    }
    else{
        storage = QStorageInfo::root(); //获取root目录
        ui->lineEditDir->setText(storage.rootPath());
        installPath = storage.rootPath();
        ui->lineEditDir->selectAll();
    }
    ui->labelWantSpace->setText(tr("所需空间:%1").arg(bytesToSize(filesSize)));
    ui->labelSurplusSpace->setText(tr("可用空间:%1").arg(bytesToSize(storage.bytesAvailable())));
}

QString TargetDirectory::bytesToSize(qint64 mByte)
{
    QString unit;
    double size = mByte * 1.0;
    if (size <= 0) {
        size = 0.0;
        unit = "KB";
    }
    else if (size < 1000) {
        unit = "B";
    }
    else if (size < (1024 * 1000)) {
        size /= 1024;
        unit = "KB";
    }
    else if (size < (1024 * 1024 * 1000)) {
        size /= (1024 * 1024);
        unit = "MB";
    }
    else {
        size /= (1024 * 1024 * 1024);
        unit = "GB";
    }
    //number:根据指定的精度和格式对数字进行格式化，返回与数字等价的字符串。
    //number(size, 'f', 2):小数点后有两位float.
    return QString("%1%2").arg(QString::number(size, 'f', 2),unit);
}


/*提示框*/
void TargetDirectory::mssageBoxShow(QString text)
{
    QMessageBox msgBox;
    msgBox.setText(text);

    msgBox.move(this->x() + (((this->width() - 310) / 2)), this->y() + ((this->height() - 120) / 2));
    msgBox.exec();
}

void TargetDirectory::showTargetDirectory()
{
    this->show();
}

void TargetDirectory::buttonBrowse()
{
    /* 该类提供了系统当前挂载的磁盘的相关信息，包括它们的总大小，盘符名，文件系统名等
     * */
    QStorageInfo storageTemp;
    QString dirPath = QFileDialog::getExistingDirectory(this, tr("选择要安装的目录"), ".");
    /* 类似C++的cout函数
     * 打印调试信息到终端
     * */
    //qDebug() << dirPath << "----";
    if (!dirPath.isEmpty()) {
        ui->lineEditDir->setText(dirPath + "/" + cnc::exeName);
        //qDebug() << dirPath << "----";
        //将此QStorageInfo对象设置为路径所在的文件系统。路径可以是文件系统的根路径，目录或该文件系统中的文件。
        storageTemp.setPath(dirPath);
        ui->labelSurplusSpace->setText(QString(tr("可用空间:%1").arg(bytesToSize(storageTemp.bytesAvailable()))));
    }
}

void TargetDirectory::buttonInstall()
{
    installPath = ui->lineEditDir->text();

    /*检查字符串是否为空*/
    if (installPath.isEmpty()) {
        mssageBoxShow(tr("安装路径为空请重新选择"));
        return;
    }

    /*获取一个存在的路径
     * 此处主要是获取一个存在路径，而后判断磁盘空间是否充足
    */
    bool isInstall = false;
    QString existPath;
    for (int i = 0; i < installPath.size(); ++i) { //从头遍历，检测此路径是否在本地存在，只要有一个存在即可安装
        //qDebug() << installPath.left(installPath.size() - i);
        if (QFileInfo(installPath.left(installPath.size() - i)).exists()) {
            existPath = installPath.left(installPath.size() - i); // 保存存在的路径下面好判断
            isInstall = true;
            break;
        }
    }

    /*是否可以安装*/
    if (isInstall) {
        if (QStorageInfo(existPath).bytesAvailable() <= filesSize) {//判断磁盘空间
            mssageBoxShow(tr("磁盘空间不足请重新选择"));
            return;
        }
        //追加/
        if (!installPath.endsWith('/') && !installPath.endsWith('\\')) {
            installPath.append('/');
        }
    }
    else {
        mssageBoxShow(tr("此路径无效请重新选择"));
        return;
    }

    if (performInstallation == nullptr) {
        installPath.replace('\\', '/');
        //qDebug() <<installPath ;

        /*检查路径是否合法*/
        //QRegExp是Qt的正则表达式类。
        QRegExp reg("[\"*?？|<>]");
        //从偏移量为0处开始在installPath中寻找匹配项。如果没有匹配项返回-1，有匹配项则不返回-1
        if (reg.indexIn(installPath) != -1) { //如果匹配到特殊字符
            mssageBoxShow(tr("此路径无效请重新选择"));
            return;
        }

        if (installPath.size() >= 2) { //判断第二个字符是否有:
            //at():返回字符串中给定索引位置的字符。
            if (installPath.at(1) != ":") {
                mssageBoxShow(tr("此路径无效请重新选择"));
                return;
            }
        }

        /*//如果升级软件，是否希望覆盖？
        QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                           tr("你是否希望只增加新添加的文件(如果是首次安装请自动忽略)?").arg(cnc::exeName,cnc::versions),
                                           QMessageBox::Yes | QMessageBox::No);

        box->button(QMessageBox::Yes)->setText(tr("是"));
        box->button(QMessageBox::No)->setText(tr("否"));
        box->button(QMessageBox::No)->setFocus(); //设置焦点
        int ret = box->exec();//如果没有exec(),不会显示对话框
        if (ret == QMessageBox::Yes) {
            ifupdate=true;
        }
        else{
            ifupdate=false;
        }*/

        performInstallation = new PerformInstallation(installPath, this->frameGeometry().topLeft());//创建对象，实现参数的传递_installPath
        connect(performInstallation, SIGNAL(signalShowTargetDirectory()), this, SLOT(showTargetDirectory()));
    }
    QDesktopWidget* desktop = QApplication::desktop();
    //将安装界面重新置于屏幕中间偏上
    performInstallation->move((desktop->width() - performInstallation->width())/2, (desktop->height() - performInstallation->height())/2-30);
    performInstallation->show();
    this->hide();
}

void TargetDirectory::buttonCancel()
{
    QMessageBox* box = new QMessageBox(QMessageBox::Question, tr("%1 %2的安装").arg(cnc::exeName,cnc::versions) ,
                                       tr("你确定要退出%1 %2 的安装吗?").arg(cnc::exeName,cnc::versions),
                                       QMessageBox::Yes | QMessageBox::No);
    box->button(QMessageBox::Yes)->setText(tr("是"));
    box->button(QMessageBox::No)->setText(tr("否"));
    box->button(QMessageBox::No)->setFocus(); //设置焦点

    box->move(this->x() + (((this->width() - 310) / 2)), this->y() + ((this->height() - 120) / 2));
    int ret = box->exec();
    if (ret == QMessageBox::Yes) {
        exit(1);
    }
}

void TargetDirectory::buttonLastStep()
{
    emit signalShowLicenseCheck(this->frameGeometry().topLeft());
    this->hide();
}

void TargetDirectory::textChanged(QString text)
{
    /*获取存在的路径*/
    bool isInstall = false;
    QString existPath;
    storage.setPath(text);
    for (int i = 0; i < text.size(); ++i) { //从头遍历，检测此路径是否在本地存在，只要有一个存在即可安装
        if (QFileInfo(text.left(text.size() - i)).exists()) {
            existPath = text.left(text.size() - i); // 保存存在的路径下面好判断
            storage.setPath(existPath);
            isInstall = true;
            break;
        }
    }
    if (isInstall) {
        ui->labelSurplusSpace->setText(tr("可用空间:%1").arg(bytesToSize(storage.bytesAvailable())));
    }
    else {
        ui->labelSurplusSpace->setText(tr("可用空间:%1").arg(0));
    }
}
