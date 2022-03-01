@ECHO OFF

PUSHD %~dp0
imagex_x64 /apply ewf_fbwf.WIM 4 %systemroot%\

psexec -i -d -s regedit /s %~dp0fbwf.reg
psexec -i -d -s regedit /s %~dp0FBWFMgmt.reg
regsvr32 -s %SystemRoot%\system32\FBWFProvider.dll
mofcomp %SystemRoot%\system32\FBWFProvider.mof
FBWFcfg /install-configuration

echo  操作已完成，请重启电脑。
pause
POPD