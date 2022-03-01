cls
@echo off
title 保存桌面图标
color 1f
MODE con: COLS=80 LINES=30
cd /d "%SystemRoot%\system32"
:PASS
CLS
echo.
echo.           ┌──────────────────────────┐
echo.           │             写保护                                 │
echo.           │                                                    │
echo.           │  作 者：NOVICK                                     │
echo.           │                                                    │
echo.           │                                                    │
echo.           └──────────────────────────┘
if not exist "%SystemRoot%\system32\config\pass" goto CuoWu3
if not exist "%SystemRoot%\system32\md5.exe" goto CuoWu3
echo.
set PASS=
set /p PASS=  输入当前操作密码：
if not defined PASS goto CuoWu4
md5 -s %PASS%>"%SystemRoot%\system32\config\pass1"
FOR /f "usebackq tokens=*" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PS1=%%I)
Set PS1=%PS1:~-32%
echo %PS1%>"%SystemRoot%\system32\config\pass1"
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass") do (Set PAS=%%I)
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PAS1=%%I)
del /f /q /a "%SystemRoot%\system32\config\pass1"
if %PAS%==%PAS1% (goto SAVE) else (goto CuoWu5)
:BUG
echo.
echo   您的 Ewf 2.0 系统保护组件注册有问题，建议您重新安装 Ewf 2.0 组件。
del /f /q /a Filter.com >nul 2>nul
pause>nul
goto exit
:CuoWu3
echo.
echo   侦测到您的 Ewf 2.0 密码验证损坏，无法进行管理操作，请重新安装本软件！
pause>nul
goto exit
:CuoWu4
echo.
echo   密码不能为空！您必须输入密码。
pause>nul
goto PASS
:CuoWu5
echo.
echo   当前密码输入不正确！请您重新输入正确密码以获取操作权限！
pause>nul
goto PASS
:CuoWu6
echo.
echo   侦测到您的 Ewf 2.0 系统保护组件丢失文件，建议您重新安装 Ewf 2.0 组件。
del /f /q /a Filter.com >nul 2>nul
pause>nul
goto exit
:SAVE
CLS
echo.
echo.
if not exist "%SystemRoot%\system32\保护桌面图标\PECMD.EXE" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\ewf.sys" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\Filter.sys" goto CuoWu6
echo.  请您关闭桌面上所有打开的文件或正在运行的程序！
echo.
echo.  即将开始保存您桌面上的图标，按任意键开始...
pause>nul
echo.
md "D:\Temp" >nul 2>nul
md "D:\IE Temp" >nul 2>nul
md "D:\我的桌面" >nul 2>nul
md "D:\我的文档" >nul 2>nul
attrib +h "D:\Temp"
attrib +h "D:\IE Temp"
attrib +h "D:\我的桌面"
cd /D "%SystemRoot%\system32\保护桌面图标\"
PECMD.EXE FILE "%SystemRoot%\system32\保护桌面图标\保存当前用户桌面快捷方式\*"
PECMD.EXE FILE "%SystemRoot%\system32\保护桌面图标\保存All Users桌面快捷方式\*"
PECMD.EXE FILE "D:\Temp\*"
PECMD.EXE FILE "D:\我的桌面\*=>%SystemRoot%\system32\保护桌面图标\保存当前用户桌面快捷方式"
PECMD.EXE FILE "%ALLUSERSPROFILE%\桌面\*=>%SystemRoot%\system32\保护桌面图标\保存All Users桌面快捷方式"
cd /d "%SystemRoot%\system32\drivers"
copy /y Filter.sys %SystemRoot%\system32\Filter.com >nul 2>nul
cd /d "%SystemRoot%\system32"
for /f "tokens=2 usebackq" %%i in (`Filter %SystemDrive%^|find "State"`) do (set EWF=%%i)
if not defined EWF goto BUG
if %EWF% == DISABLED goto AAA1
if %EWF% == ENABLED goto AAA2
:AAA1
echo.
echo.  正在保存系统桌面图标...
echo.
echo   恭喜您！桌面图标已经成功保存！
del /f /q /a Filter.com >nul 2>nul
pause>nul
goto exit
:AAA2
echo.
echo.  正在保存系统桌面图标...
echo.
echo   桌面图标已经保存；按下任意键重新启动计算机才能生效...
goto REBOOT
:REBOOT
pause>nul
Filter %SystemDrive% -COMMIT
del /f /q /a Filter.com >nul 2>nul
shutdown -r -f -t 01
:exit
