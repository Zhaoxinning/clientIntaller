@echo off
if %1.==. mshta vbscript:createobject("wscript.shell").run("""%~f0"" h",0)(close)&exit/b
:0
start /wait /d "D:\CNC\" CNC.exe
goto 0