cls
@echo off
title �ر� д����
color 1f
MODE con: COLS=80 LINES=30
cd /d "%SystemRoot%\system32"
:PASS
CLS
echo.
echo.           ��������������������������������������������������������
echo.           ��             д����                                 ��
echo.           ��                                                    ��
echo.           ��  �� �ߣ�NOVICK                                     ��
echo.           ��                                                    ��
echo.           ��                                                    ��
echo.           ��������������������������������������������������������
if not exist "%SystemRoot%\system32\config\pass" goto CuoWu3
if not exist "%SystemRoot%\system32\md5.exe" goto CuoWu3
echo.
set PASS=
set /p PASS=  ���뵱ǰ�������룺
if not defined PASS goto CuoWu4
md5 -s %PASS%>"%SystemRoot%\system32\config\pass1"
FOR /f "usebackq tokens=*" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PS1=%%I)
Set PS1=%PS1:~-32%
echo %PS1%>"%SystemRoot%\system32\config\pass1"
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass") do (Set PAS=%%I)
FOR /f "tokens=* usebackq" %%I in ("%SystemRoot%\system32\config\pass1") do (Set PAS1=%%I)
del /f /q "%SystemRoot%\system32\config\pass1"
setlocal enabledelayedexpansion
for %%i in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
fsutil fsinfo drivetype %%i:|find "�̶�">nul && for /f "delims=" %%j in ("%%i") do set partition=!partition! %%j:
)
setlocal disabledelayedexpansion
if %PAS%==%PAS1% (goto OFF) else (goto CuoWu5)
:OFF
cls
echo.
if not exist "%SystemRoot%\system32\��������ͼ��\PECMD.EXE" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\ewf.sys" goto CuoWu6
if not exist "%SystemRoot%\system32\drivers\Filter.sys" goto CuoWu6
cd /d "%SystemRoot%\system32\drivers"
copy /y Filter.sys %SystemRoot%\system32\Filter.com >nul 2>nul
cd /d "%SystemRoot%\system32"
echo.
echo   ����ϵͳӦ���ܹ������·��������� д������
echo.
echo    %partition%
echo.
echo.
echo   ָ����Ҫ�رձ����ķ����̷����� C D E F ������ð�ţ��м��Կո���ָ���
echo.
set E_OFF=
set /p E_OFF=  ��Ҫ�رձ����ķ����̷���  
if not defined E_OFF goto AAA2
for /f "tokens=2 usebackq" %%i in (`Filter %SystemDrive%^|find "State"`) do (set EWF=%%i)
if not defined EWF goto BUG
goto AAA1
:CuoWu3
echo.
echo   ��⵽���� д����������֤�𻵣��޷����й�������������°�װ�������
pause>nul
goto exit
:CuoWu4
echo.
echo   ���벻��Ϊ�գ��������������롣
pause>nul
goto PASS
:CuoWu5
echo.
echo   ��ǰ�������벻��ȷ����������������ȷ�����Ի�ȡ����Ȩ�ޣ�
pause>nul
goto PASS
:CuoWu6
echo.
echo   ��⵽���� д����ϵͳ���������ʧ�ļ������������°�װ �����
pause>nul
goto exit
:BUG
echo.
echo   ���� д�������ע�������⣬���������°�װ �����
del /f /q /a Filter.com >nul 2>nul
pause>nul
goto exit
:AAA2
echo.
echo.
echo   ���벻��Ϊ�գ�����ȷ��������̷���
pause>nul
goto OFF
:AAA1
echo.
echo.
echo.  ��ָ��������������������Ч������������������������...
pause>nul
for %%i in (%E_OFF%) do (Filter %%i: -COMMITANDDISABLE >nul)
Filter %SystemDrive% -COMMIT
del /f /q /a Filter.com >nul 2>nul
shutdown -r -f -t 01
goto exit
:exit
