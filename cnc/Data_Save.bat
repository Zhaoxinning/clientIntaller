cls
@echo off
title 保存数据变更
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
set partition=
set /p PASS=  输入当前操作密码：
if not defined PASS goto CuoWu4
md5 -s %PASS%>"%SystemRoot%\system32\config\pass1"
FOR /f "usebackq tokens=*" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PS1=%%I)
Set PS1=%PS1:~-32%
echo %PS1%>"%SystemRoot%\system32\config\pass1"
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass") do (Set PAS=%%I)
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PAS1=%%I)
del /f /q /a "%SystemRoot%\system32\config\pass1"
setlocal enabledelayedexpansion
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
fsutil fsinfo drivetype %%i:|find "固定">nul && for /f "delims=" %%j in ("%%i") do set partition=!partition! %%j:
)
setlocal disabledelayedexpansion
if %PAS%==%PAS1% (goto SAVE) else (goto CuoWu5)
:SAVE
cls
echo.
if not exist "%SystemRoot%\system32\保护桌面图标\PECMD.EXE" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\ewf.sys" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\Filter.sys" goto CuoWu6
cd /d "%SystemRoot%\system32\drivers"
copy /y Filter.sys %SystemRoot%\system32\Filter.com >nul 2>nul
cd /d "%SystemRoot%\system32"
echo.
echo   您的系统应该能够在以下分区上配置 写保护：
echo.
echo    %partition%
echo.
echo.
echo   指定需要保存数据变更的分区盘符，如 C D E F （无需冒号，中间以空格符分隔）
echo.
set E_SAVE=
set /p E_SAVE=  需要保存数据变更的分区盘符：  
if not defined E_SAVE goto AAA2
for /f "tokens=2 usebackq" %%i in (`Filter %SystemDrive%^|find "State"`) do (set EWF=%%i)
if not defined EWF goto BUG
if %EWF% == DISABLED goto AAA1
if %EWF% == ENABLED goto SAVE1
:SAVE1
for %%i in (%E_SAVE%) do (
if /i "%%i:"=="%SystemDrive%" goto AAA3
)
goto AAA1
:CuoWu3
echo.
echo   侦测到您的 写保护密码验证损坏，无法进行管理操作，请重新安装本软件！
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
echo   侦测到您的 写保护组件丢失文件，建议您重新安装 软件。
pause>nul
goto exit
:BUG
echo.
echo   您的 写保护组件注册有问题，建议您重新安装 软件。
del /f /q /a Filter.com >nul 2>nul
pause>nul
goto exit
:AAA2
echo.
echo.
echo   输入不能为空！请正确输入分区盘符。
pause>nul
goto SAVE
:AAA1
echo.
echo.
echo.  您指定的新配置即刻生效！按下任意键即刻保存数据变更后退出...
pause>nul
for %%i in (%E_SAVE%) do (Filter %%i: -COMMIT >nul)
del /f /q /a Filter.com >nul 2>nul
goto exit
:AAA3
echo.
echo.
echo.  您指定的新配置重启后生效！按下任意键即刻保存数据变更后重新启动计算机...
pause>nul
for %%i in (%E_SAVE%) do (Filter %%i: -COMMIT >nul)
del /f /q /a Filter.com >nul 2>nul
shutdown -r -f -t 01
goto exit
:exit
