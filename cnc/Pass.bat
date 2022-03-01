cls
@echo off
title 密码管理
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
if not exist "%SystemRoot%\system32\config\pass" goto BUG5
if not exist "%SystemRoot%\system32\md5.exe" goto BUG5
echo.
echo   初始密码为“NOVICK”，计6个字符。请尽快更改密码！
echo.
set PASS=
set /p PASS=  输入当前密码：
if not defined PASS goto BUG1
md5 -s %PASS%>"%SystemRoot%\system32\config\pass1"
FOR /f "usebackq tokens=*" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PS1=%%I)
Set PS1=%PS1:~-32%
echo %PS1%>"%SystemRoot%\system32\config\pass1"
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass") do (Set PAS=%%I)
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PAS1=%%I)
del /f /q "%SystemRoot%\system32\config\pass1"
if %PAS%==%PAS1% (goto NEW_PASS) else (goto BUG2)
:NEW_PASS
CLS
echo.
echo   当前密码验证通过！您有权更改您的密码。
echo.
set PASS1=
set /p PASS1=  输入更改密码：
if not defined PASS1 goto BUG3
echo.
set PASS2=
set /p PASS2=  确认更改密码：
if not defined PASS2 goto BUG3
if not "%PASS1%"=="%PASS2%" goto BUG4
md5 -s %PASS1%>"%SystemRoot%\system32\config\pass"
FOR /f "usebackq tokens=*" %%I in ("%SystemRoot%\system32\config\pass") do (Set PS=%%I)
Set PS=%PS:~-32%
echo %PS%>"%SystemRoot%\system32\config\pass"
echo.
echo   恭喜您！新密码已转为 Md5 密文储存！请牢记您的新密码！
goto SAVE
:BUG1
echo.
echo   密码不能为空！您必须输入密码。
pause>nul
goto PASS
:BUG2
echo.
echo   当前密码输入不正确！请您重新输入正确密码以获取操作权限！
pause>nul
goto PASS
:BUG3
echo.
echo   密码不能为空！您必须输入密码。
pause>nul
goto NEW_PASS
:BUG4
echo.
echo   两次出入的密码不相同！请您重新输入密码。
pause>nul
goto NEW_PASS
:BUG5
echo.
echo   侦测到您的 Ewf 2.0 密码验证损坏，无法进行管理操作，请重新安装本软件！
pause>nul
goto exit
:SAVE
cd /d "%SystemRoot%\system32\drivers"
copy /y Filter.sys %SystemRoot%\system32\Filter.com >nul 2>nul
cd /d "%SystemRoot%\system32"
if not exist "%SystemRoot%\system32\drivers\ewf.sys" goto BUG9
if not exist "%SystemRoot%\system32\保护桌面图标\PECMD.EXE" goto BUG9
if not exist "%SystemRoot%\system32\drivers\Filter.sys" goto BUG9
for /f "tokens=2 usebackq" %%i in (`Filter %SystemDrive%^|find "State"`) do (set EWF=%%i)
if not defined EWF goto BUG6
if %EWF% == DISABLED goto BUG7
if %EWF% == ENABLED goto BUG8
:BUG6
echo.
echo   您的 Ewf 2.0 系统保护组件注册有问题或者已损坏，建议您重新安装 Ewf 2.0 组件。
echo.
echo   按下任意键退出...
del /f /q Filter.com >nul 2>nul
pause>nul
goto exit
:BUG7
echo.
echo   按下任意键退出...
del /f /q Filter.com >nul 2>nul
pause>nul
goto exit
:BUG9
echo.
echo   侦测到您的 Ewf 2.0 系统保护组件丢失文件，建议您重新安装 Ewf 2.0 组件。
pause>nul
goto exit
:BUG8
echo.
echo   侦测到您启用了系统保护，需要重新启动计算机才能生效。
echo.
echo   按下任意键重启...
pause>nul
Filter %SystemDrive% -COMMIT
del /f /q Filter.com >nul 2>nul
shutdown -r -f -t 01
:exit
