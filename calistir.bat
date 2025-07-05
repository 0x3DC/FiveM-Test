@echo off
setlocal

:: Yönetici izni kontrolü ve komut dosyasının yönetici olarak çalıştırılması
openfiles >nul 2>&1 || (
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0""", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    exit /B
)

:: TPM ayarları
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -Command Disable-TpmAutoProvisioning'"
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-NoProfile -ExecutionPolicy Bypass -Command Clear-Tpm'"

:: Reg ve hosts script'lerini çalıştır
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%1.ps1\"'"
powershell -WindowStyle Hidden -Command "Start-Process powershell -WindowStyle Hidden -Verb RunAs -Wait -ArgumentList '-ExecutionPolicy Bypass -File \"%SCRIPT_DIR%2.ps1\"'"



:: Dosyaları System32 klasörüne kopyala
set "system32Dir=C:\Windows\System32\"
if exist "%~dp0driver1.sys" (
    copy /y "%~dp0driver1.sys" "%system32Dir%"
)
if exist "%~dp0driver2.sys" (
    copy /y "%~dp0driver2.sys" "%system32Dir%"
)

:: Dosyaları sistem dosyası olarak ayarla ve gizle
attrib +s +h "%system32Dir%driver1.sys"
attrib +s +h "%system32Dir%driver2.sys"

:: mac.exe'yi yönetici olarak çalıştır
powershell -Command "Start-Process 'C:\Windows\System32\mac.exe' -Verb RunAs"

:: Yeni servisleri oluştur
C:\Windows\system32\cmd.exe /c sc create system1 binPath= "C:\Windows\System32\driver1.sys" DisplayName= "ca" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1
C:\Windows\system32\cmd.exe /c sc create system2 binPath= "C:\Windows\System32\driver2.sys" DisplayName= "caa" start= boot tag= 2 type= kernel group="System Reserved" >nul 2>&1
sc start system1 
sc start system2

:: Bilgisayarı yeniden başlat
C:\Windows\system32\cmd.exe /c shutdown /r /t 5



exit
