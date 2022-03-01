@ECHO OFF

PUSHD %~dp0
imagex_x86 /apply ewf_fbwf.WIM 1 %systemroot%\
psexec -i -d -s regedit /s %~dp0ewf.reg
psexec -i -d -s regedit /s %~dp0EWFMgmt.reg
regsvr32 -s %SystemRoot%\system32\EWFProvider.dll
mofcomp %SystemRoot%\system32\EWFProvider.mof
ewfcfg /install-configuration

echo  操作已完成，请重启电脑。
pause
POPD