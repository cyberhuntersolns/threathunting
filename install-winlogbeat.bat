@echo off
setlocal
set hour=%time:~0,2%
set minute=%time:~3,2%
set /A minute+=2
if %minute% GTR 59 (
 set /A minute-=60
 set /A hour+=1
)
if %hour%==24 set hour=00
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
if "%hour:~1,1%"=="" set hour=0%hour%
if "%minute:~1,1%"=="" set minute=0%minute%
set tasktime=%hour%:%minute%
echo [+] Downloading Winlogbeat...
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/cyberhuntersolns/threathunting/develop/winlogbeat.zip','C:\Program Files\winlogbeat.zip')"
@powershell Expand-Archive -Force 'C:\Program Files\winlogbeat.zip' 'C:\Program Files\'"
pushd "C:\Program Files\"
rename winlogbeat-7.3.0-windows-x86_64 winlogbeat
pushd "C:\Program Files\winlogbeat"
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/cyberhuntersolns/threathunting/develop/winlogbeat.yml','C:\Program Files\winlogbeat\winlogbeat.yml')"
@powershell -NoProfile -ExecutionPolicy Bypass -Command "& 'c:\Program Files\winlogbeat\install-service-winlogbeat.ps1 -c c:\Program Files\winlogbeat\winlogbeat.yml'"
@powershell 'Restart-Service winlogbeat'"
echo [+] Winlogbeat Successfully Installed!
timeout /t 10
exit
