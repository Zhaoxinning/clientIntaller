cls
@echo off
title 恢复桌面图标 （ 慎重！）
color 1f
MODE con: COLS=80 LINES=30
:AAA1
cls
echo.
echo.           ┌──────────────────────────┐
echo.           │             写保护                                 │
echo.           │                                                    │
echo.           │  作 者：NOVICK                                     │
echo.           │                                                    │
echo.           │                                                    │
echo.           └──────────────────────────┘
if not exist "%SystemRoot%\system32\保护桌面图标\PECMD.EXE" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\ewf.sys" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\Filter.sys" goto CuoWu6
echo.
echo.  危险操作，请您慎重：
echo.
echo.
echo.  1、恢复桌面至上次保存的状态，桌面上现有的文件将丢失！
echo.
echo.  2、关闭桌面上所有打开的文件或正在运行的程序，转移桌面上重要文件到别处。
echo.
echo.
set AA=
set /p AA=  按 Y 恢复   按 N 退出   输入后键入回车键确认 
if defined AA goto AAA2
if not defined AA goto AAA1
:AAA2
if /i %AA% EQU Y  (goto AAA3
) else (if /i %AA% EQU N  (goto exit
) else (goto CuoWu2
)
)
:CuoWu2
echo.
echo.  您的输入不正确，再次输入 Y 或 N 。
pause>nul
goto AAA1
:CuoWu6
echo.
echo   侦测到您的 写保护组件丢失文件，建议您重新安装 软件。
pause>nul
goto exit
:AAA3
cls
echo.
echo.
echo.  正在要恢复桌面...
echo.
md "D:\Temp" >nul 2>nul
md "D:\IE Temp" >nul 2>nul
md "D:\我的桌面" >nul 2>nul
md "D:\我的文档" >nul 2>nul
attrib +h "D:\Temp"
attrib +h "D:\IE Temp"
attrib +h "D:\我的桌面"
cd /D "%SystemRoot%\system32\保护桌面图标"
PECMD.EXE FILE "D:\我的桌面\*"
PECMD.EXE FILE "%ALLUSERSPROFILE%\桌面\*"
PECMD.EXE FILE "D:\Temp\*"
PECMD.EXE FILE "%SystemRoot%\system32\保护桌面图标\保存All Users桌面快捷方式\*=>%ALLUSERSPROFILE%\桌面"
PECMD.EXE FILE "%SystemRoot%\system32\保护桌面图标\保存当前用户桌面快捷方式\*=>D:\我的桌面\"
:exit
